

import Entity.User;
import Entity.UserFacade;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditProfile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class EditProfile extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. 更新基本资料
            String username = request.getParameter("username");
            String phone = request.getParameter("phoneNumber");
            String password = request.getParameter("password");

            if (username != null && !username.trim().isEmpty()) {
                user.setUsername(username);
            }

            if (phone != null && !phone.trim().isEmpty()) {
                user.setPhoneNumber(Integer.parseInt(phone));
            }

            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password);
            }

            // 2. 上传头像
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {

                /*String submittedFileName = filePart.getSubmittedFileName();
                String extension = ".jpg";
                if (submittedFileName.contains(".")) {
                    extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                }*/
                // Get original filename
                String submittedFileName = filePart.getSubmittedFileName();

                String uploadPath = getServletContext().getRealPath("/profile_pics");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                //String fileName = "user_" + user.getUser_id() + "_" + System.currentTimeMillis() + extension;
                //File file = new File(uploadDir, fileName);
                File file = new File(uploadDir, submittedFileName);

                // Java 8 兼容写法
                try (FileOutputStream fos = new FileOutputStream(file); InputStream input = filePart.getInputStream()) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }

                // 更新 user
                //user.setProfilePic(fileName);
                user.setProfilePic(submittedFileName);
            }

            // 3. 更新数据库
            userFacade.edit(user);
            request.getSession().setAttribute("user", user);

        } catch (Exception e) {
            e.printStackTrace();
            // 如果上传失败也继续
        }

        // 4. PRG Pattern：Redirect 并加 success 参数
        response.sendRedirect(request.getContextPath() + "/EditProfile?success=true");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 如果有 ?success=true 显示 message
        if ("true".equals(request.getParameter("success"))) {
            request.setAttribute("message", "Profile updated successfully!");
        }

        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }
}

