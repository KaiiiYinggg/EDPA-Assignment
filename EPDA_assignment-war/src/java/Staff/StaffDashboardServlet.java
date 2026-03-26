package Staff;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Kai Ying
 */
@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/Staff/StaffDashboardServlet"})
public class StaffDashboardServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appointmentFacade;
    @EJB
    private UserFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 获取当前登录用户
        User user = (User) request.getSession().getAttribute("user");

        // 安全检查：如果没有登录，直接踢回登录页
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. 获取今日日期
        java.time.LocalDate today = java.time.LocalDate.now();

        // 3. 调用 Facade 获取数据
        // 获取今日预约列表
        List<Appointment> todayApps = appointmentFacade.findAppointmentsByDate(today);

        // 获取已完成但未支付的预约
        List<Appointment> unpaidApps = appointmentFacade.findUnpaidAppointments();

        // ⭐ 这里改掉了！直接调用你刚才保留的 countCustomers()
        int totalCust = userFacade.countCustomers();

        // 4. 将数据存入 request，供 JSP 使用
        request.setAttribute("todayApps", todayApps);
        request.setAttribute("unpaidApps", unpaidApps);
        request.setAttribute("totalCust", totalCust);

        // 5. 根据角色转发到正确的页面
        String role = user.getRole().toLowerCase();
        // 在 StaffDashboardServlet.java 的 if 逻辑中修改
        if ("counter staff".equals(role) || "staff".equals(role)) {
            // 注意：如果你的 JSP 在 Web Pages/Staff/StaffDashboard.jsp，这里是对的
            // 如果转发失败，尝试在路径前加一个斜杠 "/"
            request.getRequestDispatcher("/Staff/StaffDashboard.jsp").forward(request, response);
        } else if ("manager".equals(role)) {
            // 如果你有 Manager 的 Dashboard 也可以在这里跳转
            request.getRequestDispatcher("Manager/ManagerDashboard.jsp").forward(request, response);
        } else {
            // 其他角色逻辑...
            response.sendRedirect("login.jsp");
        }
    }
}
