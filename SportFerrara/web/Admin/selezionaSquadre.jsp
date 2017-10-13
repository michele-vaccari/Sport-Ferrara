<%@ page info="Seleziona Squadre" %>
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
  int j = 0;
  
  /* Metodo del bean */
  gestioneTornei.visualizzaSquadre();
  
  /* Gestione degli errori */
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
      
      function conta(squadre) {
        var checked = 0;
        for(var i = 0, n = squadre.length; i < n; squadre.item(i++).checked && checked++);
        return checked;
      }

      function Avanti() {

        var count = conta(document.forms.squadre.squadra);
        if(count < document.forms.squadre.numeroSquadre.value) {
          alert("Non hai selezionato abbastanza squadre!");
          return;
        }

        var req = confirm("Vuoi creare il TORNEO? se confermi non potrai più modificarlo");
        if(req === true)
          document.squadre.submit();
        return;
      }

      function checkboxlimit(checkgroup, limit) {

        for (var i=0; i<checkgroup.length; i++) {
          checkgroup[i].onclick=function() {
            var checkedcount=0;
            for (var i = 0; i < checkgroup.length; i++)
              checkedcount+=(checkgroup[i].checked)? 1 : 0;
            if (checkedcount > limit) {
              alert("Hai già raggiunto il limite di " + limit + " squadre selezionabili");
              this.checked = false;
              checkedcount = limit;
            }
            document.getElementById("L1").innerHTML = "<b>" + checkedcount + "</b>";
          }
        }
      }
      function annulla() {

        var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri andrannpo persi.");
        if(req === true)
          document.annullaForm.submit();
        return;
      }
    
    </script>
  </head>
      
    <body>
        <form name="annullaForm" action="homeA.jsp" method="post">
            <input type="hidden" name="status" value="view"/>
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
               <h3 class="green" align="center"><%=request.getParameter("nome")%></h3><br>
               <h4 align="center">Seleziona le <<%=request.getParameter("numeroSquadre")%>> squadre che faranno parte del torneo</h4>
               <br>
               <form id="squadre" name="squadre" action="calendario.jsp" method="post">
                   <table class="calendario" align="center" width="550">
                        <tr> 
                            <th class="calendario" align="center">Nome Squadra</th>
                            <th class="calendario" align="center">Sede</th>
                            <th class="calendario" align="center">Scegli </th> 
                         </tr> 
                         
                  
                            <%if ((gestioneTornei.getSquadre().length)%2==0)
                            {
                                for (i=0; i<gestioneTornei.getSquadre().length; i++) //caso pari
                                { %>
                                        <tr>
                                            <td class="giu" align="center"><%=gestioneTornei.getSquadre(i).nomeSquadra%></td>
                                            <td class="su" align="center"><%=gestioneTornei.getSquadre(i).sede%></td>
                                            <td class="su" align="center"><input name="squadra" type="checkbox" value="<%=gestioneTornei.getSquadre(i).ID_Squadra%>"/></td>
                                        </tr>
                                    <%
                                    j++;
                                }
                            }
                            else
                            {
                                for (i=0; i<(gestioneTornei.getSquadre().length)-1; i++) //caso dispari
                                { %>
                                        <tr>
                                            <td class="giu" align="center"><%=gestioneTornei.getSquadre(i).nomeSquadra%></td>
                                            <td class="su" align="center"><%=gestioneTornei.getSquadre(i).sede%></td>
                                            <td class="su" align="center"><input name="squadra" type="checkbox" value="<%=gestioneTornei.getSquadre(i).ID_Squadra%>"/></td>
                                        </tr>
                                <%
                                    j++;
                                }
                                %>
                                    <tr>
                                            <td class="giu" align="center"><%=gestioneTornei.getSquadre(i).nomeSquadra%></td>
                                            <td class="su" align="center"><%=gestioneTornei.getSquadre(i).sede%></td>
                                            <td class="su" align="center"><input name="squadra" type="checkbox" value="<%=gestioneTornei.getSquadre(i).ID_Squadra%>"/></td>
                                    </tr>
                                <% j++;
                            }%>
                            
                            <input type="hidden" name="numeroSquadre" value="<%=request.getParameter("numeroSquadre")%>"/>
                            <input type="hidden" name="nome" value="<%=request.getParameter("nome")%>"/> <!-- nome del torneo-->
                            <input type="hidden" name="tipologia" value="<%=request.getParameter("tipologia")%>"/>
                            <input type="hidden" name="descrizione" value="<%=request.getParameter("descrizione")%>"/>
                            <input type="hidden" name="IDTorneo" value=""/>
                            </form> 
                            
                        </table>
                
                            
                        <script type="text/javascript">
                            checkboxlimit(document.forms.squadre.squadra, document.forms.squadre.numeroSquadre.value);
                        </script>
                        <br>
                        <table align="center" width="300">
                            <td align="center" width="100" height="35">
                                <input type="button" value="Indietro" onClick="javascript:history.back()"/> 
                            </td>
                           <td align="center" width="100" height="35">
                               <input type="button" value="Annulla" onClick="annulla()"/>
                           </td>    
                            <td align="center" width="100" height="35">
                                <input type="button" value="Conferma" onClick="Avanti()"/> 
                            </td>
                        </table>
                  </form> 
                  
                  <table width="650"> </table>
                  
               </div>
           </div>
       </div> 
      
        <%if (message!=null) {%>
            <script>alert("<%=message%>");</script>
        <%}%>
  
      </body>
</html>
   
