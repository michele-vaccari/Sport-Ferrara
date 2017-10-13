<%@ page info="Visualizza Referti" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneReferti" scope="page" class="bflows.RefertiManagement" />
<jsp:setProperty name="gestioneReferti" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'SSN dell'amministratore */
  gestioneReferti.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  int i;
  
  /* Chiamo sempre il metodo del bean */
  gestioneReferti.refertiVisualizza();
  
  if (gestioneReferti.getResult() == -1) {
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneReferti.getResult() == -2) {
    message=gestioneReferti.getErrorMessage();
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
        for (var count = 0; count < value.length; count++) {
          if (value.charAt(count) != " ") return false;
        }
        return true;
      }
      
      function insertReferto() {
        document.forms["ArbitroFormReferto"].submit();
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
                        
                        <li><a class="button" href="homeA.jsp">MyHOME</a></li>
                        
                        <li><a class="button" href="tornei.jsp">TORNEI</a></li>
                        
                        <li><a class="button" href="utenti.jsp">UTENTI</a></li>
                        
                        <li><a class="button" href="refertiView.jsp">REFERTI</a></li>
                        
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
               <div id="content"> 
               
                   <br>
                   <h3 class="green" align="center"> Lista assegnazioni già effetuate</h3>
                   <br>
                   
                   <table class="calendario" align="center" width="1100">
                        <tr> 
                            <th class="calendario" align="center">Torneo</th>
                            <th class="calendario" align="center">Partita</th>
                            <th class="calendario" align="center">Data</th>
                            <th class="calendario" align="center">Luogo</th>
                            <th class="calendario" align="center">Risultato</th>
                            <th class="calendario" align="center">Arbitro</th>
                            <th class="calendario" align="center">Info</th>
                        </tr>
                        
                       <% for(i=0; i<gestioneReferti.getReferti().length; i++)
                        { %>
                            
                                <tr>
                                <% if(gestioneReferti.getReferti(i).flagReferto.equals("N"))
                                   { %>
                                        <td class="red" align="center"> <%=gestioneReferti.getReferti(i).nomeTorneo%> </td>
                                        <td class="red" align="center"> <%=gestioneReferti.getNomeSquadraCasa(i)%> - <%=gestioneReferti.getNomeSquadraOspite(i)%> </td>
                                        <td class="red" align="center"> <%=gestioneReferti.getReferti(i).data%> </td>
                                        <td class="red" align="center"> <%=gestioneReferti.getReferti(i).luogo%> </td>
                                        <td class="red" align="center"> <%=gestioneReferti.getReferti(i).risultato%> </td>
                                        <td class="red" align="center"> <%=gestioneReferti.getReferti(i).nomeArbitro%> <%=gestioneReferti.getReferti(i).cognomeArbitro%> </td> 

                                        <td class="red" align="center"> NON COMPILATO</td>
                                <% }
                                   else
                                   { %>
                                        <td class="giu" align="center"> <%=gestioneReferti.getReferti(i).nomeTorneo%> </td>
                                        <td class="giu" align="center"> <%=gestioneReferti.getNomeSquadraCasa(i)%> - <%=gestioneReferti.getNomeSquadraOspite(i)%> </td>
                                        <td class="giu" align="center"> <%=gestioneReferti.getReferti(i).data%> </td>
                                        <td class="giu" align="center"> <%=gestioneReferti.getReferti(i).luogo%> </td>
                                        <td class="giu" align="center"> <%=gestioneReferti.getReferti(i).risultato%> </td>
                                        <td class="giu" align="center"> <%=gestioneReferti.getReferti(i).nomeArbitro%> <%=gestioneReferti.getReferti(i).cognomeArbitro%> </td>   

                                        <td class="giu" align="center">COMPILATO</td>       
                                <% } %>
                                </tr>
                       <% } %>
                       
                   </table>
 
                    <br><br>
                    <div align="center">
                        <input type="button" value="Assegna Arbitro a Partita" onClick="insertReferto()"/>
                    </div>
                    <form name="ArbitroFormReferto" method="post" action="newReferto.jsp">
                        <input type="hidden" name="status" value="new"/>
                    </form>  
                    
               </div>
           </div>
       </div>
    </body>
</html>