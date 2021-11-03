package control;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dao.DAO;
import entity.Account;
import entity.Category;
import entity.Product;

@WebServlet(name = "ManageAccountControl", urlPatterns = {"/manage"})
public class ManageAccountControl extends HttpServlet  {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        
        String indexPage = request.getParameter("index");
        if(indexPage ==null) {
        	indexPage = "1";
        }
        int index = Integer.parseInt(indexPage);
        DAO dao = new DAO();
        int count = dao.getTotalAccount();
        int endPage = count/6;
        if(count % 6!=0) {
        	endPage++;
        }
        List<Account> list = dao.pagingAccount(index);
       
        
        request.setAttribute("listA", list);
        request.setAttribute("endP", endPage);
        request.setAttribute("tag1", index);
        request.setAttribute("count", count);
        
       
       

        request.getRequestDispatcher("ManageAccount.jsp").forward(request, response);
        
        
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
