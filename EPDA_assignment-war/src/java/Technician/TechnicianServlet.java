/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Technician;

import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.BusinessHour;
import Entity.BusinessHourFacade;
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
import javax.servlet.http.HttpSession;

@WebServlet(name = "TechnicianServlet", urlPatterns = {"/Technician/TechnicianServlet"})
public class TechnicianServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appFacade;
    @EJB
    private BusinessHourFacade businessHourFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Entity.User user = (Entity.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String techEmail = user.getEmail();

        List<Appointment> myTasks = appFacade.findByTechnicianEmail(techEmail);
        request.setAttribute("taskList", myTasks);

        LocalDate today = LocalDate.now();
        LocalDate oneMonthLater = today.plusMonths(1);

        List<BusinessHour> all = businessHourFacade.findAllOrderedByDate();

        List<BusinessHour> businessHours = all.stream()
                .filter(b -> b.getBusinessDate() != null)
                .filter(b
                        -> !b.getBusinessDate().isBefore(today)
                && !b.getBusinessDate().isAfter(oneMonthLater)
                )
                .collect(Collectors.toList());

        request.setAttribute("businessHours", businessHours);
        request.getRequestDispatcher("TechDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appIdStr = request.getParameter("appointmentId");
            //completed
            if (appIdStr != null) {
                Long appId = Long.parseLong(appIdStr);
                Appointment app = appFacade.find(appId);

                if (app != null) {
                    app.setAppointment_status("Completed");
                    appFacade.edit(app);
                }
            }
            response.sendRedirect("TechnicianServlet");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
