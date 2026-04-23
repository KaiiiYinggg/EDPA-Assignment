package Manager;

import Entity.BusinessHour;
import Entity.BusinessHourFacade;
import Entity.Appointment;
import Entity.AppointmentFacade;
import java.io.IOException;
import java.time.LocalDate;
import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/Manager/BusinessHourServlet")
public class BusinessHourServlet extends HttpServlet {

    @EJB
    private BusinessHourFacade bhFacade;

    @EJB
    private AppointmentFacade appointmentFacade;

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateStr = request.getParameter("date");

        if (dateStr == null || dateStr.isEmpty()) {
            List<BusinessHour> allSettings = bhFacade.findAllOrderedByDate();
            request.setAttribute("allSettings", allSettings);
            request.getRequestDispatcher("businessHourManagement.jsp").forward(request, response);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            LocalDate date = LocalDate.parse(dateStr);
            BusinessHour bh = bhFacade.findByDate(date);
            List<Appointment> appts = appointmentFacade.findByDate(date);
            String customerEmails = appts.stream()
                    .map(a -> a.getCustomer().getEmail())
                    .collect(Collectors.joining(", "));

            ApiResponse apiRes;
            if (bh == null) {
                apiRes = new ApiResponse("normal", null, "10:00", "18:00");
            } else {
                apiRes = new ApiResponse(
                        bh.isIsClosed() ? "holiday" : "custom",
                        bh.getNote(),
                        bh.getOpenTime() != null ? bh.getOpenTime().toString() : "10:00",
                        bh.getCloseTime() != null ? bh.getCloseTime().toString() : "18:00"
                );
            }
            apiRes.apptCount = appts.size();
            apiRes.customerList = customerEmails;

            response.getWriter().write(gson.toJson(apiRes));
        } catch (Exception e) {
            response.getWriter().write(gson.toJson(new ApiResponse("error", "Invalid date", null, null)));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String dateStr = request.getParameter("date");

        try {
            LocalDate selectedDate = LocalDate.parse(dateStr);
            LocalDate today = LocalDate.now();

            if (selectedDate.isBefore(today)) {
                response.sendRedirect("BusinessHourServlet?error=pastDate");
                return;
            }

            BusinessHour bh = bhFacade.findByDate(selectedDate);

            if ("delete".equals(action)) {
                if (bh != null) {
                    bhFacade.remove(bh);
                }
                response.sendRedirect("BusinessHourServlet?success=deleted");
                return;
            }

            if (bh != null && "save".equals(action)) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('Error: Settings for [" + dateStr + "] already exist.'); history.back();</script>");
                return;
            }

            boolean isClosed = request.getParameter("isClosed") != null;

            if (isClosed) {
                List<Appointment> conflictAppts = appointmentFacade.findByDate(selectedDate);
                if (!conflictAppts.isEmpty()) {
                    response.setContentType("text/html;charset=UTF-8");
                    String emails = conflictAppts.stream().map(a -> a.getCustomer().getEmail()).collect(Collectors.joining("\\n"));
                    response.getWriter().println(
                            "<script>"
                            + "alert('CANNOT CLOSE: There are " + conflictAppts.size() + " appointments on " + dateStr + "!\\n\\nCustomers:\\n" + emails + "\\n\\nPlease reschedule them first.');"
                            + "history.back();"
                            + "</script>"
                    );
                    return;
                }
            }

            String successMsg = "updated";
            if (bh == null) {
                bh = new BusinessHour();
                bh.setBusinessDate(selectedDate);
                successMsg = "added";
            }

            bh.setIsClosed(isClosed);
            bh.setNote(request.getParameter("note"));
            if (!isClosed) {
                bh.setOpenTime(java.time.LocalTime.parse(request.getParameter("openTime")));
                bh.setCloseTime(java.time.LocalTime.parse(request.getParameter("closeTime")));
            } else {
                bh.setOpenTime(null);
                bh.setCloseTime(null);
            }

            if (bh.getId() == null) {
                bhFacade.create(bh);
            } else {
                bhFacade.edit(bh);
            }

            response.sendRedirect("BusinessHourServlet?success=" + successMsg);

        } catch (Exception e) {
            response.sendRedirect("BusinessHourServlet?error=true");
        }
    }

    static class ApiResponse {

        String type;
        String message;
        String openTime;
        String closeTime;
        int apptCount;
        String customerList;

        public ApiResponse(String type, String message, String openTime, String closeTime) {
            this.type = type;
            this.message = message;
            this.openTime = openTime;
            this.closeTime = closeTime;
        }
    }
}
