package control;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DAO;
import entity.Account;
import entity.Category;
import entity.Product;

import java.util.List;

@WebServlet(name = "ManagerControl", urlPatterns = {"/manager"})
public class ManagerControl extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3525025082470939651L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session  = request.getSession();
        Account a =(Account) session.getAttribute("acc");
        int id = a.getUid();
        DAO dao =new DAO();
        
       
       
        List<Product> list = dao.getProductBySaleID(id);
        List<Category> listC = dao.getAllCategory();
        request.setAttribute("listP", list);
        request.setAttribute("listCC", listC);
     
        
       

        request.getRequestDispatcher("ManagerProduct.jsp").forward(request, response);
        
        
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
