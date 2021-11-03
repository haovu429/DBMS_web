package control;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DAO;
import entity.Account;

@WebServlet(name = "SignUpControl", urlPatterns = {"/signup"})
public class SignUpControl extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7725428130375111631L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        String re_pass = request.getParameter("repass");
        if(!pass.equals(re_pass)) {
        	response.sendRedirect("Login.jsp");
        }
        else {
        	DAO dao = new DAO();
        	Account a = dao.checkAccountExist(user);
        	if(a == null) {
        		dao.signup(user,pass);
        		
        		response.sendRedirect("home");
        		
        		
        	  }
        	else {
        		response.sendRedirect("Login.jsp");
        	}
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
        return "Short description";
    }
	
}
