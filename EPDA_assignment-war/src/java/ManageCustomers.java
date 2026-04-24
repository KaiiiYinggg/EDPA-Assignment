/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import Entity.Car;
import Entity.CarFacade;
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
    @EJB
    private CarFacade carFacade;

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

        String searchQuery = request.getParameter("searchQuery");
        List<User> userList = userFacade.findAllCustomers();
        request.setAttribute("userList", userList);

        if ("counter staff".equalsIgnoreCase(role) || "manager".equalsIgnoreCase(role)) {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                userList = userFacade.searchCustomers(searchQuery);
            } else {
                userList = userFacade.findAllCustomers();
            }
        } else {
            userList = null;
        }

        if (userList != null) {
            for (User u : userList) {
                List<Car> cars = carFacade.findByUserEmail(u.getEmail());
                u.setCarList(cars);
            }
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("ManageCustomers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String contextPath = request.getContextPath();
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
                String username = request.getParameter("username");
                String gender = request.getParameter("gender");
                String address = request.getParameter("address");
                String phoneStr = request.getParameter("phoneNumber");
                int newPhoneNumber = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));

                // check duplicate phone number
                User userWithThisPhone = userFacade.findByPhone(newPhoneNumber);

                if (userWithThisPhone != null && !userWithThisPhone.getUser_id().equals(id)) {
                    request.getSession().setAttribute("errorMsg", "Update failed: Phone number is already in use!");
                } else {
                    User u = userFacade.find(id);
                    if (u != null) {
                        // update all fields
                        u.setUsername(username);
                        u.setPhoneNumber(newPhoneNumber);
                        u.setAddress(address);

                        userFacade.edit(u);
                        request.getSession().setAttribute("successMsg", "Customer '" + username + "' profile updated successfully!");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMsg", "Update failed: " + e.getMessage());
            }
        }

        response.sendRedirect(contextPath + "/ManageCustomers?action=list");
    }
}
