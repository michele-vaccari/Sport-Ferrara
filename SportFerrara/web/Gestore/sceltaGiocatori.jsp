<%@ page info="Compila Formazione" %>
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
  
  /* Setto l'SSN del gestore della squadra nel bean */
  gestioneFormazioni.setGestore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status; 
  int i;
  
  gestioneFormazioni.visualizzaGiocatori();/*gestioneFormazioni.GiocatoriView();*/
  
  /* Gestione degli errori */
  if (gestioneFormazioni.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneFormazioni.getResult() == -2) {
    message=gestioneFormazioni.getErrorMessage();
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
      
      function conta(giocatori) {
        var checked = 0;
        for(var i = 0, n = giocatori.length; i < n; giocatori.item(i++).checked && checked++);
        return checked;
      }

      function controlla(titolari, riserve) {
        for (var i = 0; i < titolari.length; i++ ) {
          if(titolari.item(i).checked && riserve.item(i).checked)
            return true;
          }
        return false;
      }

      function Avanti() {

        if(controlla(document.forms.giocatori.titolari,document.forms.giocatori.riserve)) {
          alert("Un giocatore non può essere contemporaneamente titolare e riserva!");
          return;
        }

        var count = conta(document.forms.giocatori.titolari);
        if(count < 11) {
          alert("È neccessario inserire 11 giocatori titolari");
          return;
        }

        count = conta(document.forms.giocatori.riserve);
        if(count < 7) {
          alert("È neccessario inserire 7 riserve");
          return;
        }
        var req = confirm("Vuoi confermare la FORMAZIONE? se confermi non potrai più modificara");

        if (req === true)
          document.giocatori.submit();
        return;
      }

      function checkboxlimit(checkgroup, limit) {
        for (var i = 0; i < checkgroup.length; i++) {
          checkgroup[i].onclick = function() {
            var checkedcount = 0;
            for (var i = 0; i < checkgroup.length; i++)
              checkedcount += (checkgroup[i].checked)? 1 : 0;
            if (limit === 11) {
              if (checkedcount > limit) {
                alert("Hai già raggiunto il limite di " + limit + " giocatori selezionabili");
                this.checked = false;
                checkedcount = limit;
              }
              document.getElementById("L1").innerHTML = "<b>" + checkedcount + "</b>";
            }
            else {
              if (checkedcount > limit) {
                alert("Hai già raggiunto il limite di " + limit + " giocatori selezionabili");
                this.checked = false;
                checkedcount = limit;
              }
              document.getElementById("L2").innerHTML="<b>" + checkedcount + "</b>";
            }
          }
        }
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
                        
                        <li><a class="button" href="javascript: BottoneSquadra()">SQUADRA</a></li>
                        
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
                   
                <% if(gestioneFormazioni.getGiocatori().length==0)
                   { %>
                        <br><br>
                        <h3 align="center" class="green"> NON HAI ANCORA INSERITO GIOCATORI NELLA ROSA DELLA SQUADRA </h3>
                        <br><br>
                        <div align="center">
                            <input type="button" value="Torne alla Home" onClick="home()"/>
                        </div>
                        
                <% } else { %>
                   
                   <h4 align="center"> Scegli 11 giocatori Titolari e 7 Riserve</h4>
                   
                   <table class="calendario" align="center" width="850">
                        <tr> 
                            <th class="calendario" align="center">Foto</th>
                            <th class="calendario" align="center">Nome</th>
                            <th class="calendario" align="center">Cognome</th>
                            <th class="calendario" align="center">N° Maglia</th>
                            <th class="calendario" align="center">Ruolo</th>
                            <th class="calendario" align="center">Titolare</th>
                            <th class="calendario" align="center">Riserva</th>
                        </tr>          
                                
                        <form id="giocatori" name="giocatori" action="newFormazione.jsp" method="post">
                                <% for (i=0;i<gestioneFormazioni.getGiocatori().length;i++)
                                {%>  
                                    
                                        <tr>
                                        
                                            <td class="giu" align="center">
                                                <img src="../Immagini/<%=gestioneFormazioni.getGiocatori(i).foto%>" width="75" height="75" />
                                            </td>
                                            <td class="giu" align="center"><%=gestioneFormazioni.getGiocatori(i).nome%></td>
                                            <td class="giu" align="center"><%=gestioneFormazioni.getGiocatori(i).cognome%></td>
                                            <td class="giu" align="center"><%=gestioneFormazioni.getGiocatori(i).numeroMaglia%> </td>
                                            <td class="giu" align="center"><%=gestioneFormazioni.getGiocatori(i).ruolo%></td>
                                            <td class="su" align="center"> <input name="titolari" type="checkbox" value="<%=gestioneFormazioni.getGiocatori(i).SSNGiocatore%>"/></td>
                                            <td class="su" align="center"> <input name="riserve" type="checkbox" value="<%=gestioneFormazioni.getGiocatori(i).SSNGiocatore%>"/></td>
                                        </tr>
                                    <%                                    
                                }%>
                                
                        <input type="hidden" name="IDReferto" value="<%=request.getParameter("IDReferto")%>"/>
                        <input type="hidden" name="status" value="insert"/>
                        </form>
 
                     </table>
                        
                <br><br>
                
                
                <script type="text/javascript">
                            checkboxlimit(document.forms.giocatori.titolari, 11);
                            checkboxlimit(document.forms.giocatori.riserve, 7);
                </script>
                
                        <br>
                        <table width="300" align="center">
                           <td align="center" width="900" height="35">
                               <input type="button" value="Annulla" onClick="annulla()"/>
                           </td>    
                            <td align="right" width="200" height="35">
                                <input type="button" value="Conferma Formazione" onClick="Avanti()"/> 
                            </td>
                        </table>
               
            <% } %>
                  
                <table align="center" width="1000"></table>
                
               </div>
           </div>
       </div>
    </body>
</html>