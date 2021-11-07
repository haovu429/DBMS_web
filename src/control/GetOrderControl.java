package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DAO;
import entity.Account;
import entity.Category;
import entity.Order;
import entity.Product;

@WebServlet(name = "GetOrderControl", urlPatterns = {"/getorder"})
public class GetOrderControl extends HttpServlet {

	private static final long serialVersionUID = 1L;
	 protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        response.setContentType("text/html;charset=UTF-8");
	  
	     
	        
	        Cookie arr[] = request.getCookies();
	        PrintWriter out = response.getWriter();
	        List<Product> list = new ArrayList<>();
	        DAO dao = new DAO();
	        for (Cookie o : arr) {
	            if (o.getName().equals("id")) {
	                String txt[] = o.getValue().split("#");
	                for (String s : txt) {
	                    list.add(dao.getProduct(s));
	                }
	            }
	        }
	        for (Product s : list) {
	        	System.out.println("Product: " + s);
	        }
	        for (int i = 0; i < list.size(); i++) {
	            int count = 1;
	            for (int j = i+1; j < list.size(); j++) {
	                if(list.get(i).getId() == list.get(j).getId()){
	                    count++;
	                    list.remove(j);
	                    j--;
	                    list.get(i).setAmount(count);
	                }
	            }
	        }
	        HttpSession session = request.getSession();
	        Account a = (Account) session.getAttribute("acc");
	        int uid = a.getUid();
	        
	       dao.saveOrder(String.valueOf(uid) , list);
	       Order order = new Order();
	       order = dao.getLastOrder();
	       request.setAttribute("order", order);
	       request.setAttribute("lst", list);
	       
	       for (Cookie o : arr) {
	            o.setMaxAge(0);
	            response.addCookie(o);
	        }
	        
	       
	       
	       
	        
	        request.getRequestDispatcher("DetailOrder.jsp").forward(request, response);
	        
	     
	        
	       
	        
	        
	        

	        
	        
	     
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
