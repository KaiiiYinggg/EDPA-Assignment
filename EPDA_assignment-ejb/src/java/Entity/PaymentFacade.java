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

    // View History Use
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

        if (date != null && !date.isEmpty()) {
            query.setParameter("date", date);
        }
        if (method != null && !method.isEmpty()) {
            query.setParameter("method", method);
        }

        return query.getResultList();
    }

    //Load manager dashboard
    public List<Object[]> getServiceDistribution() {
        return em.createQuery(
                "SELECT s.serviceType, COUNT(a) FROM Appointment a JOIN a.service s GROUP BY s.serviceType",
                Object[].class).getResultList();
    }

    public List<Object[]> getMonthlyRevenue() {
        return em.createQuery(
                "SELECT FUNCTION('MONTH', p.payment_date), SUM(p.total_price) "
                + "FROM Payment p GROUP BY FUNCTION('MONTH', p.payment_date)",
                Object[].class).getResultList();
    }

    public double getTotalRevenue() {
        Double total = (Double) em.createQuery("SELECT SUM(p.total_price) FROM Payment p").getSingleResult();
        return (total != null) ? total : 0.0;
    }

    //use in payment servlet
    public List<Payment> searchHistory(String query) {
        try {
            return em.createQuery(
                    "SELECT p FROM Payment p WHERE p.receipt_id LIKE :q OR p.appointment.customer.username LIKE :q",
                    Payment.class)
                    .setParameter("q", "%" + query + "%")
                    .getResultList();
        } catch (Exception e) {
            return new java.util.ArrayList<>();
        }
    }
}
