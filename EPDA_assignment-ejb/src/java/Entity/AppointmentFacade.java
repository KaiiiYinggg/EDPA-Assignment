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
        StringBuilder queryStr = new StringBuilder(
            "SELECT a, s.serviceName, s.serviceType FROM Appointment a, Services s " +
            "WHERE a.service_id = s.service_id AND a.customer_email = :email"
        );

        // Add optional filters
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
