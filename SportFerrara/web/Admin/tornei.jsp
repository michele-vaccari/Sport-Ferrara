<%@ page info="Visualizza Tornei" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneTornei" scope="page" class="bflows.TorneiManagement" />
<jsp:setProperty name="gestioneTornei" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto il creatore del torneo */
  gestioneTornei.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  int i;
  
  /* Metodo del bean */
  gestioneTornei.visualizzaTornei();
  
  if (gestioneTornei.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneTornei.getResult() == -2) {
    message = gestioneTornei.getErrorMessage();
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

    function NewTorneoI() {
      f = document.TorneoItaliana;
      f.submit();
      return;
    }

    function NewTorneoE() {
      f = document.TorneoEliminazione;
      f.submit();
      return;
    }

    function viewTorneo(index) {
      f = document.forms["viewForm"+index];
      f.submit();
      return;
    }

    </script>
        
        
  </head>
    
    <body>
   
        <form name="TorneoItaliana" method="post" action="newTorneo.jsp">
                <input type="hidden" name="tipologia" value="I"/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="numeroSquadre" value=""/>
                <input type="hidden" name="descrizione" value=""/>
                
                <input type="hidden" name="status" value="newI"/>
            </form>
            
            <form name="TorneoEliminazione" method="post" action="newTorneo.jsp">
                <input type="hidden" name="tipologia" value="E"/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="descrizione" value=""/>
                
                <input type="hidden" name="status" value="newE"/>
            </form>
        
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
                   
                   
                   <h4 align="center"> Qui puoi CREARE o VISUALIZZARE tornei:</h4>
                    <br>
                    
                        <table align="center">
                            <tr>
                                <td>
                                   <input type="button" value="Nuovo Torneo Italiana" onclick="NewTorneoI()"/>
                                </td>
                                <td>
                                   <input type="button" value="Nuovo Torneo Eliminazione" onclick="NewTorneoE()"/>
                                </td>
                            </tr>
                        </table>                        

                   <br>
                
                <table class="calendario" align="center" width="750">
                        <tr>
                            <th class="calendario" width="530">Nome del Torneo</th>
                            <th class="calendario" width="220">Tipologia</th> 
                        </tr>
                        
                        <%for (i=0; i<gestioneTornei.getTornei().length; i++)
                        {%>
                            <form name="viewForm<%=i%>" method="post" action="dettagliTorneo.jsp">
                                <input type="hidden" name="nome" value="<%=(gestioneTornei.getTornei(i)).nome%>"/>
                                <input type="hidden" name="IDTorneo" value="<%=(gestioneTornei.getTornei(i)).IDTorneo%>"/>
                                <input type="hidden" name="descrizione" value="<%=(gestioneTornei.getTornei(i)).descrizione%>"/>
                                <input type="hidden" name="tipologia" value="<%=(gestioneTornei.getTornei(i)).tipologia%>"/>
                                
                                <input type="hidden" name="status" value="AdminView"/>
                            </form>
                           
                                <tr>
                                    
                                    <% if((gestioneTornei.getTornei(i).tipologia).equals("I"))
                                        { %>
                                        <td class="giu" align="center"><a href="javascript:viewTorneo(<%=i%>)"><%=gestioneTornei.getTornei(i).nome%></a></td>
                                        <td class="giu" align="center"> ITALIANA </td>
                                        <% } else { %>
                                        <td class="su" align="center"><a href="javascript:viewTorneo(<%=i%>)"><%=gestioneTornei.getTornei(i).nome%></a></td>
                                        <td class="su" align="center"> ELIMINAZIONE </td>
                                        <% } %> 
                                </tr>
                        
                     <% }%>
                    </table>
                    
                    
                <table align="center" width="650"></table>         
                    
               </div>
           </div>
       </div>
    </body>
</html>