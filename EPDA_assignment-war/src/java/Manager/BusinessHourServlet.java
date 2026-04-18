package Manager;

import Entity.BusinessHour;
import Entity.BusinessHourFacade;
import java.io.IOException;
import java.time.LocalDate;
import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson;
import java.util.List;

@WebServlet("/Manager/BusinessHourServlet")
public class BusinessHourServlet extends HttpServlet {

    @EJB
    private BusinessHourFacade bhFacade;

    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateStr = request.getParameter("date");

        // ✨ 如果没有日期参数，说明是“打开页面”，直接查全表显示列表
        if (dateStr == null || dateStr.isEmpty()) {
            List<BusinessHour> allSettings = bhFacade.findAll();
            request.setAttribute("allSettings", allSettings);
            request.getRequestDispatcher("businessHourManagement.jsp").forward(request, response);
            return;
        }

        // ✨ 如果有日期参数，说明是 AJAX 在查询特定某天，返回 JSON (保持原来的逻辑)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            LocalDate date = LocalDate.parse(dateStr);
            BusinessHour bh = bhFacade.findByDate(date);
            if (bh == null) {
                response.getWriter().write(gson.toJson(new ApiResponse("normal", null, "10:00", "18:00")));
            } else {
                // 注意：这里要把 note 传给 message 字段显示在前端
                response.getWriter().write(gson.toJson(new ApiResponse(
                        bh.isIsClosed() ? "holiday" : "custom",
                        bh.getNote(),
                        bh.getOpenTime() != null ? bh.getOpenTime().toString() : "10:00",
                        bh.getCloseTime() != null ? bh.getCloseTime().toString() : "18:00"
                )));
            }
        } catch (Exception e) {
            response.getWriter().write(gson.toJson(new ApiResponse("error", "Invalid date", null, null)));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String dateStr = request.getParameter("date");

        try {
            LocalDate selectedDate = LocalDate.parse(dateStr);
            LocalDate today = LocalDate.now();

            // ✨ 双重保险：拦截任何尝试修改过去日期的 POST 请求
            if (selectedDate.isBefore(today)) {
                response.sendRedirect("BusinessHourServlet?error=pastDate");
                return;
            }

            BusinessHour bh = bhFacade.findByDate(selectedDate);

            // 执行删除逻辑
            if ("delete".equals(action)) {
                if (bh != null) {
                    bhFacade.remove(bh);
                }
                response.sendRedirect("BusinessHourServlet?success=deleted");
                return;
            }

            // 执行保存或更新逻辑
            if (bh == null) {
                bh = new BusinessHour();
                bh.setBusinessDate(selectedDate);
            }

            boolean isClosed = request.getParameter("isClosed") != null;
            bh.setIsClosed(isClosed);
            bh.setNote(request.getParameter("note"));

            if (!isClosed) {
                bh.setOpenTime(java.time.LocalTime.parse(request.getParameter("openTime")));
                bh.setCloseTime(java.time.LocalTime.parse(request.getParameter("closeTime")));
            } else {
                bh.setOpenTime(null);
                bh.setCloseTime(null);
            }

            if (bh.getId() == null) {
                bhFacade.create(bh);
            } else {
                bhFacade.edit(bh);
            }

            // 重定向回 Servlet 路径以刷新表格
            response.sendRedirect("BusinessHourServlet?success=saved");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BusinessHourServlet?error=true");
        }
    }

    // ✅ 更清楚的结构
    static class ApiResponse {

        String type;     // normal / holiday / custom / error
        String message;  // optional message
        String openTime;
        String closeTime;

        public ApiResponse(String type, String message, String openTime, String closeTime) {
            this.type = type;
            this.message = message;
            this.openTime = openTime;
            this.closeTime = closeTime;
        }
    }
}
