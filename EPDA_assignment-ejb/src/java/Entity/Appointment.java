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
public class Appointment implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long appointment_id;
    
    private String appointment_date;
    private String appointment_time;
    private String customer_email;
    private String staff_email;
    private String technician_email;
    private Long service_id;
    private String appointment_status;

    public Long getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Long id) {
        this.appointment_id = id;
    }

    public String getAppointment_date() {
        return appointment_date;
    }

    public void setAppointment_date(String appointment_date) {
        this.appointment_date = appointment_date;
    }

    public String getAppointment_status() {
        return appointment_status;
    }

    public void setAppointment_status(String appointment_status) {
        this.appointment_status = appointment_status;
    }

    public String getAppointment_time() {
        return appointment_time;
    }

    public void setAppointment_time(String appointment_time) {
        this.appointment_time = appointment_time;
    }

    public String getCustomer_email() {
        return customer_email;
    }

    public void setCustomer_email(String customer_email) {
        this.customer_email = customer_email;
    }

    public String getStaff_email() {
        return staff_email;
    }

    public void setStaff_email(String staff_email) {
        this.staff_email = staff_email;
    }

    public String getTechnician_email() {
        return technician_email;
    }

    public void setTechnician_email(String technician_email) {
        this.technician_email = technician_email;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (appointment_id != null ? appointment_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Appointment)) {
            return false;
        }
        Appointment other = (Appointment) object;
        if ((this.appointment_id == null && other.appointment_id != null) || (this.appointment_id != null && !this.appointment_id.equals(other.appointment_id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Entity.Appointment[ id=" + appointment_id + " ]";
    }
    
}
