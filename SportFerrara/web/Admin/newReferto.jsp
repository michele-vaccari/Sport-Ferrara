<%@ page info="Assegna Arbitro" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneReferti" scope="page" class="bflows.RefertiManagement" />
<jsp:setProperty name="gestioneReferti" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Setto il creatore del torneo */
  gestioneReferti.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  int i;
  
  /* Leggo lo status */
  String status = request.getParameter("status");
  
  /* Default status = new */
  if (status == null)
    status = "new";
  
  /* status = new */
  if (status.equals("new") || status.equals("newReferto"))
    gestioneReferti.visualizzaTornei();
  
  if (status.equals("modify"))
    gestioneReferti.visualizzaTorneiModifica(Integer.parseInt(request.getParameter("IDTorneo")));
  
  if (status.equals("conferma"))
    gestioneReferti.visualizzaTorneiModificaConferma(Integer.parseInt(request.getParameter("IDTorneo")));
  
  /* Gestione degli errori */
  if (gestioneReferti.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } else if (gestioneReferti.getResult() == -2) {
    message = gestioneReferti.getErrorMessage();
  }
%>

<!DOCTYPE html>
<html>
  <head>
    <title>SportFerrara - <%= getServletInfo() %> </title>
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
      
      function controlloData(d) {
        
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
      
      function controlloOra(orario) {
        
        var o, m;

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

      function insertReferto() {
        
        if(document.getElementById('Incontri').value === "") {
          alert("Selezionare un incontro");
          return;
        }
        if(document.getElementById('Arbitro').value === "") {
          alert("Selezionare un arbitro");
          return;
        }
        if(isEmpty(insertForm.data.value)) {
          alert("Non è stato inseirto la data della partita!");
          return;
        }
        if(controlloData(insertForm.data.value)) {
          alert("Formato data errato, usare gg-mm-aaaa!");
          return;
        }
        if(isEmpty(insertForm.ora.value)) {
          alert("Inserisci almeno un orario approssimativo di inizio partita!");
          return;
        }
        if(controlloOra(insertForm.ora.value)) {
          alert("Formato ora errato, usare hh:mm!");
          return;
        }
        if(isEmpty(insertForm.luogo.value)) {
          alert("Non è stata inseirto il luogo in cui si disputerà la partita!");
          return;
        }

        var req = confirm("Sei sicuro di voler Assegnare l'arbitro alla Partita?");

        if(req === true)
          insertForm.submit();

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
                   
                   
                   <h3 class="green" align="center"> Assegnazione arbitro a Partita</h3>
                   <br><br>
                   
                    <table align="center">
                      
                      <tr>
                        <td width="200" height="40" align="right"><b>Torneo</b></td>
                        <td>
                          <form name="Torneo" action="newReferto.jsp" method="post">
                            <div align="center">
                                <select id="IDTorneo" name="IDTorneo">
                                  <option value=""></option>
                                  <% if (status.equals("new")) {
                                      for (i=0; i<gestioneReferti.getTornei().length; i++) { %>
                                         <option value="<%=gestioneReferti.getTornei(i).IDTorneo%>"><%=gestioneReferti.getTornei(i).nome%> --> Tipo:<%=gestioneReferti.getTornei(i).tipologia%></option>
                                    <% } } else { for (i=0; i<gestioneReferti.getTornei().length; i++) { %>
                                    <option value="<%=gestioneReferti.getTornei(i).IDTorneo%>" <%=request.getParameter("IDTorneo").equals(""+gestioneReferti.getTornei(i).IDTorneo)?"selected":""%>><%=gestioneReferti.getTornei(i).nome%> --> Tipo:<%=gestioneReferti.getTornei(i).tipologia%></option>
                                    <%} }%>%>
                                </select>  
                            </div>
                            <input type="hidden" name="status" value="modify"/>
                          </form>
                        </td>
                      </tr>
                      
                      <% if (status.equals("modify") || status.equals("conferma")) { %>
                        <tr>
                          <td width="200" height="40" align="right"><b>Giornata/Fase</b></td>
                          <form name="fase" action="newReferto.jsp" method="post">
                            <td>
                              <select id="Fasi" name="fase">
                                <option value=""></option>    
                                 <% if (status.equals("modify")) {
                                      for (i=0; i<gestioneReferti.getFasi().length; i++) { %>
                                      <option value="<%=gestioneReferti.getFasi(i)%>"><%=gestioneReferti.getFasi(i)%></option>
                                     <% } } else { for (i=0; i<gestioneReferti.getFasi().length; i++) { %>
                                      <option value="<%=gestioneReferti.getFasi(i)%>" <%=request.getParameter("fase").equals(gestioneReferti.getFasi(i))?"selected":""%>><%=gestioneReferti.getFasi(i)%></option>
                                     <% } } %>
                              </select>
                            </td>
                            <input type="hidden" name="IDTorneo" value="<%=request.getParameter("IDTorneo")%>"/>
                            <input type="hidden" name="status" value="conferma"/>
                          </form>
                        </tr>
                      <% } %>
                        
                        
                    <%  if (status.equals("conferma"))
                          if(gestioneReferti.getIncontri().length!=0) { %>
                        <form name="insertForm" action="referti.jsp" method="post">
                          
                            <tr>
                                <td width="200" height="40" align="right"><b>Partita</b></td>
                            <form name="incontri" action="newReferto.jsp" method="post">
                                    <td><select id="Incontri" name="IDPartita">
                                            <option value=""></option>  
                                        <% if (gestioneReferti.getIncontri().length!=0) {
                                              for (i=0; i<gestioneReferti.getIncontri().length; i++)
                                              {%>
                                              <option value="<%=gestioneReferti.getIncontri(i).IDPartita%>"> <%=gestioneReferti.getNomeSquadreA(i)%> - <%=gestioneReferti.getNomeSquadreB(i)%> </option>
                                              <%}%>
                                              </select></td>
                                          <%}
                                          else
                                          {%>
                                                </select></td>
                                                <td align="center"> Nessuna partita <br>disponibile </td>
                                          <%}%>
                                            
                                        <input type="hidden" name="status" value="newReferto"/>
                             
                                              
                            </tr>
                            <tr>
                                <td width="200" height="40" align="right"><b>Arbitro</b></td>
                                <td><select id="Arbitro" name="Arbitro">
                                        <option value=""></option>    
                                    <%
                                    for (i=0; i<gestioneReferti.getArbitri().length; i++)
                                    {%>
                                        <option value="<%=gestioneReferti.getArbitri(i).SSN%>"><%=gestioneReferti.getArbitri(i).nome%> <%=gestioneReferti.getArbitri(i).cognome%></option>
                                    <%}%>
                                    </select>
                                </td>
                            </tr>
          
                            <tr>
                                <td width="200" height="40" align="right"><b>Data Partita</b></td>
                                <td><input type="text" name="data" size="10" maxlength="10" value=""/></td>
                            </tr>
                            <tr>
                                <td width="200" height="40" align="right"><b>Orario Partita</b></td>
                                <td><input type="text" name="ora" size="5" maxlength="5" value=""/></td>
                            </tr>
                            <tr>
                                <td width="200" height="40" align="right"><b>Luogo Partita</b></td>
                                <td><input type="text" name="luogo" size="15" maxlength="50" value=""/></td>
                            </tr>
                            
                        </form>
                            
                            
                            
                        <%} else {%>
                        <tr> <td></td> <td align="center"> Nessuna partita disponibile </td></tr>
                        <% }%>
                        
                    </table>
                    <br><br>
                    
                    <div align="center">
                        <table>
                            <tr align="center">
                                <input type="button" value="Annulla" onClick="annulla()"/>
                            </tr>
                            <%if (status.equals("conferma")&&(gestioneReferti.getIncontri().length!=0))
                            {%>
                            <tr width="50"> </tr>
                            <tr align="center">
                                <input type="button" value="Conferma assegnazione" onclick="insertReferto()"/>
                            </tr>    
                            <%}%>
                        </table>
                    </div>
    
                       
                <table align="center" width="500"></table>
                  
                
              <script>
                   var torneoSelect=document.getElementById('IDTorneo');
                   var faseSelect=document.getElementById('Fasi');

                   torneoSelect.addEventListener('change',function() {
                     document.Torneo.submit();
                   });

                   faseSelect.addEventListener('change',function() {
                     if (!this.value==(""))
                       document.fase.submit();
                   });
              </script>
                
                
               </div>
           </div>
       </div>
    </body>
</html>