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
                // 在 POST 逻辑部分
                try {
                    String oldEmail = request.getParameter("oldEmail");
                    String newEmail = request.getParameter("newEmail");
                    String username = request.getParameter("username");
                    String role = request.getParameter("role");
                    String gender = request.getParameter("gender");
                    String password = request.getParameter("password");
                    String address = request.getParameter("address");
                    String userIC = request.getParameter("userIC");
                    int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber").replaceAll("[^0-9]", ""));
                    
                    // Check if null, check length, and check if it's numeric
                    if (userIC == null || userIC.trim().length() != 12 || !userIC.matches("^[0-9]+$")) {
                        request.setAttribute("error", "IC must be exactly 12 numeric digits!");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                    
                    // Get the current profile picture string from the hidden field
                    String profilePic = request.getParameter("profilePic");
                    //Check if a NEW image was uploaded
                    Part filePart = request.getPart("newProfilePic"); // Make sure this matches your JSP input name
                    
                    if (filePart != null && filePart.getSize() > 0) {
                        // Extract the actual filename of the file you selected
                        String submittedFileName = filePart.getSubmittedFileName();
                        // Set your variable to this name so it saves to the database correctly
                        profilePic = submittedFileName;

                        String uploadPath = getServletContext().getRealPath("/profile_pics");
                        System.out.println("DEBUG: Files are being saved to: " + uploadPath);
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();
                        
                        // 3. Use the original name for the File object
                        File file = new File(uploadDir, profilePic);

                        //File file = new File(uploadDir, profilePic);
                        try (FileOutputStream fos = new FileOutputStream(file); 
                             InputStream input = filePart.getInputStream()) {
                            byte[] buffer = new byte[1024];
                            int bytesRead;
                            while ((bytesRead = input.read(buffer)) != -1) {
                                fos.write(buffer, 0, bytesRead);
                            }
                        }
                    }

                    // update database
                    String result = userFacade.updateStaff(oldEmail, newEmail, username, phoneNumber, role, gender, password,profilePic,userIC,address);

                    if (result.equals("success")) {
                        out.println("<script>alert('Update Successful!'); location='ManageStaff';</script>");
                    } else {
                        // send error message to JSP
                        request.setAttribute("error", result);
                        // reload staff info again so the form keeps the data
                        User staff = userFacade.findByEmail(oldEmail);
                        request.setAttribute("staff", staff);

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
