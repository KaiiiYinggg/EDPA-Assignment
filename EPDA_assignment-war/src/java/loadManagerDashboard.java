/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.AppointmentFacade;
import Entity.FeedbackFacade;
import Entity.PaymentFacade;
import Entity.UserFacade;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(urlPatterns = {"/loadManagerDashboard"})
public class loadManagerDashboard extends HttpServlet {
    @EJB private PaymentFacade paymentFacade;
    @EJB private UserFacade userFacade;
    @EJB private AppointmentFacade appointmentFacade;
    @EJB private FeedbackFacade feedbackFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 报表 1：总收入统计
            double totalRevenue = paymentFacade.getTotalRevenue();
            
            // 报表 2：总用户数统计
            long totalUsers = userFacade.count();
            
            // 报表 3：服务类型分布 (Popularity)
            List<Object[]> serviceStats = paymentFacade.getServiceDistribution();

            // 报表 4：技术人员绩效 (按完成任务数量排名)
            List<Object[]> technicianPerformance = appointmentFacade.getTechnicianPerformance();
            //
            List<Object[]> staffPerformance = appointmentFacade.getStaffPerformance();

            // 报表 5：服务质量满意度 (按服务名称计算平均分)
            List<Object[]> serviceRatings = feedbackFacade.getServiceRatings();
            
            List<Object[]> monthlyRevenue = paymentFacade.getMonthlyRevenue();

            // 将所有报表数据放入 Request 作用域传给 JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("serviceStats", serviceStats);
            request.setAttribute("technicianPerformance", technicianPerformance);
            request.setAttribute("staffPerformance", staffPerformance);
            request.setAttribute("serviceRatings", serviceRatings);
            request.setAttribute("monthlyRevenue", monthlyRevenue);

            // 跳转到经理看板页面
            request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=report_loading_failed");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
