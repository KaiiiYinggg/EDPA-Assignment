/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;

/**
 *
 * @author teech
 */
@Stateless
public class UserFacade extends AbstractFacade<User> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    public void create(User user) {
        em.persist(user);
    }

// method//
    public User findByEmail(String email) {
        try {
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public List<User> findAllStaffExceptMe(String myEmail) {
        // We use u.email here because it is marked as Unique in your Entity class
        // role=null(customer)
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role IN ('manager', 'technician', 'counter staff') "
                + "AND u.email != :email", User.class)
                .setParameter("email", myEmail)
                .getResultList();
    }

    public List<User> searchStaffExceptMe(String myEmail, String query) {
        // 使用 UPPER 进行不区分大小写的搜索
        // % 代表通配符，表示匹配任何字符
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role IN ('manager', 'technician', 'counter staff') "
                + "AND u.email != :email "
                + "AND (UPPER(u.username) LIKE UPPER(:query) OR UPPER(u.email) LIKE UPPER(:query))",
                User.class)
                .setParameter("email", myEmail)
                .setParameter("query", "%" + query + "%")
                .getResultList();
    }

    public void deleteByEmail(String email) {
        User user = findByEmail(email);
        if (user != null) {
            // merge 后再 remove 是 JPA 删除 Detached 对象的标准做法
            em.remove(em.merge(user));
        }
    }

    public List<User> findAvailableTechnicians(LocalDate date, LocalTime startTime, LocalTime endTime) {
        // 逻辑：查询所有角色为 Technician 的用户，
        // 并且他们没有参与任何在该时间段内重叠的 Appointment
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role = 'technician' AND u.email NOT IN ("
                + "    SELECT a.technician_email FROM Appointment a "
                + "    WHERE a.appointment_date = :date "
                + "    AND a.appointment_status != 'Cancelled' "
                + "    AND a.appointment_time < :endTime "
                + // 逻辑：旧预约的开始时间 < 新预约的结束时间
                "    AND a.expected_end_time > :startTime"
                + // 逻辑：旧预约的结束时间 > 新预约的开始时间
                ")", User.class)
                .setParameter("date", date)
                .setParameter("startTime", startTime)
                .setParameter("endTime", endTime)
                .getResultList();
    }

    public String updateStaff(String oldEmail, String newEmail, String username, int phone, String role, String gender, String password, String profilePic, String userIC, String address) {
        // 1. 检查新 Email 是否已经被其他人占用
        // 如果用户没改 Email，newEmail == oldEmail，我们就跳过检查
        if (!oldEmail.equals(newEmail)) {
            User existingUser = findByEmail(newEmail);
            if (existingUser != null) {
                return "Email already exists!"; // 返回错误信息
            }
        }

        // 2. 找到该用户并更新
        User user = findByEmail(oldEmail);
        if (user != null) {
            user.setEmail(newEmail); // 更新为新 Email
            user.setUsername(username);
            user.setPhoneNumber(phone);
            user.setRole(role);
            user.setGender(gender);
            user.setPassword(password);
            user.setUserIC(userIC);
            user.setAddress(address);

            user.setProfilePic(profilePic);

            em.merge(user);
            em.flush();
            return "success";
        }
        return "User not found!";
    }

    ////    

    public List<User> findAllCustomers() {
        return em.createQuery("SELECT u FROM User u WHERE u.role = 'customer'", User.class)
                .getResultList();
    }

    public List<User> searchCustomers(String query) {
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role = 'customer' "
                + "AND (UPPER(u.username) LIKE UPPER(:query) OR UPPER(u.email) LIKE UPPER(:query))",
                User.class)
                .setParameter("query", "%" + query + "%")
                .getResultList();
    }

    public List<User> findByRole(String role) {
        return em.createQuery("SELECT u FROM User u WHERE u.role = :role", User.class)
                .setParameter("role", role)
                .getResultList();
    }

    public int countCustomers() {
        // 使用 JPQL 直接从数据库查询数量，速度极快
        return ((Number) em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'customer'")
                .getSingleResult()).intValue();
    }

    @Transactional
    public void deleteById(Long id) {
        User user = em.find(User.class, id);
        if (user != null) {
            em.remove(em.merge(user));
        }
    }

    /**
     * 功能：根据角色统计用户数量 (满足你想显示的 Total Customers)
     */
    public int countByRole(String roleName) {
        try {
            // 使用 JPQL 聚合函数 COUNT，效率比查询出所有对象再 size() 快得多
            Long count = (Long) em.createQuery("SELECT COUNT(u) FROM User u WHERE LOWER(u.role) = :role")
                    .setParameter("role", roleName.toLowerCase())
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            return 0;
        }
    }
    

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UserFacade() {
        super(User.class);
    }

}
