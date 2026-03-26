 ///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
package Staff;

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

@WebServlet(name = "ManageCustomers", urlPatterns = {"/Staff/ManageCustomers"})
public class ManageCustomers extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        String role = currentUser.getRole();

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // 更新逻辑
        if ("update".equals(action)) {
            Long id = Long.parseLong(request.getParameter("user_id"));
            String username = request.getParameter("username");
            int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber"));
            String email = request.getParameter("email");

            User u = userFacade.find(id);
            if (u != null) {
                u.setUsername(username);
                u.setPhoneNumber(phoneNumber);
                u.setEmail(email);
                userFacade.edit(u);
            }
            response.sendRedirect("ManageCustomers?action=list");
            return;
        }

        // 搜索与列表逻辑
        String searchQuery = request.getParameter("searchQuery");
        List<User> userList;

        if ("counter staff".equalsIgnoreCase(role)) {
            // Staff 管理 Customers
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                userList = userFacade.searchCustomers(searchQuery);
            } else {
                userList = userFacade.findAllCustomers();
            }
        } else if ("manager".equalsIgnoreCase(role)) {
            // Manager 管理 Staff
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                userList = userFacade.searchCustomers(searchQuery);
            } else {
                userList = userFacade.findAllCustomers();
            }
        } else {
            userList = null;
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("ManageCustomers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("deleteMultiple".equals(action)) {
            String[] ids = request.getParameterValues("selectedIds");
            if (ids != null) {
                for (String idStr : ids) {
                    userFacade.remove(userFacade.find(Long.parseLong(idStr)));
                }
            }
        } else if ("update".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("user_id"));
                String username = request.getParameter("username");
                int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber"));
                String email = request.getParameter("email");

                User u = userFacade.find(id);
                if (u != null) {
                    u.setUsername(username);
                    u.setPhoneNumber(phoneNumber);
                    u.setEmail(email);
                    userFacade.edit(u);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Email already exists!");
            }
        }

        response.sendRedirect("ManageCustomers?action=list");
    }
}
