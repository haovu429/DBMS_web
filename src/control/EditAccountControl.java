package control;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dao.DAO;


@WebServlet(name = "EditAccountControl", urlPatterns = {"/editAccount"})
public class EditAccountControl extends HttpServlet {
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1710060330668303432L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        response.setContentType("text/html;charset=UTF-8");
	        request.setCharacterEncoding("UTF-8");
	        String aid = request.getParameter("uid");
	        String aname = request.getParameter("user");
	        String apass = request.getParameter("pass");
	        String aisSell = request.getParameter("isSell");
	        String aisAdmin = request.getParameter("isAdmin");
	       
	        
	     
	        
	        
	        DAO dao = new DAO();
	        dao.editAccount(aname, apass, aisSell, aisAdmin,aid);
	        response.sendRedirect("manage");
	 }
	 
	 @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        processRequest(request, response);
	    }

	    /**
	     * Handles the HTTP <code>POST</code> method.
	     *
	     * @param request servlet request
	     * @param response servlet response
	     * @throws ServletException if a servlet-specific error occurs
	     * @throws IOException if an I/O error occurs
	     */
	    @Override
	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        processRequest(request, response);
	    }

	    /**
	     * Returns a short description of the servlet.
	     *
	     * @return a String containing servlet description
	     */
	    @Override
	    public String getServletInfo() {
	        return "Short description";
	    }// </editor-fold>

}
