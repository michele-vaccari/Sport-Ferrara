<%@ page info="Visualizza Giocatore" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneTorneiGuest" scope="page" class="bflows.GuestTorneiManagement" />
<jsp:setProperty name="gestioneTorneiGuest" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Variabili ausiliarie */
  String message = null;
  String SSNGiocatore = request.getParameter("SSNGiocatore");
  int i;
  
  gestioneTorneiGuest.visualizzaGiocatore(Integer.parseInt(SSNGiocatore));
  
  /* Gestione degli errori */
  if (gestioneTorneiGuest.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneTorneiGuest.getResult() == -2) {
    message = gestioneTorneiGuest.getErrorMessage();
  }  
%>

<!DOCTYPE html>
<html>
  
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
  </head>
    
    <body>
        
           <div id="header-container">
            <div id="header">
                <h1>SportFerrara</h1>             
            </div>
            <div id="menubar">
              <ul id="menu">

                  <li><a class="button" href="../home.jsp">HOME</a></li>

                  <li><a class="button" href="listaTornei.jsp">TORNEI</a></li>

                  <li><a class="button" href="listaSquadre.jsp">SQUADRE</a></li>

                   <%if (loggedOn){%>
                   <form name="logoutForm" action="../login.jsp" method="post">
                      <input type="hidden" name="status" value="logout"/>
                  </form>  
                  <li><a class="button" href="javascript:logoutForm.submit()">LOGOUT</a></li> 
                  <%}
                  else
                  {%>
                  <li><a class="button" href="../login.jsp">LOGIN</a></li> 
                  <%}%>
              </ul>
            </div>
        </div>
                        
       <div id="main">
           <div id="container">  
               <div id="content"> 
                   
                   
                   <table width="700" align="center">
                       <tr>
                           <td with="100"></td>
                            <td with="600">
                                <br><h2  class="green"> <%=gestioneTorneiGuest.getGiocatore().nome%> <%=gestioneTorneiGuest.getGiocatore().cognome%> </h2><br>  
                            </td>
                            <td align="right" with="100" >
                                <img class="logoSquadra" src="../Immagini/<%=gestioneTorneiGuest.getGiocatore().foto%>" width="140" height="150" /> 
                            </td>
                        </tr>
                </table>

                
                    
                    
                    &nbsp Nazionalità: <b><%=gestioneTorneiGuest.getGiocatore().nazionalità%></b><br>
                    &nbsp&nbsp Data di nascita: <b><%=gestioneTorneiGuest.getGiocatore().dataNascita%></b><br><br>

                    &nbsp Numero maglia: <b><%=gestioneTorneiGuest.getGiocatore().numeroMaglia%></b><br>
                    &nbsp&nbsp Ruolo: <b><%=gestioneTorneiGuest.getGiocatore().ruolo%></b><br><br>
                    &nbsp Caratteristiche tecniche:
                   
                    <table width="675">
                        <tr >
                            <td width="20"> </td>
                            <td>
                                <h6 ><%=gestioneTorneiGuest.getGiocatore().descrizione%> </h6>
                            </td>
                        </tr> 
                    </table>
                    <br>
                    
                    
                    &nbsp Nella squadra <b><%=request.getParameter("nomeSquadra")%></b>, stagione 2016/2017 <br><br>
                    &nbsp&nbsp Goal segnati: <b><%=gestioneTorneiGuest.getGiocatore().goal%></b><br>
                    &nbsp&nbsp Ammonizioni: <b><%=gestioneTorneiGuest.getGiocatore().ammonizioni%></b><br>
                    &nbsp&nbsp Espulsioni: <b><%=gestioneTorneiGuest.getGiocatore().espulsioni%></b><br>
               
                       
                    <br>               
                    <br>        
                    <table align="center">
                        <tr>
                            <td>
                                <input type="button" value="Indietro" Indietro onClick="javascript:history.back()" />
                            </td>
                        </tr>
                    </table>
                    
                <table align="center" width="650"></table>
                    
               </div>
           </div>
       </div>
    </body>
</html>