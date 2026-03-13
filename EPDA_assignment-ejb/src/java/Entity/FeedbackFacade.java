/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author teech
 */
@Stateless
public class FeedbackFacade extends AbstractFacade<Feedback> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public FeedbackFacade() {
        super(Feedback.class);
    }
    
   public List<Object[]> findDetailedFeedback(String email, String role) {
        // We select 'f' first to match your viewFeedback.jsp logic (row[0])
        String baseSelect = "SELECT f, s.serviceName, s.serviceType, a.appointment_date, " +
                            "a.appointment_time, a.staff_email, a.technician_email, c.carPlateNumber, a.customer.email ";

        // Use JPA paths: f.appointment -> a.service -> a.car
        String baseJoin = "FROM Feedback f " +
                          "JOIN f.appointment a " + 
                          "JOIN a.service s " +     
                          "LEFT JOIN a.car c ";     

        String jpql = baseSelect + baseJoin;

        if ("manager".equals(role)) {
            jpql += " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).getResultList();
        } else {
            // Accessing the email via the 'customer' object property
            jpql += " WHERE a.customer.email = :email ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class)
                     .setParameter("email", email)
                     .getResultList();
        }
    }

}
