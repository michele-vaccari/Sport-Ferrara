<%@ page info="Modulo Formazione" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneFormazioni" scope="page" class="bflows.FormazioneManagement" />
<jsp:setProperty name="gestioneFormazioni" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  gestioneFormazioni.setGestore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status; 
  int i;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* Default status = view */
  if (request.getParameter("status") == null)
    status="view";
  
  /* status = view */
  if (status.equals("view"))
    gestioneFormazioni.visualizzaReferti();
  
  /* status = insert */
  if(status.equals("insert"))
    gestioneFormazioni.inserisciFormazioneVisualizza();
  
  /* Gestione degli errori */
  if (gestioneFormazioni.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneFormazioni.getResult() == -2) {
    message = gestioneFormazioni.getErrorMessage();
  }
%>


<!DOCTYPE html>
<html>
  <head>
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
    
    <script language="javascript">

    function insertFormazione(index) {
      f = document.forms["insertForm"+index];
      f.submit();
      return;
    }
    
    function annulla() {
      var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
      if(req === true)
        document.annullaForm.submit();
      return;
    }
    
    function BottoneSquadra() {
      document.forms["bottoneFormSquadra"].submit();
      return;
    }
    
    </script>
  </head>
    
    <body>
        
        <form name="annullaForm" action="homeG.jsp" method="post">
            <input type="hidden" name="status" value="view"/>
        </form> 
        
         <form name="bottoneFormSquadra" method="post" action="squadre.jsp">
            <input type="hidden" name="status" value="view"/> 
            <input type="hidden" name="flag" value="Y"/>
        </form>
        
        
        
           <div id="header-container">
            <div id="header">
                <h1>SportFerrara</h1>             
            </div>
            <div id="menubar">
              <ul id="menu">

                 <li><a class="button" href="homeG.jsp">MyHOME</a></li>

                  <li><a class="button" href="giocatori.jsp">GIOCATORI</a></li>

                  <li><a class="button" href="newFormazione.jsp">FORMAZIONI</a></li>

                  <li><a class="button" href="javascript:BottoneSquadra()">SQUADRA</a></li>

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
                   
                   
                   <h4 align="center"> Qui puoi DISEGNARE la formazione per una determinata partita</h4>
                   
                   <% if(gestioneFormazioni.getReferti().length!=0)
                        { %>
                   
                   <h4 align="center"> Premi su scegli per procedere con la scelta dei giocatori</h4>
                   <br><br>
                                      
                   <table class="calendario" align="center" width="900">
                        <tr>
                            <th>ID Referto</th>
                            <th>Nome del Torneo</th>
                            <th>Sfidanti</th>
                            <th>Data Partita</th>
                            <th>Selezione</th>
                            
                        </tr>
                        
                       <% for (i=0; i<gestioneFormazioni.getReferti().length; i++)
                        {
                            if (gestioneFormazioni.getReferti(i).flagReferto.equals("N"))
                            {%>
                                <form name="insertForm<%=i%>" method="post" action="sceltaGiocatori.jsp"> 
                                    <input type="hidden" name="IDPartita" value="<%=gestioneFormazioni.getReferti(i).IDPartita%>"/>
                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneFormazioni.getReferti(i).IDSquadraA%>"/>
                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneFormazioni.getReferti(i).IDSquadraB%>"/>
                                    <input type="hidden" name="NomeSquadraA" value="<%=gestioneFormazioni.getNomeSquadreA(i)%>"/>
                                    <input type="hidden" name="NomeSquadraB" value="<%=gestioneFormazioni.getNomeSquadreB(i)%>"/>
                                    <input type="hidden" name="IDReferto" value="<%=gestioneFormazioni.getReferti(i).IDReferto%>"/>
                                    <input type="hidden" name="nomeTorneo" value="<%=gestioneFormazioni.getReferti(i).nomeTorneo%>"/>
                                    <input type="hidden" name="data" value="<%=gestioneFormazioni.getReferti(i).data%>"/>
                                    <input type="hidden" name="status" value="new"/>
                                </form>
                                </form>
                                
                                    <tr>
                                        <td class="giu" align="center"><%=gestioneFormazioni.getReferti(i).IDReferto%></td>
                                        <td class="giu" align="center"><%=gestioneFormazioni.getReferti(i).nomeTorneo%></td>
                                        <td class="giu" align="center"><%=gestioneFormazioni.getNomeSquadreA(i)%> - <%=gestioneFormazioni.getNomeSquadreB(i)%></td>
                                        <td class="giu" align="center"><%=gestioneFormazioni.getReferti(i).data%></td>
                                        <td class="su" align="center"><a href="javascript:insertFormazione(<%=i%>)">Scegli</a></td>
                                    </tr>   
                          <%  }
                        }
                     }
                     else
                      {%>
                      <br><br>
                      <h3 align="center" class="green"> NON CI SONO FORMAZIONI DA COMPILARE</h3>
                      
                      <% } %>
                    </table>
                   
                   
               
                    <br><br>
                    <div align="center">
                        <input type="button" value="Annulla" onClick="annulla()"/>
                    </div>
                       
                <table align="center" width="1000"></table>
                
               </div>
           </div>
       </div>
    </body>
</html>