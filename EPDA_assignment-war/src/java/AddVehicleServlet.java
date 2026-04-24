/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
            //trim, change to all uppercase
            String rawPlate = request.getParameter("carPlate");
            if (rawPlate == null || rawPlate.trim().isEmpty()) {
                throw new Exception("Car plate number is required.");
            }
            String carPlate = rawPlate.trim().replace(" ", "").toUpperCase();

            String brand = request.getParameter("brand").trim();
            String model = request.getParameter("model").trim();
            String color = request.getParameter("color").trim();
            String yearStr = request.getParameter("year");

            Car existingCar = carFacade.find(carPlate);
            if (existingCar != null) {
                //check db got duplicate vehicle
                request.setAttribute("errorMessage",
                        "Error: Vehicle [" + carPlate + "] is already registered under "
                        + (existingCar.getUser().getEmail().equals(currentUser.getEmail()) ? "your account." : "another user."));

                request.setAttribute("customerId", request.getParameter("customerId"));
                request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
                return;
            }

            String customerIdStr = request.getParameter("customerId");
            User owner;
            if (customerIdStr != null && !customerIdStr.isEmpty()) {
                // staff help customer add vehicle
                Long customerId = Long.parseLong(customerIdStr);
                owner = userFacade.find(customerId);
            } else {
                // customer add vehicle
                owner = userFacade.find(currentUser.getUser_id());
            }

            if (owner == null) {
                throw new Exception("Customer data integrity error.");
            }

            int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : 0;
            Car car = new Car(carPlate, brand, model, color, year, owner);
            carFacade.create(car);

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

        boolean isViewOnly = false;

        request.setAttribute("viewOnly", isViewOnly);
        request.setAttribute("customerId", customerId);

        request.getRequestDispatcher("AddVehicle.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Add vehicle servlet";
    }
}
