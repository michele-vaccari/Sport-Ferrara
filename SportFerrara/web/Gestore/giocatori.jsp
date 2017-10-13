<%@ page info="Visualizza Giocatori" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneGiocatori" scope="page" class="bflows.GiocatoreManagement" />
<jsp:setProperty name="gestioneGiocatori" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto l'SSN del gestore della squadra nel bean */
  gestioneGiocatori.setGestore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  int i;
  String message = null;
  String status;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* Default status = view */
  if (status == null)
      status = "view";
  
  /* status = view */
  if (status.equals("view"))
    gestioneGiocatori.visualizzaGiocatoriSquadra();
  
  /* status = delete */
  if (status.equals("delete"))
    gestioneGiocatori.eliminaGiocatoriSquadraVisualizza();
  
  /* Gestione degli errori */
  if (gestioneGiocatori.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneGiocatori.getResult() == -2) {
    message=gestioneGiocatori.getErrorMessage();
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
      
      function insertGiocatore() {
        document.forms["insertFormGiocatore"].submit();
        return;
      }
      
      function modifica(index) {
        f = document.forms["modifyFormGiocatore"+index];
        f.submit();
        return;
      }
      
      function deleteGiocatore(cognome, nome, SSNGiocatore) {
        document.deleteForm.SSNGiocatore.value = SSNGiocatore;
        var req = confirm("Sei sicuro di volere eliminare " + cognome + " " + nome + " ?");
        if (req === true)
            document.deleteForm.submit();
        return;        
      }
        
      function annulla() {
        var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
        if(req === true)
          document.annullaForm.submit();
        return;
      }
        
      function home() {
        document.homeForm.submit();
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
        
        <form name="homeForm" action="homeG.jsp" method="post">
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
              
      
             <% if(gestioneGiocatori.getSquadra().flag.equals("N"))
             { %>
                <h4 align="center">Qui puoi visualizzare/modificare i dettagli di ogni singolo giocatore</h4>
                <br><br>  
                <h3 align="center" class="green"> SPICENTI MA NON PUOI VEDERE/INSERIRE o MODIFICARE GIOCATORI SE NON HAI COMPILATO I DATI RELATIVI ALLA TUA SQUADRA </h3>
                <br><br>
                <div align="center">
                    <input type="button" value="Torne alla Home" onClick="home()"/>
                </div>
             <% }
                else
                {
                    if(gestioneGiocatori.getGiocatori().length==0)
                 { %>
                    <h4 align="center">Qui puoi visualizzare/modificare i dettagli di ogni singolo ocatoregi</h4>
                    <br><br>  
                    <h3 align="center" class="green"> NON HAI ANCORA INSERITO GIOCATORI NELLA ROSA DELLA SQUADRA </h3>
                    <br><br>
                    <h4 align="center">Inizia ora:</h4>
               <% } 
                 else 
                    { %>
             
             
                    <h4 align="center">Qui puoi visualizzare/modificare i dettagli di ogni singolo gioactore</h4>
                    <br>
                    <h4 align="center"> Fin'ora hai inserito <%=gestioneGiocatori.getGiocatori().length%>/36 Giocatori </h4>
                    <br>
                    <br>
     
                    <table class="calendario" align="center" width="1050">
                        <tr> 
                            <th class="calendario" align="center" width="80">Foto</th>
                            <th class="calendario" align="center" width="160">Nome</th>
                            <th class="calendario" align="center" width="180">Cognome</th>
                            <th class="calendario" align="center" width="80">N°</th>
                            <th class="calendario" align="center" width="220">Ruolo</th>
                            <th class="calendario" align="center" width="150">Opzioni</th>
                        </tr>          

                                <% for (i=0;i<gestioneGiocatori.getGiocatori().length;i++)
                                {%>  
                                    <form name="modifyFormGiocatore<%=i%>" method="post" action="dettagliGiocatore.jsp">
                                        
                                        
                                        <input type="hidden" name="SSNGiocatore" value="<%=gestioneGiocatori.getGiocatori(i).SSNGiocatore%>" />
                                        <input type="hidden" name="cognome" value="<%=gestioneGiocatori.getGiocatori(i).cognome%>"/>
                                        <input type="hidden" name="nome" value="<%=gestioneGiocatori.getGiocatori(i).nome%>"/>
                                        <input type="hidden" name="dataNascita" value="<%=gestioneGiocatori.getGiocatori(i).dataNascita%>"/>
                                        <input type="hidden" name="nazionalità" value="<%=gestioneGiocatori.getGiocatori(i).nazionalità%>"/>
                                        <input type="hidden" name="ruolo" value="<%=gestioneGiocatori.getGiocatori(i).ruolo%>"/>
                                        <input type="hidden" name="numeroMaglia" value="<%=gestioneGiocatori.getGiocatori(i).numeroMaglia%>"/>
                                        <input type="hidden" name="foto" value="<%=gestioneGiocatori.getGiocatori(i).foto%>"/>
                                        <input type="hidden" name="descrizione" value="<%=gestioneGiocatori.getGiocatori(i).descrizione%>">
                                        <input type="hidden" name="IDSquadra" value="<%=gestioneGiocatori.getGiocatori(i).IDSquadra%>"/>
                                        
                                        <input type="hidden" name="status" value="modifyGiocatore"/>
                                    </form>
                                    
                                        <tr>
                                        
                                            <td class="giu" align="center">
                                                <img src="../Immagini/<%=gestioneGiocatori.getGiocatori(i).foto%>" width="75" height="75" />
                                            </td>
                                            <td class="giu" align="center"><%=gestioneGiocatori.getGiocatori(i).nome%></td>
                                            <td class="giu" align="center"><%=gestioneGiocatori.getGiocatori(i).cognome%></td>
                                            <td class="giu" align="center"><%=gestioneGiocatori.getGiocatori(i).numeroMaglia%> </td>
                                            <td class="giu" align="center"><%=gestioneGiocatori.getGiocatori(i).ruolo%></td>
                                            <td class="su" align="center"> <a href="javascript:deleteGiocatore('<%=gestioneGiocatori.getGiocatori(i).cognome%>','<%=gestioneGiocatori.getGiocatori(i).nome%>','<%=gestioneGiocatori.getGiocatori(i).SSNGiocatore%>')">Elimina</a>
                                                <br> <a href="javascript:modifica(<%=i%>)">Modifica</a></td>
                                        </tr>
                                    <%                                    
                                }%>
 
             </table>
                 
                <br><br>
              <h4 align="center">Puoi inoltre inserire un nuovo Giocatore:</h4>
            <% } %>
              <br>
              <div align="center">
                <form action="giocatori.jsp"> 
                     <input type="button" value="Inserisci nuovo Giocatore" onClick="insertGiocatore()"/>
                </form>
              </div>
              
            <% } %>
                            
                    
           <form name="insertFormGiocatore" method="post" action="dettagliGiocatore.jsp">
                    <input type="hidden" name="SSNGiocatore" value=""/>
                    <input type="hidden" name="nome" value=""/>
                    <input type="hidden" name="cognome" value=""/>
                    <input type="hidden" name="dataNascita" value=""/>
                    <input type="hidden" name="nazionalità" value=""/>
                    <input type="hidden" name="ruolo" value=""/>
                    <input type="hidden" name="numeroMaglia" value=""/>
                    <input type="hidden" name="foto" value=""/>
                    <input type="hidden" name="descrizione" value=""/>
                    <input type="hidden" name="IDSquadra" value=""/>

                    <input type="hidden" name="status" value="newGiocatore"/>
            </form>
            
                
             <form name="deleteForm" method="post" action="giocatori.jsp">
                        <input type="hidden" name="SSNGiocatore">
                        <input type="hidden" name="status" value="delete"/>
                    </form>
                    
                <table align="center" width="1100"></table>
              
            </div>
        </div>
     </div>
        
    
      <%if (message!=null) {%>
          <script>alert("<%=message%>");</script>
      <%}%>
      
   </body>
</html>