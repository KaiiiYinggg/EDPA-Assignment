/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtils {

    public static void sendWelcomeEmail(String recipientEmail, String userName) {
        final String myEmail = "nikcoleong31@gmail.com";
        final String myPassword = "ewsc tjuk mife vshe";

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(myEmail, myPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myEmail, "APU Automotive Service Center")); //display name
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Welcome to APU Automotive - Registration Successful!");
            
            // email design
            String htmlBody
                    = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;'>"
                    + "<div style='background-color: #2c3e50; color: white; padding: 20px; text-align: center;'>"
                    + "<h1>APU AUTOMOTIVE</h1>"
                    + "<p style='margin: 0;'>Your Trusted Car Service Partner</p>"
                    + "</div>"
                    + "<div style='padding: 30px; line-height: 1.6; color: #333;'>"
                    + "<h3>Hi " + userName + ",</h3>"
                    + "<p>Congratulations! Your account has been successfully created at <b>APU Automotive Service Center</b>.</p>"
                    + "</div>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; text-align: center; font-size: 12px; color: #777;'>"
                    + "<p>© 2026 APU Automotive Service Center. All Rights Reserved.</p>"
                    + "<p>Bukit Jalil, KL</p>"
                    + "</div>"
                    + "</div>";

            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email Sent Successfully with Design!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
