package Servlet;

import Entity.Car;
import Entity.CarFacade;
import Entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/AddVehicle"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AddVehicleServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); 
        response.setContentType("text/html;charset=UTF-8");
        
        // 1. 先检查用户是否登录，没登录直接拦截
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String carPlate = request.getParameter("carPlate");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String color = request.getParameter("color");
            int year = Integer.parseInt(request.getParameter("year"));

            // 2. 使用 User 对象创建 Car 
            Car car = new Car(carPlate, brand, model, color, year, user);

            // 3. 执行数据库保存 
            carFacade.create(car);

            // 4. 成功后跳转 (在 try 块内) 
            response.sendRedirect(request.getContextPath() + "/EditProfile?vehicleAdded=true");

        } catch (Exception e) {
            e.printStackTrace(); 
            request.setAttribute("errorMessage", "Failed: " + e.getMessage());
            request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("true".equals(request.getParameter("success"))) {
            request.setAttribute("successMessage", "Added Successful！");
        }
        response.sendRedirect(request.getContextPath() + "/EditProfile?vehicleAdded=1");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add vehicle servlet";
    }
}
