 ///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package Staff;
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
//@WebServlet(name = "ManageCustomers", urlPatterns = {"/Staff/ManageCustomers"})
//public class ManageCustomers extends HttpServlet {
//
//    @EJB
//    private UserFacade userFacade;
//
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        String action = request.getParameter("action");
//        
//        // 如果没有提供 action 或者 action 为 list
//        if (action == null || action.equals("list")) {
//            List<User> customers = userFacade.findAllCustomers();
//            request.setAttribute("customerList", customers);
//            request.getRequestDispatcher("ManageCustomers.jsp").forward(request, response);
//        
//        } 
//        // 处理删除操作
//        else if (action.equals("delete")) {
//            String idStr = request.getParameter("id");
//            if (idStr != null) {
//                Long id = Long.parseLong(idStr);
//                userFacade.deleteById(id);
//            }
//            // 删除后重新导向到列表页面，刷新数据
//            response.sendRedirect("ManageCustomers?action=list");
//        }
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//}
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // 逻辑：更新
        if (action.equals("update")) {
            Long id = Long.parseLong(request.getParameter("id"));
            String newName = request.getParameter("username");
            User u = userFacade.find(id);
            if (u != null) {
                u.setUsername(newName);
                userFacade.edit(u); // 调用 AbstractFacade 的 edit 方法
            }
            response.sendRedirect("ManageCustomers?action=list");
            return;
        }

        // 逻辑：搜索与列出
        String searchQuery = request.getParameter("searchQuery");
        List<User> customers;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // 这里你可以复用之前写的 search 方法，但确保它是搜 customer 角色
            customers = userFacade.searchCustomers(searchQuery);
        } else {
            customers = userFacade.findAllCustomers();
        }

        request.setAttribute("customerList", customers);
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
                Long id = Long.parseLong(request.getParameter("id"));
                String username = request.getParameter("username");
                int phoneNumber = Integer.parseInt(request.getParameter("phoneNumber"));
                String email = request.getParameter("email");

                User u = userFacade.find(id);
                if (u != null) {
                    u.setUsername(username);
                    u.setPhoneNumber(phoneNumber);
                    // 这里要特别注意：如果你允许改 email，JPA 会在提交时检查 Unique 约束
                    // 建议在 set 之前做一个简单的 UserFacade.findByEmail 检查
                    u.setEmail(email);
                    userFacade.edit(u);
                }
            } catch (Exception e) {
                // 可以通过 request.setAttribute("error", "Email already exists!"); 传回页面
            }
        }

        response.sendRedirect("ManageCustomers?action=list");
    }
}
