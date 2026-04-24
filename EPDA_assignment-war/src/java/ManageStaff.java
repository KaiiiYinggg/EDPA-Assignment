/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/ManageStaff"})
public class ManageStaff extends HttpServlet {
    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
            User currentManager = (User) request.getSession().getAttribute("user");
            
            String myEmail = currentManager.getEmail();

            // get search text
            String searchQuery = request.getParameter("searchQuery");
            List<User> staffList;

            // if search show result, else show all
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                staffList = userFacade.searchStaffExceptMe(myEmail, searchQuery);
            } else {
                staffList = userFacade.findAllStaffExceptMe(myEmail);
            }

            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("manageStaff.jsp").forward(request, response);
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
        return "Short description";
    }

}
