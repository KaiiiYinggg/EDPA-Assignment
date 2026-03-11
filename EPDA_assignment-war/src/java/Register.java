///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//import Entity.User;
//import Entity.UserFacade;
//import java.io.IOException;
//import java.io.PrintWriter;
//import javax.ejb.EJB;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
///**
// *
// * @author teech
// */
//@WebServlet(urlPatterns = {"/Register"})
//public class Register extends HttpServlet {
//    @EJB
//    private UserFacade userFacade;
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            String name = request.getParameter("username");
//            String password = request.getParameter("password");
//            String email = request.getParameter("email");
//            String role = request.getParameter("role");
//            String gender= request.getParameter("gender");
//            
//            // Handle the phone number carefully (Strings can be null, ints cannot)
//            String phoneStr = request.getParameter("phoneNumber");
//            int phoneNumber = 0;
//
//            if (phoneStr != null && !phoneStr.isEmpty()) {
//                // Remove all non-numeric characters (like hyphens or spaces)
//                String cleanPhone = phoneStr.replaceAll("[^0-9]", ""); 
//                try {
//                    phoneNumber = Integer.parseInt(cleanPhone);
//                } catch (NumberFormatException e) {
//                    request.setAttribute("error", "Phone Number Error! ");
//                    request.getRequestDispatcher("register.jsp").forward(request, response);
//                }
//            }
//
//            try {
//                // 1. Validate required fields
//                if (name == null || name.trim().isEmpty() ||
//                    password == null || password.trim().isEmpty() ||
//                    email == null || email.trim().isEmpty() ||
//                    role == null || role.trim().isEmpty() ||
//                    phoneStr == null || phoneStr.trim().isEmpty() ||
//                    gender == null || gender.trim().isEmpty()) {
//
//                    request.setAttribute("error", "All fields are required!(Name, Password, Email, Gender, and Role)");
//                    request.getRequestDispatcher("register.jsp").forward(request, response);
//                    return;
//                }
//                // 2. Check if user already exists
//                User userByEmail = userFacade.findByEmail(email);
//                
//                if (userByEmail!=null) {
//                    request.setAttribute("error", "This email already registered!Please try another.");
//                    request.getRequestDispatcher("register.jsp").forward(request, response);
//                    return;
//                }                
//
//               // 3. Create and Save (using lowercase userFacade)
//                userFacade.create(new User(name,password,phoneNumber,gender,role,email));
//                
//                // 4. Success handling
//                request.setAttribute("loginSuccessMessage", "Registration Successful for " + name); //where data save?????
//                request.getRequestDispatcher("register.jsp").forward(request, response);
//
//            } catch (Exception e) {
//                request.setAttribute("error", "Error: " + e.getMessage());
//                request.getRequestDispatcher("register.jsp").forward(request, response);
//            }
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.User;
import Entity.UserFacade;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(urlPatterns = {"/Register"})
public class Register extends HttpServlet {
    @EJB
    private UserFacade userFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // 获取前端输入
        String name = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String gender = request.getParameter("gender");
        String phoneStr = request.getParameter("phoneNumber");
        
        int phoneNumber = 0;

        try {
            // 1. 基础验证：确保所有字段都不为空
            if (name == null || name.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                role == null || role.trim().isEmpty() ||
                phoneStr == null || phoneStr.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {

                request.setAttribute("error", "All fields are required! (Name, Password, Email, Gender, and Role)");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 2. 处理电话号码格式
            String cleanPhone = phoneStr.replaceAll("[^0-9]", ""); 
            try {
                phoneNumber = Integer.parseInt(cleanPhone);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Phone Number Error! Please enter numbers only.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 3. 检查 Email 是否已经存在 (Unique Constraint)
            User userByEmail = userFacade.findByEmail(email);
            if (userByEmail != null) {
                request.setAttribute("error", "This email is already registered! Please try another.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }                

            // 4. 创建 User 对象
            User newUser = new User(name, password, phoneNumber, gender, role, email);
            
            // --- 核心改动：根据性别分配默认照片文件名 ---
            if ("Male".equalsIgnoreCase(gender)) {
                newUser.setProfilePic("male_default.jpg");
            } else if ("Female".equalsIgnoreCase(gender)) {
                newUser.setProfilePic("female_default.jpg");
            }
            
            // 5. 调用 Facade 保存到数据库
            userFacade.create(newUser);
            
            // 6. 成功跳转
            request.setAttribute("loginSuccessMessage", "Registration Successful for " + name);
            request.getRequestDispatcher("register.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "System Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
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
        return "Register Servlet for EDP Assignment";
    }
}