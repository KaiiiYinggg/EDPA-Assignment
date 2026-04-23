/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

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
        String baseSelect = "SELECT f, s.serviceType, a.appointment_date, "
                + "a.appointment_time, a.staff_email, a.technician_email, c.carPlateNumber, a.customer.email ";

        String baseJoin = "FROM Feedback f "
                + "JOIN f.appointment a "
                + "JOIN a.service s "
                + "LEFT JOIN a.car c ";

        String jpql = baseSelect + baseJoin;

        if ("manager".equals(role)) {
            //see all existing feedback records
            jpql += " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).getResultList();

        } else if ("technician".equals(role)) {
            //display all orders assigned to this technician
            jpql += " WHERE a.technician_email = :email "
                    + " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).setParameter("email", email).getResultList();
        } else {
            // customer part
            // must be their own services and they already rated it , means ranking > 0
            jpql += " WHERE a.customer.email = :email "
                    + " AND f.ranking > 0 "
                    + " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).setParameter("email", email).getResultList();
        }
    }

    // Give Feedback & View History
    public Feedback findByAppointmentId(Long appointmentId) {
        try {
            return (Feedback) em.createQuery(
                    "SELECT f FROM Feedback f WHERE f.appointment.appointment_id = :appId")
                    .setParameter("appId", appointmentId)
                    .getSingleResult();
        } catch (javax.persistence.NoResultException e) {
            // no feedback record for the appointment return null
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Load Manager Dashboard
    public List<Object[]> getServiceRatings() {
        return em.createQuery(
                "SELECT s.serviceType, AVG(f.ranking) FROM Feedback f "
                + "JOIN f.appointment a JOIN a.service s "
                + "WHERE f.ranking > 0 GROUP BY s.serviceType",
                Object[].class).getResultList();
    }

    // View Feedback
    public List<Object[]> findDetailedFeedbackFiltered(String email, String role, String search, String rating, String date) {

        StringBuilder jpql = new StringBuilder(
                "SELECT f, c.carPlateNumber, s.serviceType, a.appointment_date, "
                + "a.staff_email, a.technician_email, a.appointment_status, u.username "
                + "FROM Feedback f "
                + "JOIN f.appointment a "
                + "JOIN a.service s "
                + "JOIN a.car c "
                + "JOIN a.customer u "
                + "WHERE 1=1 "
        );

        //filter by role
        if ("technician".equalsIgnoreCase(role)) {
            jpql.append(" AND a.technician_email = :email");
        } else if ("customer".equalsIgnoreCase(role)) {
            jpql.append(" AND u.email = :email");
        }

        //search
        if (search != null && !search.trim().isEmpty()) {
            jpql.append(" AND (UPPER(c.carPlateNumber) LIKE :search "
                    + "OR UPPER(s.serviceType) LIKE :search "
                    + "OR UPPER(u.username) LIKE :search)");
        }

        //rating filter
        if (rating != null && !rating.trim().isEmpty()) {
            jpql.append(" AND f.ranking = :rating");
        }

        //date filter
        boolean hasDate = (date != null && !date.trim().isEmpty());
        if (hasDate) {
            // compare date range (same day)
            jpql.append(" AND FUNCTION('DATE', a.appointment_date) >= :startDate ");
            jpql.append(" AND FUNCTION('DATE', a.appointment_date) <= :endDate");
        }

        jpql.append(" ORDER BY a.appointment_date DESC");

        TypedQuery<Object[]> query = em.createQuery(jpql.toString(), Object[].class);
        if ("technician".equalsIgnoreCase(role) || "customer".equalsIgnoreCase(role)) {
            query.setParameter("email", email);
        }

        if (search != null && !search.trim().isEmpty()) {
            query.setParameter("search", "%" + search.trim().toUpperCase() + "%");
        }
        if (rating != null && !rating.trim().isEmpty()) {
            try {
                query.setParameter("rating", Integer.parseInt(rating));
            } catch (NumberFormatException e) {
                // fallback invalid rating
                query.setParameter("rating", -1);
            }
        }

        if (hasDate) {
            try {
                LocalDate parsedDate = LocalDate.parse(date.trim());
                // same day range
                String startDate = parsedDate.toString();
                String endDate = parsedDate.toString();

                query.setParameter("startDate", startDate);
                query.setParameter("endDate", endDate);

            } catch (Exception e) {
                System.err.println("date parse error: " + date);
                e.printStackTrace();
                return new ArrayList<>();
            }
        }

        return query.getResultList();
    }
}
