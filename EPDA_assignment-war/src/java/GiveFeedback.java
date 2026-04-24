/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Feedback;
import Entity.FeedbackFacade;
import Entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/GiveFeedback"})
public class GiveFeedback extends HttpServlet {

    @EJB
    FeedbackFacade feedbackFacade;
    @EJB
    private AppointmentFacade appointmentFacade; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appIdStr = request.getParameter("appointmentId");
        if (appIdStr != null && !appIdStr.isEmpty()) {
            Long appId = Long.parseLong(appIdStr);

            // check appointment has already received feedback
            Feedback fb = feedbackFacade.findByAppointmentId(appId);
            if (fb != null) {
                // if comment = true and role = customer
                User user = (User) request.getSession().getAttribute("user");
                if (fb != null && user != null && "customer".equalsIgnoreCase(user.getRole())) {
                    // check if BOTH are filled. If one is empty, let them in to finish the feedback
                    boolean techFilled = fb.getCustomerCommentToTech() != null && !fb.getCustomerCommentToTech().trim().isEmpty();
                    boolean staffFilled = fb.getCustomerCommentToStaff() != null && !fb.getCustomerCommentToStaff().trim().isEmpty();

                    if (techFilled && staffFilled) {
                        response.sendRedirect(request.getContextPath() + "/ViewHistory?error=already_commented");
                        return;
                    }
                }
            }

            Appointment app = appointmentFacade.find(appId);
            request.setAttribute("app", app);
        }
        request.getRequestDispatcher("/giveFeedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        String appIdStr = request.getParameter("appointmentId");

        try {
            Long appointmentId = Long.parseLong(appIdStr);
            Appointment app = appointmentFacade.find(appointmentId);
            Feedback fb = feedbackFacade.findByAppointmentId(appointmentId); 

            if (fb == null) {
                fb = new Feedback();
                fb.setAppointment(app);
                
            }
            String role = user.getRole().toLowerCase();

            if ("technician".equals(role)) {
                String techNote = request.getParameter("technicianNote");
                fb.setTechnician_feedback(techNote);
            } else {
                String target = request.getParameter("commentTarget");
                String commentText = request.getParameter("customerComment");
                int ranking = Integer.parseInt(request.getParameter("ranking"));

                // ranking
                fb.setRanking(ranking);

                if (target.contains("TECHNICIAN")) {
                    fb.setCustomerCommentToTech(commentText);
                } 
                if (target.contains("STAFF")) {
                    fb.setCustomerCommentToStaff(commentText);
                }
                if (target.contains("BOTH")) {
                    fb.setCustomerCommentToTech(commentText);
                    fb.setCustomerCommentToStaff(commentText);
                }
            }
            feedbackFacade.edit(fb); 

            response.sendRedirect(request.getContextPath() + "/ViewHistory?commentmessage=saved");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewHistory?error=failed");
        }
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
