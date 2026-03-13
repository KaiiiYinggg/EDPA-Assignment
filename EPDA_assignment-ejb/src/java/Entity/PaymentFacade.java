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
public class PaymentFacade extends AbstractFacade<Payment> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public PaymentFacade() {
        super(Payment.class);
    }
    
    public List<Payment> findFilteredPayments(String email, String date, String method) {
        StringBuilder queryStr = new StringBuilder(
            "SELECT p FROM Payment p WHERE p.appointment.customer.email = :email"
        );

        if (date != null && !date.isEmpty()) {
            queryStr.append(" AND p.payment_date = :date");
        }
        if (method != null && !method.isEmpty()) {
            queryStr.append(" AND p.payment_method = :method");
        }

        Query query = em.createQuery(queryStr.toString(), Payment.class);
        query.setParameter("email", email);

        if (date != null && !date.isEmpty()) query.setParameter("date", date);
        if (method != null && !method.isEmpty()) query.setParameter("method", method);

        return query.getResultList();
    }
}
