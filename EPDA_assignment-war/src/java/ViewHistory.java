/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Feedback;
import Entity.FeedbackFacade;
import Entity.Payment;
import Entity.PaymentFacade;
import Entity.Services;
import Entity.ServicesFacade;
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/ViewHistory"})
public class ViewHistory extends HttpServlet {

    @EJB
    private UserFacade userFacade;
    @EJB
    private AppointmentFacade appointmentFacade;
    @EJB
    private PaymentFacade paymentFacade;
    @EJB
    private ServicesFacade serviceFacade;
    @EJB
    private FeedbackFacade feedbackFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User activeUser = userFacade.find(user.getUser_id());

        if (activeUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = activeUser.getRole().toLowerCase();
        String searchDate = request.getParameter("searchDate");
        String searchName = request.getParameter("searchName");
        String status = request.getParameter("status"); 

        // services
        List<Services> allServices = serviceFacade.findAll();
        request.setAttribute("allServices", allServices);

        String emailFilter = null;

        if (!"manager".equals(role)) {
            emailFilter = activeUser.getEmail();
        }
        List<Appointment> appointmentData = appointmentFacade.findFilteredAppointments(
                emailFilter,
                role,
                searchDate,
                searchName,
                status
        );

        // feedback load
        for (Appointment app : appointmentData) {

            Feedback fb = feedbackFacade.findByAppointmentId(app.getAppointment_id());

            if (fb != null) {
                app.setFeedbacks(Arrays.asList(fb));
            }

        }

        List<Payment> payments = null;
        if ("customer".equals(role)) {
            payments = paymentFacade.findFilteredPayments(
                    activeUser.getEmail(),
                    request.getParameter("payDate"),
                    request.getParameter("payMethod")
            );
        }

        request.setAttribute("appointmentData", appointmentData);
        request.setAttribute("payments", payments);

        request.getRequestDispatcher("viewHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "View History Servlet with Service Dropdown Logic";
    }
}
