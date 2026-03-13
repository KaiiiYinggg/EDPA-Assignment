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
    
    @EJB // <-- 修复 1：必须添加此注解
    private CarFacade carFacade;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. 更新资料
            String username = request.getParameter("username");
            String phone = request.getParameter("phoneNumber");
            String password = request.getParameter("password");

            if (username != null && !username.trim().isEmpty()) user.setUsername(username);
            if (phone != null && !phone.trim().isEmpty()) user.setPhoneNumber(Integer.parseInt(phone));
            if (password != null && !password.trim().isEmpty()) user.setPassword(password);

            // 2. 头像处理
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
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
                user.setProfilePic(submittedFileName);
            }

            // 3. 同步数据库与 Session
            userFacade.edit(user);
            request.getSession().setAttribute("user", user);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 修复 2：跳转回 EditProfile 触发 doGet 刷新数据
        response.sendRedirect("EditProfile?message=Profile+Updated");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 核心：加载车辆列表
        try {
            List<Car> carList = carFacade.findByUserEmail(user.getEmail());
            request.setAttribute("carList", carList);
        } catch (Exception e) {
            System.out.println("Error fetching cars: " + e.getMessage());
        }

        if ("true".equals(request.getParameter("vehicleAdded"))) {
            request.setAttribute("vehicleMessage", "Vehicle added successfully!");
        }

        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }
}