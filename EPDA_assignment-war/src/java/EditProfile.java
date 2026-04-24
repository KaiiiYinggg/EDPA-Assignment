/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import Entity.Car;
import Entity.CarFacade;
import Entity.User;
import Entity.UserFacade;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditProfile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class EditProfile extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    @EJB 
    private CarFacade carFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String username = request.getParameter("username");
            String phoneStr = request.getParameter("phoneNumber");
            String password = request.getParameter("password");

            //phone num format checking
            if (phoneStr != null && !phoneStr.trim().isEmpty()) {
                int newPhone = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));

                // check duplicate phone num
                User existingUser = userFacade.findByPhone(newPhone);
                if (existingUser != null && !existingUser.getUser_id().equals(user.getUser_id())) {
                    request.setAttribute("errorMessage", "Error: The phone number " + phoneStr + " is already in use by another account!");
                    doGet(request, response);
                    return;
                }
                user.setPhoneNumber(newPhone);
            }

            if (username != null && !username.trim().isEmpty()) {
                user.setUsername(username);
            }

            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password);
            }

            // profile pic
            Part filePart = request.getPart("profileImage");
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
                user.setProfilePic(submittedFileName);
            }

            userFacade.edit(user);
            request.getSession().setAttribute("user", user);

            response.sendRedirect("EditProfile?message=Profile+Updated+Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Update failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        //load vehicle list
        try {
            List<Car> carList = carFacade.findByUserEmail(user.getEmail());
            request.setAttribute("carList", carList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("true".equals(request.getParameter("vehicleAdded"))) {
            request.setAttribute("vehicleMessage", "Vehicle added successfully!");
        }

        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }
}
