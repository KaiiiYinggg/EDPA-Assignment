/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Technician;

import Entity.Appointment;
import Entity.AppointmentFacade; // 确保导入了这个
import Entity.BusinessHour;
import Entity.BusinessHourFacade;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import javax.ejb.EJB; // 必须导入这个
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * TechnicianServlet - 处理任务分配和状态更新
 *
 * @author Kai Ying
 */
@WebServlet(name = "TechnicianServlet", urlPatterns = {"/Technician/TechnicianServlet"})
public class TechnicianServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appFacade; // 刚才你漏了这一行！
    @EJB
    private BusinessHourFacade businessHourFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        // 拿到登录的 User 对象
        Entity.User user = (Entity.User) session.getAttribute("user");

        if (user == null) {
            // 如果没登录，回退到 login (注意路径)
            response.sendRedirect("../login.jsp");
            return;
        }

        // 拿到 Technician 的 Email
        String techEmail = user.getEmail();

        // 获取分配给他的任务
        List<Appointment> myTasks = appFacade.findByTechnicianEmail(techEmail);
        request.setAttribute("taskList", myTasks);

// ⭐ HERE（替换原本 businessHour 那一行）
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
        // 转发回 Dashboard
        request.getRequestDispatcher("TechDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appIdStr = request.getParameter("appointmentId");
            // 直接硬编码为 Completed，省去传参的麻烦
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
            response.sendRedirect("../error.jsp");
        }
    }
}
