package Customer;
import Entity.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/Customer/CustomerDashboardServlet"})
public class CustomerDashboardServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    @EJB
    private AppointmentFacade appointmentFacade;

    @EJB
    private BusinessHourFacade businessHourFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 🔥 refresh user cars
        List<Car> customerCars = carFacade.findByUserEmail(user.getEmail());
        session.setAttribute("customerCars", customerCars);

        // 🔥 service summary
        List<Object[]> serviceSummary = appointmentFacade.findServiceSummary(user.getEmail());
        session.setAttribute("serviceSummary", serviceSummary);

        // 🔥 business hours (IMPORTANT)
        LocalDate today = LocalDate.now();
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

        // forward to JSP
        request.getRequestDispatcher("/Customer/customerDashboard.jsp")
                .forward(request, response);
    }
}
