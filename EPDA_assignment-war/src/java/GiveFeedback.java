/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Feedback;
import Entity.FeedbackFacade;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author teech
 */
@WebServlet(urlPatterns = {"/GiveFeedback"})
public class GiveFeedback extends HttpServlet {

    @EJB
    FeedbackFacade feedbackFacade;
    @EJB
    private AppointmentFacade appointmentFacade; 

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("giveFeedback.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Retrieve raw parameters
        String target = request.getParameter("commentTarget");
        String commentText = request.getParameter("customerComment");
        String rankingStr = request.getParameter("ranking");
        String appIdStr = request.getParameter("appointmentId");
        
        try {
            // 3. Safe Parsing
            int ranking = Integer.parseInt(rankingStr);
            Long appointmentId = Long.parseLong(appIdStr);
            String fullComment = target + commentText; // Example: "To TECHNICIAN: Excellent service"
            
            Appointment appointment = appointmentFacade.find(appointmentId);
            if (appointment == null) {
                response.sendRedirect("ViewHistory?error=appointmentNotFound");
                return;
            }

            // 4. Populate and Create Entity
            Feedback fb = new Feedback();
            // IMPORTANT: Ensure the method name matches your Feedback.java exactly
            fb.setCustomer_comment(fullComment); 
            fb.setRanking(ranking);
            fb.setAppointment(appointment);
            fb.setTechnician_feedback(null); 

            feedbackFacade.create(fb);
            
            // 5. Success redirect
            response.sendRedirect("ViewHistory?commentmessage=saved");
            
        } catch (NumberFormatException e) {
            // Log the error and notify the user
            response.sendRedirect("ViewHistory?error=invalidFormat");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
