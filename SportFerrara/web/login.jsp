<%@ page info="Login" %>
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
  
  boolean loggedOn = (cookies != null);
  
  /* Variabili ausiliarie */
  int i;
  String message = null;
  String status;
  
  /* Leggo lo stato */
  
  /* Default status = view */
  status=request.getParameter("status");
  if (status==null) status = "view";
  
  /* Status = logon */
  if (status.equals("logon")) {
    
    /* Chiamata al metodo del bean */
    Login.logon();
    
    if (Login.getCookies() != null) {
      for( i = 0; i < Login.getCookies().length; i++)
        response.addCookie(Login.getCookies(i));
      
      cookies = Login.getCookies();
      loggedOn = true;       
    }
  }
  
  /* Status = logout */
  if (status.equals("logout")) {
    
    if (loggedOn) {
      
      Login.setCookies(cookies);
      
      /* Chiamata al metodo del bean */
      Login.logout();
      
      for( i = 0; i < Login.getCookies().length; i++)
        response.addCookie(Login.getCookies(i));
      loggedOn = false;
    }
  }
  
  if (Login.getResult()==-1){    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } else if (Login.getResult()==-2) {
    message=Login.getErrorMessage();
  }

%>


<!DOCTYPE html>
<html>
  
  <head>
      <title>SportFerrara - <%= getServletInfo() %></title>
      <meta name="author" content="Michele Vaccari"/>
      <link href="css/custom.css" rel="stylesheet" type="text/css">
      <link href="css/jAlert.css" rel="stylesheet" type="text/css">
      <link rel="icon" href="Immagini/favicon.ico" />

      <script src="js/dist/jquery-1.11.3.min.js"></script>
      <script src="js/dist/jAlert.js"></script>
      <script src="js/dist/jAlert-functions.js"></script>

      <script src="js/login.js"></script>
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
              <li><a class="button" href="Guest/listaTornei.jsp">TORNEI</a></li>
              <li><a class="button" href="Guest/listaSquadre.jsp">SQUADRE</a></li>
          <% } %>
          
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

    <div id="main">
       <div id="container">
        <%if (loggedOn) { %>
          <div id="content">  
            <h3 class="green" align="center"><%=Session.getUserNome(cookies)%> <%=Session.getUserCognome(cookies)%> </h3><br>
            <% if((Session.getType(cookies)).equals("A")){%>
              <h4 align="center">Ora puoi navigare nel sito come <b>AMMINISTRATORE</b>. <br><br>Clicca su MyHome per procedere.<br> </h4>
            <%} if((Session.getType(cookies)).equals("R")) {%>
              <h4 align="center">Ora puoi navigare nel sito come <b>ARBITRO</b>. <br><br>Clicca su MyHome per procedere.</h4>
            <%} if(Session.getType(cookies).equals("G")) {%>
              <h4 align="center">Ora puoi navigare nel sito come <br><b>GESTORE SQUADRA</b>. <br><br>Clicca su MyHome per procedere.</h4>
            <% } %>
          </div>
        <% } else { %>
            <div id="content">
              <h4 class="green" align="center"> Compila i campi per accedere alla tua pagina: </h4><br>
              <form name="logonForm" action="login.jsp" method="post">
                <table align="center" width="330">
                  <tr>
                    <td width="120">E-mail</td>
                    <td width="100">
                      <input type="text" name="email" size="25" maxlength="50"/>
                    </td>
                  </tr>
                  <tr>
                    <td width="120">Password</td>
                    <td width="100">
                      <input type="password" name="password" size="25" maxlength="50"/>
                    </td>
                  </tr>
                  </table><br>
                <table align="center">
                  <tr>
                    <td width="300">
                      <input type="button" value="Accedi" onClick="submitLogin()"/>
                    </td>
                  </tr>
                </table>
                <input type="hidden" name="status" value="logon"/> 
              </form>
            </div>
         <% } %>       
     </div> 
    </div>

    <% if (message!=null) { %>
      <script>
        $(document).ready(function () {
          $.jAlert({
            'title': 'Errore!',
            'content': '<%=message%>',
            'theme': 'green'
          });
        });
      </script>
    <% } %>

    </body>
</html>