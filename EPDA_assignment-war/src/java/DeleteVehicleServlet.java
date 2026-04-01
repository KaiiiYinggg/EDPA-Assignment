import Entity.Car;
import Entity.CarFacade;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteVehicle")
public class DeleteVehicleServlet extends HttpServlet {

    @EJB
    private CarFacade carFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String plate = request.getParameter("plate");
        
        if (plate != null && !plate.isEmpty()) {
            try {
                // 1. 找到这辆车
                Car car = carFacade.find(plate);
                if (car != null) {
                    // 2. 从数据库删除
                    carFacade.remove(car);
                }
                // 3. 删除成功，跳回 Profile 页面
                response.sendRedirect(request.getContextPath() + "/EditProfile?msg=VehicleRemoved");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/EditProfile?error=DeleteFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/EditProfile");
        }
    }
}