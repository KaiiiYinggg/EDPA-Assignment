package Manager;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.AppointmentFacade;
import Entity.FeedbackFacade;
import Entity.PaymentFacade;
import Entity.UserFacade;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/Manager/loadManagerDashboard"})
public class loadManagerDashboard extends HttpServlet {
    @EJB private PaymentFacade paymentFacade;
    @EJB private UserFacade userFacade;
    @EJB private AppointmentFacade appointmentFacade;
    @EJB private FeedbackFacade feedbackFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // total revenue
            double totalRevenue = paymentFacade.getTotalRevenue();
            
            // total user
            long totalUsers = userFacade.count();
            
            // services
            List<Object[]> serviceStats = paymentFacade.getServiceDistribution();

            // technician
            List<Object[]> technicianPerformance = appointmentFacade.getTechnicianPerformance();
            //
            List<Object[]> staffPerformance = appointmentFacade.getStaffPerformance();

            // services ranking
            List<Object[]> serviceRatings = feedbackFacade.getServiceRatings();
            
            List<Object[]> monthlyRevenue = paymentFacade.getMonthlyRevenue();

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("serviceStats", serviceStats);
            request.setAttribute("technicianPerformance", technicianPerformance);
            request.setAttribute("staffPerformance", staffPerformance);
            request.setAttribute("serviceRatings", serviceRatings);
            request.setAttribute("monthlyRevenue", monthlyRevenue);

            request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=report_loading_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
