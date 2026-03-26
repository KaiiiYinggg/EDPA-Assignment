import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Payment;
import Entity.PaymentFacade;
import Entity.Services; // 确保导入 Service 实体
import Entity.ServicesFacade; // 确保导入 ServiceFacade
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
 * @author teech
 */
@WebServlet(urlPatterns = {"/ViewHistory"})
public class ViewHistory extends HttpServlet {

    @EJB
    private UserFacade userFacade;
    @EJB
    private AppointmentFacade appointmentFacade;
    @EJB
    private PaymentFacade paymentFacade;
    @EJB
    private ServicesFacade serviceFacade; // 1. 注入 ServiceFacade

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the current user from the session
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 根据 ID 重新获取一个“活跃”的 User 对象
        User activeUser = userFacade.find(user.getUser_id());

        if (activeUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = activeUser.getRole().toLowerCase();
        String searchDate = request.getParameter("searchDate");
        String searchName = request.getParameter("searchName");

        // 2. 💡 新增：获取数据库中所有的服务类型，供下拉菜单使用
        List<Services> allServices = serviceFacade.findAll();
        request.setAttribute("allServices", allServices);

        // 3. 获取 appointment 列表
        List<Appointment> appointmentData = appointmentFacade.findFilteredAppointments(
                activeUser.getEmail(),
                role,
                searchDate,
                searchName
        );

        // ⚡ 强制加载 feedbacks，避免 Hibernate 延迟加载导致第一次 redirect 看不到最新反馈
        for (Appointment app : appointmentData) {
            if (app.getFeedbacks() != null) {
                app.getFeedbacks().size(); 
            }
        }

        // 4. 获取 payment 列表（仅客户）
        List<Payment> payments = null;
        if ("customer".equals(role)) {
            payments = paymentFacade.findFilteredPayments(
                    activeUser.getEmail(),
                    request.getParameter("payDate"),
                    request.getParameter("payMethod")
            );
        }

        // 5. 传递给 JSP
        request.setAttribute("appointmentData", appointmentData);
        request.setAttribute("payments", payments);

        // 6. Forward 到 JSP
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