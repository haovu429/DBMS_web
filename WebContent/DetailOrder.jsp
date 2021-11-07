
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Bootstrap CRUD Data Table for Database with Modal Form</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
</head>

<body>

 <div class="offset-xl-2 col-xl-8 col-lg-12 col-md-12 col-sm-12 col-12 padding">
     <div class="card">
         <div class="card-header p-4">
            
             <div class="float-right">
                 <h3 class="mb-0">ORDER</h3>
                 
             </div>
         </div>
         <div class="card-body">
             <div class="row mb-4">
                 <div class="col-sm-6">
                     <h5 class="mb-3">From:</h5>
                     <h3 class="text-dark mb-1">Group 5 Shop</h3>
                     <div>484 Lê Văn Việt, Phường Tăng Nhơn Phú A, Quận 9, Thành Phố HCM</div>
             
                     <div>Email: g5@gmail.com</div>
                     <div>Phone: +91 9897 989 989</div>
                 </div>
                 <div class="col-sm-6 ">
                     <h5 class="mb-3">To:</h5>
                     <h3 class="text-dark mb-1"> ${acc.user}</h3>
          
                     <div>Address: ${order.getAddress() }</div>
                     <div>Email: ${order.getEmail()}</div>
                     <div>State: ${order.getStatus()}</div>
                     <div>Phone: ${order.getPhone() }</div>
                 </div>
             </div>
             <div class="table-responsive-sm">
                 <table class="table table-striped">
                     <thead>
                         <tr>
                             <th class="center">ID</th>
                             <th>Item</th>
                            
                             <th class="right">Price</th>
                             <th class="center">Quantity</th>
                            
                         </tr>
                     </thead>
                     <tbody>
                     <c:forEach items="${lst}" var="o">
                         <tr>
                             <td class="center">${o.id }</td>
                             <td class="left strong">${o.name }</td>
                             
                             <td class="right">${o.price}</td>
                              <td class="center">${o.amount }</td>
                              
                         </tr>
                       
                         </c:forEach>
                     </tbody>
                 </table>
             </div>
             <div class="row">
                 <div class="col-lg-4 col-sm-5">
                 </div>
                 <div class="col-lg-4 col-sm-5 ml-auto">
                     <table class="table table-clear">
                         <tbody>
                         
                              <tr>
                                
                             <tr>
                                 <td class="left">
                                     <strong class="text-dark">Total</strong> </td>
                                 <td class="right">
                                     <strong class="text-dark">${order.getTotalMoney() } vnđ</strong>
                                 </td>
                             </tr>
                         </tbody>
                     </table>
                 </div>
             </div>
         </div>
            <a href="home"><button type="button" class="btn btn-primary">Back to home</button></a>
            <hr></hr>
     </div>
 </div>
 </body>
</html>