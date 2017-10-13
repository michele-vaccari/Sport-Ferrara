<%@ page info="Visualizza Squadre" %>
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
  int i;
  
  /* Visualizza squadre */
  gestioneTorneiGuest.visualizzaSquadre();
  
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

    <script src="../js/guest/listaSquadre.js"></script>
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
                     
                   
                <table class="calendario" align="center" width="850">
                        <tr>
                            <th class="calendario" width="75">Logo</th>
                            <th class="calendario" width="140">Nome</th>
                            <th class="calendario" width="140">Sede</th> 
                            <th class="calendario" width="80"></th>
                            <th class="calendario" width="80">Opzioni</th>
                            <th class="calendario" width="80"></th>    
                        </tr>
                        
                        <%for (i=0; i<gestioneTorneiGuest.getSquadre().length; i++)
                        {%>
                            <form name="viewForm<%=i%>" method="post" action="vediSquadra.jsp">
                                <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getSquadre(i).ID_Squadra%>"/>
                                
                                
                                <input type="hidden" name="vista" value="view"/>
                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                            <form name="viewFormRosa<%=i%>" method="post" action="listaGiocatori.jsp">
                                <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getSquadre(i).ID_Squadra%>"/>
                                <input type="hidden" name="nomeSquadra" value="<%=gestioneTorneiGuest.getSquadre(i).nomeSquadra%>"/>
                                <input type="hidden" name="logoSquadra" value="<%=gestioneTorneiGuest.getSquadre(i).logoSquadra%>"/>

                                <input type="hidden" name="status" value="view"/>
                           </form> 
                                
                           <form name="viewFormTornei<%=i%>" method="post" action="listaTornei.jsp">
                                <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getSquadre(i).ID_Squadra%>"/>
                               
                                <input type="hidden" name="status" value="squadra"/>
                           </form>
                                
                           
                                <tr>
                                    <td class="giu" align="center" with="80" >
                                        <img src="../Immagini/<%=gestioneTorneiGuest.getSquadre(i).logoSquadra%>" width="70" height="70" /> 
                                    </td>
                                    <td class="giu" align="center"><a href="javascript:viewSquadra(<%=i%>)"><%=gestioneTorneiGuest.getSquadre(i).nomeSquadra%></a></td>
                                    <td class="giu" align="center"><%=gestioneTorneiGuest.getSquadre(i).sede%></td>
                                    <td class="su" align="center"> <input type="button" value="Dettagli" onClick="viewSquadra(<%=i%>)"/></td>
                                    <td class="su" align="center"> <input type="button" value="Rosa" onClick="viewRosa(<%=i%>)"/></td>
                                    <td class="su" align="center"> <input type="button" value="Tornei" onClick="viewTornei(<%=i%>)"/></td>
                                </tr>
                        
                      <%}%>
                    </table>
                           
                <table align="center" width="650"></table>
                    
               </div>
           </div>
       </div>
    </body>
</html>