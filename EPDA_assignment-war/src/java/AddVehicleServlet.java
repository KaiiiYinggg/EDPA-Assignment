
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

            String carPlate = request.getParameter("carPlate").trim().toUpperCase();
            String brand = request.getParameter("brand").trim();
            String model = request.getParameter("model").trim();
            String color = request.getParameter("color").trim();
            String yearStr = request.getParameter("year");

            // 检查空值
            if (carPlate.isEmpty() || brand.isEmpty() || model.isEmpty()) {
                throw new Exception("Please fill in all required fields.");
            }

            // 检查重复车牌
            Car existingCar = carFacade.find(carPlate);
            if (existingCar != null) {

                request.setAttribute("errorMessage",
                        "Error: Car plate number '" + carPlate + "' already exists in our system.");

                request.getRequestDispatcher("AddVehicle.jsp")
                        .forward(request, response);
                return;
            }

            int year = 0;
            if (yearStr != null && !yearStr.isEmpty()) {
                year = Integer.parseInt(yearStr);
            }

            /*
            ------------------------------------------------
            关键逻辑：判断车是属于谁
            ------------------------------------------------
             */
            String customerIdStr = request.getParameter("customerId");
            User owner;

            if (customerIdStr != null && !customerIdStr.isEmpty()) {

                Long customerId = Long.parseLong(customerIdStr);
                owner = userFacade.find(customerId); // staff / manager 帮 customer 加

                if (owner == null) {
                    throw new Exception("Customer not found.");
                }

            } else {

                owner = currentUser; // customer 自己加

            }

            // 创建 Car
            Car car = new Car(carPlate, brand, model, color, year, owner);

            carFacade.create(car);

            /*
            ------------------------------------------------
            根据角色 redirect
            ------------------------------------------------
             */
            if ("customer".equalsIgnoreCase(currentUser.getRole())) {

                response.sendRedirect(request.getContextPath()
                        + "/EditProfile?vehicleAdded=true");

            } else {

                response.sendRedirect(request.getContextPath()
                        + "/ManageCustomers?action=list");

            }

        } catch (NumberFormatException e) {

            request.setAttribute("errorMessage", "Invalid Year format.");

            request.getRequestDispatcher("AddVehicle.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("errorMessage", e.getMessage());

            request.getRequestDispatcher("AddVehicle.jsp")
                    .forward(request, response);
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
