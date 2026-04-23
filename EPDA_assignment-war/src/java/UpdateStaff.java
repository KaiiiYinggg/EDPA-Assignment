/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.User;
import Entity.UserFacade;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author teech
 */
@WebServlet(urlPatterns = {"/UpdateStaff"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UpdateStaff extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String method = request.getMethod();

            if (method.equalsIgnoreCase("GET")) {
                // --- 这里放之前的 doGet 逻辑 (准备资料) ---
                String email = request.getParameter("email");
                User staff = userFacade.findByEmail(email);
                if (staff != null) {
                    request.setAttribute("staff", staff);
                    request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                } else {
                    response.sendRedirect("ManageStaff");
                }

            } else if (method.equalsIgnoreCase("POST")) {
                try {
                    String oldEmail = request.getParameter("oldEmail");
                    String newEmail = request.getParameter("newEmail");
                    String username = request.getParameter("username");
                    String role = request.getParameter("role");
                    String gender = request.getParameter("gender");
                    String password = request.getParameter("password");
                    String address = request.getParameter("address");
                    String userIC = request.getParameter("userIC"); // 这里虽然是 readonly，但提交时仍会带上旧值

                    String rawPhone = request.getParameter("phoneNumber").replaceAll("[^0-9]", "");
                    int phoneNumber = Integer.parseInt(rawPhone);

                    // 💡 1. 电话号码查重逻辑
                    // 我们先找到旧员工的对象，用来比对 ID
                    User currentStaff = userFacade.findByEmail(oldEmail);
                    User userWithThisPhone = userFacade.findByPhone(phoneNumber);

                    if (userWithThisPhone != null && !userWithThisPhone.getUser_id().equals(currentStaff.getUser_id())) {
                        // 如果这个电话有人用了，且那个人不是正在被修改的这位员工
                        request.setAttribute("error", "The phone number " + rawPhone + " is already in use by another account!");
                        request.setAttribute("staff", currentStaff); // 重新放回页面显示
                        request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                        return;
                    }

                    // 💡 2. IC 格式校验 (虽然只读，但为了防止绕过前端修改，后端留一个基础判断)
                    if (userIC == null || userIC.length() != 12) {
                        request.setAttribute("error", "Critical error: IC data is missing or corrupted.");
                        request.setAttribute("staff", currentStaff);
                        request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                        return;
                    }

                    // 3. 处理图片 (保持你原本的代码逻辑)
                    String profilePic = request.getParameter("profilePic");
                    Part filePart = request.getPart("newProfilePic");
                    if (filePart != null && filePart.getSize() > 0) {
                        String submittedFileName = filePart.getSubmittedFileName();
                        profilePic = submittedFileName;
                        String uploadPath = getServletContext().getRealPath("/profile_pics");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        File file = new File(uploadDir, profilePic);
                        try (FileOutputStream fos = new FileOutputStream(file); InputStream input = filePart.getInputStream()) {
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = input.read(buffer)) != -1) {
                                fos.write(buffer, 0, bytesRead);
                            }
                        }
                    }

                    // 4. 调用 Facade 更新数据库
                    String result = userFacade.updateStaff(oldEmail, newEmail, username, phoneNumber, role, gender, password, profilePic, userIC, address);

                    if (result.equals("success")) {
                        out.println("<script>alert('Staff Record Updated!'); location='ManageStaff';</script>");
                    } else {
                        request.setAttribute("error", result);
                        request.setAttribute("staff", currentStaff);
                        request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    out.println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
                }
            }
        }
    }

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
        processRequest(request, response);
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
        processRequest(request, response);
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
