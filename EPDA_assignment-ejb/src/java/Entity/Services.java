/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 *
 * @author teech
 */
@Entity
public class Services implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long service_id;
 
    private int serviceHour;// baterry change or screen replacement
    private String serviceType;//normal(1h) or major(3h)
    private double price;

    public Services() {
    }

    public Long getService_id() {
        return service_id;
    }

    public void setService_id(Long id) {
        this.service_id = id;
    }

    public int getServiceHour() {
        return serviceHour;
    }

    public void setServiceHour(int serviceHour) {
        this.serviceHour = serviceHour;
    }


    

    public void setPrice(double price) {
        this.price = price;
    }

    public double getPrice() {
        return price;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getServiceType() {
        return serviceType;
    }

    public Services(int serviceHour, String serviceType, double price) {
        this.serviceHour = serviceHour;
        this.serviceType = serviceType;
        this.price = price;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (service_id != null ? service_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Services)) {
            return false;
        }
        Services other = (Services) object;
        if ((this.service_id == null && other.service_id != null) || (this.service_id != null && !this.service_id.equals(other.service_id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Entity.Services[ id=" + service_id + " ]";
    }
    
}
