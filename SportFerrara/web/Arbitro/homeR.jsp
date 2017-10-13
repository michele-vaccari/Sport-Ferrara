<%@ page info="Home Arbitro" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
%>

<!DOCTYPE html>
<html>
  <head>
      <title>SportFerrara - <%= getServletInfo() %></title>
      <meta name="author" content="Michele Vaccari"/>   
      <link href="../css/custom.css" rel="stylesheet" type="text/css">
      <link rel="icon" href="../Immagini/favicon.ico" />
      
      <script language="javascript">
        
        function insertReferto() {
          document.forms["insertFormReferto"].submit();
          return;
        }
        
      </script>

  </head>
    
    <body>
       <div id="header-container">
            <div id="header">
                <h1>SportFerrara</h1>             
            </div>
            <div id="menubar">
                    <ul id="menu">
                        
                        <li><a class="button" href="homeR.jsp">MyHOME</a></li>
                        
                         <li><a class="button" href="myReferti.jsp">REFERTI</a></li>
                                                
                        <% if (loggedOn){%>
                         <form name="logoutForm" action="../login.jsp" method="post">
                            <input type="hidden" name="status" value="logout"/>
                        </form>  
                        <li><a class="button" href="javascript:logoutForm.submit()">LOGOUT</a></li> 
                        <%}
                        else
                        {%>
                        <li><a class="button" href="login.jsp">LOGIN</a></li> 
                        <%}%>
                    </ul>
            </div>
        </div>
                        
       <div id="main">
        <div id="container">   
            
            <div id="content">    
                <table align="center">
                    <tr>
                        <td>
                            <div id="content-set">
                                <a href="javascript:insertReferto()">Nuovo<br> Referto</a>
                            </div>
                        </td>
                    </tr>                    
                </table>
                      
            </div>
            
            <form name="insertFormReferto" method="post" action="referti.jsp">
                
                <input type="hidden" name="status" value="newR"/> 
            </form>
          </div>
      </div>

  </body>     
    
</html>