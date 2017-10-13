<%@ page info="Home Gestore" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneSquadre" scope="page" class="bflows.SquadraManagement" />
<jsp:setProperty name="gestioneSquadre" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies=null;
  cookies=request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'SSN del gestore della squadra nel bean */
  gestioneSquadre.setGestore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  
  /* Visualizzo semprela squadra */
  gestioneSquadre.visualizzaSquadra();
  
  /* Gestione degli errori */
  if (gestioneSquadre.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneSquadre.getResult() == -2) {
    message=gestioneSquadre.getErrorMessage();
  }
%>

<!DOCTYPE html>
<html>
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
    
    <script language="javascript">
      
      function isEmpty(value) {
        if (value == null || value.length == 0)
            return true;
        for (var count = 0; count < value.length; count++)
        {
            if (value.charAt(count) != " ") return false;
        }
        return true;
      }

      function submitLogin() {
        if (isEmpty(logonForm.email.value)) {
          alert("email mancante");
            return;
        }         
        if (isEmpty(logonForm.password.value)) {
          alert("Password mancante");
            return;
        }      
        logonForm.submit();
      }

      function submitLoginGuest() {
        logonGuest.submit();
      }

      function updateSquadra() {
        document.forms["updateFormSquadra"].submit();
        return;
      }

      function insertGiocatore() {
        document.forms["insertFormGiocatore"].submit();
        return;
      }

      function insertFormazione() {
        document.forms["insertFormFormazione"].submit();
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
                        
                        <li><a class="button" href="homeG.jsp">MyHOME</a></li>

                        <li><a class="button" href="giocatori.jsp">GIOCATORI</a></li>
                        
                        <li><a class="button" href="newFormazione.jsp">FORMAZIONI</a></li>
                        
                        <li><a class="button" href="javascript:updateSquadra()">SQUADRA</a></li>
                                                
                        <%if (loggedOn){%>
                        <form name="logoutForm" action="../login.jsp" method="post"> <!-- form nascosta, non in get perchè è brutto in quanto è meglio il metodo post-->
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
            
           <% if ((gestioneSquadre.getSquadra().flag).equals("N"))
                { %>
   
            <div id="content"> 
                
                <br>
                <h4 align="center">
                    Gentile <%=Session.getUserNome(cookies)%> <%=Session.getUserCognome(cookies)%> 
                    sei stao aggiunto recentemente da un amministratore, devi compilare i seguenti campi 
                    per poter navigare nel sito come gestore della squadra! <br><br>
                    Squadra gestita: <%=gestioneSquadre.getSquadra().nomeSquadra%> <br><br>
                </h4>
                
                <table align="center">
                    <tr>
                        <td>
                            <div id="content-set">
                                <a href="javascript:updateSquadra()">COMPILA LA TUA SQUADRA</a>
                            </div>
                        </td>
                    </tr>
                </table>
                
                <form name="updateFormSquadra" method="post" action="squadre.jsp">
                    <input type="hidden" name="status" value="view"/> 
                    <input type="hidden" name="flag" value="N"/>
                </form>

                
               <% }
           else {%>
            
            <div id="content">    
                <table align="center">
                    <tr>
                        <td>
                            <div id="content-set">
                                <a href="javascript:updateSquadra()"> Visualizza<br> Squadra</a>
                            </div>
                        </td>
                    </tr>
                </table>
                <table align="center">
                    <tr>
                        <td>
                            <div id="content-set">
                                <a href="javascript:insertGiocatore()">Nuovo<br> Giocatore</a>
                            </div>
                        </td>
                        <td>
                            <div id="content-set">
                                <a href="javascript:insertFormazione()">Nuova<br> Formazione</a>
                            </div>                       
                        </td>
                    </tr>                    
                </table>
                
                <form name="updateFormSquadra" method="post" action="squadre.jsp">
                    <input type="hidden" name="status" value="view"/> 
                    <input type="hidden" name="flag" value="Y"/>
                </form>
                
                <form name="insertFormGiocatore" method="post" action="dettagliGiocatore.jsp">
                    <input type="hidden" name="SSNGiocatore" value=""/>
                    <input type="hidden" name="nome" value=""/>
                    <input type="hidden" name="cognome" value=""/>
                    <input type="hidden" name="dataNascita" value=""/>
                    <input type="hidden" name="nazionalità" value=""/>
                    <input type="hidden" name="ruolo" value=""/>
                    <input type="hidden" name="numeroMaglia" value=""/>
                    <input type="hidden" name="foto" value=""/>
                    <input type="hidden" name="descrizione" value=""/>
                    <input type="hidden" name="IDSquadra" value=""/>

                    <input type="hidden" name="status" value="newGiocatore"/>
                </form>
                
           <% } %> 
           
            <form name="insertFormFormazione" method="post" action="newFormazione.jsp">
              
                <input type="hidden" name="status" value="view"/>
            </form>
       </div>
    </div>
  </div>
 </div>
</body>     
    
</html>