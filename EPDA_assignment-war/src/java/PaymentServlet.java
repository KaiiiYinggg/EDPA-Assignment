
import Entity.Appointment;
import Entity.AppointmentFacade;
import Entity.Payment;
import Entity.PaymentFacade;
import java.io.IOException;
import java.util.ArrayList;
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

        String subAction = request.getParameter("subAction");

        try {
            if ("exportPDF".equals(action)) {
                exportPDF(request, response);
                return;
            }

            if ("viewHistory".equals(action)) {
                List<Payment> history;

                if ("searchHistory".equals(subAction) && query != null && !query.isEmpty()) {
                    history = paymentFacade.searchHistory(query);
                } else {
                    history = paymentFacade.findAll();
                }

                request.setAttribute("paymentHistory", history);
                request.setAttribute("view", "history");

            } else {
                List<Appointment> list;
                if ("search".equals(action) && query != null && !query.isEmpty()) {
                    list = appFacade.searchUnpaid(query);
                } else {
                    list = appFacade.findAllCompleted();
                }

                request.setAttribute("appList", list);
                request.setAttribute("view", "pending");
            }

            request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errorMessage", "Invalid search input.");
            request.setAttribute("appList", new ArrayList<>());
            request.setAttribute("view", "pending");

            request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);
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

                // Save Payment
                Payment pay = new Payment();
                pay.setAppointment(app);
                pay.setReceipt_id(txnId);
                pay.setPayment_method(method);
                pay.setTotal_price(price);
                pay.setPayment_date(java.time.LocalDate.now());

                paymentFacade.create(pay);

                // Update Appointment
                app.setAppointment_status("Paid");
                appFacade.edit(app);

                // Receipt Data
                request.setAttribute("transactionId", txnId);
                request.setAttribute("custName", app.getCustomer().getUsername());
                request.setAttribute("serviceType", app.getService().getServiceType());
                request.setAttribute("price", price);
                request.setAttribute("method", method);

                request.setAttribute("view", "pending");
                request.setAttribute("appList", appFacade.findAllCompleted());

                request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("errorMessage", "Invalid search input.");
            request.setAttribute("appList", new ArrayList<>());
            request.setAttribute("view", "pending");

            request.getRequestDispatcher("PaymentReceipt.jsp").forward(request, response);
        }
    }

    private void exportPDF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 获取参数 (保持不变)
        String id = request.getParameter("id");
        String cust = request.getParameter("cust");
        String svc = request.getParameter("svc");
        String price = request.getParameter("price");
        String method = request.getParameter("method");

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Receipt_" + id + ".pdf");

        try {
            // 1. 设置纸张大小（类似于小票的宽度，或者用 A4 但窄一点）
            com.itextpdf.text.Document document = new com.itextpdf.text.Document(com.itextpdf.text.PageSize.A6);
            com.itextpdf.text.pdf.PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // 2. 定义字体
            com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 16, com.itextpdf.text.Font.BOLD);
            com.itextpdf.text.Font boldFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.BOLD);
            com.itextpdf.text.Font normalFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.NORMAL);

            // 3. 标题居中
            com.itextpdf.text.Paragraph title = new com.itextpdf.text.Paragraph("APU AUTOMOTIVE", titleFont);
            title.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            document.add(title);

            com.itextpdf.text.Paragraph subTitle = new com.itextpdf.text.Paragraph("Official Payment Receipt", normalFont);
            subTitle.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            subTitle.setSpacingAfter(10f);
            document.add(subTitle);

            // 分割线
            document.add(new com.itextpdf.text.Paragraph("----------------------------------------------------------"));

            // 4. 使用表格来排列详情 (2列)
            com.itextpdf.text.pdf.PdfPTable table = new com.itextpdf.text.pdf.PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            // 辅助方法：添加表格行
            addTableRow(table, "Transaction ID:", id, normalFont);
            addTableRow(table, "Customer:", cust, normalFont);
            addTableRow(table, "Date:", java.time.LocalDate.now().toString(), normalFont);
            addTableRow(table, "Payment Method:", method, normalFont);

            document.add(table);

            document.add(new com.itextpdf.text.Paragraph("----------------------------------------------------------"));

            // 5. 费用总计 (两端对齐)
            com.itextpdf.text.pdf.PdfPTable totalTable = new com.itextpdf.text.pdf.PdfPTable(2);
            totalTable.setWidthPercentage(100);

            com.itextpdf.text.pdf.PdfPCell cellLeft = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(svc, boldFont));
            cellLeft.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
            totalTable.addCell(cellLeft);

            com.itextpdf.text.pdf.PdfPCell cellRight = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase("RM " + price, boldFont));
            cellRight.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
            cellRight.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
            totalTable.addCell(cellRight);

            document.add(totalTable);

            document.add(new com.itextpdf.text.Paragraph("----------------------------------------------------------"));

            // 6. PAID 状态
            com.itextpdf.text.Paragraph footer = new com.itextpdf.text.Paragraph("*** PAID ***", titleFont);
            footer.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
            footer.setSpacingBefore(20f);
            document.add(footer);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// 辅助函数：用来简化表格行的添加
    private void addTableRow(com.itextpdf.text.pdf.PdfPTable table, String label, String value, com.itextpdf.text.Font font) {
        com.itextpdf.text.pdf.PdfPCell cell1 = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(label, font));
        cell1.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
        cell1.setPaddingBottom(5f);
        table.addCell(cell1);

        com.itextpdf.text.pdf.PdfPCell cell2 = new com.itextpdf.text.pdf.PdfPCell(new com.itextpdf.text.Phrase(value, font));
        cell2.setBorder(com.itextpdf.text.Rectangle.NO_BORDER);
        cell2.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_RIGHT);
        table.addCell(cell2);
    }

}
