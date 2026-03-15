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

        try {
            String carPlate = request.getParameter("carPlate");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String color = request.getParameter("color");
            int year = Integer.parseInt(request.getParameter("year"));

            // 使用 User 对象里的 email，避免重复存储
            String email = (user != null) ? user.getEmail() : null;

            Car car = new Car(carPlate, brand, model, color, year, email);
            car.setUserEmail(email);
            carFacade.create(car);

            // 成功后跳转并提示
            response.sendRedirect(request.getContextPath() + "/EditProfile?vehicleAdded=true");

        } catch (Exception e) {
            e.printStackTrace(); 
            request.setAttribute("errorMessage", "添加车辆失败: " + e.getMessage());
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
