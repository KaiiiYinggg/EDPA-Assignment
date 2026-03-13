/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 *
 * @author Kai Ying
 */

@Entity
@Table(name = "CAR_LIST")
public class Car implements Serializable {

    @Id
    private String carPlateNumber;

    private String carBrand;
    private String carModel;
    private String color;
    private int year;

    @ManyToOne
    @JoinColumn(name = "user_id") // 数据库列
    private User user;
    
    // In Car.java, ensure this matches the variable name in Appointment.java
    @javax.persistence.OneToMany(mappedBy = "car") 
    private java.util.List<Appointment> appointment;
    
    public Car() {
    }

    public String getCarPlateNumber() {
        return carPlateNumber;
    }

    public void setCarPlateNumber(String carPlateNumber) {
        this.carPlateNumber = carPlateNumber;
    }

    public String getCarBrand() {
        return carBrand;
    }

    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
    
    public java.util.List<Appointment> getAppointment() {
        return appointment;
    }

    public void setAppointment(java.util.List<Appointment> appointment) {
        this.appointment = appointment;
    }
}