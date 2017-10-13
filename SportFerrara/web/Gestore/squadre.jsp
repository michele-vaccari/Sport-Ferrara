<%@ page info="Visualizza Squadra" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneSquadre" scope="page" class="bflows.SquadraManagement" />
<jsp:setProperty name="gestioneSquadre" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  gestioneSquadre.setGestore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* status = view || status = modify */
  if (status.equals("view")||status.equals("modify"))
    gestioneSquadre.visualizzaSquadra();
  
  /* status = modifySquadra */
  if (status.equals("modifySquadra"))
    gestioneSquadre.modificaSquadreVisualizza();
  
  /* Gestione degli errori */
  if (gestioneSquadre.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  }
  else if (gestioneSquadre.getResult() == -2) {
    message=gestioneSquadre.getErrorMessage();
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
      
      d = document;
      
      function isEmpty(value) {
        if (value == null || value.length == 0)
          return true;
        for (var count = 0; count < value.length; count++) {
          if (value.charAt(count) != " ") 
            return false;
        }
        return true;
      } 
      
      function insertGiocatore() {
        d.forms["insertFormGiocatoreContinuo"].submit();
        return;
       }
      
      function updateSquadra() {
        if(isEmpty(d.compilaForm.nomeSquadra.value)) {
          alert("Compila il campo Nome squadra!");
          return;
        }
        if(isEmpty(d.compilaForm.sede.value)) {
          alert("Compila il campo Sede!");
          return;
        }
        if(isEmpty(d.compilaForm.descrizione.value)) {
          alert("Inserisci almeno una breve descrizione!");
          return;
        }
        
        var req = confirm("Confermi i dati appena inseriti?");
        if(req === true)
          d.compilaForm.submit();
        return;
      }
      
      function Modify() {
        d.modifyForm.submit();
        return;
      }
      
      function backHome() {
        d.homeForm.submit();
        return;
      }
      
      function annulla() {
        var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
        if(req === true)
          d.document.annullaForm.submit();
        return;
      }
      
      function BottoneSquadra() {
        d.document.forms["bottoneFormSquadra"].submit();
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
             
                <table align="center" width="600">
                    <tr>
                        <td>
                            <br><h2  class="green" align="center"> <%=gestioneSquadre.getSquadra().nomeSquadra%> </h2><br>  
                        </td>
                    <% if (!gestioneSquadre.getSquadra().flag.equals("N"))
                    { %>
                        <td align="right">
                            <img class="logoSquadra" src="../Immagini/<%=gestioneSquadre.getSquadra().logoSquadra%>" width="85" height="85" /> 
                        </td>
                    <% } else { %>
                        <td align="right">
                            <img class="logoSquadra" src="../Immagini/defaultImmagine.png" width="85" height="85" /> 
                        </td>
                     <% } %>
                    </tr>
                </table><br>
                

                <% if (gestioneSquadre.getSquadra().flag.equals("N")||request.getParameter("status").equals("modify"))
                { %>
                
                <br><h3 align="center"> Compila i seguenti campi e poi conferma! </h3> <br><br>
                
                <form name="compilaForm" action="squadre.jsp" method="post">
                <table align="center" width="950">
                    <tr>                         
                        <td align="right" width="175" height="35"><b>Nome</b></td>
                        <td width="260">
                            <input type="text" name="nomeSquadra" size="25" maxlength="30" value="<%=gestioneSquadre.getSquadra().nomeSquadra!=null?gestioneSquadre.getSquadra().nomeSquadra:""%>">
                        </td>
                        <td align="right" width="175" height="35"><b>Sede</b></td>
                        <td width="260">
                            <input type="text" name="sede" size="25" maxlength="30" value="<%=gestioneSquadre.getSquadra().sede!=null?gestioneSquadre.getSquadra().sede:""%>">
                        </td> 
                    </tr>
                    <tr> 
                        <td align="right" width="175" height="35"><b>Foto Squadra</b></td>
                        <td width="260" >
                            <input type="file" name="immagineSquadra" onchange="upload()">
                        </td>
                        <td align="right" width="175" height="35"><b>Logo Squadra</b></td>
                        <td width="260" >
                            <input type="file" name="logoSquadra" onchange="upload()">
                        </td>
                    </tr> 
                    <tr>                         
                        <td align="right"  width="175" height="35"><b>Sponsor Ufficiale</b></td>
                        <td width="260">
                            <input type="text" name="nomeSponsor" size="25" maxlength="50" value="<%=gestioneSquadre.getSquadra().nomeSponsor!=null?gestioneSquadre.getSquadra().nomeSponsor:""%>">
                        </td>
                        <td align="right" width="175" height="35"><b>Immagine Sponsor</b></td>
                        <td width="260" >
                            <input type="file" name="logoSponsor" value="<%=gestioneSquadre.getSquadra().logoSquadra!=null?gestioneSquadre.getSquadra().logoSquadra:""%>">
                        </td>
                    </tr>  
                    <tr>                         
                        <td align="right" width="175" height="35"><b>Descrizone</b></td>
                        <td width="260">
                            <textarea name="descrizione" rows="5" cols="24" maxlength="5000"><%=gestioneSquadre.getSquadra().descrizione!=null?gestioneSquadre.getSquadra().descrizione:""%></textarea>
                        </td>
                    </tr>
                </table>
                <br><br>
              
                <% if(gestioneSquadre.getSquadra().flag.equals("N"))
                  { %>
                    <div align='center'>
                        <input type="button" value="Conferma Dati Squadra" onClick="updateSquadra()"/>
                    </div>
              <% } else { %>
                    <div align='center'>
                       <input type="button" value="Conferma Modifiche" onClick="updateSquadra()"/>
                    </div>  
              <% } %>
                <input type="hidden" name="status" value="modifySquadra"/>
                <input type="hidden" name="flag" value="Y"/>
                </form>
                        

                <% }
                else
                { %>
                
                <div align="center" >
                <img src="../Immagini/<%=gestioneSquadre.getSquadra().immagineSquadra%>" width="800" height="450"/>
                </div>
                <br>
    
                
    
                <div align="center">
                   <br>
                   <h4 class="green"> Sede attuale: <%=gestioneSquadre.getSquadra().sede%></h4><br>
                   <h5> <%=gestioneSquadre.getSquadra().descrizione%> </h5>
               </div>
               <br><br>
                <table align="center" width="800">
                    <tr>
                        <td  align="center" width="300">
                            <br><br><h4 class="green"> Sponsor Ufficiale</h4><br> <h3><%=gestioneSquadre.getSquadra().nomeSponsor%> </h3><br><br>
                        </td>    
                        <td  align="center">
                            <img class="logoSponsor" src="../Immagini/<%=gestioneSquadre.getSquadra().logoSponsor%>" width="350" height="150" />
                        </td>
                    </tr>
                </table>
                
               
 
                <br><br>
                <table align="center">
                <tr>
                <% if(!gestioneSquadre.getSquadra().flag.equals("N"))
                    { %>
                    <td align="center">
                        <form name="modifyForm" action="squadre.jsp" method="post">
                            <input type="button" value="Modifica" onClick="Modify()"/>
                            <input type="hidden" name="status" value="modify"/>
                            <input type="hidden" name="flag" value="Y"/>
                        </form>
                    </td>
                 <% }
                    else 
                    {  %>
                    <td align="center">
                        <form name="modifyForm" action="squadre.jsp" method="post">
                            <input type="button" value="Compila Ora la Tua Squadra" onClick="Modify()"/>
                            <input type="hidden" name="status" value="modify"/>
                            <input type="hidden" name="flag" value="Y"/>
                        </form>
                    </td>
                 <% } %>
                    <td>
                        <form name="homeForm" action="homeG.jsp" method="post">
                            <input type="button" value="Home" onclick="backHome()"/>
                            <input type="hidden" name="status" value="view"/>
                        </form>     
                    </td>
                    
                    <% if(!gestioneSquadre.getSquadra().flag.equals("N"))
                        { %>
                    <td align="center">
                        <form action="dettagliGiocatori.jsp"> 
                            <input type="button" value="Inserisci nuovo Giocatore" onClick="insertGiocatore()"/>
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
                    </td>
                    <% } %>
                </tr>
                </table>
                

                <% } %>
                      
                <table align="center" width="950"></table>
                
            </div>
        </div>
    </div> 

    
    <%if (message!=null) {%>
        <script>alert("<%=message%>");</script>
    <%}%>

  </body>
</html>