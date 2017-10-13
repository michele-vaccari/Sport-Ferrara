<%@ page info="Visualizza Giocatori" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneTorneiGuest" scope="page" class="bflows.GuestTorneiManagement" />
<jsp:setProperty name="gestioneTorneiGuest" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies=null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  int i;
  
  /* Visualizza i giocatori di una squadra */
  gestioneTorneiGuest.visualizzaGiocatori(Integer.parseInt(request.getParameter("IDSquadra")));
  
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
    
    <script src="../js/guest/listaGiocatori.js"></script>
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
                   
                   
                   <table align="center" width="600">
                    <tr>
                        <td>
                            <br><h2  class="green" align="center"> <%=request.getParameter("nomeSquadra")%> </h2><br>  
                        </td>
                        <td align="right">
                            <img class="logoSquadra" src="../Immagini/<%=request.getParameter("logoSquadra")%>" width="85" height="85" /> 
                        </td>
                    </tr>
                </table>
             
         <% if(gestioneTorneiGuest.getGiocatori().length==0)
         { %>
            <br><br>  
                <h3 align="center"> SPICENTI MA AL MOMENTO NON SONO PRESENTI GIOCATORI NELLA ROSA DELLA SQUADRA </h3>
                <br><br>
       <% } else { %>
         
                    <br><h3  align="center"> Giocatori </h3><br>
                    <table class="formazione" align="center" width="650">
                        <tr> 
                            <th width="70"></th>
                            <th align="center" width="100">Nome</th>
                            <th align="center" width="110">Cognome</th>
                            <th align="center" width="65">N°</th>
                            <th align="center" width="85">Data nascita</th>
                            <th align="center" width="150">Ruolo</th>
                        </tr>          

                    <% for (i=0;i<gestioneTorneiGuest.getGiocatori().length;i++)
                    {%>  
                        <form name="viewGiocatore<%=i%>" method="post" action="vediGiocatore.jsp">
                            <input type="hidden" name="SSNGiocatore" value="<%=gestioneTorneiGuest.getGiocatori(i).SSNGiocatore%>" />
                            <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getGiocatori(i).IDSquadra%>"/>
                            <input type="hidden" name="nomeSquadra" value="<%=request.getParameter("nomeSquadra")%>" />
                            <input type="hidden" name="logoSquadra" value="<%=request.getParameter("logoSquadra")%>" />
                            

                            <input type="hidden" name="status" value="viewGiocatore"/>
                        </form>

                            <tr>

                                <td class="giu" align="center">
                                    <img src="../Immagini/<%=gestioneTorneiGuest.getGiocatori(i).foto%>" width="60" height="60" />
                                </td>
                                <td class="giu" align="center"><b><a class="b" href="javascript:viewGiocatore(<%=i%>)"><%=gestioneTorneiGuest.getGiocatori(i).nome%></a></b></td>
                                <td class="giu" align="center"><b><a class="b" href="javascript:viewGiocatore(<%=i%>)"><%=gestioneTorneiGuest.getGiocatori(i).cognome%></a></b></td>
                                <td class="giu" align="center"><b><%=gestioneTorneiGuest.getGiocatori(i).numeroMaglia%></b> </td>
                                <td class="giu" align="center"><b><%=gestioneTorneiGuest.getGiocatori(i).dataNascita%></b></td>
                                <td class="giu" align="center"><b><%=gestioneTorneiGuest.getGiocatori(i).ruolo%></b></td>
                            </tr>
                        <%                                    
                    }%>
 
                </table>
          <% } %>          
                    
                    
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