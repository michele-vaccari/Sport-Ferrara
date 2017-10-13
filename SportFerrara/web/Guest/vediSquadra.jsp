<%@ page info="Visualizza Squadra" %>
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
  
  gestioneTorneiGuest.visualizzaSquadra(Integer.parseInt(IDSquadra));
  
  /* Gestione degli errori */
  if (gestioneTorneiGuest.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneTorneiGuest.getResult() == -2) {
    message=gestioneTorneiGuest.getErrorMessage();
  }
%>

<!DOCTYPE html>
<html>
  
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
    
    <script src="../js/guest/vediSquadra.js"></script>
  </head>
    
    <body>
        
        <form name="viewRosaSquadra" action="listaGiocatori.jsp" method="post">
             <input type="hidden" name="IDSquadra" value="<%=request.getParameter("IDSquadra")%>"/>
             <input type="hidden" name="nomeSquadra" value="<%=gestioneTorneiGuest.getSquadra().nomeSquadra%>"/>
             <input type="hidden" name="logoSquadra" value="<%=gestioneTorneiGuest.getSquadra().logoSquadra%>"/>
             
             <input type="hidden" name="status" value="view"/>
        </form>
             
        <form name="viewTorneiCorso" action="listaTornei.jsp" method="post">
             <input type="hidden" name="IDSquadra" value="<%=request.getParameter("IDSquadra")%>"/>
             
             <input type="hidden" name="status" value="squadra"/>
        </form>
             
           
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
                   
                   
                   <table align="center" width="600">
                    <tr>
                        <td>
                            <br><h2  class="green" align="center"> <%=gestioneTorneiGuest.getSquadra().nomeSquadra%> </h2><br>  
                        </td>
                        <td align="right">
                            <img class="logoSquadra" src="../Immagini/<%=gestioneTorneiGuest.getSquadra().logoSquadra%>" width="85" height="85" /> 
                        </td>
                    </tr>
                </table><br>

                    <div align="center" >
                        <img src="../Immagini/<%=gestioneTorneiGuest.getSquadra().immagineSquadra%>" width="800" height="450"/>
                    </div>
                    <br>
                    



                    <div align="center">
                       <br>
                       <h4 class="green"> Sede attuale: <%=gestioneTorneiGuest.getSquadra().sede%></h4><br>
                       <h5> <%=gestioneTorneiGuest.getSquadra().descrizione%> </h5>
                   </div>
                   <br><br>
                    <table align="center" width="800">
                        <tr>
                            <td  align="center" width="300">
                                <br><br><h4 class="green"> Sponsor Ufficiale</h4><br> <h3><%=gestioneTorneiGuest.getSquadra().nomeSponsor%> </h3><br><br>
                            </td>    
                            <td  align="center">
                                <img class="logoSponsor" src="../Immagini/<%=gestioneTorneiGuest.getSquadra().logoSponsor%>" width="350" height="150" />
                            </td>
                        </tr>
                    </table>
                    <br>        
                    <table align="center">
                        <tr>
                            <td>
                                <input type="button" value="Indietro" Indietro onClick="javascript:history.back()" />
                            </td>
                            <td>
                                <input type="button" value="Visualizza Rosa" onClick="viewRosa()"/>
                            </td>
                            <td>
                                <input type="button" value="Tornei in corso" onClick="viewTornei()"/>
                            </td>

                        </tr>
                    </table>
                    
                <table align="center" width="650"></table>
                    
               </div>
           </div>
       </div>
    </body>
</html>