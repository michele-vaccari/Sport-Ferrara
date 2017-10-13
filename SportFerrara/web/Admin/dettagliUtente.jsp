<%@ page info="Modulo Utente" %>
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
  
  /* Setto l'SSN dell'amministratore */
  gestioneUtenti.setAdmin(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  /* status = insertArbitro */
  if(status.equals("insertArbitro"))
      gestioneUtenti.inserisciArbitro();
  
  /* status = insertGestore */
  if (status.equals("insertGestore"))
      gestioneUtenti.inserisciGestore();
  
  /* status = modifyArbitro */  
  if (status.equals("modifyArbitro"))
      gestioneUtenti.modificaArbitro();
  
  /* status = modifyGestore */
  if (status.equals("modifyGestore"))
      gestioneUtenti.modificaGestore(); 
  
  /* Gestione degli errori */
  if (gestioneUtenti.getResult()==-1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneUtenti.getResult()==-2) {
    message=gestioneUtenti.getErrorMessage();
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

      function controlloMail(mail) {
        
        if ((mail.indexOf("@") == "-1") || (mail.indexOf(".") == "-1") || ((mail.length - 5) < mail.indexOf("@"))) {
          return true;
        }
        return false;
      }

      function controlloPassword(password) {
        
        if (password.length === 0) {
          return true;
        }
        
        if((password.length) < 8) {
          return true;
        }

        var i = 0, num = 0, alfa = 0;

        for(i = 0; i < (password.length); i++) {
          if (((password.charAt(i)) >= '0') && ((password.charAt(i)) <= '9' ))
            num = num + 1;
          if (((((password.charAt(i)) >= 'a') || (password.charAt(i)) >= 'A')) && (((password.charAt(i)) <= 'z' )||((password.charAt(i)) <= 'Z' )))
            alfa = alfa + 1;
        }

        if((num == 0) || (alfa == 0)) {
          return true;
        }   
        return false;
      }
      
      function controlloTelefono(telefono) {
        
        if(((telefono.length) < 6)) {
          return true;
        }
        if(isNaN(telefono)) {
          return true;
        }
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
        a = d[6] + d[7] + d[8] + d[9]; /*anno*/

        if((isNaN(g)) || (isNaN(m)) || (isNaN(a)))
          return true;

        if ((m == 2) && (g > 29))                   
          return true;

        if (((m == 4) || (m == 6)|| (m == 9) || (m == 11)) && (g > 30))
          return true;

        return;
      }

      function insertArbitro() {
        
        if(isEmpty(insertForm.nome.value)) {
          alert("Non è stato inseirto il Nome!");
          return;
        }
        if(isEmpty(insertForm.cognome.value)) {
          alert("Non è stato inseirto il Cognome!");
          return;
        }
        if(controlloPassword(insertForm.password.value)) {
          alert("Errore: la password deve essere almeno di 8 caratteri e alfanumerica");
          return;
        }
        if(isEmpty(insertForm.email.value)) {
          alert("La mail non è stata inserita!");
          return;
        }
        if(controlloMail(insertForm.email.value)) {
          alert("Errore nella scrittura formale della mail!");
          return;
        }
        if(isEmpty(insertForm.indirizzo.value)) {
          alert("Non è stato inseirto alcun indirizzo!");
          return;
        }
        if(isEmpty(insertForm.telefono.value)) {
          alert("Non è stato inseirto alcun numero di telefono!");
          return;
        }
        if(controlloTelefono(insertForm.telefono.value)) {
          alert("Il numero di telefono inserito non è valido!");
          return;
        }
        if(isEmpty(insertForm.data.value)) {
          alert("Non è stato inseirto la data di nascita!");
          return;
        }
        if(controlloDataN(insertForm.data.value)) {
           alert("Formato data errato, usare gg-mm-aaaa!");
           return;
        }
        if(isEmpty(insertForm.nazionalità.value)) {
           alert("Non è stata inseirta la Nazionalità!");
           return;
        } 
        insertForm.submit();
        return;
    }

    function insertGestore() {
      
      if(isEmpty(insertForm.nome.value)) {
        alert("Non è stato inseirto il Nome!");
        return;
      }
      if(isEmpty(insertForm.cognome.value)) {
        alert("Non è stato inseirto il Cognome!");
        return;
      }
      if(controlloPassword(insertForm.password.value)) {
        alert("Errore: la password deve essere almeno di 8 caratteri e alfanumerica");
        return;
      }
      if(isEmpty(insertForm.email.value)) {
        alert("La mail non è stata inserita!");
        return;
      }
      if(controlloMail(insertForm.email.value)) {
        alert("Errore nella scrittura formale della mail!");
        return;
      }
      if(isEmpty(insertForm.indirizzo.value)) {
        alert("Non è stato inseirto alcun indirizzo!");
        return;
      }
      if(isEmpty(insertForm.telefono.value)) {
        alert("Non è stato inseirto alcun numero di telefono!");
        return;
      }
      if(controlloTelefono(insertForm.telefono.value)) {
        alert("Il numero di telefono inserito non è valido!");
        return;
      }
      if (isEmpty(insertForm.squadra.value)) {
        alert("Inserire la squadra da lui gestita");
        return;
      }
      insertForm.submit();
      return;
    }

    function annulla() {
      
      var req = confirm("Sei sicuro di voler annullare? Tutti i dati inseiri/modificati andrannpo persi.");
      if (req === true)
        document.annullaForm.submit();
      return;
    }

    function conferma() {
      
      var req = confirm("Sei sicuro di voler confermare i dati inseriti?");
      if (req === true)
        document.confermaForm.submit();
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
        <% if (request.getParameter("type").equals("R"))
        { %>
            <h3 align="center"> Compila i seguenti campi per inserire un nuovo ARBITRO: </h3><br>
        <% }
        else
        { %>
            <h3 align="center"> Compila i seguenti campi per inserire un nuovo GESTORE: </h3><br>
        <% } %>
        <br>
                <form name="insertForm" action="dettagliUtente.jsp" method="post">
                <table align="center" width="900">
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
                        <td align="right"  width="175" height="35"><b>e-mail</b></td>
                        <td width="250">
                            <input type="text" name="email" size="25" maxlength="30" value="<%=request.getParameter("email")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Password</b></td>
                        <td width="250">
                            <input type="text" name="password" size="25" maxlength="16" value="<%=request.getParameter("password")%>"/>
                        </td>
                    </tr> 
                    <tr>                         
                        <td align="right"  width="175" height="35"><b>Indirizzo Civico</b></td>
                        <td width="250">
                            <input type="text" name="indirizzo" size="25" maxlength="50" value="<%=request.getParameter("indirizzo")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Telefono</b></td>
                        <td width="250">
                            <input type="text" name="telefono" size="25" maxlength="20" value="<%=request.getParameter("telefono")%>"/>
                        </td>
                    </tr>   
                    
                    <input type="hidden" name="type" value="<%=request.getParameter("type")%>"/>
                    
                    <% if(!((request.getParameter("status").equals("newG"))||(request.getParameter("status").equals("newR"))) & message == null) { 
                        if(request.getParameter("status").equals("insertArbitro")) { %>
                        <input type="hidden" name="SSN" value="<%=gestioneUtenti.getSSN()%>"/>
                        <% } else if(request.getParameter("status").equals("insertGestore")) { %>
                        <input type="hidden" name="SSN" value="<%=gestioneUtenti.getSSN()%>"/>
                        <% } else { %>
                        <input type="hidden" name="SSN" value="<%=request.getParameter("SSN")%>"/>
                     <% } } %>
                     
            <%if (request.getParameter("type").equals("R"))
            {%>
                
                    <tr>                         
                         <td align="right"  width="175" height="35"><b>Data nascita</b></td>
                        <td width="250">
                            <input type="text" name="data" size="25" maxlength="10" value="<%=request.getParameter("data")%>"/>
                        </td>
                        <td align="right"  width="175" height="35"><b>Nazionalità</b></td>
                        <td width="250">
                            <input type="text" name="nazionalità" size="25" maxlength="20" value="<%=request.getParameter("nazionalità")%>"/>
                        </td>
                    </tr> 
                    <tr>                         
                        <td align="right" width="175" height="35"><b>Foto</b></td>
                        <td width="175" >
                            <input type="file" name="foto" value="<%=request.getParameter("foto")%>" onchange="upload()">
                        </td>
                        <td align="right" width="175" height="35"><b>Carriera</b></td>
                        <td width="250">
                            <textarea name="carriera" rows="5" cols="24" maxlength="5000"><%=request.getParameter("carriera")%></textarea>
                        </td>
                    </tr>       
                
             <%}
             else 
             {%>
                
                    <tr>                         
                        <td align="right"  width="175" height="35"><b>Squadra</b></td>
                        <td width="250">
                            <input type="text" name="squadra" size="25" maxlength="30" value="<%=request.getParameter("squadra")%>"/>
                        </td>
                    </tr>     
                
                    
            <%}%>
            </table><br>
            
            <table align="center" width="350">
                <tr>
                    
                <%if ((request.getParameter("type").equals("R")))
                {%>
                    <% if(request.getParameter("status").equals("newR") || (request.getParameter("status").equals("insertArbitro") & message!=null)) {%>
                    <td align="center" width="150" height="35">
                    <input type="button" value="Conferma" onClick="insertArbitro()"/>
                    <input type="hidden" name="status" value="insertArbitro"/>
                    
                    <% } else {%>
                    <td align="center" width="150" height="35">
                    <input type="button" value="Conferma Modifiche" onClick="insertArbitro()"/>
                    <input type="hidden" name="status" value="modifyArbitro"/>
                    
                   <% } %> 
                    </td>
                    <td align="center" width="150" height="35">
                        <input type="button" value="Annulla" onClick="annulla()"/>
                    </td>
                    
               <%}
               else {
                    if ((request.getParameter("type").equals("G")))
               {%>
                    <% if(request.getParameter("status").equals("newG") || (request.getParameter("status").equals("insertGestore") & message!=null)) {%>
                    <td align="center" width="150" height="35">
                    <input type="button" value="Conferma" onClick="insertGestore()"/>
                    <input type="hidden" name="status" value="insertGestore"/>
                    <% } 
                    else {%>
                    <td align="center" width="150" height="35">
                    <input type="button" value="Conferma Modifiche" onClick="insertGestore()"/>
                    <input type="hidden" name="status" value="modifyGestore"/>
                    <% } %> 
                    </td>
                    <td align="center" width="150" height="35">
                        <input type="button" value="Annulla" onClick="annulla()"/>
                    </td>
                <%}}%>
                </tr>
            </table>
            </form>

                
        </div>
     </div> 
    </div>
      
    
    <%if (message!=null) {%>
        <script>alert("<%=message%>");</script>
    <%}%>
   
    </body>
</html>