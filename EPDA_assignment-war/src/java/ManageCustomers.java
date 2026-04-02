// ///*
 //// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
//// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
//
//
//import Entity.User;
//import Entity.UserFacade;
//import java.io.IOException;
//import java.util.List;
//import javax.ejb.EJB;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//@WebServlet(name = "ManageCustomers", urlPatterns = {"/ManageCustomers"})
//public class ManageCustomers extends HttpServlet {
//
//    @EJB
//    private UserFacade userFacade;
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        User currentUser = (User) request.getSession().getAttribute("user");
//        String role = currentUser.getRole();
//
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "list";
//        }
//
//        // 更新逻辑
//        if ("update".equals(action)) {
//            Long id = Long.parseLong(request.getParameter("user_id"));
//            String username = request.getParameter("username");
//            int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber"));
//            String email = request.getParameter("email");
//
//            User u = userFacade.find(id);
//            if (u != null) {
//                u.setUsername(username);
//                u.setPhoneNumber(phoneNumber);
//                u.setEmail(email);
//                userFacade.edit(u);
//            }
//            response.sendRedirect("ManageCustomers?action=list");
//            return;
//        }
//
//        // 搜索与列表逻辑
//        String searchQuery = request.getParameter("searchQuery");
//        List<User> userList;
//
//        if ("counter staff".equalsIgnoreCase(role)) {
//            // Staff 管理 Customers
//            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
//                userList = userFacade.searchCustomers(searchQuery);
//            } else {
//                userList = userFacade.findAllCustomers();
//            }
//        } else if ("manager".equalsIgnoreCase(role)) {
//            // Manager 管理 Staff
//            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
//                userList = userFacade.searchCustomers(searchQuery);
//            } else {
//                userList = userFacade.findAllCustomers();
//            }
//        } else {
//            userList = null;
//        }
//
//        request.setAttribute("userList", userList);
//        request.getRequestDispatcher("ManageCustomers.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String action = request.getParameter("action");
//
//        if ("deleteMultiple".equals(action)) {
//            String[] ids = request.getParameterValues("selectedIds");
//            if (ids != null) {
//                for (String idStr : ids) {
//                    userFacade.remove(userFacade.find(Long.parseLong(idStr)));
//                }
//            }
//        } 
//        else if ("update".equals(action)) {
//            try {
//                Long id = Long.parseLong(request.getParameter("user_id"));
//                String email = request.getParameter("email");
//                String username = request.getParameter("username");
//                int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber"));
//
//                // 💡 1. 检查 Email 是否被【其他人】占用
//                User existingUser = userFacade.findByEmail(email);
//                
//                if (existingUser != null && !existingUser.getUser_id().equals(id)) {
//                    // Email 冲突了
//                    request.getSession().setAttribute("errorMsg", "Error: Email '" + email + "' is already in use!");
//                } else {
//                    // 💡 2. 执行更新
//                    User u = userFacade.find(id);
//                    if (u != null) {
//                        u.setUsername(username);
//                        u.setPhoneNumber(phoneNumber);
//                        u.setEmail(email);
//                        userFacade.edit(u);
//                        request.getSession().setAttribute("successMsg", "Customer updated successfully!");
//                    }
//                }
//            } catch (Exception e) {
//                request.getSession().setAttribute("errorMsg", "System Error: " + e.getMessage());
//            }
//        }
//
//        // 💡 统一跳回列表页
//        response.sendRedirect("ManageCustomers?action=list");
//    }
//}

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

@WebServlet(name = "ManageCustomers", urlPatterns = {"/ManageCustomers"})
public class ManageCustomers extends HttpServlet {

    @EJB
    private UserFacade userFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = currentUser.getRole();
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // 💡 搜索与列表逻辑
        String searchQuery = request.getParameter("searchQuery");
        List<User> userList;

        // 统一逻辑：Staff 和 Manager 都能管理 Customers
        if ("counter staff".equalsIgnoreCase(role) || "manager".equalsIgnoreCase(role)) {
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
        String contextPath = request.getContextPath(); // 💡 获取项目根路径，防止跳错地方

        if ("deleteMultiple".equals(action)) {
            try {
                String[] ids = request.getParameterValues("selectedIds");
                if (ids != null) {
                    for (String idStr : ids) {
                        userFacade.remove(userFacade.find(Long.parseLong(idStr)));
                    }
                    request.getSession().setAttribute("successMsg", "Selected customers deleted successfully.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMsg", "Delete failed: " + e.getMessage());
            }
        } else if ("update".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("user_id"));
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String phoneStr = request.getParameter("phoneNumber");

                // 💡 1. 检查 Email 是否被【其他人】占用
                User existingUser = userFacade.findByEmail(email);

                if (existingUser != null && !existingUser.getUser_id().equals(id)) {
                    request.getSession().setAttribute("errorMsg", "Error: Email '" + email + "' is already in use by another customer!");
                } else {
                    // 💡 2. 执行更新
                    User u = userFacade.find(id);
                    if (u != null) {
                        u.setUsername(username);
                        u.setPhoneNumber(Integer.parseInt(phoneStr));
                        u.setEmail(email);
                        userFacade.edit(u);
                        request.getSession().setAttribute("successMsg", "Customer '" + username + "' updated successfully!");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMsg", "Update failed: " + e.getMessage());
            }
        }

        // 💡 重点修正：使用 contextPath 确保绝对路径重定向，防止跳去 Edit 页面
        response.sendRedirect(contextPath + "/ManageCustomers?action=list");
    }
}
