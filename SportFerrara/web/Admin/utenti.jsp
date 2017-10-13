<%@ page info="Visualizza Utenti" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneUtenti" scope="page" class="bflows.UserManagement" />
<jsp:setProperty name="gestioneUtenti" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'amministratore nel bean */
  gestioneUtenti.setAdmin(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  int i;
  String message = null;
  String status;
  
  /* Leggo lo status */
  if (request.getParameter("status") == null)
      status = "view";
  else
    status=request.getParameter("status");
  
  if (status.equals("delete"))
    gestioneUtenti.eliminaUtenteVisualizza();
 
  if (status.equals("view"))
    gestioneUtenti.visualizzaUtenti();
  
  /* Gestione degli errori */
  if (gestioneUtenti.getResult() == -1) {
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } else if (gestioneUtenti.getResult() == -2) {
    message = gestioneUtenti.getErrorMessage();
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
      
      function insertArbitro() {
        document.forms["insertFormR"].submit();
        return;
      }
      
      function insertGestore() {
        document.forms["insertFormG"].submit();
        return;
      }
      
      function modifyUtente(index) {
        f = document.forms["modifyForm" + index];
        f.submit();
        return;
      }
      
      function deleteUtente(mail) {
        document.deleteForm.email.value = mail;
        alert("L'eliminazione riporterà alla vista completa di tutti gli utenti");
        var req=confirm("Sei sicuro di volere eliminare " + mail + "?");
        if (req === true)
          document.deleteForm.submit();
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
                   
                    <h4 align="center">Per visualizzare/modificare i dettagli di ogni singolo utente, passa alla visualizzazione per tipo:</h4>
                    <br>
                    <form action="utenti.jsp" method="post">
                        <table align="center">
                            <tr>
                                <td>
                                    <input type="submit" name="vista" value="Tutti">
                                </td>
                                <td>
                                    <input type="submit" name="vista" value="Arbitro">    
                                </td>
                                <td>
                                    <input type="submit" name="vista" value="Gestore">
                                </td>
                            </tr>
                        </table>                        
                 </form>
                    <br>
                    <h5 align="center">Importante: il verde è per gli Arbitri, il bianco per i Gestori delle squadre </h5><br>
                    <div>
                    <table class="utente" align="center">
                        <tr> 
                            <th class="calendario" align="center" width="45">ID</th>
                            <th class="calendario" align="center" width="125">Cognome</th>
                            <th class="calendario" align="center" width="115">Nome</th>
                            <th class="calendario" align="center" width="270">E-mail</th>
                            <th class="calendario" align="center" width="270">Indirizzo</th>
                            <th class="calendario" align="center" width="125">Telefono</th>
                            <th class="calendario" align="center" width="125">Opzioni</th>
                        </tr>          
        
        
                    <% 
                        String[] spunta = request.getParameterValues("vista");
                        if (spunta != null && spunta.length != 0) 
                        {
                            if(spunta[0].equals("Arbitro"))
                            {        
                                for (i=0;i<gestioneUtenti.getArbitri().length;i++) 
                                {%>  
                                    <form name="modifyForm<%=i%>" method="post" action="dettagliUtente.jsp">
                                        <input type="hidden" name="type" value="R"/>
                                        <input type="hidden" name="email" value="<%=(gestioneUtenti.getArbitri(i)).email%>"/>
                                        <input type="hidden" name="password" value="<%=(gestioneUtenti.getArbitri(i)).password%>"/>
                                        <input type="hidden" name="nome" value="<%=(gestioneUtenti.getArbitri(i)).nome%>"/>
                                        <input type="hidden" name="cognome" value="<%=(gestioneUtenti.getArbitri(i)).cognome%>"/>
                                        <input type="hidden" name="nazionalità" value="<%=(gestioneUtenti.getArbitri(i)).nazionalità%>"/>
                                        <input type="hidden" name="data" value="<%=(gestioneUtenti.getArbitri(i)).data_n%>"/>
                                        <input type="hidden" name="indirizzo" value="<%=(gestioneUtenti.getArbitri(i)).indirizzo%>"/>
                                        <input type="hidden" name="telefono" value="<%=(gestioneUtenti.getArbitri(i)).telefono%>"/>
                                        <input type="hidden" name="foto" value="<%=(gestioneUtenti.getArbitri(i)).foto%>"/>
                                        <input type="hidden" name="SSN" value="<%=(gestioneUtenti.getArbitri(i)).SSN%>"/>
                                        <input type="hidden" name="carriera" value="<%=(gestioneUtenti.getArbitri(i)).carriera%>"/>
                                        <input type="hidden" name="status" value="modify"/>
                                    </form>
                                    
                                        <tr height="50">
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).SSN%></td>
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).cognome%></td>
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).nome%></td>
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).email%></td>
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).indirizzo%></td>
                                            <td class="giu" align="center"><%=(gestioneUtenti.getArbitri(i)).telefono%></td>
                                            <td class="giu" align="center"><a href="javascript:deleteUtente('<%=gestioneUtenti.getArbitri(i).email%>')">Elimina</a>
                                                <a href="javascript:modifyUtente(<%=i%>)">Modifica</a></td>
                                        </tr>
                                    <%                                    
                                }%>
                            <%}
                            if(spunta[0].equals("Gestore"))
                            {
                                for (i=0;i<gestioneUtenti.getGestori().length;i++) 
                                {%>
                                    <form name="modifyForm<%=i%>" method="post" action="dettagliUtente.jsp">
                                        <input type="hidden" name="type" value="G"/>
                                        <input type="hidden" name="email" value="<%=(gestioneUtenti.getGestori(i)).email%>"/>
                                        <input type="hidden" name="password" value="<%=(gestioneUtenti.getGestori(i)).password%>"/>
                                        <input type="hidden" name="nome" value="<%=(gestioneUtenti.getGestori(i)).nome%>"/>
                                        <input type="hidden" name="cognome" value="<%=(gestioneUtenti.getGestori(i)).cognome%>"/>
                                        <input type="hidden" name="indirizzo" value="<%=(gestioneUtenti.getGestori(i)).indirizzo%>"/>
                                        <input type="hidden" name="telefono" value="<%=(gestioneUtenti.getGestori(i)).telefono%>"/>
                                        <input type="hidden" name="squadra" value="<%=(gestioneUtenti.getGestori(i)).squadra%>"/>
                                        <input type="hidden" name="SSN" value="<%=(gestioneUtenti.getGestori(i)).SSN%>"/>
                                        <input type="hidden" name="status" value="modify"/>
                                    </form>
                                    
                                        <tr height="50">
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).SSN%></td>
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).cognome%></td>
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).nome%></td>
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).email%></td>
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).indirizzo%></td>
                                            <td class="su" align="center"><%=(gestioneUtenti.getGestori(i)).telefono%></td>
                                            <td class="su" align="center"><a href="javascript:deleteUtente('<%=gestioneUtenti.getGestori(i).email%>')">Elimina</a>
                                                <br><a href="javascript:modifyUtente(<%=i%>)">Modifica</a></td>
                                        </tr>
                                    <%
                                }
                            }
                        }
                        if ((spunta == null)||(spunta[0].equals("Tutti")))
                        {
                            for (i=0;i<gestioneUtenti.getUtentiReg().length;i++) 
                            {
                                if ((gestioneUtenti.getUtentiReg(i)).type.equals("R"))
                                {%>
                                    <tr height="50">
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).SSN%></td>
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).cognome%></td>
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).nome%></td>
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).email%></td>
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).indirizzo%></td>
                                        <td class="giu" align="center"><%=(gestioneUtenti.getUtentiReg(i)).telefono%></td>
                                        <td class="giu" align="center"><a href="javascript:deleteUtente('<%=gestioneUtenti.getUtentiReg(i).email%>')">Elimina</a></td>
                                    </tr>
                                <%}
                                else
                                {%>
                                    <tr height="50">
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).SSN%></td>
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).cognome%></td>
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).nome%></td>
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).email%></td>
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).indirizzo%></td>
                                        <td class="su" align="center"><%=(gestioneUtenti.getUtentiReg(i)).telefono%></td>
                                        <td class="su" align="center"><a href="javascript:deleteUtente('<%=gestioneUtenti.getUtentiReg(i).email%>')">Elimina</a></td>
                                    </tr>
                                <%}%>   
                        <%}
                    }%>
                </div>
             </table>
                <br><br>
              <h4 align="center">Puoi inoltre inserire un nuovo utente:</h4>
              <br>
              <form action="utenti.jsp"> 
              <table align="center">
                            <tr>
                                <td>
                                    <input type="button" value="Inserisci nuovo Arbitro" onClick="insertArbitro()"/>
                                </td>
                                <td>
                                    <input type="button" value="Inserisci nuovo Gestore Squadra" onClick="insertGestore()"/>
                                </td>
                               
                            </tr>
               </table> 
              </form>
                    
                                       
                    
           <form name="insertFormR" method="post" action="dettagliUtente.jsp">
                <input type="hidden" name="type" value="R"/>
                <input type="hidden" name="SSN" value=""/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="cognome" value=""/>
                <input type="hidden" name="email" value=""/>
                <input type="hidden" name="password" value=""/>
                
                <input type="hidden" name="indirizzo" value=""/>
                <input type="hidden" name="telefono" value=""/>
                
                <input type="hidden" name="foto" value=""/>
                <input type="hidden" name="data" value=""/>
                <input type="hidden" name="nazionalità" value=""/>
                <input type="hidden" name="carriera" value=""/>
                
                
              <input type="hidden" name="status" value="newR"/>
            </form>
            
            <form name="insertFormG" method="post" action="dettagliUtente.jsp">
                <input type="hidden" name="type" value="G"/>
                <input type="hidden" name="SSN" value=""/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="cognome" value=""/>
                <input type="hidden" name="email" value=""/>
                <input type="hidden" name="password" value=""/>
                
                <input type="hidden" name="indirizzo" value=""/>
                <input type="hidden" name="telefono" value=""/>
                
                <input type="hidden" name="squadra" value=""/>
                                
              <input type="hidden" name="status" value="newG"/>
            </form>
                
             <form name="deleteForm" method="post" action="utenti.jsp">
                        <input type="hidden" name="email">
                        <input type="hidden" name="status" value="delete"/>
                    </form>
                </div>
                     
                <table align="center" width="1110"></table>
                
            </div>
        </div>
     </div>
    
    <%if (message!=null) {%>
        <script>alert("<%=message%>");</script>
    <%}%>
  
   </body>
   
</html>