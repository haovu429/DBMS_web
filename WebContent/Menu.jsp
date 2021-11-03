<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!--begin of menu-->





    <!-- Css Styles -->
    <link rel="stylesheet" href="header/css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="header/css/font-awesome.min.css" type="text/css">
    <link rel="stylesheet" href="header/css/elegant-icons.css" type="text/css">
    <link rel="stylesheet" href="header/css/nice-select.css" type="text/css">
    <link rel="stylesheet" href="header/css/jquery-ui.min.css" type="text/css">
    <link rel="stylesheet" href="header/css/owl.carousel.min.css" type="text/css">
    <link rel="stylesheet" href="header/css/slicknav.min.css" type="text/css">
    <link rel="stylesheet" href="header/css/style.css" type="text/css">
    
    <div class="humberger__menu__overlay"></div>
    <div class="humberger__menu__wrapper">
        <div class="humberger__menu__logo">
            <a href="home"><img src="img/logo.png" alt=""></a>
        </div>
        <div class="humberger__menu__cart">
            <ul>
                <li><a href="#"><i class="fa fa-heart"></i> <span>1</span></a></li>
                <li><a href="#"><i class="fa fa-shopping-bag"></i> <span>3</span></a></li>
            </ul>
            <div class="header__cart__price">item: <span>$150.00</span></div>
        </div>
        <div class="humberger__menu__widget">
            <div class="header__top__right__language">
                <img src="img/language.png" alt="">
                <div>English</div>
                <span class="arrow_carrot-down"></span>
                <ul>
                    <li><a href="#">Spanis</a></li>
                    <li><a href="#">English</a></li>
                </ul>
            </div>
            <div class="header__top__right__auth">
                <a href="#"><i class="fa fa-user"></i> Login</a>
            </div>
        </div>
        <nav class="humberger__menu__nav mobile-menu">
            
        </nav>
        <div id="mobile-menu-wrap"></div>
        <div class="header__top__right__social">
            <a href="#"><i class="fa fa-facebook"></i></a>
            <a href="#"><i class="fa fa-twitter"></i></a>
            <a href="#"><i class="fa fa-linkedin"></i></a>
            <a href="#"><i class="fa fa-pinterest-p"></i></a>
        </div>
        <div class="humberger__menu__contact">
            <ul>
                <li><i class="fa fa-envelope"></i> hello@colorlib.com</li>
                <li>Free Shipping for all Order of $99</li>
            </ul>
        </div>
    </div>
    <!-- Humberger End -->

    <!-- Header Section Begin -->
    <header class="header">
        <div class="header__top">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 col-md-6">
                        <div class="header__top__left">
                            <ul>
                                <li><i class="fa fa-envelope"></i> hello@colorlib.com</li>
                                <li>Free Shipping for all Order of $99</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6">
                        <div class="header__top__right">
                            <div class="header__top__right__social">
                                <a href="#"><i class="fa fa-facebook"></i></a>
                                <a href="#"><i class="fa fa-twitter"></i></a>
                                <a href="#"><i class="fa fa-linkedin"></i></a>
                                <a href="#"><i class="fa fa-pinterest-p"></i></a>
                            </div>
                            <div class="header__top__right__language">
                                <img src="img/language.png" alt="">
                                <div>English</div>
                                <span class="arrow_carrot-down"></span>
                                <ul>
                                    <li><a href="#">Spanis</a></li>
                                    <li><a href="#">English</a></li>
                                </ul>
                            </div>
                             <div class="header__top__right__auth">
                                <a href="print"><i class="fa fa-shopping-bag"></i> <span>${amout}</span></a>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-lg-3">
                    <div class="header__logo">
                        <a href="home"><img src="header/img/logo.png" alt=""></a>
                    </div>
                </div>
                <div class="col-lg-9">
                    <nav class="header__menu">
                    
               <ul >
	               <c:if test="${sessionScope.acc.isAdmin == 1}">
	                <li >
	                    <a  href="manage">Manager Account</a>
	                </li>
	                </c:if>
	                 <c:if test="${sessionScope.acc.isSell == 1}">
	                <li >
	                    <a  href="manager">Manager Product</a>
	                </li>
	                </c:if>
	                <c:if test="${sessionScope.acc !=null}">
	                <li >
	                    <a href="MyAccount.jsp">Hello ${sessionScope.acc.user}</a>
	                </li>
	                <li >
	                    <a href="Contact.jsp">Contact</a>
	                </li>
	                <li >
	                    <a  href="ChangePass.jsp">Change Password</a>
	                </li>
	            
	                <li >
	                    <a  href="logout">Logout</a>
	                </li>
	                </c:if>
	                <c:if test="${sessionScope.acc ==null}">
	                <li >
	                    <a  href="Login.jsp">Login</a>
	                </li>
	                </c:if>
            </ul>
                        
                    </nav>
                </div>
               
            </div>
            <div class="humberger__open">
                <i class="fa fa-bars"></i>
            </div>
        </div>
    </header>
    
     <section class="hero">
        <div class="container">
            <div class="row">
                
                <div class="col-lg-12">
                    <div class="hero__search">
                        <div class="hero__search__form">
                            <form action="search" method="post">
                                <div class="hero__search__categories">
                                    All Categories
                                    <span class="arrow_carrot-down"></span>
                                </div>
                                <input value="${inputValue}"  name="txt" type="text" placeholder="Search...">
                                <button type="submit" class="site-btn">SEARCH</button>
                            </form>
                        </div>
                        <div class="hero__search__phone">
                            <div class="hero__search__phone__icon">
                                <i class="fa fa-phone"></i>
                            </div>
                            <div class="hero__search__phone__text">
                                <h5>+65 11.188.888</h5>
                                <span>support 24/7 time</span>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
    </section>
     
    
    <script src="header/js/jquery-3.3.1.min.js"></script>
    <script src="header/js/bootstrap.min.js"></script>
    <script src="header/js/jquery.nice-select.min.js"></script>
    <script src="header/js/jquery-ui.min.js"></script>
    <script src="header/js/jquery.slicknav.js"></script>
    <script src="header/js/mixitup.min.js"></script>
    <script src="header/js/owl.carousel.min.js"></script>
    <script src="header/js/main.js"></script>
       


<!--end of menu-->
