
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import javax.servlet.http.Part;

/**
 *
 * @author teech
 */
@WebServlet(urlPatterns = {"/Register"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class Register extends HttpServlet {
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

        String name = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String gender = request.getParameter("gender");
        String phoneStr = request.getParameter("phoneNumber");

        // 1. Basic Validation
        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Name and Email are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. Check if user already exists
        if (userFacade.findByEmail(email) != null) {
            request.setAttribute("error", "Email already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Create the User FIRST (with a temporary or default filename)
        // This allows us to get the generated User ID
        String tempFileName = "default.png"; 
        int phoneNumber = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));

        User newUser = new User(name, password, phoneNumber, gender, role, email, tempFileName);
        userFacade.create(newUser); 

        // Now newUser has an ID (if your Facade returns the object or refreshes it)
        // If userFacade.create doesn't return the object, fetch it:
        newUser = userFacade.findByEmail(email); 

        // 4. Handle the Image Upload now that we have the ID
        Part filePart = request.getPart("profilePic");
        if (filePart != null && filePart.getSize() > 0) {
            
            String submittedFileName = filePart.getSubmittedFileName();

            // Use standard web path so JSP can find it
            String uploadPath = getServletContext().getRealPath("/profile_pics");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            File file = new File(uploadDir, submittedFileName);

            try (FileOutputStream fos = new FileOutputStream(file); 
                 InputStream input = filePart.getInputStream()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            // 5. Update the user record with the REAL filename
            newUser.setProfilePic(submittedFileName);
            userFacade.edit(newUser);
        }

        response.sendRedirect(request.getContextPath() + "/Register?success=true");
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
        //processRequest(request, response);
        if ("true".equals(request.getParameter("success"))) {
            request.setAttribute("loginSuccessMessage", "Registration Successful!");
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
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
