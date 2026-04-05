//import Entity.Car;
//import Entity.CarFacade;
//import java.io.IOException;
//import javax.ejb.EJB;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//@WebServlet("/DeleteVehicle")
//public class DeleteVehicleServlet extends HttpServlet {
//
//    @EJB
//    private CarFacade carFacade;
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        String plate = request.getParameter("plate");
//        
//        if (plate != null && !plate.isEmpty()) {
//            try {
//                // 1. 找到这辆车
//                Car car = carFacade.find(plate);
//                if (car != null) {
//                    // 2. 从数据库删除
//                    carFacade.remove(car);
//                }
//                // 3. 删除成功，跳回 Profile 页面
//                response.sendRedirect(request.getContextPath() + "/EditProfile?msg=VehicleRemoved");
//            } catch (Exception e) {
//                e.printStackTrace();
//                response.sendRedirect(request.getContextPath() + "/EditProfile?error=DeleteFailed");
//            }
//        } else {
//            response.sendRedirect(request.getContextPath() + "/EditProfile");
//        }
//    }
//}

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

        // 默认 redirect 到 customer profile
        String redirectURL = request.getContextPath() + "/EditProfile";

        // 如果是 staff / manager
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
                        owner.getCarList().remove(car); // 从集合移除
                    }
                    carFacade.remove(car); // 删除实体
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
