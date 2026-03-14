/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
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
    

    public List<Object[]> findFilteredAppointments(String email, String role, String date, String name) {
        // 1. 基础 SELECT 和 JOIN 部分
        StringBuilder queryStr = new StringBuilder(
            "SELECT a, s.serviceName, s.serviceType, a.appointment_time, " +
            "a.staff_email, a.technician_email, c.carPlateNumber " + 
            "FROM Appointment a " +
            "JOIN a.service s " +
            "LEFT JOIN a.car c "
        );

        // 2. 根据角色动态添加第一个 WHERE
        if ("technician".equals(role)) {
            queryStr.append(" WHERE a.technician_email = :email");
        } else {
            queryStr.append(" WHERE a.customer.email = :email");
        }

        // --- 核心修改：强制只查询状态为 Done 的数据 ---
        queryStr.append(" AND a.appointment_status = 'Done'"); 

        // 3. 后续过滤条件使用 AND
        if (date != null && !date.isEmpty()) {
            queryStr.append(" AND a.appointment_date = :date");
        }
        if (name != null && !name.isEmpty()) {
            queryStr.append(" AND UPPER(s.serviceName) LIKE :name");
        }

        Query query = em.createQuery(queryStr.toString());
        query.setParameter("email", email);

        if (date != null && !date.isEmpty()) query.setParameter("date", date);
        if (name != null && !name.isEmpty()) query.setParameter("name", "%" + name.toUpperCase() + "%");

        return query.getResultList();
    }
    
    public List<Object[]> findServiceSummary(String email) {
        try {
            // 更新 SELECT 语句：增加 s.serviceType
            String jpql = "SELECT a.appointment_date, s.serviceName, a.appointment_status, " +
                          "a.appointment_time, c.carPlateNumber, s.serviceType " + // s.serviceType 现在是索引 [5]
                          "FROM Appointment a " +
                          "JOIN a.service s " +
                          "LEFT JOIN a.car c " +
                          "WHERE a.customer.email = :email " +
                          "AND a.appointment_status = 'Pending' " +
                          "ORDER BY a.appointment_date DESC";

            return em.createQuery(jpql, Object[].class)
                    .setParameter("email", email)
                    .setMaxResults(5)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}
