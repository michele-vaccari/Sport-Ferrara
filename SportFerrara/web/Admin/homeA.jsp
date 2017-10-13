<%@ page info="Home Amministratore" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
%>

<!DOCTYPE html>
<html>
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
    
    <script src="../js/admin/homeA.js"></script>
  </head>
    
  <body>
        
    <div id="header-container">
      <div id="header">
        <h1>SportFerrara</h1>             
      </div>
      <div>
        <ul id="menu">
          <li><a class="button" href="homeA.jsp">MyHOME</a></li>
          <li><a class="button" href="tornei.jsp">TORNEI</a></li>
          <li><a class="button" href="utenti.jsp">UTENTI</a></li>
          <li><a class="button" href="refertiView.jsp">REFERTI</a></li>
          <% if (loggedOn){ %>
            <form name="logoutForm" action="../login.jsp" method="post">
              <input type="hidden" name="status" value="logout"/>
            </form>  
            <li><a class="button" href="javascript:logoutForm.submit()">LOGOUT</a></li> 
          <% } else { %>
            <li><a class="button" href="login.jsp">LOGIN</a></li> 
          <% } %>
        </ul>
      </div>
    </div>
                        
    <div id="main">
      <div id="container">
        
        <div id="content">    
          <table align="center">
            <tr>
              <td>
                <div id="content-set">
                  <a href="javascript:insertArbitro()">Nuovo<br>Arbitro</a>
                </div>
              </td>
              <td>
                <div id="content-set">
                  <a href="javascript:insertGestore()">Nuovo<br>Gestore Squadra</a>
                </div>
              </td>
            </tr>
              <tr>
                <td>
                  <div id="content-set">
                    <a href="javascript:insertTorneoItaliana()">Nuovo<br> Torneo Italiana</a>
                  </div>                       
                </td>
                <td>
                  <div id="content-set">
                    <a href="javascript:insertTorneoEliminazione()">Nuovo<br> Torneo Eliminazione</a>
                  </div>
                </td>
              </tr>
          </table>
          <table align="center">
            <tr>
              <td>
                <div id="content-set">
                  <a href="javascript:insertReferto()">Assegna<br> Arbitro</a>
                </div>
              </td>
            </tr>
          </table>

        </div>
        
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


        <form name="TorneoItaliana" method="post" action="newTorneo.jsp">
            <input type="hidden" name="tipologia" value="I"/>
            <input type="hidden" name="nome" value=""/>
            <input type="hidden" name="numeroSquadre" value=""/>
            <input type="hidden" name="descrizione" value=""/>
            <input type="hidden" name="IDTorneo" value=""/>
            
            <input type="hidden" name="status" value="newI"/>
        </form>

        <form name="TorneoEliminazione" method="post" action="newTorneo.jsp">
            <input type="hidden" name="tipologia" value="E"/>
            <input type="hidden" name="nome" value=""/>
            <input type="hidden" name="descrizione" value=""/>
            <input type="hidden" name="IDTorneo" value=""/>

            <input type="hidden" name="status" value="newE"/>
        </form>

        <form name="ArbitroFormReferto" method="post" action="newReferto.jsp">
          
            <input type="hidden" name="status" value="new"/>
        </form>
        
      </div>
    </div>
  </body>
    
</html>
