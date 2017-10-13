<%@ page info="Modulo Referto" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneRefertiArbitro" scope="page" class="bflows.ArbitroRefertiManagement" />
<jsp:setProperty name="gestioneRefertiArbitro" property="*" />

<%
  /* Gestione della sessione*/
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'SSN dell'arbitro nel bean */
  gestioneRefertiArbitro.setSSNArbitro(Integer.parseInt(Session.getSSN(cookies)));
  
  /* Variabili ausiliarie */
  String message = null;
  String status; 
  int i;
  
  /* Leggo lo status */
  status = request.getParameter("status");
  
  /* status = insert */  
  if (status.equals("insert"))
    gestioneRefertiArbitro.compilaReferto();
  
  /* status = view */
  if (status.equals("newR"))
    gestioneRefertiArbitro.visualizzaRefertiArbitro();
  
  /* status = newReferto */
  if (status.equals("newReferto"))
    gestioneRefertiArbitro.inserisciRefertoVisualizza();
  
  /* Variabili ausiliarie */
  if (gestioneRefertiArbitro.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneRefertiArbitro.getResult() == -2) {
    message = gestioneRefertiArbitro.getErrorMessage();
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
      
      function insertReferto(index) {
        f = document.forms["insertForm"+index];
        f.submit();
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

               <li><a class="button" href="homeR.jsp">MyHOME</a></li>

               <li><a class="button" href="myReferti.jsp">REFERTI</a></li>

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
                   
                   
                   <h3 class="green" align="center"> Qui puoi COMPILARE il referto per una determinata partita</h3><br>
                   
                   <% if(gestioneRefertiArbitro.getReferti().length!=0)
                        { %>
                   
                   <h4 align="center"> Premi su SCEGLI per procedere con la redazione</h4>
                   <br><br>
                                      
                   <table class="calendario" align="center" width="900">
                        <tr>
                            <th>ID Referto</th>
                            <th>Nome del Torneo</th>
                            <th>Sfidanti</th>
                            <th>Data Partita</th>
                            <th></th>
                            
                        </tr>
                        
                       <% for (i=0; i<gestioneRefertiArbitro.getReferti().length; i++)
                        {
                            if (gestioneRefertiArbitro.getReferti(i).flagReferto.equals("N"))
                            {%>
                                <form name="insertForm<%=i%>" method="post" action="dettagliReferto.jsp"> 
                                    <input type="hidden" name="IDPartita" value="<%=gestioneRefertiArbitro.getReferti(i).IDPartita%>"/>
                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneRefertiArbitro.getReferti(i).IDSquadraA%>"/>
                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneRefertiArbitro.getReferti(i).IDSquadraB%>"/>
                                    <input type="hidden" name="nomeSquadraA" value="<%=gestioneRefertiArbitro.getNomeSquadreA(i)%>"/>
                                    <input type="hidden" name="nomeSquadraB" value="<%=gestioneRefertiArbitro.getNomeSquadreB(i)%>"/>
                                    <input type="hidden" name="IDReferto" value="<%=gestioneRefertiArbitro.getReferti(i).IDReferto%>"/>
                                    <input type="hidden" name="nomeTorneo" value="<%=gestioneRefertiArbitro.getReferti(i).nomeTorneo%>"/>
                                    <input type="hidden" name="IDTorneo" value="<%=gestioneRefertiArbitro.getReferti(i).IDTorneo%>"/>
                                    <input type="hidden" name="tipoTorneo" value="<%=gestioneRefertiArbitro.getReferti(i).tipoTorneo%>"/>
                                    <input type="hidden" name="data" value="<%=gestioneRefertiArbitro.getReferti(i).data%>"/>
                                    
                                    <input type="hidden" name="status" value="new"/>
                                </form>
                                </form>
                                
                                    <tr>
                                        <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).IDReferto%></td>
                                        <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).nomeTorneo%></td>
                                        <td class="red" align="center"><%=gestioneRefertiArbitro.getNomeSquadreA(i)%> - <%=gestioneRefertiArbitro.getNomeSquadreB(i)%></td>
                                        <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).data%></td>
                                        <td class="su" align="center"><a href="javascript:insertReferto(<%=i%>)">Compila</a></td>
                                    </tr>   
                          <%  }
                        }
                     }
                     else
                      {%>
                      <br><br>
                      <h3 align="center" class="green"> NON CI SONO REFERTI DA COMPILARE</h3>
                      
                      <% } %>
                    </table>

                    <br><br>
                    <div align="center">
                        <input type="button" value="Indietro" onClick="javascript:history.back()"/>
                    </div>
                   
                <table align="center" width="1000"></table>
                
               </div>
           </div>
       </div>
    </body>
</html>