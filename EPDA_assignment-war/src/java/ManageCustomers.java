
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

        // 💡 搜索与列表逻辑
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
                String phoneStr = request.getParameter("phoneNumber");
                int newPhoneNumber = Integer.parseInt(phoneStr.replaceAll("[^0-9]", ""));

                // 💡 1. 检查电话号码是否被【其他人】占用
                User userWithThisPhone = userFacade.findByPhone(newPhoneNumber);

                if (userWithThisPhone != null && !userWithThisPhone.getUser_id().equals(id)) {
                    // 如果找到了这个电话号码，且拥有者不是当前正在修改的这个人
                    request.getSession().setAttribute("errorMsg", "Update failed: Phone number '" + phoneStr + "' is already registered to another customer!");
                } else {
                    // 💡 2. 没冲突，执行更新
                    User u = userFacade.find(id);
                    if (u != null) {
                        u.setUsername(username);
                        u.setPhoneNumber(newPhoneNumber);
                        // Email 已经在 JSP 设为 readonly，这里不处理 email

                        userFacade.edit(u);
                        request.getSession().setAttribute("successMsg", "Customer '" + username + "' profile updated successfully!");
                    } else {
                        request.getSession().setAttribute("errorMsg", "Update failed: Customer not found.");
                    }
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMsg", "Update failed: " + e.getMessage());
            }
        }

        response.sendRedirect(contextPath + "/ManageCustomers?action=list");
    }
}
