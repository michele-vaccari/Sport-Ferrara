<%@ page info="Dettagli Giocatore" %>
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
  String message = null;
  String status;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* Default status = view */
  if (status == null)
    status = "newGiocatore";
  
  /* status = newGiocatore */
  if (status.equals("newGiocatore"))
    gestioneGiocatori.visualizzaSquadra();
  
  /* status = insertGiocatore */
  if(status.equals("insertGiocatore"))
    gestioneGiocatori.inserisciGiocatoreVisualizza();
  
  /* status = modifyGiocatore */
  if (status.equals("modifyGiocatore"))
    gestioneGiocatori.modificaGiocatoreVisualizza();
  
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
      
      function isEmpty(value) {
        if (value == null || value.length == 0)
            return true;
        for (var count = 0; count < value.length; count++) {
          if (value.charAt(count) != " ") 
            return false;
        }
        return true;
      }
      
      function insertGiocatoreContinuo() {
        document.forms["insertFormGiocatoreContinuo"].submit();
        return;
      }
      
      function controlloNumeroMaglia(NuM) {
        if(isNaN(NuM))
          return true;
        return;
      }
      
      function controlloDataN(d) {
        var g, m, a;

        if((d.length !== 10) || (d[2] !== '-') || (d[5] !== '-'))                  
          return true;

        if(((d.charAt(0)) > 3) || ((d.charAt(3)) > 1))
          return true;
        
        g = d[0] + d[1]; /* giorno */
        if (d[3] == 0)
          m = d[4]; /* mese 0 */
        else 
          m = d[3] + d[4]; /* mese 1 */
        a = d[6] + d[7] + d[8] + d[9]; /* anno */

        if((isNaN(g)) || (isNaN(m)) || (isNaN(a)))
          return true;

        if ((m == 2) && (g > 29))                   
          return true;

        if (((m == 4) || (m == 6) || (m == 9) || (m == 11)) && (g > 30))
          return true;
        
        return;
      }
      
      function insertGiocatore() {
        
        if(isEmpty(insertFormGiocatore.nome.value)) {
          alert("Non è stato inseirto il Nome!");
          return;
        }
        if(isEmpty(insertFormGiocatore.cognome.value)) {
          alert("Non è stato inseirto il Cognome!");
          return;
        }
        if(isEmpty(insertFormGiocatore.dataNascita.value)) {
          alert("Non è stata inseirta la data di nascita!");
          return;
        }
        if(controlloDataN(insertFormGiocatore.dataNascita.value)) {
          alert("Formato data di nascita errato! usare gg-mm-aaaa!");
          return;
        }
        if(isEmpty(insertFormGiocatore.nazionalità.value)) {
          alert("Non è stata inseirta la Nazionalità!");
          return;
        }
        if(isEmpty(insertFormGiocatore.numeroMaglia.value)) {
          alert("Non è stato inseirto il numero della maglia!");
          return;
        }
        if(controlloNumeroMaglia(insertFormGiocatore.numeroMaglia.value)) {
          alert("Il numero della maglia non è valido");
          return;
        }
        if(isEmpty(insertFormGiocatore.ruolo.value)) {
          alert("Non è stata inseirto il ruolo!");
          return;
        }
        insertFormGiocatore.submit();
        return;    
      }
      
      function annulla() {
        var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
        if(req === true)
          document.annullaForm.submit();
        return;
      }

      function backHome() {
        homeForm.submit();
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
                
                 <h4 align="center"> Qui potrai INSERIRE un nuovo GIOCATORE! </h4>
                 <h4 align="center"> Compila i seguenti campi: </h4><br>
                 
                 
                <form name="insertFormGiocatore" action="dettagliGiocatore.jsp" method="post">
                <table align="center">
                    <tr>                         
                        <td align="right" width="175" height="35"><b>Nome</b></td>
                        <td width="250">
                            <input type="text" name="nome" size="25" maxlength="30" value="<%=request.getParameter("nome")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Cognome</b></td>
                        <td width="250">
                            <input type="text" name="cognome" size="25" maxlength="30" value="<%=request.getParameter("cognome")%>"/>
                        </td>
                    </tr>
                    <tr>                         
                        <td align="right"  width="175" height="35"><b>Data nascita</b></td>
                        <td width="250">
                            <input type="text" name="dataNascita" size="25" maxlength="10" value="<%=request.getParameter("dataNascita")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Nazionalità</b></td>
                        <td width="250">
                            <input type="text" name="nazionalità" size="25" maxlength="20" value="<%=request.getParameter("nazionalità")%>"/>
                        </td>
                    </tr> 
                    <tr>
                        <td align="right"  width="175" height="35"><b>Numero Maglia</b></td>
                        <td width="250">
                            <input type="text" name="numeroMaglia" size="25" maxlength="20" value="<%=request.getParameter("numeroMaglia")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Ruolo</b></td>
                        <td width="250">
                            <input type="text" name="ruolo" size="25" maxlength="50" value="<%=request.getParameter("ruolo")%>"/>
                        </td>
                    </tr>   
               
                    <tr>                         
                        <td align="right" width="175" height="35"><b>Foto</b></td>
                        <td width="175" >
                            <input type="file" name="foto" onchange="upload()">
                        </td>
                        <td align="right" width="175" height="35"><b>Descrizone</b></td>
                        <td width="250">
                            <textarea name="descrizione" rows="5" cols="24" maxlength="5000" ><%=request.getParameter("descrizione")%></textarea>
                        </td>
                    </tr>       
            </table><br>
            
            <input type="hidden" name="IDSquadra" value="<%=gestioneGiocatori.getSquadra().ID_Squadra%>">
            
            <% if(!request.getParameter("status").equals("insertGiocatore"))
               { %>
                     <input type="hidden" name="SSNGiocatore" value="<%=request.getParameter("SSNGiocatore")%>"/>
               <% } %>
               
               
           <table align="center">
                <tr width="200">       
                    <% if(request.getParameter("status").equals("newGiocatore")) 
                       { %>
                    <td>         
                        <input type="button" value="Annulla" onClick="annulla()"/>
                    </td>
                    <td>
                        <input type="button" value="Conferma" onClick="insertGiocatore()"/>
                        <input type="hidden" name="status" value="insertGiocatore"/>
                    </td>    
                    <% }
                       else 
                       { %>
                    <td>         
                        <input type="button" value="Annulla" onClick="annulla()"/> 
                    </td>
                    <td>
                        <input type="button" value="Conferma modifiche" onClick="insertGiocatore()"/>
                         <input type="hidden" name="status" value="modifyGiocatore"/>
                    </td> 
                    <td>
                        <input type="button" value="Inserisci nuovo Giocatore" onClick="insertGiocatoreContinuo()"/>
                    </td>
                     <% } %>
                </tr>
           </table>
                  
            </form>
              
              
             
        
              <form name="insertFormGiocatoreContinuo" method="post" action="dettagliGiocatore.jsp"> 
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
          
                <table align="center" width="950"></table>
                
            </div>
        </div>
    </div>
                
        <%if (message!=null) {%>
            <script>alert("<%=message%>");</script>
        <%}%>
  
      </body>
</html>