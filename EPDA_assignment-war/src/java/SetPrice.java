 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.Services;
import Entity.ServicesFacade;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/SetPrice"})
public class SetPrice extends HttpServlet {

    @EJB
    private ServicesFacade servicesFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Services> serviceList = servicesFacade.findAll();
        request.setAttribute("serviceList", serviceList);

        request.getRequestDispatcher("setPrice.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // add services
        if ("add".equals(action)) {
            String serviceType = request.getParameter("serviceType").trim().toUpperCase();
            String priceStr = request.getParameter("price");
            String hourStr = request.getParameter("serviceHour");

            if (serviceType != null && !serviceType.isEmpty()) {
                // check same service type
                Services existing = servicesFacade.findByType(serviceType);
                if (existing != null) {
                    sendAlert(response, "Error: Service [" + serviceType + "] already exists!");
                    return;
                }

                Services s = new Services();
                s.setServiceType(serviceType);
                s.setPrice(Double.parseDouble(priceStr));
                s.setServiceHour(Integer.parseInt(hourStr));
                servicesFacade.create(s);
            }
            response.sendRedirect("SetPrice");
            return;
        }

        // update all
        if (request.getParameter("updateAll") != null) {
            try {
                int total = Integer.parseInt(request.getParameter("totalCount"));

                //check edited services type no duplicate record in db
                for (int i = 0; i < total; i++) {
                    String idStr = request.getParameter("serviceId_" + i);
                    String newName = request.getParameter("serviceName_" + i).trim().toUpperCase();

                    if (idStr != null) {
                        Long id = Long.parseLong(idStr);
                        Services existing = servicesFacade.findByType(newName);

                        if (existing != null && !existing.getService_id().equals(id)) {
                            sendAlert(response, "Error: The name [" + newName + "] is already used! No changes were saved.");
                            return;
                        }
                    }
                }

                // save
                for (int i = 0; i < total; i++) {
                    String idStr = request.getParameter("serviceId_" + i);
                    String newName = request.getParameter("serviceName_" + i).trim();
                    String newHourStr = request.getParameter("serviceHour_" + i);
                    String newPriceStr = request.getParameter("price_" + i);

                    if (idStr != null) {
                        Long id = Long.parseLong(idStr);
                        Services s = servicesFacade.find(id);
                        if (s != null) {
                            s.setServiceType(newName);
                            s.setServiceHour(Integer.parseInt(newHourStr));
                            s.setPrice(Double.parseDouble(newPriceStr));
                            servicesFacade.edit(s);
                        }
                    }
                }

                sendAlert(response, "All services updated successfully!", "SetPrice");

            } catch (Exception e) {
                sendAlert(response, "Update failed: " + e.getMessage());
            }
        }
    }

    private void sendAlert(HttpServletResponse response, String msg) throws IOException {
        sendAlert(response, msg, null);
    }

    private void sendAlert(HttpServletResponse response, String msg, String redirectUrl) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        String script = "<script>alert('" + msg + "'); "
                + (redirectUrl != null ? "location='" + redirectUrl + "';" : "history.back();")
                + "</script>";
        response.getWriter().println(script);
    }
}
