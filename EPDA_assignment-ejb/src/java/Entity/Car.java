/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.JoinColumn;

@Entity
@Table(name = "CAR_LIST")
public class Car implements Serializable {

    private static final long serialVersionUID = 1L;
    

    @Id
    private String carPlateNumber;
    

    private String carBrand;
    private String carModel;
    private String color;
    @Column(name = "CAR_YEAR")
    private int year;
    
    @JoinColumn(name = "userEmail",referencedColumnName = "email") 
    private User user;

    public Car() {
    }
    public User getUser() {
        return user;
   }

    public void setUser(User user) {
        this.user = user;
    } 
    
    public Car(String carPlateNumber, String carBrand, String carModel,
            String color, int year, User user) {
        this.carPlateNumber = carPlateNumber;
        this.carBrand = carBrand;
        this.carModel = carModel;
        this.color = color;
        this.year = year;
        this.user = user;
    }

    // getters 和 setters
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
}
