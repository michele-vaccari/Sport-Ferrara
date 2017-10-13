<%@ page info="Dettagli Referto" %>
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
  
  gestioneRefertiArbitro.setSSNArbitro(Integer.parseInt(Session.getSSN(cookies)));
  
  /* Variabili ausiliarie */
  String message = null;
  int i;
  int IDSquadraA = Integer.parseInt(request.getParameter("IDSquadraA"));
  int IDSquadraB = Integer.parseInt(request.getParameter("IDSquadraB"));
  int IDReferto = Integer.parseInt(request.getParameter("IDReferto"));
  String status = request.getParameter("status");
  
  /* Visualizza il referto della squadra */
  gestioneRefertiArbitro.visualizzaReferto(IDSquadraA, IDSquadraB, IDReferto);
  
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
        
        function isEmpty(value) {
          
          if (value == null || value.length == 0)
              return true;
          for (var count = 0; count < value.length; count++) {
            if (value.charAt(count) != " ") return false;
          }
          return true;
        }
        
        function Maggiore(value) {
          if (value >= 3)
            return true; 
        }
        
        function controlloOra(orario) {
          
          var o,m;

          if((orario.length !== 5) || (orario[2] !== ':'))                
            return true;

          if(((orario.charAt(0)) > 2) || ((orario.charAt(3)) > 5))
            return true;

          if (orario[0] == 0)
            o = orario[1]; /* mese 0 */
          else 
            o = orario[0] + orario[1]; /* mese 1 */

          if (orario[3] == 0)
            m = orario[4]; /* mese 0 */
          else 
            m = orario[3] + orario[4]; /* mese 1 */

          if((isNaN(o)) || (isNaN(m)))
             return true;
          return;
        }
        
        function confermaOrari() {
          
          if(isEmpty(OrariForm.oraInizio.value)) {
            alert("Devi inserire l'ora d'inizio partita!");
            return;
          }

          if(controlloOra(OrariForm.oraInizio.value)) {
            alert("Formato ora errato, usare hh:mm!");
            return;
          }

          if(isEmpty(OrariForm.oraFine.value)) {
            alert("Goal Ospite: Devi inserire l'ora di fine partita!");
            return;
          }

          if(controlloOra(OrariForm.oraFine.value)) {
            alert("Formato ora errato, usare hh:mm!");
            return;
          }

          document.forms["OrariForm"].submit();
          return;
        }
       
        function goalCasa() {
          var i, somma = 0;
          for (i = 0; i < 18; i++) {
            if(isEmpty(document.RefertoForm.goalCasa[i].value)) {
              alert("Devi inserire un valore, 0 se nessun goal!");
              return;
            }
            if (!numero(document.RefertoForm.goalCasa[i].value)) {
              alert("Goal Casa: Inserire un valore numerico");
              return;
            }
            somma = eval(document.RefertoForm.goalCasa[i].value) + somma;
          }
          if (!numero(document.RefertoForm.autogoalOspite.value)) {
            alert("Inserire un valore numerico");
            return;
          }
          somma = eval(document.RefertoForm.autogoalOspite.value)+somma;
          return;
        }
        
        function goalOspite() {
          var i,  somma = 0;
          
          for (i = 0; i < 18; i++) {
            if(isEmpty(document.RefertoForm.goalOspite[i].value)) {
              alert("Devi inserire un valore, 0 se nessun goal!");
              return;
            }
            if (isNaN((document.RefertoForm.goalOspite[i].value))) {
              alert("Inserire un valore numerico");
              return;
            }
            somma = eval(document.RefertoForm.goalOspite[i].value)+somma;
          }
          if (!numero(document.RefertoForm.autogoalCasa.value)) {
            alert("Inserire un valore numerico");
            return;
          }
          somma = eval(document.RefertoForm.autogoalCasa.value) + somma;
          return;
        }
        
        function Salva() {
          
          var tip = document.RefertoForm.tipoTorneo.value;
          var i, sommaCasa = 0, sommaOspite = 0;

          /* Controllo che una partita ad eliminazione termini con un vincitore */
          for (i = 0; i < 18; i++)
            sommaCasa = eval(document.RefertoForm.goalCasa[i].value) + sommaCasa;
          sommaCasa = eval(document.RefertoForm.autogoalOspite.value) + sommaCasa;
          for (i = 0; i < 18; i++)
            sommaOspite = eval(document.RefertoForm.goalOspite[i].value) + sommaOspite;
          sommaOspite = eval(document.RefertoForm.autogoalCasa.value) + sommaOspite;
          for (i = 0; i < 18; i++) {
            if (isEmpty(document.RefertoForm.goalCasa[i].value) || isNaN(document.RefertoForm.goalCasa[i].value)
                || isEmpty(document.RefertoForm.cartelliniCasa[i].value) || isNaN(document.RefertoForm.cartelliniCasa[i].value)) {
              alert("Nella righa "+(i+1)+" della tabella giocatori Casa \n\hai inseirto un Carattere o tolto lo 0 di default!");
              return;
            }
          }
          for (i = 0; i < 18; i++) {
            if (isEmpty(document.RefertoForm.goalOspite[i].value) || isNaN(document.RefertoForm.goalOspite[i].value)
                || isEmpty(document.RefertoForm.cartelliniOspite[i].value) || isNaN(document.RefertoForm.cartelliniOspite[i].value)) {
              alert("Nella righa "+(i+1)+" della tabella giocatori Ospiti \n\hai inseirto un Carattere o tolto lo 0 di default!");
              return;
            }
          }
          /* Controllo se ho più di 2 cartellini */
          for (i = 0; i < 18; i++) {
            if (Maggiore(document.RefertoForm.cartelliniOspite[i].value)) {
              alert("Nella righa "+(i+1)+" della tabella giocatori Ospite\n\hai inseirto più di 2 cartellini!");
              return;
            }
          }
          for (i = 0; i < 18; i++) { 
            if (Maggiore(document.RefertoForm.cartelliniCasa[i].value)) {
              alert("Nella righa "+(i+1)+" della tabella giocatori Casa\n\hai inseirto più di 2 cartellini!");
              return;
            }
          }
          if(isNaN(document.RefertoForm.autogoalCasa.value) || isEmpty(document.RefertoForm.autogoalCasa.value)) {
            alert("Hai inserito in Autogoal Casa un carattere \n\ oppure non hai inserito nessun dato");
            return;
          }
          if (isNaN(document.RefertoForm.autogoalOspite.value) || isEmpty(document.RefertoForm.autogoalOspite.value)) {
            alert("Hai inserito in Autogoal Casa un carattere \n\oppure non hai inserito nessun dato");
            return;
          }
          if (tip === "E") {
            if(sommaCasa == sommaOspite) {
              alert("ERRORE. La partita fa parte di un torneo ad eliminazione diretta quindi non può terminare con un pareggio!");
              return;
            }
          }
          var req = confirm("Salvare il seguente referto? \n\Dopo il salvataggio non sarà più possibile modificare i dati inseriti");
          if (req === true)
            document.RefertoForm.submit();
          return;
        }
        
        function annulla() {
          
          var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
          if(req === true)
            document.annullaForm.submit();
          return;
        }
        
    </script>
        
        
  </head>
    
    <body>
        
        <form name="annullaForm" action="homeR.jsp" method="post">
            <input type="hidden" name="status" value="view"/> <!-- Vedere se lo stato view va bene-->
        </form> 
        
        
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
                   
                   <h2 class="green" align="center"><%=request.getParameter("nomeTorneo")%> </h2>
                   
              <% if((gestioneRefertiArbitro.getGiocatoriSquadraA().length==0)||(gestioneRefertiArbitro.getGiocatoriSquadraB().length==0))
                { %>
                <br><br>
                <h3 align="center"> Una o nessuna delle 2 squadre ha fornito la Formazione per questa partita
                                    Riprova più tardi o contatta l'amministratore </h3>
             <% }  else
                 {
        
                if(status.equals("new"))
                    {%>
                
                    <form name="OrariForm" action="dettagliReferto.jsp" method="post">
                    <br>
                    <table width="350" align="center">
                        <tr width="200">
                            <td>Oraio di inizio effettivo:</td>
                            <td><input type="text" name="oraInizio" size="5" maxlength="5"/></td>
                        </tr>
                        <tr width="200">
                            <td>Oraio di fine effettivo:</td>
                            <td><input type="text" name="oraFine" size="5" maxlength="5"/></td>
                        </tr>
                        
                    </table>               
                    <br>
                    <table width="300" align="center">
                        <tr>
                            <td align="center">
                                <input type="button" value="Annulla" onClick="annulla()"/>
                            </td>
                            <td align="center">
                                <input type="button" value="conferma orari" onClick="confermaOrari()"/>
                            </td>  
                        </tr>
                    </table>
                    <br>
                    

                    <input type="hidden" name="IDPartita" value="<%=request.getParameter("IDPartita")%>"/>
                    <input type="hidden" name="IDSquadraA" value="<%=request.getParameter("IDSquadraA")%>"/>
                    <input type="hidden" name="IDSquadraB" value="<%=request.getParameter("IDSquadraB")%>"/>
                    <input type="hidden" name="nomeSquadraA" value="<%=request.getParameter("nomeSquadraA")%>"/>
                    <input type="hidden" name="nomeSquadraB" value="<%=request.getParameter("nomeSquadraB")%>"/>
                    <input type="hidden" name="IDReferto" value="<%=request.getParameter("IDReferto")%>"/>
                    <input type="hidden" name="IDTorneo" value="<%=request.getParameter("IDTorneo")%>"/>
                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nomeTorneo")%>"/>
                    <input type="hidden" name="tipoTorneo" value="<%=request.getParameter("tipoTorneo")%>"/>
                    <input type="hidden" name="data" value="<%=request.getParameter("data")%>"/>
                    <input type="hidden" name="status" value="new2"/>
                
                </form>
   
              <% } } %>
              
              
              
              
              
              <%if(status.equals("new2"))
                {%>
                
                <br>
                
                <form name="RefertoForm" action="referti.jsp" method="post">
                    <input type="hidden" name="status" value="insert"/>
                
                    <table class="formazione">
                        <tr height="60" valign="bottom">
                            <td align="center"> <h2 align="center"> <%=request.getParameter("nomeSquadraA")%> </h2></td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td align="center"> <h2 align="center"> <%=request.getParameter("nomeSquadraB")%> </h2></td>
                        </tr>
                        <tr height="40" valign="bottom">
                            <td align="center"> <h3 class="fred">TITOLARI DELLA FORMAZIONE </h3></td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td align="center"> <h3 class="fred">TITOLARI DELLA FORMAZIONE </h3></td>
                        </tr>
                        <tr>
                            <td> <!-- tabella titolarisquadra A-->
                                <table class="calendario" width="470" align="center">
                                    <tr>

                                        <th class="calendario" align="center">Foto</th>
                                        <th class="calendario" align="center">Giocatore</th>
                                        <th class="calendario" align="center" width="70">Goal</th>
                                        <th class="calendario" align="center" width="70">Cartellini</th>
                                    </tr>


                                    <%for (i=0; i<11; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).nome%> <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).cognome%></td>
                                        <td class="su" align="center"><input type="text" name="goalCasa" onchange="goalCasa()" size="2" maxlength="2" value="0"/></td>
                                        <td class="su" align="center"><input type="text" name="cartelliniCasa" onchange="cartelliniCasa()" size="2" maxlength="2" value="0"/></td>
                                    </tr>
                                    <%}%>

                                 </table>
                             </td>
                             <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp</td>
                             <td><!-- tabella titolarisquadra B-->
                                <table class="calendario" width="470" align="center">
                                    <tr>

                                        <th class="calendario" align="center">Foto</th>
                                        <th class="calendario" align="center">Giocatore</th>
                                        <th class="calendario" align="center" width="70">Goal</th>
                                        <th class="calendario" align="center" width="70">Cartellini</th>
                                    </tr>


                                    <%for (i=0; i<11; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).nome%> <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).cognome%></td>
                                        <td class="su" align="center"><input type="text" name="goalOspite" onchange="goalOspite()" size="2" maxlength="2" value="0"/></td>
                                        <td class="su" align="center"><input type="text" name="cartelliniOspite" onchange="cartelliniOspite()" size="2" maxlength="2" value="0"/></td>
                                    </tr>
                                    <%}%>

                                 </table>
                             </td>
                        </tr>
                        <tr height="50" valign="bottom">
                            <td align="center"> <h3 class="fred">RISERVE DELLA FORMAZIONE </h3> </td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td align="center"> <h3 class="fred">RISERVE DELLA FORMAZIONE </h3></td>
                        </tr>
                        <tr>
                            <td><!-- tabella Riserve squadra A-->
                                <table class="calendario" width="470" align="center">
                                    <tr>

                                        <th class="calendario" align="center">Foto</th>
                                        <th class="calendario" align="center">Giocatore</th>
                                        <th class="calendario" align="center" width="70">Goal</th>
                                        <th class="calendario" align="center" width="70">Cartellini</th>
                                    </tr>

                                    <%for (i=11; i<gestioneRefertiArbitro.getGiocatoriSquadraA().length; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).nome%> <%=gestioneRefertiArbitro.getGiocatoriSquadraA(i).cognome%></td>
                                        <td class="su" align="center"><input type="text" name="goalCasa" onchange="goalCasa()" size="2" maxlength="2" value="0"/></td>
                                        <td class="su" align="center"><input type="text" name="cartelliniCasa" onchange="cartelliniCasa()" size="2" maxlength="2" value="0"/></td>
                                    </tr>
                                    <%}%>

                                </table>
                            </td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td><!-- tabella Riserve squadra B-->
                                <table class="calendario" width="470" align="center">
                                    <tr>

                                        <th class="calendario" align="center">Foto</th>
                                        <th class="calendario" align="center">Giocatore</th>
                                        <th class="calendario" align="center" width="70">Goal</th>
                                        <th class="calendario" align="center" width="70">Cartellini</th>
                                    </tr>

                                    <%for (i=11; i<gestioneRefertiArbitro.getGiocatoriSquadraA().length; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).nome%> <%=gestioneRefertiArbitro.getGiocatoriSquadraB(i).cognome%></td>
                                        <td class="su" align="center"><input type="text" name="goalOspite" onchange="goalOspite()" size="2" maxlength="2" value="0"/></td>
                                        <td class="su" align="center"><input type="text" name="cartelliniOspite" onchange="cartelliniOspite()" size="2" maxlength="2" value="0"/></td>
                                    </tr>
                                    <%}%>

                                </table>
                            </td>
                        </tr>
                        <tr height="50" valign="bottom">
                            <td align="center"> <h3 class="fred">INSERISCI IL NUMERO DI AUTOGOAL </h3></td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td align="center"> <h3 class="fred">INSERISCI IL NUMERO DI AUTOGOAL </h3></td>
                        </tr>
                        <tr height="60" valign="baseline">
                            <td align="center"><input type="text" name="autogoalCasa" onchange="goalOspite()" size="5" maxlength="2" value="0"/></td>
                            <td align="center" width="80"> &nbsp&nbsp&nbsp&nbsp </td>
                            <td align="center"><input type="text" name="autogoalOspite" onchange="goalCasa()" size="5" maxlength="2" value="0"/></td>
                        <tr>
                    </table> 
                     
                    <input type="hidden" name="oraInizio" value="<%=request.getParameter("oraInizio")%>"/>
                    <input type="hidden" name="oraFine" value="<%=request.getParameter("oraFine")%>"/>
                    <input type="hidden" name="risultato" value="<%=request.getParameter("risultato")%>"/>
                    
                                    
                    <input type="hidden" name="IDPartita" value="<%=request.getParameter("IDPartita")%>"/>
                    <input type="hidden" name="IDSquadraA" value="<%=request.getParameter("IDSquadraA")%>"/>
                    <input type="hidden" name="IDSquadraB" value="<%=request.getParameter("IDSquadraB")%>"/>
                    <input type="hidden" name="nomeSquadraA" value="<%=request.getParameter("nomeSquadraA")%>"/>
                    <input type="hidden" name="nomeSquadraB" value="<%=request.getParameter("nomeSquadraB")%>"/>
                    <input type="hidden" name="IDReferto" value="<%=request.getParameter("IDReferto")%>"/>
                    <input type="hidden" name="IDTorneo" value="<%=request.getParameter("IDTorneo")%>"/>
                    <input type="hidden" name="tipoTorneo" value="<%=request.getParameter("tipoTorneo")%>"/>
                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nomeTorneo")%>"/>
                                    
                </form>
                    
                <table width="450" align="center">
                    <tr>
                        <td align="center" width="200">
                            <input type="button" value="Annulla" onClick="annulla()"/>
                        </td>
                        <td align="center" width="200">
                            <input type="button" value="Conferma" onClick="Salva()"/>
                        </td>  
                    </tr>
                </table>
                    
                
              <% }
                 %>
                   
            <br>
    
                <table align="center" width="1000"></table>
                  
               </div>
           </div>
       </div>
    </body>
</html>