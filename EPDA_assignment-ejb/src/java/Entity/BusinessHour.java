/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import javax.persistence.*;

@Entity
public class BusinessHour implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate businessDate;

    private LocalTime openTime;

    private LocalTime closeTime;

    private boolean isClosed;

    private String note;

    public Long getId() {
        return id;
    }

    public LocalDate getBusinessDate() {
        return businessDate;
    }

    public LocalTime getOpenTime() {
        return openTime;
    }

    public LocalTime getCloseTime() {
        return closeTime;
    }

    public boolean isIsClosed() {
        return isClosed;
    }

    public String getNote() {
        return note;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setBusinessDate(LocalDate businessDate) {
        this.businessDate = businessDate;
    }

    public void setOpenTime(LocalTime openTime) {
        this.openTime = openTime;
    }

    public void setCloseTime(LocalTime closeTime) {
        this.closeTime = closeTime;
    }

    public void setIsClosed(boolean isClosed) {
        this.isClosed = isClosed;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    
}