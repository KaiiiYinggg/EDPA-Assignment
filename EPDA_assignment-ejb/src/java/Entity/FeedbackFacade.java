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
        String baseSelect = "SELECT f, s.serviceType, a.appointment_date, " +
                            "a.appointment_time, a.staff_email, a.technician_email, c.carPlateNumber, a.customer.email ";

        String baseJoin = "FROM Feedback f " +
                          "JOIN f.appointment a " + 
                          "JOIN a.service s " +      
                          "LEFT JOIN a.car c ";      

        String jpql = baseSelect + baseJoin;

        if ("manager".equals(role)) {
            // 管理员：通常看到所有已存在反馈的记录（可选：是否过滤 Pending）
            jpql += " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).getResultList();

        } else if ("technician".equals(role)) {
            // 技术人员逻辑：必须是分配给自己的，且自己已经回复过的 (不等于 Pending)
            jpql += " WHERE a.technician_email = :email " +
                    " AND f.technician_feedback IS NOT NULL " +
                    " AND f.technician_feedback <> 'Pending' " +
                    " AND f.technician_feedback <> '' " +
                    " ORDER BY a.appointment_date DESC";
            return em.createQuery(jpql, Object[].class).setParameter("email", email).getResultList();

        } else {
            // 顾客逻辑：必须是自己的，且自己已经评价过的 (ranking > 0)
            jpql += " WHERE a.customer.email = :email " +
                    " AND f.ranking > 0 " + 
                    " ORDER BY a.appointment_date DESC";
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
   
   public List<Object[]> getServiceRatings() {
        return em.createQuery(
            "SELECT s.serviceType, AVG(f.ranking) FROM Feedback f " +
            "JOIN f.appointment a JOIN a.service s " +
            "WHERE f.ranking > 0 GROUP BY s.serviceType", 
            Object[].class).getResultList();
    }

}
