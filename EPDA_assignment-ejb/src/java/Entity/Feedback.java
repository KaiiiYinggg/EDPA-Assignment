/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 *
 * @author teech
 */
@Entity
public class Feedback implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long feedback_id;
    
    private String customer_comment;
    private int ranking;
    private String technician_feedback;
    private Long appointment_id;

    public Long getFeedback_id() {
        return feedback_id;
    }

    public void setFeedback_id(Long id) {
        this.feedback_id = id;
    }

    public Long getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Long appointment_id) {
        this.appointment_id = appointment_id;
    }

    public String getCustomer_comment() {
        return customer_comment;
    }

    public void setCustomer_comment(String customer_comments) {
        this.customer_comment = customer_comments;
    }

    public int getRanking() {
        return ranking;
    }

    public void setRanking(int ranking) {
        this.ranking = ranking;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public String getTechnician_feedback() {
        return technician_feedback;
    }

    public void setTechnician_feedback(String technician_feedback) {
        this.technician_feedback = technician_feedback;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (feedback_id != null ? feedback_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Feedback)) {
            return false;
        }
        Feedback other = (Feedback) object;
        if ((this.feedback_id == null && other.feedback_id != null) || (this.feedback_id != null && !this.feedback_id.equals(other.feedback_id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Entity.Feedback[ id=" + feedback_id + " ]";
    }
    
}
