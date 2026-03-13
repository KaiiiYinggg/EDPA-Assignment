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
    

    public List<Object[]> findFilteredAppointments(String email, String date, String name) {
        // 1. 修改 SELECT 增加字段：a.appointment_time, a.staff_email, a.technician_email, c.carPlateNumber
        StringBuilder queryStr = new StringBuilder(
            "SELECT a, s.serviceName, s.serviceType, a.appointment_time, " +
            "a.staff_email, a.technician_email, c.carPlateNumber " + 
            "FROM Appointment a " +
            "JOIN a.service s " +
            "LEFT JOIN a.car c " + // 必须 JOIN car 才能拿到车牌
            "WHERE a.customer.email = :email"
        );

        // 保持现有的 filter 逻辑不变
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
}
