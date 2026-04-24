/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import Entity.Car;
import Entity.CarFacade;
import Entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DeleteVehicle")
public class DeleteVehicleServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String plate = request.getParameter("plate");

        HttpSession session = request.getSession(false);
        User currentUser = null;

        if (session != null) {
            currentUser = (User) session.getAttribute("user");
        }

        String redirectURL = request.getContextPath() + "/EditProfile";

        if (currentUser != null) {

            String role = currentUser.getRole();

            if ("manager".equalsIgnoreCase(role)
                    || "counter staff".equalsIgnoreCase(role)
                    || "staff".equalsIgnoreCase(role)) {

                redirectURL = request.getContextPath() + "/ManageCustomers?action=list";
            }
        }

        try {

            if (plate != null && !plate.isEmpty()) {

                Car car = carFacade.find(plate);
                if (car != null) {
                    User owner = car.getUser();
                    if (owner != null) {
                        owner.getCarList().remove(car);
                    }
                    carFacade.remove(car); 
                    carFacade.flush();
                }

                addMessageAndRedirect(response, redirectURL, "msg=VehicleRemoved");

            } else {

                addMessageAndRedirect(response, redirectURL, "error=InvalidPlate");

            }

        } catch (Exception e) {

            e.printStackTrace();
            addMessageAndRedirect(response, redirectURL, "error=DeleteFailed");

        }
    }

    private void addMessageAndRedirect(HttpServletResponse response, String url, String param)
            throws IOException {

        if (url.contains("?")) {
            response.sendRedirect(url + "&" + param);
        } else {
            response.sendRedirect(url + "?" + param);
        }
    }
}
