
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(urlPatterns = {"/Register"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class Register extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            // 1. Get parameters
            String name = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String gender = request.getParameter("gender");
            String phoneStr = request.getParameter("phoneNumber");

            // 2. Basic validation
            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || phoneStr == null || phoneStr.trim().isEmpty()) {

                request.setAttribute("error", "All fields are required!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 3. Validate phone number
            int phoneNumber;
            try {
                phoneNumber = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));
                if (phoneNumber < 0 || phoneNumber > 2147483647) {
                    throw new NumberFormatException("Phone number out of range");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid phone number!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 4. Check if email already exists
            if (userFacade.findByEmail(email) != null) {
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 5. Set default profile picture based on gender
            String defaultPic = "default.jpg";
            if ("Male".equalsIgnoreCase(gender)) {
                defaultPic = "male_default.jpg";
            } else if ("Female".equalsIgnoreCase(gender)) {
                defaultPic = "female_default.jpg";
            }

            // 6. Create user with default profile pic
            User newUser = new User(name, password, phoneNumber, gender, role, email);
            newUser.setProfilePic(defaultPic);
            userFacade.create(newUser);

            // 7. Handle file upload
            Part filePart = request.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();

                String uploadPath = getServletContext().getRealPath("/profile_pics");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File file = new File(uploadDir, submittedFileName);
                try (FileOutputStream fos = new FileOutputStream(file);
                     InputStream input = filePart.getInputStream()) {

                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }

                // Upload successful, update profilePic
                newUser.setProfilePic(submittedFileName);
                userFacade.edit(newUser);
            }

            // 8. Redirect success
            response.sendRedirect(request.getContextPath() + "/Register?success=true");

        } catch (Exception ex) {
            ex.printStackTrace(); // Print full stack trace for debugging
            String causeMsg = (ex.getCause() != null) ? ex.getCause().getMessage() : ex.getMessage();
            request.setAttribute("error", "Registration failed: " + causeMsg);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("true".equals(request.getParameter("success"))) {
            request.setAttribute("loginSuccessMessage", "Registration Successful!");
        }
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User registration servlet";
    }
}