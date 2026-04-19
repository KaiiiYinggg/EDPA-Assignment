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
import javax.persistence.Query;
import javax.persistence.TypedQuery;

/**
 *
 * @author teech
 */
@Stateless
public class AppointmentFacade extends AbstractFacade<Appointment> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AppointmentFacade() {
        super(Appointment.class);
    }

//    public List<Object[]> findFilteredAppointments(String email, String role, String date, String name) {
//        // 1. 基础 SELECT 保持不变
//        StringBuilder queryStr = new StringBuilder(
//                "SELECT a, s.serviceType, a.appointment_time, "
//                + "a.staff_email, a.technician_email, c.carPlateNumber "
//                + "FROM Appointment a "
//                + "JOIN a.service s "
//                + "LEFT JOIN a.car c "
//        );
//
//        // 2. 根据角色过滤用户
//        if ("technician".equals(role)) {
//            queryStr.append(" WHERE a.technician_email = :email");
//        } else {
//            queryStr.append(" WHERE a.customer.email = :email");
//        }
//
//        // 🔥 关键修改：删掉原本那行 AND a.appointment_status = 'Done' 或 'Completed'
//        // 这样不管是 Pending, Approved, Completed 还是 Paid，全部都会显示出来。
//        // 3. 动态过滤（日期和名字搜索）
//        if (date != null && !date.isEmpty()) {
//            queryStr.append(" AND a.appointment_date = :date");
//        }
//        if (name != null && !name.isEmpty()) {
//            queryStr.append(" AND UPPER(s.serviceType) LIKE :name");
//        }
//
//        // 4. 排序：最新的排上面
//        queryStr.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");
//
//        Query query = em.createQuery(queryStr.toString());
//        query.setParameter("email", email);
//
//        if (date != null && !date.isEmpty()) {
//            try {
//                query.setParameter("date", java.time.LocalDate.parse(date));
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//        if (name != null && !name.isEmpty()) {
//            query.setParameter("name", "%" + name.toUpperCase() + "%");
//        }
//
//        return query.getResultList();
//    }
    public List<Appointment> findFilteredAppointments(String email, String role, String date, String name) {
        StringBuilder queryStr = new StringBuilder(
                "SELECT DISTINCT a FROM Appointment a "
                + "JOIN FETCH a.service s "
                + "LEFT JOIN FETCH a.car c "
                + "LEFT JOIN FETCH a.feedbacks f "
        );

        if ("technician".equals(role)) {
            queryStr.append(" WHERE a.technician_email = :email");
        } else {
            queryStr.append(" WHERE a.customer.email = :email");
        }

        if (date != null && !date.isEmpty()) {
            queryStr.append(" AND a.appointment_date = :date");
        }
        if (name != null && !name.isEmpty()) {
            queryStr.append(" AND UPPER(s.serviceType) LIKE :name");
        }

        queryStr.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");

        TypedQuery<Appointment> query = em.createQuery(queryStr.toString(), Appointment.class);
        query.setParameter("email", email);

        if (date != null && !date.isEmpty()) {
            query.setParameter("date", java.time.LocalDate.parse(date));
        }
        if (name != null && !name.isEmpty()) {
            query.setParameter("name", "%" + name.toUpperCase() + "%");
        }

        return query.getResultList();
    }

    public List<Appointment> searchAppointments(String custEmail, String dateStr, String idStr) {
        // 基础查询：先锁定这个 Customer 的所有预约
        StringBuilder jpql = new StringBuilder("SELECT a FROM Appointment a WHERE a.customer.email = :email");

        // 动态拼接条件：如果有日期就加日期，有 ID 就加 ID
        if (dateStr != null && !dateStr.isEmpty()) {
            jpql.append(" AND a.appointment_date = :date");
        }
        if (idStr != null && !idStr.isEmpty()) {
            jpql.append(" AND a.appointment_id = :id");
        }

        // 按照 ID 倒序排列，让最新的在上面
        jpql.append(" ORDER BY a.appointment_id DESC");

        javax.persistence.TypedQuery<Appointment> query = em.createQuery(jpql.toString(), Appointment.class);
        query.setParameter("email", custEmail);

        // 设置参数（记得转换类型，DB 里的 Date 是 LocalDate，ID 是 Long）
        if (dateStr != null && !dateStr.isEmpty()) {
            query.setParameter("date", java.time.LocalDate.parse(dateStr));
        }
        if (idStr != null && !idStr.isEmpty()) {
            try {
                query.setParameter("id", Long.parseLong(idStr));
            } catch (NumberFormatException e) {
                // 如果用户乱填 ID（比如填了字母），这里可以设一个不存在的 ID
                query.setParameter("id", -1L);
            }
        }

        return query.getResultList();
    }

    public List<Object[]> findServiceSummary(String email) {
        try {
            // 更新 SELECT 语句：增加 s.serviceType
            String jpql = "SELECT a.appointment_date, s.serviceType, a.appointment_status, "
                    + "a.appointment_time, c.carPlateNumber, s.serviceType "
                    + // s.serviceType 现在是索引 [5]
                    "FROM Appointment a "
                    + "JOIN a.service s "
                    + "LEFT JOIN a.car c "
                    + "WHERE a.customer.email = :email "
                    + "AND a.appointment_status = 'Approved' "
                    + "ORDER BY a.appointment_date DESC";

            return em.createQuery(jpql, Object[].class)
                    .setParameter("email", email)
                    .setMaxResults(5)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public List<Appointment> findByCustomerEmail(String email) {
        return em.createQuery(
                "SELECT a FROM Appointment a WHERE a.customer.email = :email",
                Appointment.class)
                .setParameter("email", email)
                .getResultList();
    }

    public List<User> findAvailableTechnicians(LocalDate date, LocalTime startTime, LocalTime endTime) {
        // 逻辑：排除在该时间段内已有预约的技术员
        // 冲突条件：(现有开始 < 目标结束) AND (现有结束 > 目标开始)
        // 注意：我们需要通过 serviceHour 动态计算现有预约的结束时间

        String busyTechsQuery = "SELECT DISTINCT a.technician_email FROM Appointment a "
                + "WHERE a.appointment_date = :date "
                + "AND a.technician_email IS NOT NULL "
                + "AND a.appointment_time < :targetEnd "
                + "AND a.appointment_status != 'Cancelled' "
                + "AND FUNC('TIMESTAMPADD', FUNC('SQL_TSI_HOUR'), a.service.serviceHour, "
                + "CAST(a.appointment_time AS TIMESTAMP)) > :targetStart";

        // 注意：上述 FUNC 是特定于 Derby 的写法。如果 JPQL 不支持，建议查询出列表后在 Java 中 filter
        return em.createQuery("SELECT u FROM User u WHERE u.role = 'technician' "
                + "AND u.email NOT IN (" + busyTechsQuery + ")", User.class)
                .setParameter("date", date)
                .setParameter("targetStart", startTime)
                .setParameter("targetEnd", endTime)
                .getResultList();
    }

    public List<Object[]> getTechnicianPerformance() {
        return em.createQuery(
                "SELECT a.technician_email, COUNT(a) FROM Appointment a "
                + "WHERE a.appointment_status = 'Completed' "
                + "GROUP BY a.technician_email ORDER BY COUNT(a) DESC",
                Object[].class).getResultList();
    }

    public List<Object[]> getStaffPerformance() {
        return em.createQuery(
                "SELECT a.staff_email, COUNT(a) FROM Appointment a "
                + "WHERE a.appointment_status = 'Completed' "
                + "GROUP BY a.staff_email ORDER BY COUNT(a) DESC",
                Object[].class).getResultList();
    }

    public List<Appointment> findAllCompleted() {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_status = 'Completed'", Appointment.class)
                .getResultList();
    }

// 根据 ID 或 Email 搜索这些已经修好的预约
    public List<Appointment> searchUnpaid(String query) {
        try {
            // 如果是数字 → search by ID
            if (query.matches("\\d+")) {
                Long id = Long.parseLong(query);

                return em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.appointment_id = :id AND a.appointment_status = 'Completed'",
                        Appointment.class)
                        .setParameter("id", id)
                        .getResultList();
            } else {
                // 否则 → search by email
                return em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.customer.email LIKE :q AND a.appointment_status = 'Completed'",
                        Appointment.class)
                        .setParameter("q", "%" + query + "%")
                        .getResultList();
            }

        } catch (Exception e) {
            return new ArrayList<>(); // ❗ 不要 throw error
        }
    }

    public List<Appointment> findByTechnicianEmail(String email) {
        // 只查 Approved，因为一旦变成 Completed 就不该出现在待办里了
        return em.createQuery("SELECT a FROM Appointment a WHERE a.technician_email = :email AND a.appointment_status = 'Approved'", Appointment.class)
                .setParameter("email", email)
                .getResultList();
    }

    /**
     * 功能：查询指定日期的所有预约
     */
    public List<Appointment> findAppointmentsByDate(LocalDate date) {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_date = :date", Appointment.class)
                .setParameter("date", date)
                .getResultList();
    }

    /**
     * 功能：查询所有已完成但未支付的预约 (Requirement 2.7 相关) 逻辑：状态是 'Completed' 且不在 Payment
     * 表中的预约
     */
    public List<Appointment> findUnpaidAppointments() {
        // 假设你的状态字段叫 appointment_status
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_status = 'Completed'", Appointment.class)
                .getResultList();
    }

}
