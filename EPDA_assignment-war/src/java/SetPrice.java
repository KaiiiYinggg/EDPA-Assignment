
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

        // ================= 1. ADD SERVICE (新增逻辑) =================
        if ("add".equals(action)) {
            String serviceType = request.getParameter("serviceType").trim();
            String priceStr = request.getParameter("price");
            String hourStr = request.getParameter("serviceHour");

            if (serviceType != null && !serviceType.isEmpty()) {
                // 💡 检查名字是否已存在
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

        // ================= 2. UPDATE ALL (编辑逻辑 + 重名检查) =================
        if (request.getParameter("updateAll") != null) {
            try {
                int total = Integer.parseInt(request.getParameter("totalCount"));

                // 💡 第一步：【全面预检】—— 先检查一遍有没有任何一个名字会被改重名
                for (int i = 0; i < total; i++) {
                    String idStr = request.getParameter("serviceId_" + i);
                    String newName = request.getParameter("serviceName_" + i).trim();

                    if (idStr != null) {
                        Long id = Long.parseLong(idStr);
                        Services existing = servicesFacade.findByType(newName);

                        // 如果找到了同名服务，且 ID 不是当前这个正在改的服务
                        if (existing != null && !existing.getService_id().equals(id)) {
                            sendAlert(response, "Error: The name [" + newName + "] is already used! No changes were saved.");
                            return; // ✋ 立刻停止，不执行下面的第二步（Save 逻辑）
                        }
                    }
                }

                // 💡 第二步：【正式执行】—— 只有预检通过了，才真正跑第二次循环去 Save
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
                            servicesFacade.edit(s); // 这次才是真的存进 DB
                        }
                    }
                }

                sendAlert(response, "All services updated successfully!", "SetPrice");

            } catch (Exception e) {
                sendAlert(response, "Update failed: " + e.getMessage());
            }
        }
    }

// 辅助方法：用来弹窗并跳转/返回
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
