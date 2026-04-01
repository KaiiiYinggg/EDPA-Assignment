
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
        maxFileSize = 1024 * 1024 * 5, // 5MB
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

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String carPlate = request.getParameter("carPlate").trim().toUpperCase(); // 统一转大写
            String brand = request.getParameter("brand").trim();
            String model = request.getParameter("model").trim();
            String color = request.getParameter("color").trim();
            String yearStr = request.getParameter("year");

            // 1. 基本非空检查
            if (carPlate.isEmpty() || brand.isEmpty() || model.isEmpty()) {
                throw new Exception("Please fill in all required fields.");
            }

            // 2. 核心逻辑：重复车牌检查
            // 假设 carPlate 是 Car Entity 的 Primary Key (find 方法通常根据 PK 找)
            Car existingCar = carFacade.find(carPlate);
            if (existingCar != null) {
                request.setAttribute("errorMessage", "Error: Car plate number '" + carPlate + "' already exists in our system.");
                request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
                return;
            }

            int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : 0;

            // 3. 创建并保存
            Car car = new Car(carPlate, brand, model, color, year, user);
            carFacade.create(car);

            // 4. 成功后跳转
            response.sendRedirect(request.getContextPath() + "/EditProfile?vehicleAdded=true");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Year format.");
            request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
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
