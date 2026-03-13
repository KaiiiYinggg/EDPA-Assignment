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
        // SELECT f 表示 row[0] 是一个完整的 Feedback 对象
        String baseSelect = "SELECT f, s.serviceName, s.serviceType, a.appointment_date, " +
                            "a.appointment_time, a.staff_email, a.technician_email, c.carPlateNumber, a.customer.email ";

        String baseJoin = "FROM Feedback f " +
                          "JOIN f.appointment a " + 
                          "JOIN a.service s " +      
                          "LEFT JOIN a.car c ";      

        String jpql = baseSelect + baseJoin;

        if ("manager".equals(role)) {
            jpql += " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).getResultList();
        } else if ("technician".equals(role)) {
            // 新增：技术人员只能看到分配给自己的任务评价
            jpql += " WHERE a.technician_email = :email ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).setParameter("email", email).getResultList();
        } else {
            // 客户：看到自己提交的评价
            jpql += " WHERE a.customer.email = :email ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).setParameter("email", email).getResultList();
        }
    }
   
   public Feedback findByAppointmentId(Long appointmentId) {
        try {
            // 使用 JPQL 查询，通过关联实体 appointment 的 ID 进行筛选
            return (Feedback) em.createQuery(
                "SELECT f FROM Feedback f WHERE f.appointment.appointment_id = :appId")
                .setParameter("appId", appointmentId)
                .getSingleResult();
        } catch (javax.persistence.NoResultException e) {
            // 如果该预约还没有任何反馈记录（客户还没填），则返回 null
            return null; 
        } catch (Exception e) {
            // 捕获其他潜在异常
            e.printStackTrace();
            return null;
        }
    }

}
