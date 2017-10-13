<%@ page info="Dettagli Calendario" %>
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
  
  boolean loggedOn =(cookies!=null);
  
  /* Setto il creatore del torneo */
  gestioneTornei.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  boolean newline = false;
  int giornate, partite, i, j, k;
  
  /* Metodo del bean */
  gestioneTornei.visualizzaCalendario();
  
  /* Gestione degli errori */
  if (gestioneTornei.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneTornei.getResult() == -2) {
    message=gestioneTornei.getErrorMessage();
  }
  
%>


<!DOCTYPE html>
<html>
  
  <head>
    <title>SportFerrara - <%= getServletInfo() %></title>
    <meta name="author" content="Michele Vaccari"/>   
    <link href="../css/custom.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="../Immagini/favicon.ico" />
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
        
            <% if (message==null) {
                if((request.getParameter("tipologia")).equals("I")) { %>
                  
                <h3 align="center">Calendario del torneo <%=request.getParameter("nome")%>:</h3><br>  
            
       <br><h4 align="center"> ANDATA: </h4><br>             
         <table class="calendario" align="center">
   
                                <tr>
                                <%if (Integer.parseInt(request.getParameter("numeroSquadre"))%2==0)
                                {
                                  giornate = ((Integer.parseInt(request.getParameter("numeroSquadre")))*2)-2;
                                  partite = Integer.parseInt(request.getParameter("numeroSquadre"))/2;
                                }
                                else
                                {
                                    giornate = ((Integer.parseInt(request.getParameter("numeroSquadre"))+1)*2)-2;
                                    partite = (Integer.parseInt(request.getParameter("numeroSquadre"))+1)/2;
                                }
                                k = 0; %>
                                
                               <% for (i = 1; i <= giornate/2; i++)
                                {
                                    if(newline==false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTornei.getIncontri(i).nomeAss)==(Integer.parseInt(request.getParameter("numeroSquadre"))))
                                                { %>
                                                <% } %>
                                                
                                                <th colspan="2" width="300"> Giornata <%=i%>:</th>
                                                <%for(j=0;j<partite;j++)
                                                {%>
                                                    <tr>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTornei.getNomeSquadreA(k)%>
                                                             - <%=gestioneTornei.getNomeSquadreB(k)%>
                                                        </td>
                                                    </tr>
                                                <%k++;}%>
                                            </table>
                                        </td>
                                    <%}
                                    else
                                    {%>
                                </tr>
                                    <tr>
                                        <td>
                                            <table class="calendario" align="center">
                                                <th colspan="2" width="300">Giornata <%=i%> :</th>
                                                <%for(j=0;j<partite;j++)
                                                {%>
                                                    <tr>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTornei.getNomeSquadreA(k)%>
                                                             - <%=gestioneTornei.getNomeSquadreB(k)%>
                                                        </td>
                                                    </tr>
                                                <%k++;}%>
                                            </table>
                                        </td>
                                    <%}
                                    if(i%3==0)
                                        newline=true;
                                    else
                                        newline=false;
                                }%>
         </table><br>
         
         <br><h4 align="center"> RITORNO: </h4><br>     
         
         <table class="calendario" align="center">  
             <tr>
                                <% for (i = (giornate/2)+1; i <= giornate; i++)
                                {
                                    if(newline == false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTornei.getIncontri(i).nomeAss)==(Integer.parseInt(request.getParameter("numeroSquadre"))))
                                                { %>
                                                <% } %>
                                                
                                                <th colspan="2" width="300"> Giornata <%=i%>:</th>
                                                <%for(j=0;j<partite;j++)
                                                {%>
                                                    <tr>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTornei.getNomeSquadreA(k)%>
                                                             - <%=gestioneTornei.getNomeSquadreB(k)%>
                                                        </td>
                                                    </tr>
                                                <%k++;}%>
                                            </table>
                                        </td>
                                    <%}
                                    else
                                    {%>
                                </tr><tr>
                                        <td>
                                            <table class="calendario" align="center">
                                                <th colspan="2" width="300">Giornata <%=i%> :</th>
                                                <%for(j=0;j<partite;j++)
                                                {%>
                                                    <tr>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTornei.getNomeSquadreA(k)%>
                                                             - <%=gestioneTornei.getNomeSquadreB(k)%>
                                                        </td>
                                                    </tr>
                                                <%k++;}%>
                                            </table>
                                        </td>
                                    <%}
                                    if(i%3==0)
                                        newline=true;
                                    else
                                        newline=false;
                                }%>
                                
                                <tr>
         </table><br> 
       <% }
            else 
            {
       %>   
       
            <h3 align="center"> Tabellone del torneo <%=request.getParameter("nome")%>:</h3><br> 
            <% if((Integer.parseInt(request.getParameter("numeroSquadre")))==2)
                            {%>
                           <table class="calendario" align="center">
                                <tr height="10"></tr>
                                <tr>
                                    <td class="giu" align="center" width="300">
                                        <b><%=gestioneTornei.getNomeSquadreA(0)%>
                                            - <%=gestioneTornei.getNomeSquadreB(0)%></b>
                                    </td>
                                </tr>
                                <tr height="10"></tr>
                            </table>
                            <%}
                            else if((Integer.parseInt(request.getParameter("numeroSquadre")))==4)
                            {%>
                            <table class="calendario" align="center">
                                <tr>
                                    <td>
                                    <table width="350">
                                        <caption><b>SEMIFINALE</b></caption>
                                        <tr><td class="giu" align="center" width="20"><b>A</b></td><td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(0)%> - <%=gestioneTornei.getNomeSquadreB(0)%></td></tr>
                                        <tr height="35"></tr>
                                        <tr><td class="giu" align="center" width="20"><b>B</b></td><td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(1)%> - <%=gestioneTornei.getNomeSquadreB(1)%></tr>
                                    </table>
                                    </td>
                                    <td>
                                    <table width="400">
                                        <caption><b>FINALE</b></caption>
                                        
                                        <tr>
                                            <td align="center" class="su" width="250">
                                                Vincente <b>A</b>
                                            </td> 
                                            <td align="center" class="su" width="250">
                                                Vincente <b>B</b>
                                            </td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((Integer.parseInt(request.getParameter("numeroSquadre")))==8)
                            {%>
                            <table class="calendario" align="center">
                                <tr>
                                    <td>
                                        <table width="350">
                                            <caption><b>QUARTI DI FINALE</b></caption>
                                            <tr> <td class="giu" align="center" width="20"><b>A</b></td>
                                                <td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(0)%> - <%=gestioneTornei.getNomeSquadreB(0)%></td>
                                            </tr>
                                            <tr height="35"></tr>
                                            <tr> <td class="giu" align="center" width="20"><b>B</b></td>
                                                <td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(1)%> - <%=gestioneTornei.getNomeSquadreB(1)%></td>
                                            </tr>
                                            <tr height="60"></tr>
                                            <tr> <td class="giu" align="center" width="20"><b>C</b></td>
                                                <td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(2)%> - <%=gestioneTornei.getNomeSquadreB(2)%></td>
                                            </tr>
                                            <tr height="35"></tr>
                                            <tr> <td class="giu" align="center" width="20"><b>D</b></td>
                                                <td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(3)%> - <%=gestioneTornei.getNomeSquadreB(3)%></td>
                                            </tr>
                                        </table>
                                    </td>
                                   <td>
                                        <table width="300">
                                            <caption><b>SEMIFINALE</b></caption>
                                            <tr><td class="giu" align="center"><b>E</b></td>
                                                
                                            <td class="su" align="center">
                                                Vincente <b>A</b>
                                            </td>
                                            <td class="su" align="center">
                                                Vincente <b>B</b>
                                            </td>
                                        </tr>
                                        <tr height="135"></tr>
                                            <tr><td class="giu" align="center"><b>F</b></td>
                                            <td class="su" align="center">
                                                Vincente <b>C</b>
                                            </td> 
                                            <td class="su" align="center">
                                                Vincente <b>D</b>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table width="300">
                                            <caption><b>FINALE</b></caption>
                                            <tr>
                                            <td class="su" align="center">
                                                Vincente <b>E</b>
                                            </td> 
                                            <td class="su" align="center">
                                                Vincente <b>F</b>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((Integer.parseInt(request.getParameter("numeroSquadre")))==16)
                            {%>
                            <table>
                                <tr>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>Ottavi di finale</b></caption>
                                            <tr><td><b>A</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(0)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(0)%></td></tr>
                                            <tr><td><b>B</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(1)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(1)%></td></tr>
                                            <tr><td><b>C</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(2)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(2)%></td></tr>
                                            <tr><td><b>D</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(3)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(3)%></td></tr>
                                            <tr><td><b>E</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(4)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(4)%></td></tr>
                                            <tr><td><b>F</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(5)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(5)%></td></tr>
                                            <tr><td><b>G</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(6)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(6)%></td></tr>
                                            <tr><td><b>H</b></td><td width="100"><%=gestioneTornei.getNomeSquadreA(7)%></td><td width="100"><%=gestioneTornei.getNomeSquadreB(7)%></td></tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>QUARTI DI FINALE</b></caption>
                                            <tr><td><b>I</b></td><td width="100">Vincente <b>A</b></td><td width="100">Vincente <b>B</b></td></tr>
                                            <tr><td><b>L</b></td><td width="100">Vincente <b>C</b></td><td width="100">Vincente <b>D</b></td></tr>
                                            <tr><td><b>M</b></td><td width="100">Vincente <b>E</b></td><td width="100">Vincente <b>F</b></td></tr>
                                            <tr><td><b>N</b></td><td width="100">Vincente <b>G</b></td><td width="100">Vincente <b>H</b></td></tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>SEMIFINALE</b></caption>
                                            <tr><td><b>O</b></td><td width="100">Vincente <b>I</b></td><td width="100">Vincente <b>L</b></td></tr>
                                            <tr><td><b>P</b></td><td width="100">Vincente <b>M</b></td><td width="100">Vincente <b>N</b></td></tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>FINALE</b></caption>
                                            <tr><td width="100">Vincente <b>O</b></td><td width="100">Vincente <b>P</b></td></tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
       
                    <% }
               }
          } else {%>
          
          <h3>Hai già creato un torneo con questo nome!</h3><br>
          <h4>Premi indietro per tornare alla pagina di creazione torneo</h4>
                        <br>
          <input type="button" value="Indietro" onclick="javascript:history.go(-2)"/>
          
          <% } %>
            
        </div>
     </div> 
    </div>
      
    
    <%if (message!=null) {%>
        <script>alert("<%=message%>");</script>
    <%}%>
  
  </body>
</html>