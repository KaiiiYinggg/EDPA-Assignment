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
import javax.servlet.http.*;

@WebServlet(urlPatterns = {"/Login"})
public class Login extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String emailInput = request.getParameter("email");
        String passwordInput = request.getParameter("password");

        // 1️⃣ Basic validation
        if (emailInput == null || emailInput.isEmpty() || passwordInput == null || passwordInput.isEmpty()) {
            request.setAttribute("error", "Please enter both email and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 2️⃣ Find user by email
        User user = userFacade.findByEmail(emailInput);

        if (user != null && user.getPassword().equals(passwordInput)) {
            // 3️⃣ Store user in session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);          // 整个 User 对象
            session.setAttribute("email", user.getEmail()); // 单独存 email，AddVehicle 可以直接用

            // 4️⃣ Redirect according to role
            String role = user.getRole().toLowerCase();
            switch (role) {
                case "manager":
                    response.sendRedirect("managerDashboard.jsp");
                    break;
                case "counter staff":
                    response.sendRedirect("Staff/StaffDashboard.jsp");
                    break;
                case "technician":
                    response.sendRedirect("Staff/TechDashboard.jsp");
                    break;
                case "customer":
                    response.sendRedirect("customerDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("index.jsp");
            }
        } else {
            // 5️⃣ Login failed
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet";
    }
}