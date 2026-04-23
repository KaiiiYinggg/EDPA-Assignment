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
import javax.annotation.security.PermitAll;

@Stateless
@PermitAll
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

    // Use in View History
    public List<Appointment> findFilteredAppointments(String email, String role, String date, String name, String status) {
        StringBuilder queryStr = new StringBuilder(
                "SELECT DISTINCT a FROM Appointment a "
                + "JOIN FETCH a.service s "
                + "LEFT JOIN FETCH a.car c "
                + "LEFT JOIN FETCH a.feedbacks f "
        );

        boolean hasWhere = false;

        if (!"manager".equals(role) && email != null) {
            if ("technician".equals(role)) {
                queryStr.append(" WHERE a.technician_email = :email");
            } else {
                queryStr.append(" WHERE a.customer.email = :email");
            }
            hasWhere = true;
        }

        if (date != null && !date.isEmpty()) {
            queryStr.append(hasWhere ? " AND" : " WHERE");
            queryStr.append(" a.appointment_date = :date");
            hasWhere = true;
        }

        if (name != null && !name.isEmpty()) {
            queryStr.append(hasWhere ? " AND" : " WHERE");
            queryStr.append(" UPPER(s.serviceType) LIKE :name");
            hasWhere = true;
        }

        if (status != null && !status.isEmpty()) {
            queryStr.append(hasWhere ? " AND" : " WHERE");
            queryStr.append(" a.appointment_status = :status");
            hasWhere = true;
        }

        queryStr.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");

        TypedQuery<Appointment> query = em.createQuery(queryStr.toString(), Appointment.class);

        if (!"manager".equals(role) && email != null) {
            query.setParameter("email", email);
        }

        if (date != null && !date.isEmpty()) {
            query.setParameter("date", java.time.LocalDate.parse(date));
        }
        if (name != null && !name.isEmpty()) {
            query.setParameter("name", "%" + name.toUpperCase() + "%");
        }
        if (status != null && !status.isEmpty()) {
            query.setParameter("status", status);
        }

        return query.getResultList();
    }

    // Use in Appointment Servlet
    public List<Appointment> searchAppointments(String custEmail, String dateStr, String idStr) {
        // lock all appointments for this customer
        StringBuilder jpql = new StringBuilder("SELECT a FROM Appointment a WHERE a.customer.email = :email");

        // Add the date if it exists then add the ID if it exists
        if (dateStr != null && !dateStr.isEmpty()) {
            jpql.append(" AND a.appointment_date = :date");
        }
        if (idStr != null && !idStr.isEmpty()) {
            jpql.append(" AND a.appointment_id = :id");
        }

        // sort by ID in descending order
        jpql.append(" ORDER BY a.appointment_id DESC");

        javax.persistence.TypedQuery<Appointment> query = em.createQuery(jpql.toString(), Appointment.class);
        query.setParameter("email", custEmail);

        if (dateStr != null && !dateStr.isEmpty()) {
            query.setParameter("date", java.time.LocalDate.parse(dateStr));
        }
        if (idStr != null && !idStr.isEmpty()) {
            try {
                query.setParameter("id", Long.parseLong(idStr));
            } catch (NumberFormatException e) {
                query.setParameter("id", -1L);
            }
        }

        return query.getResultList();
    }

    public List<Appointment> findByCustomerEmail(String email) {
        return em.createQuery(
                "SELECT a FROM Appointment a WHERE a.customer.email = :email",
                Appointment.class)
                .setParameter("email", email)
                .getResultList();
    }

    // Use in Customer Dashboard & Login
    public List<Object[]> findServiceSummary(String email) {
        try {
            String jpql = "SELECT a.appointment_date, s.serviceType, a.appointment_status, "
                    + "a.appointment_time, c.carPlateNumber, s.serviceType "
                    + "FROM Appointment a "
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

    public List<User> findAvailableTechnicians(LocalDate date, LocalTime startTime, LocalTime endTime) {

        String busyTechsQuery = "SELECT DISTINCT a.technician_email FROM Appointment a "
                + "WHERE a.appointment_date = :date "
                + "AND a.technician_email IS NOT NULL "
                + "AND a.appointment_time < :targetEnd "
                + "AND a.appointment_status != 'Cancelled' "
                + "AND FUNC('TIMESTAMPADD', FUNC('SQL_TSI_HOUR'), a.service.serviceHour, "
                + "CAST(a.appointment_time AS TIMESTAMP)) > :targetStart";

        return em.createQuery("SELECT u FROM User u WHERE u.role = 'technician' "
                + "AND u.email NOT IN (" + busyTechsQuery + ")", User.class)
                .setParameter("date", date)
                .setParameter("targetStart", startTime)
                .setParameter("targetEnd", endTime)
                .getResultList();
    }
    // Use in Load Manager Dashboard
    public List<Object[]> getTechnicianPerformance() {
        return em.createQuery(
                "SELECT a.technician_email, COUNT(a) FROM Appointment a "
                + "WHERE a.appointment_status = 'Completed' OR a.appointment_status='Paid'"
                + "GROUP BY a.technician_email ORDER BY COUNT(a) DESC",
                Object[].class).getResultList();
    }

    public List<Object[]> getStaffPerformance() {
        return em.createQuery(
                "SELECT a.staff_email, COUNT(a) FROM Appointment a "
                + "WHERE a.appointment_status = 'Completed' OR a.appointment_status='Paid'"
                + "GROUP BY a.staff_email ORDER BY COUNT(a) DESC",
                Object[].class).getResultList();
    }

    // Use in Payment Servlet
    public List<Appointment> findAllCompleted() {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_status = 'Completed'", Appointment.class)
                .getResultList();
    }

    public List<Appointment> searchUnpaid(String query) {
        try {
            if (query.matches("\\d+")) {
                Long id = Long.parseLong(query);

                return em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.appointment_id = :id AND a.appointment_status = 'Completed'",
                        Appointment.class)
                        .setParameter("id", id)
                        .getResultList();
            } else {
                // search by email
                return em.createQuery(
                        "SELECT a FROM Appointment a WHERE a.customer.email LIKE :q AND a.appointment_status = 'Completed'",
                        Appointment.class)
                        .setParameter("q", "%" + query + "%")
                        .getResultList();
            }

        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    // Use in Technician Servlet
    public List<Appointment> findByTechnicianEmail(String email) {
        // only check "Approved" because once it become "Completed" it not in the todo list
        return em.createQuery("SELECT a FROM Appointment a WHERE a.technician_email = :email AND a.appointment_status = 'Approved'", Appointment.class)
                .setParameter("email", email)
                .getResultList();
    }

    // Use in Staff Dashboard
    public List<Appointment> findAppointmentsByDate(LocalDate date) {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_date = :date", Appointment.class)
                .setParameter("date", date)
                .getResultList();
    }

    public List<Appointment> findUnpaidAppointments() {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_status = 'Completed'", Appointment.class)
                .getResultList();
    }

    // Use in Business Hour
    public List<Appointment> findByDate(LocalDate date) {
        return em.createQuery("SELECT a FROM Appointment a WHERE a.appointment_date = :date", Appointment.class)
                .setParameter("date", date)
                .getResultList();
    }

    public List<Appointment> findAllFiltered(String date, String service, String status) {

        StringBuilder jpql = new StringBuilder("SELECT a FROM Appointment a WHERE 1=1");

        // date filter
        if (date != null && !date.isEmpty()) {
            jpql.append(" AND a.appointment_date = :date");
        }

        // service filter
        if (service != null && !service.isEmpty()) {
            jpql.append(" AND a.service.serviceType = :service");
        }

        // status filter
        if (status != null && !status.isEmpty()) {
            jpql.append(" AND a.appointment_status = :status");
        }

        jpql.append(" ORDER BY a.appointment_date DESC, a.appointment_time DESC");

        TypedQuery<Appointment> query = em.createQuery(jpql.toString(), Appointment.class);

        // set parameter
        if (date != null && !date.isEmpty()) {
            query.setParameter("date", java.time.LocalDate.parse(date));
        }

        if (service != null && !service.isEmpty()) {
            query.setParameter("service", service);
        }

        if (status != null && !status.isEmpty()) {
            query.setParameter("status", status);
        }

        return query.getResultList();
    }
}
