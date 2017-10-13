<%@ page info="Crea Torneo" %>
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
  
  boolean loggedOn=(cookies != null);
  
  /* Setto il creatore del torneo */
  gestioneTornei.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  
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
      
      function isEmpty(value) {
        
        if (value == null || value.length == 0)
          return true;
        for (var count = 0; count < value.length; count++) {
          if (value.charAt(count) != " ")
            return false;
        }
        return true;
      }  

      function controlTorneo() {
        
        if (isEmpty(insertFormSquadre.nome.value)) {
          alert("Inserire il nome del torneo!");
          return;
        }
        if (isEmpty(insertFormSquadre.numeroSquadre.value)) {
          alert("Inserire il numero delle squadre partecipanti!");
          return;
        }
        if (isEmpty(insertFormSquadre.descrizione.value)) {
          alert("Inserisci una breve descrizione!");
          return;
        }
        
        insertFormSquadre.submit();
        return;
      }

      function annulla() {
        
        var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri andrannpo persi.");
        if (req === true)
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
        <% if (request.getParameter("status").equals("newI"))
        { %>
            <h3 class="green" align="center"> Compila i seguenti campi per creare <br> un nuovo Torneo all'Italiana</h3><br>
        <% }
        else
        { if(request.getParameter("status").equals("newE"))
            {%>
            <h3 class="green" align="center"> Compila i seguenti campi per creare <br> un nuovo Torneo ad Eliminazione</h3><br>
        <%  }
        } %>
        <br>
            <form name="insertFormSquadre" action="selezionaSquadre.jsp" method="post">
                <table align="center" width="375">
                    <tr>                         
                        <td align="right" width="100" height="35"><b>Nome</b></td>
                        <td width="250">
                            <input type="text" name="nome" size="25" maxlength="30" value="<%=request.getParameter("nome")%>"/>
                        </td>
                    </tr>
                        
                        <% if (request.getParameter("status").equals("newI"))
                        { %>
                        
                        <tr><td align="right" width="100" height="35"><b>N° Squadre<br> partecipanti</b></td>
                                        <td>
                                            <select name="numeroSquadre">
                                            <option value="0"></option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                            <option value="8">8</option>
                                            <option value="9">9</option>
                                            <option value="10">10</option>
                                            <option value="11">11</option>
                                            <option value="12">12</option>
                                            <option value="13">13</option>
                                            <option value="14">14</option>
                                            <option value="15">15</option>
                                            <option value="16">16</option>
                                            <option value="17">17</option>
                                            <option value="18">18</option>
                                            <option value="19">19</option>
                                            <option value="20">20</option>
                                            </select>
                                        </td>
                                    </tr>
                        
                         <% }
                        else
                         { if(request.getParameter("status").equals("newE"))
                         {%>
                         <tr>
                             <td align="right" width="100" height="35"><b>N° Squadre<br> partecipanti</b></td>
                                <td>
                                    <select name="numeroSquadre">
                                    <option value="0"></option>
                                    <option value="2">2</option>
                                    <option value="4">4</option>
                                    <option value="8">8</option>
                                    <option value="16">16</option>
                                    </select>
                                </td>
                         </tr>
                        
                       <%  }
                         } %>  
                         
                        <tr>                         
                            <td align="right" width="100" height="35"><b>Descrizione</b></td>
                            <td width="250">
                                <textarea name="descrizione" rows="5" cols="24" maxlength="5000" value="<%=request.getParameter("descrizione")%>"></textarea>
                            </td>
                        </tr>  
                        
                 <input type="hidden" name="tipologia" value="<%=request.getParameter("tipologia")%>"/>
                 <input type="hidden" name="IDTorneo" value=""/>
            </table>            
            <br>
            <table align="center" width="200">
                <tr>
                    <td align="center" width="500" height="35">
                        <input type="button" value="Annulla" onClick="annulla()"/>
                    </td>  
                    <td align="center" width="500" height="35">
                        <input type="button" value="Continua" onClick="controlTorneo()"/>
                    </td>
                </tr>
            </table>   
            </form>
            
               
            <table width="530"></table>
                 
        </div>
     </div> 
    </div>
    
    <%if (message!=null) {%>
        <script>alert("<%=message%>");</script>
    <%}%>
  
  </body>
</html>
   


