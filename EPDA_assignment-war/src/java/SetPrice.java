
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

        // ================= ADD SERVICE =================
        if ("add".equals(action)) {

            String serviceType = request.getParameter("serviceType");
            String priceStr = request.getParameter("price");
            String hourStr = request.getParameter("serviceHour");

            if (serviceType != null && priceStr != null && hourStr != null
                    && !serviceType.isEmpty()) {

                double price = Double.parseDouble(priceStr);
                int hour = Integer.parseInt(hourStr);

                Services s = new Services();
                s.setServiceType(serviceType);
                s.setPrice(price);
                s.setServiceHour(hour); // ✅ IMPORTANT

                servicesFacade.create(s);
            }

            response.sendRedirect("SetPrice");
            return;
        }

        // ================= UPDATE PRICE =================
        if (request.getParameter("updateAll") != null) {

            int total = Integer.parseInt(request.getParameter("totalCount"));

            for (int i = 0; i < total; i++) {

                String idStr = request.getParameter("serviceId_" + i);
                String priceStr = request.getParameter("price_" + i);

                if (idStr != null && priceStr != null && !priceStr.isEmpty()) {

                    Long id = Long.parseLong(idStr);
                    double price = Double.parseDouble(priceStr);

                    servicesFacade.updatePrice(id, price);
                }
            }

            response.getWriter().println(
                    "<script>alert('Updated Successfully!'); location='SetPrice';</script>"
            );
        }

        // ================= DELETE SERVICE =================
        if ("delete".equals(action)) {

            String idStr = request.getParameter("id");

            if (idStr != null) {
                Long id = Long.parseLong(idStr);
                servicesFacade.delete(id);
            }

            response.sendRedirect("SetPrice");
            return;
        }
    }
}
