/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Feedback;
import Entity.FeedbackFacade;
import Entity.User;
import java.io.IOException;
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
@WebServlet(urlPatterns = {"/GiveFeedback"})
public class GiveFeedback extends HttpServlet {

    @EJB
    FeedbackFacade feedbackFacade;
    @EJB
    private AppointmentFacade appointmentFacade; 

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
        // 获取 URL 传来的 appointmentId
        String appIdStr = request.getParameter("appointmentId");
        if (appIdStr != null && !appIdStr.isEmpty()) {
            Long appId = Long.parseLong(appIdStr);

            // 核心安全检查：如果该预约已有反馈，重定向并报错 
            Feedback fb = feedbackFacade.findByAppointmentId(appId);
            if (fb != null) {
                // 如果反馈已存在，且当前用户是客户（不是技术人员更新备注），则拦截
                User user = (User) request.getSession().getAttribute("user");
                if (user != null && "customer".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("ViewHistory?error=already_commented");
                    return;
                }
            }

            Appointment app = appointmentFacade.find(appId);
            request.setAttribute("app", app);
        }
        request.getRequestDispatcher("giveFeedback.jsp").forward(request, response);
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

        User user = (User) request.getSession().getAttribute("user");
        String appIdStr = request.getParameter("appointmentId");

        try {
            Long appointmentId = Long.parseLong(appIdStr);
            Appointment app = appointmentFacade.find(appointmentId);

            // 1. 查找是否已经存在该预约的反馈记录 [cite: 41]
            Feedback fb = feedbackFacade.findByAppointmentId(appointmentId); 

            if (fb == null) {
                // 如果不存在，新建一个对象并绑定预约 [cite: 41]
                fb = new Feedback();
                fb.setAppointment(app);
            }

            // 2. 根据 Role 处理数据
            String role = user.getRole().toLowerCase();

            if ("technician".equals(role)) {
                String techNote = request.getParameter("technicianNote");
                fb.setTechnician_feedback(techNote);
            } else {
                // 客户逻辑：根据 Target 分流存储
                String target = request.getParameter("commentTarget");
                String commentText = request.getParameter("customerComment");
                int ranking = Integer.parseInt(request.getParameter("ranking"));

                // 设置 Ranking (共用字段) [cite: 41]
                fb.setRanking(ranking);

                // 根据目标存储到对应的列 (请确保 Feedback.java 中有这些 Setter)
                if (target.contains("TECHNICIAN")) {
                    fb.setCustomerCommentToTech(commentText);
                } 
                if (target.contains("STAFF")) {
                    fb.setCustomerCommentToStaff(commentText);
                }
                if (target.contains("BOTH")) {
                    fb.setCustomerCommentToTech(commentText);
                    fb.setCustomerCommentToStaff(commentText);
                }
            }

            // 3. 统一使用 edit (JPA merge)，处理 INSERT 或 UPDATE [cite: 41]
            feedbackFacade.edit(fb); 

            // 4. 跳转成功页面 [cite: 41]
            response.sendRedirect("ViewHistory?commentmessage=saved");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewHistory?error=failed");
        }
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
