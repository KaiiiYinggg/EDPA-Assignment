/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.Services;
import Entity.ServicesFacade;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author teech
 */
@WebServlet(urlPatterns = {"/SetPrice"})
public class SetPrice extends HttpServlet {
    @EJB
    private ServicesFacade servicesFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
            String method = request.getMethod();
            
            if (method.equalsIgnoreCase("GET")) {
 
            // get all services and send to JSP
            List<Services> serviceList = servicesFacade.findAll();
            request.setAttribute("serviceList", serviceList);
            request.getRequestDispatcher("setPrice.jsp").forward(request, response);

        } else if (method.equalsIgnoreCase("POST")) {
            if (request.getParameter("updateAll") != null) {
                String totalStr = request.getParameter("totalCount");
        
                if (totalStr != null) {
                    int total = Integer.parseInt(totalStr);

                    for (int i = 0; i < total; i++) {
                        // 根据索引精准获取对应的 ID 和 Price
                        String idStr = request.getParameter("serviceId_" + i);
                        String priceStr = request.getParameter("price_" + i);

                        if (idStr != null && priceStr != null && !priceStr.isEmpty()) {
                            Long id = Long.parseLong(idStr);
                            double price = Double.parseDouble(priceStr);

                            // update bsed on id 
                            servicesFacade.updatePrice(id, price);
                        }
                    }
                }

                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('All Prices Updated Successfully!'); location='SetPrice';</script>");
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
