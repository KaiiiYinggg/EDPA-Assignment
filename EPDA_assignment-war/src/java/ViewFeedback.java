/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Entity.FeedbackFacade;
import Entity.User;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/ViewFeedback"})
public class ViewFeedback extends HttpServlet {

    @EJB
    private FeedbackFacade FeedbackFacade;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = user.getEmail();
        String role = user.getRole();

        String searchQuery = request.getParameter("searchQuery");
        String ratingFilter = request.getParameter("ratingFilter");
        String dateFilter = request.getParameter("dateFilter");

        List<Object[]> feedbackData = FeedbackFacade.findDetailedFeedbackFiltered(email, role, searchQuery, ratingFilter, dateFilter);

        request.setAttribute("feedbackData", feedbackData);
        request.getRequestDispatcher("viewFeedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
