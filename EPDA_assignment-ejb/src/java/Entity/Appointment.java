/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 *
 * @author teech
 */
@Entity
public class Appointment implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long appointment_id;
    
    private LocalDate appointment_date;
    private LocalTime appointment_time;
    
    @ManyToOne
    @JoinColumn(name="customer_email",referencedColumnName="email")
    private User customer;
    
    private String staff_email;
    private String technician_email;
    
    @ManyToOne
    @JoinColumn(name="service_id")
    private Services service;
    
    private String appointment_status;
    
    @ManyToOne
    @JoinColumn(name = "car_plate_number") // This creates the column in the APPOINTMENT table
    private Car car;
    
    @javax.persistence.OneToMany(mappedBy = "appointment", cascade = javax.persistence.CascadeType.ALL,fetch = javax.persistence.FetchType.EAGER)
    private java.util.List<Feedback> feedbacks;
    
    public java.util.List<Feedback> getFeedbacks() {
        return feedbacks;
    }

    public void setFeedbacks(java.util.List<Feedback> feedbacks) {
        this.feedbacks = feedbacks;
    }

    public Long getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(Long id) {
        this.appointment_id = id;
    }

    public LocalDate getAppointment_date() {
        return appointment_date;
    }

    public void setAppointment_date(LocalDate appointment_date) {
        this.appointment_date = appointment_date;
    }


    public String getAppointment_status() {
        return appointment_status;
    }

    public void setAppointment_status(String appointment_status) {
        this.appointment_status = appointment_status;
    }

    public LocalTime getAppointment_time() {
        return appointment_time;
    }

    public void setAppointment_time(LocalTime appointment_time) {
        this.appointment_time = appointment_time;
    }


    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public User getCustomer() {
        return customer;
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

    public Services getService() {
        return service;
    }

    public void setService(Services service) {
        this.service = service;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public Car getCar() {
        return car;
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
