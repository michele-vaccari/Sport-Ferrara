<%@ page info="Home Page" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="/ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>


<jsp:useBean id="Login" scope="page" class="bflows.LoginManagement" />
<jsp:setProperty name="Login" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  
  cookies = request.getCookies();
  
  /* Se ho dei cookie sono loggato */
  boolean loggedOn = (cookies != null); //se ci sono dei cookies sono loggato, metodo molto semplice, non si capisce che tipo di utente sono.
  
%>

<!DOCTYPE html>
<html>
  
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>
    <link href="css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="Immagini/favicon.ico" />
  </head>
  
  <body>
    
    <div id="header-container">
      
      <div id="header">
          <h1>SportFerrara</h1>             
      </div>
      
      <div id="menubar">
        <ul id="menu">
            <% if (loggedOn) {
                 if((Session.getType(cookies)).equals("A")) { %>
                    <li><a class="button" href="Admin/homeA.jsp">MyHOME</a></li>
            <% } if((Session.getType(cookies)).equals("R")) { %>
                    <li><a class="button" href="Arbitro/homeR.jsp">MyHOME</a></li>
            <% } if(Session.getType(cookies).equals("G")) { %>
                    <li><a class="button" href="Gestore/homeG.jsp">MyHOME</a></li>
            <% } } else { %>
                    <li><a class="button" href="home.jsp">HOME</a></li>
            <% } %>
            <li><a class="button" href="Guest/listaTornei.jsp">TORNEI</a></li>
            <li><a class="button" href="Guest/listaSquadre.jsp">SQUADRE</a></li>
            
            <% if (loggedOn){ %>
              <form name="logoutForm" action="login.jsp" method="post">
                <input type="hidden" name="status" value="logout"/>
              </form>
              <li><a class="button" href="javascript:logoutForm.submit()">LOGOUT</a></li> 
            <% } else { %>
              <li><a class="button" href="login.jsp">LOGIN</a></li> 
            <% } %>
        </ul>
      </div>
    </div>
        
    <div id="container">
      <div id="content">
          <h3 class="green" align="center">BENVENUTO in SportFerrara</h3>
          <br>
          <table align="center" width="550">
              <tr>
                  <td valign="baseline">
                      <h5 align="center" >
                        Puoi utilizzare l'applicazione web in due modalità:<br> <b>UTENTE OSPITE</b> e <b>UTENTE REGISTRATO</b>.
                        <br><br>
                        <div style="text-align: left;">
                        Se sei un <b>UTENTE OSPITE</b> puoi:
                          <ul>
                            <li>visionare i dati di tutte le squadre registrate;</li>
                            <li>vedere i risultati delle squadre nei vari tornei;</li>
                            <li>visionare, per ogni squadra, i dati dei giocatori.</li>
                          </ul>
                        </div>
                        <br>
                        <div style="text-align: left;">
                        Se sei un <b>UTENTE REGISTRATO</b> puoi autenticarti inserendo le tue credenziali sulla pagina di LOGIN.
                        <br><br>
                        </div>
                        Buona permanenza! <br><b>Michele Vaccari</b>
                      </h5>
                  </td>
              </tr>
          </table>
      </div>
    </div>

  </body>
</html>