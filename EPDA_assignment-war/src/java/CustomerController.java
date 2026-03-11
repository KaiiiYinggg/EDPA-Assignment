///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller;
//
//import java.io.IOException;
//import java.util.List;
//import javax.ejb.EJB;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import Entity.User;
//import Entity.UserFacade;
//
//@WebServlet(name = "CustomerController", urlPatterns = {"/CustomerController"})
//public class CustomerController extends HttpServlet {
//
//    @EJB
//    private UserFacade userFacade;
//
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        if ("list".equals(action)) {
//            // 获取所有用户
//            List<User> allUsers = userFacade.findAll();
//            request.setAttribute("userList", allUsers);
//            request.getRequestDispatcher("manage_customers.jsp").forward(request, response);
//
//        } else if ("delete".equals(action)) {
//            // 获取要删除的 username
//            String username = request.getParameter("username");
//            if (username != null) {
//                User target = userFacade.find(username);
//                if (target != null) {
//                    userFacade.remove(target);
//                }
//            }
//            // 删除后刷新列表
//            response.sendRedirect("CustomerController?action=list");
//
//        } else if ("editPage".equals(action)) {
//            // 获取要修改的用户 username
//            String username = request.getParameter("username");
//            if (username != null) {
//                User found = userFacade.find(username);
//                request.setAttribute("targetUser", found);
//            }
//            request.getRequestDispatcher("edit_customer.jsp").forward(request, response);
//        }
//    }
//
//    @Override 
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
//            throws ServletException, IOException { 
//        processRequest(req, resp); 
//    }
//    
//    @Override 
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
//            throws ServletException, IOException { 
//        processRequest(req, resp); 
//    }
//}