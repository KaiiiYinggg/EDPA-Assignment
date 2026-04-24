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

@WebServlet(urlPatterns = {"/UpdateStaff"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class UpdateStaff extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String method = request.getMethod();

            if (method.equalsIgnoreCase("GET")) {
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
                    String email = request.getParameter("email");
                    String username = request.getParameter("username");
                    String role = request.getParameter("role");
                    String gender = request.getParameter("gender");
                    String password = request.getParameter("password");
                    String address = request.getParameter("address");
                    String userIC = request.getParameter("userIC"); //readonly reocrd

                    String rawPhone = request.getParameter("phoneNumber").replaceAll("[^0-9]", "");
                    int phoneNumber = Integer.parseInt(rawPhone);

                    // check phone number
                    User currentStaff = userFacade.findByEmail(email);
                    User userWithThisPhone = userFacade.findByPhone(phoneNumber);

                    if (userWithThisPhone != null && !userWithThisPhone.getUser_id().equals(currentStaff.getUser_id())) {
                        //duplicate phone number
                        request.setAttribute("error", "The phone number " + rawPhone + " is already in use by another account!");
                        request.setAttribute("staff", currentStaff);
                        request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                        return;
                    }

                    // ic validate
                    if (userIC == null || userIC.length() != 12) {
                        request.setAttribute("error", "Critical error: IC data is missing or corrupted.");
                        request.setAttribute("staff", currentStaff);
                        request.getRequestDispatcher("updateStaff.jsp").forward(request, response);
                        return;
                    }
                    
                    //profile pic
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

                    String result = userFacade.updateStaff(email, email, username, phoneNumber, role, gender, password, profilePic, userIC, address);

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
