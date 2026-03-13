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
        // 1. 基础 SELECT 和 JOIN 部分 (不要在这里写 WHERE)
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
            // 选择日期、服务名称和状态。通过 a.customer.email 过滤
            return em.createQuery(
                "SELECT a.appointment_date, s.serviceName, a.appointment_status " +
                "FROM Appointment a JOIN a.service s " +
                "WHERE a.customer.email = :email " +
                "ORDER BY a.appointment_date DESC", Object[].class)
                .setParameter("email", email)
                .setMaxResults(5) // 可选：只显示最近的 5 条记录
                .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }
}
