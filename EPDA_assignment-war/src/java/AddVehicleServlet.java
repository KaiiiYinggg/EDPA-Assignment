
import Entity.Car;
import Entity.CarFacade;
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
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/AddVehicle"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class AddVehicleServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        response.setContentType("text/html;charset=UTF-8");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. 获取并【深度规范化】车牌号：去掉前后空格、去掉中间空格、转大写
            String rawPlate = request.getParameter("carPlate");
            if (rawPlate == null || rawPlate.trim().isEmpty()) {
                throw new Exception("Car plate number is required.");
            }
            String carPlate = rawPlate.trim().replace(" ", "").toUpperCase();

            String brand = request.getParameter("brand").trim();
            String model = request.getParameter("model").trim();
            String color = request.getParameter("color").trim();
            String yearStr = request.getParameter("year");

            // 2. 【严格查重】
            Car existingCar = carFacade.find(carPlate);
            if (existingCar != null) {
                // 只要数据库里有这个车牌，不管是哪个用户的，直接拦截
                request.setAttribute("errorMessage",
                        "Error: Vehicle [" + carPlate + "] is already registered under "
                        + (existingCar.getUser().getEmail().equals(currentUser.getEmail()) ? "your account." : "another user."));

                request.setAttribute("customerId", request.getParameter("customerId"));
                request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
                return; // ✋ 关键：立刻停止，不要执行下面的 create
            }

            // 3. 确定真正的 Owner 对象
            String customerIdStr = request.getParameter("customerId");
            User owner;
            if (customerIdStr != null && !customerIdStr.isEmpty()) {
                // Staff/Manager 为 Customer 添加
                Long customerId = Long.parseLong(customerIdStr);
                owner = userFacade.find(customerId);
            } else {
                // Customer 自己添加，建议重新从 DB 抓取以确保 Persistence Context 正常
                owner = userFacade.find(currentUser.getUser_id());
            }

            if (owner == null) {
                throw new Exception("Customer data integrity error.");
            }

            // 4. 执行创建
            int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : 0;
            Car car = new Car(carPlate, brand, model, color, year, owner);
            carFacade.create(car);

            // 5. 跳转
            if ("customer".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/EditProfile?vehicleAdded=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/ManageCustomers?action=list&success=vehicleAdded");
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carPlate = request.getParameter("carPlate");
        String customerId = request.getParameter("customerId");

        // 默认是 false
        boolean isViewOnly = false;

        // 统一设置，确保 JSP 拿到的永远不是 null
        request.setAttribute("viewOnly", isViewOnly);
        request.setAttribute("customerId", customerId);

        request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add vehicle servlet";
    }
}
