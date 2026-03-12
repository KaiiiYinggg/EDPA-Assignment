/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
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
@WebServlet(urlPatterns = {"/Login"})
public class Login extends HttpServlet {
    
    @EJB
    private UserFacade userFacade;

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
        
        String emailInput = request.getParameter("email");
        String passwordInput = request.getParameter("password");
        
        // Check if fields are empty first (Basic Validation)
        if (emailInput == null || emailInput.isEmpty() || passwordInput == null || passwordInput.isEmpty()) {
            request.setAttribute("error", "Please enter both email and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return; 
        }
        
        // 2. Database Comparison
        User user = userFacade.findByEmail(emailInput);
            
        if (user != null) {
            // Check if Password matches
            if (user.getPassword().equals(passwordInput)) {

                // 4. Success! Store user in session
                request.getSession().setAttribute("user", user);

                // 5. Get role from the database object and redirect
                String role = user.getRole().toLowerCase(); // Normalize to lowercase

                switch (role) {
                    case "manager":
                        response.sendRedirect("managerDashboard.jsp");
                        break;
                    case "counter staff":
                        response.sendRedirect("counterDashboard.jsp");
                        break;
                    case "technician":
                        response.sendRedirect("technicianDashboard.jsp");
                        break;
                    case "customer":
                        response.sendRedirect("customerDashboard.jsp");
                        break;
                    default:
                        // Fallback for undefined roles
                        response.sendRedirect("index.jsp"); 
                        break;
                }
                return; 

            } else {
                request.setAttribute("error", "Invalid Password.");
            }
        } else {
            request.setAttribute("error", "No account found with that email.");
        }

            // 3. If we reach here, there was an error
            request.getRequestDispatcher("login.jsp").forward(request, response);
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