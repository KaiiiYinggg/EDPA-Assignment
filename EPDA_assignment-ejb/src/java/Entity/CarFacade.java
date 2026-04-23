/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class CarFacade {

    @PersistenceContext(unitName = "EPDA_assignment-ejbPU")
    private EntityManager em;

    public void create(Car car) {
        em.persist(car);
    }

    public void edit(Car car) {
        em.merge(car);
    }

    public void remove(Car car) {
        em.remove(em.merge(car));
        em.flush();
        em.clear();
    }

    public Car find(String carPlate) {
        return em.find(Car.class, carPlate);
    }

    public List<Car> findAll() {
        return em.createQuery("SELECT c FROM Car c", Car.class)
                .getResultList();
    }

    public void flush() {
        em.flush();
    }
    
    // Use in Appointment, EditProfile, Login, ManageCustomer, CustomerDashboard
    public List<Car> findByUserEmail(String email) {
        return em.createQuery("SELECT c FROM Car c WHERE c.user.email = :email", Car.class)
                .setParameter("email", email)
                .getResultList();
    }
    
}
