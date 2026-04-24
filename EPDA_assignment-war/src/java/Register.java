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
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5, 
        maxRequestSize = 1024 * 1024 * 10 
)
public class Register extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            String name = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String gender = request.getParameter("gender");
            String phoneStr = request.getParameter("phoneNumber");
            String userICStr = request.getParameter("userIC");
            String address = request.getParameter("address");

            // basic validation
            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || phoneStr == null || phoneStr.trim().isEmpty()
                    || userICStr == null || userICStr.trim().isEmpty()
                    || address == null || address.trim().isEmpty()) {

                request.setAttribute("error", "All fields are required!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // check if null, check length, and check if is numeric
            if (userICStr == null || userICStr.trim().length() != 12 || !userICStr.matches("^[0-9]+$")) {
                request.setAttribute("error", "IC must be exactly 12 numeric digits!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            try {
                //ic format yymmdd-pb(specific)-xxxx(random)
                // check ic , split to yy(year) mm(month) dd(date)
                int yy = Integer.parseInt(userICStr.substring(0, 2));
                int mm = Integer.parseInt(userICStr.substring(2, 4));
                int dd = Integer.parseInt(userICStr.substring(4, 6));

                //validate year
                int currentYear = java.time.LocalDate.now().getYear();
                int birthYear = (yy <= (currentYear % 100)) ? (2000 + yy) : (1900 + yy);
                java.time.LocalDate birthDate = java.time.LocalDate.of(birthYear, mm, dd);

                // validate pb
                String pbStr = userICStr.substring(6, 8);
                int pbCode = Integer.parseInt(pbStr);

                java.util.List<Integer> validPB = java.util.Arrays.asList(
                        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                        21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                        40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
                        82
                );

                if (!validPB.contains(pbCode)) {
                    request.setAttribute("error", "Invalid IC: State code '" + pbStr + "' is not a valid Malaysia state code.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                java.time.LocalDate today = java.time.LocalDate.now();
                int age = java.time.Period.between(birthDate, today).getYears();

                if (age < 17) {
                    request.setAttribute("error", "Underaged: Registration requires at least 17 years old (Current age: " + age + ").");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

            } catch (java.time.DateTimeException | NumberFormatException | StringIndexOutOfBoundsException e) {
                request.setAttribute("error", "Invalid IC Number: Incorrect birth date or format.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (userFacade.findByIC(userICStr) != null) {
                request.setAttribute("error", "Error: IC Number already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // validate phone number
            int phoneNumber;
            try {
                phoneNumber = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));

                if (phoneNumber < 0 || phoneNumber > 2147483647) {
                    throw new NumberFormatException("Phone number out of range");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid phone number format!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (userFacade.findByPhone(phoneNumber) != null) {
                request.setAttribute("error", "Error: Phone Number already in use!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // check if email already exists
            if (userFacade.findByEmail(email) != null) {
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // set default profile picture based on gender
            String defaultPic = "default.jpg";
            if ("Male".equalsIgnoreCase(gender)) {
                defaultPic = "male_default.jpg";
            } else if ("Female".equalsIgnoreCase(gender)) {
                defaultPic = "female_default.jpg";
            }

            // create user with default profile pic
            User newUser = new User(name, password, userICStr, address, phoneNumber, gender, role, email);
            newUser.setProfilePic(defaultPic);
            userFacade.create(newUser);
            // send register successful email
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        EmailUtils.sendWelcomeEmail(email, name);
                    } catch (Exception e) {
                        System.out.println("Email sending failed: " + e.getMessage());
                    }
                }
            }).start();
            // handle file upload
            Part filePart = request.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();

                String uploadPath = getServletContext().getRealPath("/profile_pics");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File file = new File(uploadDir, submittedFileName);
                try (FileOutputStream fos = new FileOutputStream(file); InputStream input = filePart.getInputStream()) {

                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }

                // upload successful, update profilePic
                newUser.setProfilePic(submittedFileName);
                userFacade.edit(newUser);
            }

            // redirect success
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
