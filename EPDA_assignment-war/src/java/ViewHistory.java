/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.AppointmentFacade;
import Entity.Payment;
import Entity.PaymentFacade;
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
    private AppointmentFacade appointmentFacade; // Assumes you have these Facades
    @EJB
    private PaymentFacade paymentFacade;

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
        // 1. Get the current user from the session
        User user = (User) request.getSession().getAttribute("user");
               
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // 关键修复：根据 ID 重新获取一个“活跃”的 User 对象
        // 这样能确保 email 和其它关联字段 100% 可用且受 JPA 管理
        User activeUser = userFacade.find(user.getUser_id()); 

        if (activeUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 使用这个 activeUser 的 email 进行查询
        List<Object[]> appointmentData = appointmentFacade.findFilteredAppointments(
            activeUser.getEmail(), 
            request.getParameter("searchDate"), 
            request.getParameter("searchName")
        );

        List<Payment> payments = paymentFacade.findFilteredPayments(
            activeUser.getEmail(), 
            request.getParameter("payDate"), 
            request.getParameter("payMethod")
        );

        // 3. Pass the lists to the JSP
        request.setAttribute("appointmentData", appointmentData);
        request.setAttribute("payments", payments);

        // 4. Forward to the viewHistory.jsp
        request.getRequestDispatcher("viewHistory.jsp").forward(request, response);
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
        // Usually, viewing history doesn't need POST, so we call doGet
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
