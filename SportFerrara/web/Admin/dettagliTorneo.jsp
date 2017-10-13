<%@ page info="Dettagli Torneo" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneTornei" scope="page" class="bflows.TorneiManagement" />
<jsp:setProperty name="gestioneTornei" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies=null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  boolean newline=false;
  
  /* Setto il creatore del torneo */
  gestioneTornei.setCreatore(Session.getSSN(cookies));
  
  /* Variabili ausiliarie */
  String message = null;
  String status; 
  int i,j,k,giornate,partite;
  
  /* Chiamo sempre il metodo del bean */
  gestioneTornei.visualizzaTorneo();
          
  /* Gestione degli errori */
  if (gestioneTornei.getResult()==-1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneTornei.getResult()==-2) {
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
        
        <form name="TorneoItaliana" method="post" action="newTorneo.jsp">
                <input type="hidden" name="tipologia" value="I"/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="numeroSquadre" value=""/>
                <input type="hidden" name="descrizione" value=""/>
                
                <input type="hidden" name="status" value="newI"/>
            </form>
            
            <form name="TorneoEliminazione" method="post" action="newTorneo.jsp">
                <input type="hidden" name="tipologia" value="E"/>
                <input type="hidden" name="nome" value=""/>
                <input type="hidden" name="descrizione" value=""/>
                
                <input type="hidden" name="status" value="newE"/>
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
                 
                   <h2 align="center"><%= request.getParameter("nome")%> </h2><br><br>
                   
    <% if((request.getParameter("tipologia")).equals("I"))
       { %>
                                      
       <h3 align="center">Calendario </h3><br>  
       <br> 
       <div  align="center">
            <b> ANDATA: </b>
       </div>
       <br>             
         <table class="calendario" align="center">
   
                                <tr>
                                <%if ((gestioneTornei.getClassifiche().length)%2==0)
                                {
                                    giornate=((gestioneTornei.getClassifiche().length)*2)-2;
                                    partite= (gestioneTornei.getClassifiche().length)/2;
                                }
                                else
                                {
                                    giornate=(((gestioneTornei.getClassifiche().length)+1)*2)-2;
                                    partite= ((gestioneTornei.getClassifiche().length)+1)/2;
                                }
                                k=0; %>
                                
                               <% for (i=1;i<=giornate/2;i++)
                                {
                                    if(newline==false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTornei.getIncontri(i).nomeAss)==(gestioneTornei.getClassifiche().length))
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
         <br> 
         <div  align="center">
             <b> RITORNO: </b>
         </div>
         <br>    
         <table class="calendario" align="center">  
             <tr>
                                <% for (i=(giornate/2)+1;i<=giornate;i++)
                                {
                                    if(newline==false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTornei.getIncontri(i).nomeAss)==(gestioneTornei.getClassifiche().length))
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
                              
                              
         </table><br><br>
         
         <h3 align="center"> Classifica </h3><br>
         
         
          <table class="calendario" align="center">
                        <tr>
                            <th class="calendario" align="center"></th>
                            <th class="calendario" align="center">Squadra</th>
                            <th class="calendario" align="center">Punti</th>
                            <th class="calendario" align="center">Partite Giocate</th>
                            <th class="calendario" align="center">Vittorie </th>
                            <th class="calendario" align="center">Pareggi </th>
                            <th class="calendario" align="center">Sconfitte</th>
                            <th class="calendario" align="center">GF</th>
                            <th class="calendario" align="center">GS</th>
                        </tr>  
                        
                      <%  for (i=0;i<gestioneTornei.getClassifiche().length;i++)
                                {%>  
                                    
                                        <tr>
                                            <td class="su" align="center"><%= i+1 %>°</td>
                                            <td class="giu" align="center"><%=gestioneTornei.getNomeSquadreClassifica(i)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).Punti)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).Partite)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).Vittorie)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).Pareggi)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).Sconfitte)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).GoalFatti)%></td>
                                            <td class="giu" align="center"><%=(gestioneTornei.getClassifiche(i).GoalSubiti)%></td> 
                                        </tr>
                                    <%                                    
                                }%>
         </table>        

         
       <% }
            else 
            {
       %>   
       
            <h3 align="center"> Tabellone </h3><br> 
            <% if((gestioneTornei.getClassifiche().length)==2)
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
                            else if((gestioneTornei.getClassifiche().length)==4)
                            {%>
                            <table class="calendario" align="center">
                                <tr>
                                    <td>
                                    <table width="350">
                                        <caption><b>SEMIFINALE</b></caption>
                                        <tr><td class="giu" align="center" width="20"><b>A</b></td><td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(0)%> - <%=gestioneTornei.getNomeSquadreB(0)%></td></tr>
                                        <tr height="35"></tr>
                                        <tr><td class="giu" align="center" width="20"><b>B</b></td><td class="su" width="250" align="center"><%=gestioneTornei.getNomeSquadreA(0)%> - <%=gestioneTornei.getNomeSquadreB(0)%></tr>
                                    </table>
                                    </td>
                                    <td>
                                    <table width="400">
                                        <caption><b>FINALE</b></caption>
                                        
                                        <tr>
                                            <td align="center" class="su" width="250">
                                                <%if ((gestioneTornei.getIncontri(2).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                <b><%=(gestioneTornei.getNomeSquadreA(2))%></b>
                                                <%}%>
                                            </td> 
                                            <td align="center" class="su" width="250">
                                                <%if ((gestioneTornei.getIncontri(2).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                <b><%=(gestioneTornei.getNomeSquadreB(2))%></b>
                                                <%}%>
                                            </td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((gestioneTornei.getClassifiche().length)==8)
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
                                                <%if ((gestioneTornei.getIncontri(4).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(4))%>
                                                <%}%>
                                            </td>
                                            <td class="su" align="center">
                                                <%if ((gestioneTornei.getIncontri(4).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(4))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        <tr height="135"></tr>
                                            <tr><td class="giu" align="center"><b>F</b></td>
                                            <td class="su" align="center">
                                                <%if ((gestioneTornei.getIncontri(5).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>C</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(5))%>
                                                <%}%>
                                            </td> 
                                            <td class="su" align="center">
                                                <%if ((gestioneTornei.getIncontri(5).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>D</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(5))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table width="300">
                                            <caption><b>FINALE</b></caption>
                                            <tr>
                                            <td class="su" align="center">
                                                <%if ((gestioneTornei.getIncontri(6).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>E</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(6))%>
                                                <%}%>
                                            </td> 
                                            <td class="su" align="center">
                                                <%if ((gestioneTornei.getIncontri(6).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>F</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(6))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((gestioneTornei.getClassifiche().length)==16)
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
                                            <tr><td><b>I</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(8).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(8))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(8).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(8))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>L</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(9).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>C</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(9))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(9).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>D</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(9))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>M</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(10).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>E</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(10))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(10).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>F</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(10))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>N</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(11).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>G</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(11))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(11).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>H</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(11))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>SEMIFINALE</b></caption>
                                            <tr><td><b>O</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(12).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>I</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreA(12))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTornei.getIncontri(12).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>L</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTornei.getNomeSquadreB(12))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>P</b></td>
                                            <tr>
                                                <td width="100">
                                                    <%if ((gestioneTornei.getIncontri(13).IDSquadraA)==0)
                                                    {%>
                                                        Vincente <b>M</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTornei.getNomeSquadreA(13))%>
                                                    <%}%>
                                                </td> 
                                                <td width="100">
                                                    <%if ((gestioneTornei.getIncontri(13).IDSquadraB)==0)
                                                    {%>
                                                        Vincente <b>N</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTornei.getNomeSquadreB(13))%>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>FINALE</b></caption>
                                            <tr>
                                                <td width="100">
                                                    <%if ((gestioneTornei.getIncontri(14).IDSquadraA)==0)
                                                    {%>
                                                        Vincente <b>O</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTornei.getNomeSquadreA(14))%>
                                                    <%}%>
                                                </td> 
                                                <td width="100">
                                                    <%if ((gestioneTornei.getIncontri(14).IDSquadraB)==0)
                                                    {%>
                                                        Vincente <b>P</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTornei.getNomeSquadreB(14))%>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
         
                    <% } %>
                    
         <br><br>
                                        
         <h3 align="center"> Classifica </h3><br>
         
          <table class="calendario" align="center">
                        <tr>
                            <th class="calendario" align="center" width="50"></th>
                            <th class="calendario" align="center" width="220">Squadra</th>
                            <th class="calendario" align="center" width="120">Vittorie </th>
                            <th class="calendario" align="center" width="120">Sconfitte</th>
                            <th class="calendario" align="center" width="110">Giocate</th>
                            <th class="calendario" align="center" width="60">GF</th>
                            <th class="calendario" align="center" width="60">GS</th>
                        </tr>  
                        
                      <%  for (i=0;i<gestioneTornei.getClassifiche().length;i++)
                                {%>  
                               <% if((gestioneTornei.getClassifiche(i).Sconfitte)==1)
                            {  %>
                              
                                <tr> 
                                    <td class="giu" align="center"><b><%= i+1 %>°</b></td>
                                    <td class="red" align="center"><%=gestioneTornei.getNomeSquadreClassifica(i)%></td>
                                    <td class="red" align="center">ELIMINATA</td>
                                    <td class="red" align="center"></td>
                                    <td class="red" align="center"><%=(gestioneTornei.getClassifiche(i).Partite)%></td>
                                    <td class="red" align="center"><%=(gestioneTornei.getClassifiche(i).GoalFatti)%></td>
                                    <td class="red" align="center"><%=(gestioneTornei.getClassifiche(i).GoalSubiti)%></td> 
                                </tr>
                            
                         <% } else { %> 
                           
                                    <tr> 
                                        <td class="giu" align="center"><b><%= i+1 %>°</b></td>
                                        <td class="su" align="center"><%=gestioneTornei.getNomeSquadreClassifica(i)%></td>
                                        <td class="su" align="center"><%=(gestioneTornei.getClassifiche(i).Vittorie)%></td>
                                        <td class="su" align="center"><%=(gestioneTornei.getClassifiche(i).Sconfitte)%></td>
                                        <td class="su" align="center"><%=(gestioneTornei.getClassifiche(i).Partite)%></td>
                                        <td class="su" align="center"><%=(gestioneTornei.getClassifiche(i).GoalFatti)%></td>
                                        <td class="su" align="center"><%=(gestioneTornei.getClassifiche(i).GoalSubiti)%></td> 
                                    </tr>
                                    <%                                    
                                } 
                          }%>
         </table>                        
       
              <% } %>
              
              <br><br>
         <h3 align="center"> Informazioni sul Torneo </h3>
         <table width="900">     
             <tr>
                 <td>
                     <h6><%= request.getParameter("descrizione") %></h6>
                 </td>
             </tr> 
         </table>
                   
          
          <br><br>
          <table align="center">
            <tr>
                <td>
                    <input type="button" value="Indietro" onclick="javascript:history.go(-1)"/>
                </td>
            </tr>
          </table>                 
          <br>
          
               </div>
           </div>
       </div>
    </body>
</html>