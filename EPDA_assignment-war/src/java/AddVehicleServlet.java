
import Entity.Car;
import Entity.CarFacade;
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

@WebServlet("/AddVehicleServlet")
public class AddVehicleServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    @EJB
    private UserFacade userFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String userEmail = (String) session.getAttribute("email");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = userFacade.findByEmail(userEmail);

        String carPlate = request.getParameter("carPlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String color = request.getParameter("color");

        int year = 0;
        String yearStr = request.getParameter("year");

        if (yearStr != null && !yearStr.isEmpty()) {
            year = Integer.parseInt(yearStr);
        }

        Car car = new Car();
        car.setCarPlateNumber(carPlate);
        car.setCarBrand(brand);
        car.setCarModel(model);
        car.setColor(color);
        car.setYear(year);
        car.setUser(user);

        carFacade.create(car);

        response.sendRedirect("EditProfile");
    }
}