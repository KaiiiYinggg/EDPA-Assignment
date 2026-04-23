/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author teech
 */
@Stateless
public class ServicesFacade extends AbstractFacade<Services> {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ServicesFacade() {
        super(Services.class);
    }

    //method//   
    public void updatePrice(Long service_id, double newPrice) {
        Services s = em.find(Services.class, service_id);
        if (s != null) {
            s.setPrice(newPrice);
            em.merge(s);
            em.flush();
        }
    }

    public void delete(Long id) {
        Services s = em.find(Services.class, id);
        if (s != null) {
            em.remove(s);
        }
    }

    public Services findByType(String type) {
        try {
            return (Services) em.createQuery("SELECT s FROM Services s WHERE s.serviceType = :type")
                    .setParameter("type", type)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

}
