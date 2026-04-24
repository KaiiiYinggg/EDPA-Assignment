package Staff;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.BusinessHour;
import Entity.BusinessHourFacade;
import Entity.Services;
import Entity.ServicesFacade;
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/Staff/StaffDashboardServlet"})
public class StaffDashboardServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appointmentFacade;
    @EJB
    private UserFacade userFacade;
    @EJB
    private ServicesFacade serviceFacade;
    @EJB
    private BusinessHourFacade businessHourFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        java.time.LocalDate today = java.time.LocalDate.now();

        List<Appointment> todayApps = appointmentFacade.findAppointmentsByDate(today);

        LocalDate oneMonthLater = today.plusMonths(1);

        List<BusinessHour> businessHours = businessHourFacade.findAllOrderedByDate()
                .stream()
                .filter(b -> b.getBusinessDate() != null)
                .filter(b -> {
                    LocalDate d = b.getBusinessDate();
                    return !d.isBefore(today) && !d.isAfter(oneMonthLater);
                })
                .collect(Collectors.toList());

        request.setAttribute("businessHours", businessHours);

        // unpaid bill
        List<Appointment> unpaidApps = appointmentFacade.findUnpaidAppointments();
        int totalCust = userFacade.countCustomers();

        request.setAttribute("todayApps", todayApps);
        request.setAttribute("unpaidApps", unpaidApps);
        request.setAttribute("totalCust", totalCust);

        List<Services> services = serviceFacade.findAll();
        request.setAttribute("services", services);

        String role = user.getRole().toLowerCase();
        if ("counter staff".equals(role) || "staff".equals(role)) {
            request.getRequestDispatcher("/Staff/StaffDashboard.jsp").forward(request, response);
        } else if ("manager".equals(role)) {
            request.getRequestDispatcher("Manager/ManagerDashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
