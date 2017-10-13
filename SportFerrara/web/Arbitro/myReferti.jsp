<%@ page info="Inserisci Referto" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneRefertiArbitro" scope="page" class="bflows.ArbitroRefertiManagement" />
<jsp:setProperty name="gestioneRefertiArbitro" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'SSN dell'arbitro nel bean */  
  gestioneRefertiArbitro.setSSNArbitro(Integer.parseInt(Session.getSSN(cookies)));
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  int i;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* Default status = view */
  if (status == null)
      status = "view";
  
  /* status = insert */
  if (status.equals("insert"))
    gestioneRefertiArbitro.inserisciRefertoVisualizza();
    
  /* status = view*/
  if (status.equals("view"))
    gestioneRefertiArbitro.visualizzaReferti();
  
  /* Gestione degli errori */
  if (gestioneRefertiArbitro.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneRefertiArbitro.getResult() == -2) {
    message=gestioneRefertiArbitro.getErrorMessage();
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
                   
                   
                   <h3 align="center"> Qui puoi vedere i referti che hai già compilato <br>o che devi ancora compilare</h3>
                   
                   <% if(gestioneRefertiArbitro.getReferti().length!=0)
                        { %>
                   
                   <br>
                                      
                   <table class="calendario" align="center" width="950">
                        <tr>
                            <th>ID</th>
                            <th>Nome del Torneo</th>
                            <th>Sfidanti</th>
                            <th>Risultato</th>
                            <th>Data Partita</th>
                            <th>Stato</th>
                            
                        </tr>
                        
                       <% for (i=0; i<gestioneRefertiArbitro.getReferti().length; i++)
                        { %>
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
                                    
                                <% if(gestioneRefertiArbitro.getReferti(i).flagReferto.equals("N"))
                                   {%>            
                                        <tr>
                                            <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).IDReferto%></td>
                                            <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).nomeTorneo%></td>
                                            <td class="red" align="center"><%=gestioneRefertiArbitro.getNomeSquadreA(i)%> - <%=gestioneRefertiArbitro.getNomeSquadreB(i)%></td>
                                            <td class="red" align="center"></td>
                                            <td class="red" align="center"><%=gestioneRefertiArbitro.getReferti(i).data%></td>
                                            <td class="su" align="center"><a href="javascript:insertReferto(<%=i%>)">Compila</a></td>
                                        </tr> 
                                  <% } else { %>
                                        <tr>
                                            <td class="giu" align="center"><%=gestioneRefertiArbitro.getReferti(i).IDReferto%></td>
                                            <td class="giu" align="center"><%=gestioneRefertiArbitro.getReferti(i).nomeTorneo%></td>
                                            <td class="giu" align="center"><%=gestioneRefertiArbitro.getNomeSquadreA(i)%> - <%=gestioneRefertiArbitro.getNomeSquadreB(i)%></td>
                                            <td class="giu" align="center"><%=gestioneRefertiArbitro.getReferti(i).risultato%></td>
                                            <td class="giu" align="center"><%=gestioneRefertiArbitro.getReferti(i).data%></td>
                                            <td class="giu" align="center"><b>COMPILATO</b></td>
                                        </tr> 
                                  
                          <%  }
                        }
                     }
                     else
                      {%>
                      <br><br>
                      <h3 align="center" class="green"> NON CI SONO REFERTI DA VISUALIZZARE/COMPILARE</h3>
                      
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