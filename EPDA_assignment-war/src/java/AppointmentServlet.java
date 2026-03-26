
import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.User;
import Entity.UserFacade;
import Entity.Car;
import Entity.CarFacade;
import Entity.Services;
import Entity.ServicesFacade;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appFacade;
    @EJB
    private UserFacade userFacade;
    @EJB
    private CarFacade carFacade;
    @EJB
    private ServicesFacade servicesFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // --- 1. AJAX 请求：获取可用技师 ---
        if ("getAvailableTechs".equals(action)) {
            try {
                String dateStr = request.getParameter("date");
                String startStr = request.getParameter("startTime");
                String endStr = request.getParameter("endTime");

                System.out.println("DEBUG: date=" + dateStr + ", start=" + startStr + ", end=" + endStr);

                LocalDate date = LocalDate.parse(dateStr);

                // 时间解析容错：先尝试 HH:mm，再尝试 HH:mm:ss
                LocalTime startTime = parseTime(startStr);
                LocalTime endTime = parseTime(endStr);

                List<User> techs = userFacade.findAvailableTechnicians(date, startTime, endTime);
                System.out.println("DEBUG: found " + techs.size() + " technicians");

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < techs.size(); i++) {
                    User t = techs.get(i);
                    json.append(String.format("{\"username\":\"%s\", \"email\":\"%s\"}",
                            t.getUsername(), t.getEmail()));
                    if (i < techs.size() - 1) {
                        json.append(",");
                    }
                }
                json.append("]");
                response.getWriter().write(json.toString());
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            return;
        }

        // --- 2. 正常页面加载 (包含搜索逻辑) ---
        String custEmail = request.getParameter("customerEmail");
        if (custEmail != null && !custEmail.isEmpty()) {
            User customer = userFacade.findByEmail(custEmail);
            if (customer != null) {
                // 获取搜索参数
                String searchDate = request.getParameter("searchDate");
                String searchId = request.getParameter("searchId");

                List<Appointment> appList;

                // --- 核心：根据是否有搜索条件来调用不同的方法 ---
                if ((searchDate != null && !searchDate.isEmpty()) || (searchId != null && !searchId.isEmpty())) {
                    // 如果有搜索条件，调用搜索方法
                    appList = appFacade.searchAppointments(custEmail, searchDate, searchId);
                } else {
                    // 默认显示该客户的所有预约
                    appList = appFacade.findByCustomerEmail(custEmail);
                }

                List<Car> cars = carFacade.findByUserEmail(custEmail);
                List<Services> services = servicesFacade.findAll();

                request.setAttribute("customer", customer);
                request.setAttribute("appList", appList);
                request.setAttribute("cars", cars);
                request.setAttribute("services", services);

                request.getRequestDispatcher("MakeAppointment.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect("StaffDashboard.jsp");
    }

    // 辅助方法：容错解析时间
    private LocalTime parseTime(String timeStr) {
        try {
            return LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("HH:mm"));
        } catch (Exception e) {
            return LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("HH:mm:ss"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String custEmail = request.getParameter("customerEmail");

        try {
            if ("add".equals(action)) {
                Appointment app = new Appointment();
                app.setCustomer(userFacade.findByEmail(custEmail));
                app.setCar(carFacade.find(request.getParameter("carPlateNumber")));

                // 1. 获取 Service 并设置
                Services svc = servicesFacade.find(Long.parseLong(request.getParameter("serviceId")));
                app.setService(svc);

                app.setAppointment_date(LocalDate.parse(request.getParameter("date")));

                // 2. 解析开始时间并设置
                LocalTime startTime = parseTime(request.getParameter("time"));
                app.setAppointment_time(startTime);

                // 3. --- 核心逻辑：计算并保存 Expected End Time ---
                if (svc != null && startTime != null) {
                    // 将 serviceHour (double) 转为分钟并相加
                    long minutesToAdd = Math.round(svc.getServiceHour() * 60);
                    LocalTime endTime = startTime.plusMinutes(minutesToAdd);
                    app.setExpected_end_time(endTime); // 确保你的 Entity 里有这个 Setter
                }

                String techEmail = request.getParameter("technicianEmail");
                app.setTechnician_email(techEmail);

                String staffEmail = (String) request.getSession().getAttribute("email");
                app.setStaff_email(staffEmail);

                if (techEmail != null && !techEmail.isEmpty()) {
                    app.setAppointment_status("Approved");
                } else {
                    app.setAppointment_status("Pending");
                }

                appFacade.create(app);

            } else if ("update".equals(action)) {
                Long id = Long.parseLong(request.getParameter("appointmentId"));
                Appointment app = appFacade.find(id);
                if (app != null) {
                    app.setCar(carFacade.find(request.getParameter("carPlateNumber")));

                    // 同理，更新时也要重新计算结束时间
                    Services svc = servicesFacade.find(Long.parseLong(request.getParameter("serviceId")));
                    app.setService(svc);

                    app.setAppointment_date(LocalDate.parse(request.getParameter("date")));

                    LocalTime startTime = parseTime(request.getParameter("time"));
                    app.setAppointment_time(startTime);

                    if (svc != null && startTime != null) {
                        long minutesToAdd = Math.round(svc.getServiceHour() * 60);
                        LocalTime endTime = startTime.plusMinutes(minutesToAdd);
                        app.setExpected_end_time(endTime);
                    }

                    String techEmail = request.getParameter("technicianEmail");
                    app.setTechnician_email(techEmail);

                    appFacade.edit(app);
                }

            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(request.getParameter("appointmentId"));
                Appointment app = appFacade.find(id);
                if (app != null) {
                    appFacade.remove(app);
                }
            }
            response.sendRedirect("AppointmentServlet?customerEmail=" + custEmail);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
