<%@ page info="Visualizza Tornei" %>
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
  String IDSquadra = request.getParameter("IDSquadra");
  int i;
  
  /* Leggo lo stato */
  String status = request.getParameter("status");
  
  /* Leggo lo stato */
  if (status == null)
    status = "view";
  
  /* status = squadra */
  if (status.equals("squadra"))
    gestioneTorneiGuest.visualizzaTorneo(Integer.parseInt(IDSquadra));
  
  /* status = view */
  if (status.equals("view"))
    gestioneTorneiGuest.visualizzaTornei();
  
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

    <script src="../js/guest/listaTornei.js"></script>
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
 
                   
                <table class="calendario" align="center" width="750">
                        <tr>
                            <th class="calendario" width="530">Nome del Torneo</th>
                            <th class="calendario" width="220">Tipologia</th> 
                        </tr>
                        
                        <%for (i=0; i<gestioneTorneiGuest.getTornei().length; i++)
                        {%>
                            <form name="viewForm<%=i%>" method="post" action="vediTorneo.jsp">
                                <input type="hidden" name="nome" value="<%=(gestioneTorneiGuest.getTornei(i)).nome%>"/>
                                <input type="hidden" name="IDTorneo" value="<%=(gestioneTorneiGuest.getTornei(i)).IDTorneo%>"/>
                                <input type="hidden" name="descrizione" value="<%=(gestioneTorneiGuest.getTornei(i)).descrizione%>"/>
                                <input type="hidden" name="tipologia" value="<%=(gestioneTorneiGuest.getTornei(i)).tipologia%>"/>
                                
                                <input type="hidden" name="status" value="AdminView"/>
                            </form>
                           
                                <tr>
                                    
                                    <% if((gestioneTorneiGuest.getTornei(i).tipologia).equals("I"))
                                        { %>
                                        <td class="giu" align="center"><a href="javascript:viewTorneo(<%=i%>)"><%=gestioneTorneiGuest.getTornei(i).nome%></a></td>
                                        <td class="giu" align="center"> ITALIANA </td>
                                        <% } else { %>
                                        <td class="su" align="center"><a href="javascript:viewTorneo(<%=i%>)"><%=gestioneTorneiGuest.getTornei(i).nome%></a></td>
                                        <td class="su" align="center"> ELIMINAZIONE </td>
                                        <% } %> 
                                </tr>
                        
                     <% }%>
                    </table>
                    
                    
                   <% if (status.equals("squadra"))
                   { %>
                    <br>
                    <table align="center">
                      <tr>
                          <td>
                              <input type="button" value="Indietro" onclick="javascript:history.go(-1)"/>
                          </td>
                      </tr>
                    </table>                 
                  <% } %>
                          
                <table align="center" width="650"></table>
                    
               </div>
           </div>
       </div>
    </body>
</html>