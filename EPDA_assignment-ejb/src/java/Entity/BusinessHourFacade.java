/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDate;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.*;

@Stateless
public class BusinessHourFacade extends AbstractFacade<BusinessHour> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public BusinessHourFacade() {
        super(BusinessHour.class);
    }
    
    // Use in Appointment
    public BusinessHour findByDate(LocalDate date) {
        try {
            return em.createQuery(
                    "SELECT b FROM BusinessHour b WHERE b.businessDate = :date",
                    BusinessHour.class)
                    .setParameter("date", date)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    // Use in Customer Dashboard, Business Hour, Staff Dashboard, Technician Servlet
    public List<BusinessHour> findAllOrderedByDate() {
        return em.createQuery("SELECT b FROM BusinessHour b ORDER BY b.businessDate ASC", BusinessHour.class)
                .getResultList();
    }
}
