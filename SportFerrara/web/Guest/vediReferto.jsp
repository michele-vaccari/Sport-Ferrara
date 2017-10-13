<%@ page info="Visualizza Referto" %>
<%@ page contentType="text/html" %>
<%@ page session="false" %>
<%@ page buffer="30kb" %>
<%@ page errorPage="../ErrorPage.jsp" %>
<%@ page import="services.sessionservice.*" %>

<jsp:useBean id="gestioneTorneiGuest" scope="page" class="bflows.GuestTorneiManagement" />
<jsp:setProperty name="gestioneTorneiGuest" property="*" />

<%
  /* Gestione della sessione */
  Cookie[] cookies = null;
  cookies = request.getCookies();
  
  boolean loggedOn = (cookies != null);
  
  /* Variabili ausiliarie */
  String message = null;
  String status;
  int IDPartita = Integer.parseInt(request.getParameter("IDPartita"));
  int IDSquadraA = Integer.parseInt(request.getParameter("IDSquadraA"));
  int IDSquadraB = Integer.parseInt(request.getParameter("IDSquadraB"));
  int i, j, k, AutogoalCasa = 0, AutogoalOspite = 0, goalOspite = 0, goalCasa = 0, Rcasa = 0, Rospite = 0;
  Boolean pronto = true;
  
  /* Leggo lo stato */
  status = request.getParameter("status");
  
  gestioneTorneiGuest.visualizzaReferto(IDPartita, IDSquadraA, IDSquadraB);
  
  if(gestioneTorneiGuest.getReferti().length == 0)
    pronto = false;
  
  /* Gestione degli errori */
  if (gestioneTorneiGuest.getResult() == -1) {    
    throw new Exception("Errore nell'applicazione: consultare i logs.");
  } 
  else if (gestioneTorneiGuest.getResult() == -2) {
    message = gestioneTorneiGuest.getErrorMessage();
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
        
           <div id="header-container">
            <div id="header">
                <h1>SportFerrara</h1>             
            </div>
            <div id="menubar">
                    <ul id="menu">
                        
                        <li><a class="button" href="../home.jsp">HOME</a></li>
                        
                        <li><a class="button" href="listaTornei.jsp">TORNEI</a></li>
                        
                        <li><a class="button" href="listaSquadre.jsp">SQUADRE</a></li>
                        
                         <%if (loggedOn){%>
                         <form name="logoutForm" action="../login.jsp" method="post">
                            <input type="hidden" name="status" value="logout"/>
                        </form>  
                        <li><a class="button" href="javascript:logoutForm.submit()">LOGOUT</a></li> 
                        <%}
                        else
                        {%>
                        <li><a class="button" href="../login.jsp">LOGIN</a></li> 
                        <%}%>
                    </ul> 
            </div>
        </div>
                        
       <div id="main">
           <div id="container">  
               <div id="content">
                              
                   
                <h2 class="green" align="center"><%=request.getParameter("nomeTorneo")%> </h2
                <br><br>
                
            <% if(pronto.equals(false))
               { %>
               <br><br>
               <h3 align="center"> Spiacenti ma risultato della partita non è ancora disponibile!</h3>
               <br>
           <% } 
              else
             {
             if((gestioneTorneiGuest.getGiocatoriSquadraA().length==0)||(gestioneTorneiGuest.getGiocatoriSquadraA().length==0)||(gestioneTorneiGuest.getReferto().risultato.equals("_-_")))
                { %>
                <br><br>
                <h3 align="center"> Spiacenti ma risultato della partita non è ancora disponibile!</h3>
                <br>
             <% }  else
                 {%>
                
                <br>
                <form name="RefertoForm" action="referti.jsp">
                    <input type="hidden" name="status" value="insert"/>
                
                    <table class="formazione">
                        <tr height="60" >
                            <td align="center" > <h2 align="center"> <%=request.getParameter("nomeSquadraA")%> </h2></td>
                            <td align="center" width="80" valign="bottom" > <h2 class="green"> <%=gestioneTorneiGuest.getReferto().risultato%></h2></td>
                            <td align="center"> <h2 align="center"> <%=request.getParameter("nomeSquadraB")%> </h2></td>
                        </tr>
                        <tr height="40" valign="bottom">
                            <td align="center"> <h3 class="fred">TITOLARI DELLA FORMAZIONE </h3></td>
                            <td align="center" width="100"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                            <td align="center"> <h3 class="fred">TITOLARI DELLA FORMAZIONE </h3></td>
                        </tr>
                        <tr>
                            <td> <!-- tabella titolarisquadra A-->
                                <table class="calendario" width="470" align="center">
                                    <tr>

                                        <th class="calendario" align="center">Foto</th>
                                        <th class="calendario" align="center">Giocatore</th>
                                        <th class="calendario" align="center">Goal</th>
                                        <th class="calendario" align="center">Cartellini</th>
                                    </tr>


                                    <%for (i=0; i<11; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneTorneiGuest.getGiocatoriSquadraA(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).nome%> <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).cognome%></td>
                                     <% for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                                     {
                                         if(((gestioneTorneiGuest.getGiocatoriSquadraA(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                                         { %>
                                         <td class="su" align="center"> <b><%=gestioneTorneiGuest.getGoalFormazioni(j).goal%></b> </td> 
                                           <% break;
                                         }
                                     }
                                     if(j==((gestioneTorneiGuest.getGoalFormazioni().length)))
                                     { %>
                                     <td class="su" align="center"></td> 
                                  <% } 
                                      j=0;
                                            %>
                                   
                                     <% for (j=0;j<gestioneTorneiGuest.getCartelliniGiocatori().length;j++)
                                     {
                                         if(((gestioneTorneiGuest.getGiocatoriSquadraA(i).SSNGiocatore)==(gestioneTorneiGuest.getCartelliniGiocatori(j).SSNGiocatore)))
                                         { 
                                            if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagAmmonito.equals("Y"))
                                            {%>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/giallo.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                            else if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagEspulso.equals("Y"))
                                            { %>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/rosso.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                         }
                                     }
                                     if(j==((gestioneTorneiGuest.getCartelliniGiocatori().length)))
                                     { %>
                                        <td class="su" align="center">  </td> 
                                  <% } 
                                      j=0;
                                            %> 
                                    
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
                                        <th class="calendario" align="center">Goal</th>
                                        <th class="calendario" align="center">Cartellini</th>
                                    </tr>


                                    <%for (i=0; i<11; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneTorneiGuest.getGiocatoriSquadraB(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).nome%> <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).cognome%></td>
                                        <% for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                                        {
                                            if(((gestioneTorneiGuest.getGiocatoriSquadraB(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                                            { %>
                                            <td class="su" align="center"> <b><%=gestioneTorneiGuest.getGoalFormazioni(j).goal%></b> </td> 
                                              <% break;
                                            }

                                        }
                                        if(j==((gestioneTorneiGuest.getGoalFormazioni().length)))
                                        { %>
                                        <td class="su" align="center"></td> 
                                     <% } 
                                         j=0;
                                               %>
                                        
                                  <% for (j=0;j<gestioneTorneiGuest.getCartelliniGiocatori().length;j++)
                                     {
                                         if(((gestioneTorneiGuest.getGiocatoriSquadraB(i).SSNGiocatore)==(gestioneTorneiGuest.getCartelliniGiocatori(j).SSNGiocatore)))
                                         { 
                                            if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagAmmonito.equals("Y"))
                                            {%>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/giallo.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                            else if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagEspulso.equals("Y"))
                                            { %>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/rosso.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                         }
                                     }
                                     if(j==((gestioneTorneiGuest.getCartelliniGiocatori().length)))
                                     { %>
                                        <td class="su" align="center">  </td> 
                                  <% } 
                                      j=0;
                                            %> 
                                               
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
                                        <th class="calendario" align="center">Goal</th>
                                        <th class="calendario" align="center">Cartellini</th>
                                    </tr>

                                    <%for (i=11; i<gestioneTorneiGuest.getGiocatoriSquadraA().length; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneTorneiGuest.getGiocatoriSquadraA(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).nome%> <%=gestioneTorneiGuest.getGiocatoriSquadraA(i).cognome%></td>
                                        <% for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                                        {
                                            if(((gestioneTorneiGuest.getGiocatoriSquadraA(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                                            { %>
                                            <td class="su" align="center"> <b><%=gestioneTorneiGuest.getGoalFormazioni(j).goal%></b> </td> 
                                              <% break;
                                            }

                                        }
                                        if(j==((gestioneTorneiGuest.getGoalFormazioni().length)))
                                        { %>
                                        <td class="su" align="center"></td> 
                                     <% } 
                                         j=0;
                                               %>
                                        
                                               
                                  <% for (j=0;j<gestioneTorneiGuest.getCartelliniGiocatori().length;j++)
                                     {
                                         if(((gestioneTorneiGuest.getGiocatoriSquadraA(i).SSNGiocatore)==(gestioneTorneiGuest.getCartelliniGiocatori(j).SSNGiocatore)))
                                         { 
                                            if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagAmmonito.equals("Y"))
                                            {%>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/giallo.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                            else if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagEspulso.equals("Y"))
                                            { %>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/rosso.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                         }
                                     }
                                     if(j==((gestioneTorneiGuest.getCartelliniGiocatori().length)))
                                     { %>
                                        <td class="su" align="center">  </td> 
                                  <% } 
                                      j=0;
                                            %>
                                               
                                               
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
                                        <th class="calendario" align="center">Goal</th>
                                        <th class="calendario" align="center">Cartellini</th>
                                    </tr>

                                    <%for (i=11; i<gestioneTorneiGuest.getGiocatoriSquadraB().length; i++)
                                    {%>
                                    <tr>
                                        <td class="giu" align="center">
                                            <img src="../Immagini/<%=gestioneTorneiGuest.getGiocatoriSquadraB(i).foto%>" width="45" height="45" />
                                        </td>
                                        <td class="giu" align="center"> <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).numeroMaglia%>&nbsp-&nbsp <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).nome%> <%=gestioneTorneiGuest.getGiocatoriSquadraB(i).cognome%></td>
                                        <% for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                                        {
                                            if(((gestioneTorneiGuest.getGiocatoriSquadraB(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                                            { %>
                                            <td class="su" align="center"> <b><%=gestioneTorneiGuest.getGoalFormazioni(j).goal%></b> </td> 
                                              <% break;
                                            }

                                        }
                                        if(j==((gestioneTorneiGuest.getGoalFormazioni().length)))
                                        { %>
                                        <td class="su" align="center"></td> 
                                     <% } 
                                         j=0;
                                               %>
                                        
                                               
                                        <% for (j=0;j<gestioneTorneiGuest.getCartelliniGiocatori().length;j++)
                                     {
                                         if(((gestioneTorneiGuest.getGiocatoriSquadraB(i).SSNGiocatore)==(gestioneTorneiGuest.getCartelliniGiocatori(j).SSNGiocatore)))
                                         { 
                                            if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagAmmonito.equals("Y"))
                                            {%>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/giallo.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                            else if(gestioneTorneiGuest.getCartelliniGiocatori(j).FlagEspulso.equals("Y"))
                                            { %>
                                                <td class="su" align="center"><img class="cartellino" src="../Immagini/rosso.png" width="45" height="45" /></td>
                                           <% break;
                                            }
                                         }
                                     }
                                     if(j==((gestioneTorneiGuest.getCartelliniGiocatori().length)))
                                     { %>
                                        <td class="su" align="center">  </td> 
                                  <% } 
                                      j=0;
                                            %>
                                               
                                               
                                    </tr>
                                    <%}%>

                                </table>
                            </td>
                        </tr>
                  </table> 
                  <br>
                                   
                <br>
                <table align="center" width="950">
                    <tr>
                        <td align="center">
                             <b>Arbitrata da:</b>
                            <h3 class="green"><%=gestioneTorneiGuest.getReferto().nomeArbitro%> <%=gestioneTorneiGuest.getReferto().cognomeArbitro%></h3>
                        </td>
                        <td width="30"></td>
                        <td align="center" valign="middle">
                            <h3 class="green"><%=gestioneTorneiGuest.getReferto().luogo%></h3>
                            <b><%=gestioneTorneiGuest.getReferto().data%></b
                        </td>
                        <td>
                    </tr>
                    <tr height="25"></tr>
                    <tr>
                        <td align="center" >
                            <img src="../Immagini/<%=gestioneTorneiGuest.getReferto().fotoArbitro%>" width="180" height="180" />
                        </td>
                        <td width="30"></td>
                        <td align="center" valign="top">
                            <br><br>
                            Ora inizio: <b><%=gestioneTorneiGuest.getReferto().oraInizio%></b><br><br>
                            Ora fine: <b><%=gestioneTorneiGuest.getReferto().oraFine%></b>  
                        </td>
                    </tr>
                 </table>                 
                <br>
                <% 
                 // Mi serve per sapere quanti sono stati gli autogaol di Casa e Ospite        
                 for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                 {
                      for (i=0;i<gestioneTorneiGuest.getGiocatoriSquadraB().length;i++)
                          if(((gestioneTorneiGuest.getGiocatoriSquadraB(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                              goalOspite=goalOspite+gestioneTorneiGuest.getGoalFormazioni(j).goal;
                 }
              
                 for (j=0;j<gestioneTorneiGuest.getGoalFormazioni().length;j++)
                 {
                      for (i=0;i<gestioneTorneiGuest.getGiocatoriSquadraA().length;i++)
                          if(((gestioneTorneiGuest.getGiocatoriSquadraA(i).SSNGiocatore)==(gestioneTorneiGuest.getGoalFormazioni(j).SSNGiocatore)) && ((gestioneTorneiGuest.getGoalFormazioni(j).goal)!=0))
                              goalCasa=goalCasa+gestioneTorneiGuest.getGoalFormazioni(j).goal;
                 }
                              
                 AutogoalOspite=Integer.parseInt(""+gestioneTorneiGuest.getReferto().risultato.charAt(0))-goalCasa;
                 AutogoalCasa=Integer.parseInt(""+gestioneTorneiGuest.getReferto().risultato.charAt(2))-goalOspite;
            
            %>                    
            
          <% if((AutogoalCasa!=0) && (AutogoalOspite!=0))
             { %>
             <div align="center">   
                 <h3 class="green"> Entrambe le squadre hanno realizzato Autogoal:</h3><br>
                 <b><%=request.getParameter("nomeSquadraA")%>: &nbsp<%=AutogoalCasa%></b>
                 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
                 <b><%=request.getParameter("nomeSquadraB")%>: &nbsp<%=AutogoalOspite%></b><br><br><br>
             </div>
          <% } 
             else
             { 
                if(AutogoalCasa!=0)
                   { %>
                   <div align="center">
                       <h3 class="green">Squadra che ha realizzato Autogoal: </h3><br>
                       <b><%=request.getParameter("nomeSquadraA")%>: &nbsp<%=AutogoalCasa%></b><br><br><br>
                   </div>
                <% }%>
                  <br>
             <% if(AutogoalOspite!=0)
                   { %>
                    <div align="center">
                       <h3 class="green">Squadra che ha realizzato Autogoal: </h3><br>
                       <b><%=request.getParameter("nomeSquadraB")%>: &nbsp<%=AutogoalOspite%></b><br><br><br>
                   </div>
                <% }
             }%>
                          
            <table width="300" align="center">
                <tr>
                    <td align="center">
                        <input type="button" value="Indietro" onClick="javascript:history.back()"/>
                    </td> 
                </tr>
            </table>
      
              <% } 
              
            }%>
               
                <table align="center" width="1000"></table>
                  
                
                
               </div>
           </div>
       </div>
    </body>
</html>