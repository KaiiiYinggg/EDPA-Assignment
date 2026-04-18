/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDate;
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
}
