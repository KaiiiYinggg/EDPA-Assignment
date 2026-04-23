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

@Stateless
public class UserFacade extends AbstractFacade<User> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    public void create(User user) {
        em.persist(user);
    }

    //use in appointment,login,register,updateStaff
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

    //use in mamnage staff
    public List<User> findAllStaffExceptMe(String myEmail) {
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role IN ('manager', 'technician', 'counter staff') "
                + "AND u.email != :email", User.class)
                .setParameter("email", myEmail)
                .getResultList();
    }

    public List<User> searchStaffExceptMe(String myEmail, String query) {
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role IN ('manager', 'technician', 'counter staff') "
                + "AND u.email != :email "
                + "AND (UPPER(u.username) LIKE UPPER(:query) OR UPPER(u.email) LIKE UPPER(:query))",
                User.class)
                .setParameter("email", myEmail)
                .setParameter("query", "%" + query + "%")
                .getResultList();
    }

    //use in Detele Userr
    public void deleteByEmail(String email) {
        User user = findByEmail(email);
        if (user != null) {
            em.remove(em.merge(user));
        }
    }

    // use in appointment
    public List<User> findAvailableTechnicians(LocalDate date, LocalTime startTime, LocalTime endTime) {
        // check is role is technician and they did not participate in any overlapping appointments during that time period
        return em.createQuery(
                "SELECT u FROM User u WHERE u.role = 'technician' AND u.email NOT IN ("
                + "    SELECT a.technician_email FROM Appointment a "
                + "    WHERE a.appointment_date = :date "
                + "    AND a.appointment_status != 'Cancelled' "
                + "    AND a.appointment_time < :endTime "
                + "    AND a.expected_end_time > :startTime"
                + ")", User.class)
                .setParameter("date", date)
                .setParameter("startTime", startTime)
                .setParameter("endTime", endTime)
                .getResultList();
    }

    //use in Update Staff
    public String updateStaff(String oldEmail, String newEmail, String username, int phone, String role, String gender, String password, String profilePic, String userIC, String address) {

        if (!oldEmail.equals(newEmail)) {
            User existingUser = findByEmail(newEmail);
            if (existingUser != null) {
                return "Email already exists!";
            }
        }

        User user = findByEmail(oldEmail);
        if (user != null) {
            user.setEmail(newEmail);
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

    //use in Manage Customer
    public List<User> findAllCustomers() {
        em.clear();
        return em.createQuery(
                "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.carList WHERE u.role = 'customer'",
                User.class)
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

    // use in staff dashboard
    public int countCustomers() {
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

    public int countByRole(String roleName) {
        try {
            Long count = (Long) em.createQuery("SELECT COUNT(u) FROM User u WHERE LOWER(u.role) = :role")
                    .setParameter("role", roleName.toLowerCase())
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            return 0;
        }
    }

    // use in Set Price
    public User findByIC(String userIC) {
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.userIC = :ic", User.class)
                    .setParameter("ic", userIC)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    // use in edit profile, manage customer, register and update staff
    public User findByPhone(int phone) {
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.phoneNumber = :phone", User.class)
                    .setParameter("phone", phone)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
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
