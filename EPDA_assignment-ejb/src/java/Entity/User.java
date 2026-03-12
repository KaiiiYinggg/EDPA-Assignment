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
import javax.persistence.Table;
import javax.persistence.Column;
/**
 *
 * @author teech
 */
@Entity
@Table(name = "USERS_LIST")

public class User implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long user_id;
    
    private String username;
    private String password;
    private int phoneNumber;
    private String gender;
    private String role;
    

    @Column(unique = true)
    private String email;
    private String profilePic;

    public User() {
    }

    public User(String username, String password, int phoneNumber, String gender, String role, String email) {
        this.username = username;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.role = role;
        this.email = email;
    }

    public User(String username, String password, int phoneNumber, String gender, String role, String email,String profilePic) {
        this.username = username;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.role = role;
        this.email = email;
        this.profilePic = profilePic;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Long getUser_id() {
        return user_id;
    }

    public String getUsername() {
        return username;
    }

    public int getPhoneNumber() {
        return phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public String getRole() {
        return role;
    }

    public String getEmail() {
        return email;
    }

    public void setUser_id(Long user_id) {
        this.user_id = user_id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPhoneNumber(int phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
    


    @Override
    public int hashCode() {
        int hash = 0;
        hash += (user_id != null ? user_id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof User)) {
            return false;
        }
        User other = (User) object;
        if ((this.user_id == null && other.user_id != null) || (this.user_id != null && !this.user_id.equals(other.user_id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Entity.User[ id=" + user_id + " ]";
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;

    }
    
}
