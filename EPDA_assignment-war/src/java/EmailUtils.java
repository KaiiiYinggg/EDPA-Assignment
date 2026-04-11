/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Kai Ying
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
            message.setFrom(new InternetAddress(myEmail, "APU Automotive Service Center")); // 这样发件人会显示名字
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Welcome to APU Automotive - Registration Successful!");

            // 设计漂亮的 HTML 内容
            String htmlBody
                    = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;'>"
                    + "<div style='background-color: #2c3e50; color: white; padding: 20px; text-align: center;'>"
                    + "<h1>APU AUTOMOTIVE</h1>"
                    + "<p style='margin: 0;'>Your Trusted Car Service Partner</p>"
                    + "</div>"
                    + "<div style='padding: 30px; line-height: 1.6; color: #333;'>"
                    + "<h3>Hi " + userName + ",</h3>"
                    + "<p>Congratulations! Your account has been successfully created at <b>APU Automotive Service Center</b>.</p>"
                    + "<p>We are excited to help you keep your vehicle in top condition. You can now use our portal to:</p>"
                    + "<ul>"
                    + "<li>Book Service Appointments</li>"
                    + "<li>Track your Car Status</li>"
                    + "<li>View Digital Receipts</li>"
                    + "</ul>"
                    + "</div>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; text-align: center; font-size: 12px; color: #777;'>"
                    + "<p>© 2026 APU Automotive Service Center. All Rights Reserved.</p>"
                    + "<p>Asia Pacific University, Bukit Jalil, KL</p>"
                    + "</div>"
                    + "</div>";

            // 注意：这里必须用 setContent 才能发 HTML，不能用 setText
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email Sent Successfully with Design!");

        } catch (Exception e) { // 改成 Exception 可以抓到更多细节错误
            e.printStackTrace();
        }
    }
}
