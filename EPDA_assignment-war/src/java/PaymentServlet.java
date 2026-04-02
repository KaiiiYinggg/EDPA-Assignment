 ///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//


import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Payment;
import Entity.PaymentFacade;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    @EJB
    private AppointmentFacade appFacade;
    @EJB
    private PaymentFacade paymentFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String query = request.getParameter("query");

        try {
            if ("viewHistory".equals(action)) {
                // --- 1. 历史记录模式 ---
                List<Payment> history = paymentFacade.findAll();
                request.setAttribute("paymentHistory", history);
                request.setAttribute("view", "history"); // 对应 JSP 里的 <c:when test="${view == 'history'}">
            } else {
                // --- 2. 默认收银台模式 ---
                List<Appointment> list;
                if ("search".equals(action) && query != null && !query.isEmpty()) {
                    list = appFacade.searchUnpaid(query);
                } else {
                    list = appFacade.findAllCompleted();
                }
                request.setAttribute("appList", list);
                request.setAttribute("view", "pending"); // 对应 JSP 里的 <c:otherwise>
            }

            // 统一转发到 PaymentReceipt.jsp
            request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appIdStr = request.getParameter("appointmentId");
            String method = request.getParameter("paymentMethod");

            if (appIdStr == null || method == null) {
                response.sendRedirect("PaymentServlet");
                return;
            }

            Long appId = Long.parseLong(appIdStr);
            Appointment app = appFacade.find(appId);

            if (app != null) {
                double price = app.getService().getPrice();
                String txnId = "TXN-" + System.currentTimeMillis();

                // 1. 存入 Payment DB
                Entity.Payment pay = new Entity.Payment();
                pay.setAppointment(app);
                pay.setReceipt_id(txnId);
                pay.setPayment_method(method);
                pay.setTotal_price(price);
                pay.setPayment_date(java.time.LocalDate.now());

                paymentFacade.create(pay);

                // 2. 更新 Appointment 状态
                app.setAppointment_status("Paid");
                appFacade.edit(app);

                // 3. 准备收据数据
                request.setAttribute("transactionId", txnId);
                request.setAttribute("custName", app.getCustomer().getUsername());
                request.setAttribute("serviceType", app.getService().getServiceType());
                request.setAttribute("price", price);
                request.setAttribute("method", method);

                // 4. 付款后默认回到“待付列表”视图
                request.setAttribute("view", "pending");
                request.setAttribute("appList", appFacade.findAllCompleted());
                
                request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}