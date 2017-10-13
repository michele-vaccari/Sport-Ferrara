<%@ page info="Visualizza Torneo" %>
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
  boolean newline = false;
  String message = null;
  int i, j, k, giornate, partite, c = 0;
  
  gestioneTorneiGuest.visualizzaTorneo();
  
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

    <script src="../js/guest/vediTorneo.js"></script>
  </head>
    
    <body>
        
           <div id="header-container">
            <div id="header">
                <h1>SportFerrara</h1>             
            </div>
            <div id="menubar">
                <ul id="menu">

                    <li><a class="button" href="../home.jsp">MyHOME</a></li>

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
                   
                   
                   
                 
            <h2 align="center"><%= request.getParameter("nome")%> </h2><br><br>

             <% if((request.getParameter("tipologia")).equals("I"))
                { %>

                <h3 align="center">Calendario </h3><br>  

                <br>
                <div align="center">
                    <b> ANDATA: </b>
                </div>
                <br>             
                  <table class="calendario" align="center">
   
                                <tr>
                                <%if ((gestioneTorneiGuest.getClassifiche().length)%2==0)
                                {
                                    giornate=((gestioneTorneiGuest.getClassifiche().length)*2)-2;
                                    partite= (gestioneTorneiGuest.getClassifiche().length)/2;
                                }
                                else
                                {
                                    giornate=(((gestioneTorneiGuest.getClassifiche().length)+1)*2)-2;
                                    partite= ((gestioneTorneiGuest.getClassifiche().length)+1)/2;
                                }
                                k=0; %>
                                
                               <% for (i=1;i<=giornate/2;i++)
                                { %>
                               
                                <% if(newline==false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTorneiGuest.getIncontri(i).nomeAss)==(gestioneTorneiGuest.getClassifiche().length))
                                                { %>
                                                <% } %>
                                                
                                                <th colspan="2" width="300" align="center"> Giornata <%=i%>:</th>
                                                <% for (j = 0; j < partite; j++)
                                                {%>
                                                    
                                                
                                                <form name="viewFormReferto<%=k%>" method="post" action="vediReferto.jsp">
                                                    <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(k).IDPartita%>"/>
                                                    <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(k)%>"/>
                                                    <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(k)%>"/>
                                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraA%>"/>
                                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraB%>"/>
                                                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                                    <input type="hidden" name="status" value="view"/>
                                                </form>
                                                
                                                
                                                <tr>
                                                        <td class="su" align="center" witdh="40"> 
                                                            <a href="javascript:viewReferto(<%=k%>)"><%=k+1/*gestioneTorneiGuest.getIncontri(k).IDPartita*/%></a>
                                                        </td>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTorneiGuest.getNomeSquadreA(k)%>
                                                             - <%=gestioneTorneiGuest.getNomeSquadreB(k)%>
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
                                                
                                                <form name="viewFormReferto<%=k%>" method="post" action="vediReferto.jsp">
                                                    <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(k).IDPartita%>"/>
                                                    <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(k)%>"/>
                                                    <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(k)%>"/>
                                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraA%>"/>
                                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraB%>"/>
                                                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                                    <input type="hidden" name="status" value="view"/>
                                                </form>

                                                    <tr>
                                                        <td class="su" align="center" witdh="40"> 
                                                            <a href="javascript:viewReferto(<%=k%>)"><%=k+1/*gestioneTorneiGuest.getIncontri(k).IDPartita*/%></a>
                                                        </td>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTorneiGuest.getNomeSquadreA(k)%>
                                                             - <%=gestioneTorneiGuest.getNomeSquadreB(k)%>
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
        <div align="center">
            <b> RITORNO: </b>
        </div>
        <br>     
         
         <table class="calendario" align="center">  
             <tr>
                          <%  
                                newline=false;
                                for (i=(giornate/2)+1;i<=giornate;i++)
                                {
                                    if(newline==false)
                                    {%>
                                        <td align="center">
                                            <table class="calendario" align="center">
                                                <% if((gestioneTorneiGuest.getIncontri(i).nomeAss)==(gestioneTorneiGuest.getClassifiche().length))
                                                { %>
                                                <% } %>
                                                
                                                <th colspan="2" width="300"> Giornata <%=i%>:</th>
                                                <%for(j=0;j<partite;j++)
                                                {%>
                                                    
                                                <form name="viewFormReferto<%=k%>" method="post" action="vediReferto.jsp">
                                                    <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(k).IDPartita%>"/>
                                                    <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(k)%>"/>
                                                    <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(k)%>"/>
                                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraA%>"/>
                                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraB%>"/>
                                                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                                    <input type="hidden" name="status" value="view"/>
                                                </form>
                                                
                                                    <tr>
                                                        <td class="su" align="center" witdh="40"> 
                                                            <a href="javascript:viewReferto(<%=k%>)"><%=k+1/*gestioneTorneiGuest.getIncontri(k).IDPartita*/%></a>
                                                        </td>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTorneiGuest.getNomeSquadreA(k)%>
                                                             - <%=gestioneTorneiGuest.getNomeSquadreB(k)%>
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
                                                    
                                                <form name="viewFormReferto<%=k%>" method="post" action="vediReferto.jsp">
                                                    <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(k).IDPartita%>"/>
                                                    <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(k)%>"/>
                                                    <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(k)%>"/>
                                                    <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraA%>"/>
                                                    <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(k).IDSquadraB%>"/>
                                                    <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                                    <input type="hidden" name="status" value="view"/>
                                                </form>
                                                
                                                <tr>
                                                        <td class="su" align="center" witdh="40"> 
                                                            <a href="javascript:viewReferto(<%=k%>)"><%=k+1/*gestioneTorneiGuest.getIncontri(k).IDPartita*/%></
                                                        </td>
                                                        <td class="giu" align="center" width="200">
                                                            <%=gestioneTorneiGuest.getNomeSquadreA(k)%>
                                                             - <%=gestioneTorneiGuest.getNomeSquadreB(k)%>
                                                        </td>
                                                    </tr>
                                                <%k++;}%>
                                            </table>
                                        </td>
                                    <%}
                                    if(giornate==10)
                                    {
                                        if(i==8)
                                            newline=true;
                                        else
                                            newline=false;
                                    }
                                    else if(giornate==14)
                                    {
                                        if((i==10)||(i==13))
                                            newline=true;
                                        else
                                            newline=false;
                                    }
                                    else
                                    {
                                        if(i%3==0)
                                            newline=true;
                                        else
                                            newline=false;
                                    }
                                }%>
                          <tr>
                              
                              
         </table><br><br>
         
         <h3 align="center"> Classifica </h3><br>
         
         
          <table class="calendario" align="center" width="900">
                        <tr>
                            <th class="calendario" align="center">Posizione</th>
                            <th class="calendario" align="center" width="180">Squadra</th>
                            <th class="calendario" align="center">Punti</th>
                            <th class="calendario" align="center">Partite Giocate</th>
                            <th class="calendario" align="center">Vittorie </th>
                            <th class="calendario" align="center">Pareggi </th>
                            <th class="calendario" align="center">Sconfitte</th>
                            <th class="calendario" align="center">GF</th>
                            <th class="calendario" align="center">GS</th>
                        </tr>  
                        
                      <%  for (i=0;i<gestioneTorneiGuest.getClassifiche().length;i++)
                                {%>  
                                    <form name="viewForm<%=i%>" method="post" action="vediSquadra.jsp">
                                        <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getClassifiche(i).IDSquadra%>"/>
                                
                                        <input type="hidden" name="vista" value="view"/>
                                        <input type="hidden" name="status" value="view"/>
                                    </form>
                                        <tr>
                                            <td class="giu" align="center"><b><%= i+1 %>°</b></td>
                                            <td class="giu" align="center"><a href="javascript:viewSquadra(<%=i%>)"><%=gestioneTorneiGuest.getNomeSquadreClassifica(i)%></a></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Punti)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Partite)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Vittorie)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Pareggi)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Sconfitte)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalFatti)%></td>
                                            <td class="giu" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalSubiti)%></td> 
                                        </tr>
                                    <%                                    
                                }%>
         </table>        

         
       <% }
            else 
            {
       %>   
       
            <% if((gestioneTorneiGuest.getClassifiche().length)==2)
                            {%>
                             
                            <form name="viewFormReferto<%=0%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(0).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(0)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(0)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                            <h3 class="green" align="center"> 
                                <%=gestioneTorneiGuest.getNomeSquadreA(0)%>
                                - <%=gestioneTorneiGuest.getNomeSquadreB(0)%> 
                            </h3>
                            <h4  align="center" ><a href="javascript:viewReferto(<%=0%>)">Vedi Referto</a></h4>        
                             
                            <%}
                            else if((gestioneTorneiGuest.getClassifiche().length)==4)
                            {%>
                            
                            <form name="viewFormReferto<%=0%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(0).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(0)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(0)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            <form name="viewFormReferto<%=1%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(1).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(1)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(1)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(1).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(1).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                            <form name="viewFormReferto<%=2%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(2).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(2)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(2)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(2).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(2).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            
                            <h3 align="center"> Tabellone </h3><br> 

                            <table class="calendario" align="center">
                                <tr>
                                    <td>
                                        <table width="300">
                                            <caption>SEMIFINALE<br></caption>
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=0%>)">A</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(0)%> - <%=gestioneTorneiGuest.getNomeSquadreB(0)%></td>
                                            </tr>
                                            <tr height="70"></tr>
                                           
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=1%>)">B</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(1)%> - <%=gestioneTorneiGuest.getNomeSquadreB(1)%></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    <table width="300">
                                        <caption>FINALE</caption>
                                        
                                        <tr>
                                            <%if (((gestioneTorneiGuest.getIncontri(2).IDSquadraA)!=0) && ((gestioneTorneiGuest.getIncontri(2).IDSquadraB)!=0))
                                            { %>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=2%>)">#</a></b></td> <% } 
                                            else { %>
                                                <td class="su" align="center"><b>#</b></td>
                                                <% } %>
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(2).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(2))%>
                                                <%}%>
                                            </td> 
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(2).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(2))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                    </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((gestioneTorneiGuest.getClassifiche().length)==8)
                            {%>
                            
                            <form name="viewFormReferto<%=0%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(0).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(0)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(0)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(0).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            <form name="viewFormReferto<%=1%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(1).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(1)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(1)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(1).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(1).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                            <form name="viewFormReferto<%=2%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(2).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(2)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(2)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(2).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(2).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                           <form name="viewFormReferto<%=3%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(3).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(3)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(3)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(3).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(3).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            <form name="viewFormReferto<%=4%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(4).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(4)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(4)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(4).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(4).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                                
                            <form name="viewFormReferto<%=5%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(5).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(5)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(5)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(5).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(5).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            <form name="viewFormReferto<%=6%>" method="post" action="vediReferto.jsp">
                                <input type="hidden" name="IDPartita" value="<%=gestioneTorneiGuest.getIncontri(6).IDPartita%>"/>
                                <input type="hidden" name="nomeSquadraA" value="<%=gestioneTorneiGuest.getNomeSquadreA(6)%>"/>
                                <input type="hidden" name="nomeSquadraB" value="<%=gestioneTorneiGuest.getNomeSquadreB(6)%>"/>
                                <input type="hidden" name="IDSquadraA" value="<%=gestioneTorneiGuest.getIncontri(6).IDSquadraA%>"/>
                                <input type="hidden" name="IDSquadraB" value="<%=gestioneTorneiGuest.getIncontri(6).IDSquadraB%>"/>
                                <input type="hidden" name="nomeTorneo" value="<%=request.getParameter("nome")%>"/>

                                <input type="hidden" name="status" value="view"/>
                            </form>
                            
                            
                            <h3 align="center"> Tabellone </h3><br> 
                            <table class="calendario" align="center">
                                <tr>
                                    <td>
                                        <table align="center" width="300">
                                            <caption><b>QUARTI DI FINALE</b></caption>
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=0%>)">A</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(0)%> - <%=gestioneTorneiGuest.getNomeSquadreB(0)%></td>
                                            </tr>
                                            <tr height="35"></tr>
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=1%>)">B</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(1)%> - <%=gestioneTorneiGuest.getNomeSquadreB(1)%></td>
                                            </tr>
                                            <tr height="60"></tr>
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=2%>)">C</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(2)%> - <%=gestioneTorneiGuest.getNomeSquadreB(2)%></td>
                                            </tr>
                                            <tr height="35"></tr>
                                            <tr>
                                                <td class="su" align="center"><b><a href="javascript:viewReferto(<%=3%>)">D</a></b></td>
                                                <td class="giu" align="center"><%=gestioneTorneiGuest.getNomeSquadreA(3)%> - <%=gestioneTorneiGuest.getNomeSquadreB(3)%></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table width="300">
                                            <caption><b>SEMIFINALE</b></caption>
                                            <tr>
                                            <%if (((gestioneTorneiGuest.getIncontri(4).IDSquadraA)!=0) && ((gestioneTorneiGuest.getIncontri(4).IDSquadraB)!=0))
                                            { %>
                                                <td class="su" align="center" width="25"><b><a href="javascript:viewReferto(<%=4%>)">E</a></b></td> <% } 
                                            else { %>
                                                <td class="su" align="center" width="25"><b>E</b></td>
                                                <% } %>
                                                
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(4).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(4))%>
                                                <%}%>
                                            </td>
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(4).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(4))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        <tr height="135"></tr>
                                        
                                            <tr>
                                            <%if (((gestioneTorneiGuest.getIncontri(5).IDSquadraA)!=0) && ((gestioneTorneiGuest.getIncontri(5).IDSquadraB)!=0))
                                            { %>
                                                <td class="su" align="center" width="25"><b><a href="javascript:viewReferto(<%=5%>)">F</a></b></td> <% } 
                                            else { %>
                                                <td class="su" align="center" width="25"><b>F</b></td>
                                                <% } %>
                                                
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(5).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>C</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(5))%>
                                                <%}%>
                                            </td> 
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(5).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>D</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(5))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table width="300">
                                            <caption><b>FINALE</b></caption>
                                            
                                            <tr>
                                            <%if (((gestioneTorneiGuest.getIncontri(6).IDSquadraA)!=0) && ((gestioneTorneiGuest.getIncontri(6).IDSquadraB)!=0))
                                            { %>
                                                <td class="su" align="center" width="25"><b><a href="javascript:viewReferto(<%=6%>)">#</a></b></td> <% } 
                                            else { %>
                                                <td class="su" align="center" width="25"><b>#</b></td>
                                                <% } %>
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(6).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>E</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(6))%>
                                                <%}%>
                                            </td> 
                                            <td class="giu" align="center">
                                                <%if ((gestioneTorneiGuest.getIncontri(6).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>F</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(6))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <%}
                            else if((gestioneTorneiGuest.getClassifiche().length)==16)
                            {%>
                            <h4 align="center"> Tabellone </h4><br> 
                            <table>
                                <tr>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>Ottavi di finale</b></caption>
                                            <tr><td><b>A</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(0)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(0)%></td></tr>
                                            <tr><td><b>B</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(1)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(1)%></td></tr>
                                            <tr><td><b>C</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(2)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(2)%></td></tr>
                                            <tr><td><b>D</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(3)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(3)%></td></tr>
                                            <tr><td><b>E</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(4)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(4)%></td></tr>
                                            <tr><td><b>F</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(5)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(5)%></td></tr>
                                            <tr><td><b>G</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(6)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(6)%></td></tr>
                                            <tr><td><b>H</b></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreA(7)%></td><td width="100"><%=gestioneTorneiGuest.getNomeSquadreB(7)%></td></tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" width="200">
                                            <caption><b>QUARTI DI FINALE</b></caption>
                                            <tr><td><b>I</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(8).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>A</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(8))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(8).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>B</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(8))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>L</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(9).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>C</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(9))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(9).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>D</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(9))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>M</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(10).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>E</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(10))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(10).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>F</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(10))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>N</b></td>
                                                <tr>
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(11).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>G</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(11))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(11).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>H</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(11))%>
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
                                                <%if ((gestioneTorneiGuest.getIncontri(12).IDSquadraA)==0)
                                                {%>
                                                    Vincente <b>I</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreA(12))%>
                                                <%}%>
                                            </td> 
                                            <td width="100">
                                                <%if ((gestioneTorneiGuest.getIncontri(12).IDSquadraB)==0)
                                                {%>
                                                    Vincente <b>L</b>
                                                <%}
                                                else
                                                {%>
                                                    <%=(gestioneTorneiGuest.getNomeSquadreB(12))%>
                                                <%}%>
                                            </td>
                                        </tr>
                                            <tr><td><b>P</b></td>
                                            <tr>
                                                <td width="100">
                                                    <%if ((gestioneTorneiGuest.getIncontri(13).IDSquadraA)==0)
                                                    {%>
                                                        Vincente <b>M</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTorneiGuest.getNomeSquadreA(13))%>
                                                    <%}%>
                                                </td> 
                                                <td width="100">
                                                    <%if ((gestioneTorneiGuest.getIncontri(13).IDSquadraB)==0)
                                                    {%>
                                                        Vincente <b>N</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTorneiGuest.getNomeSquadreB(13))%>
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
                                                    <%if ((gestioneTorneiGuest.getIncontri(14).IDSquadraA)==0)
                                                    {%>
                                                        Vincente <b>O</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTorneiGuest.getNomeSquadreA(14))%>
                                                    <%}%>
                                                </td> 
                                                <td width="100">
                                                    <%if ((gestioneTorneiGuest.getIncontri(14).IDSquadraB)==0)
                                                    {%>
                                                        Vincente <b>P</b>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%=(gestioneTorneiGuest.getNomeSquadreB(14))%>
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
         
          <table class="calendario" align="center" width="800">
                        <tr>
                            <th class="calendario" align="center" width="50"></th>
                            <th class="calendario" align="center" width="220">Squadra</th>
                            <th class="calendario" align="center" width="120">Vittorie </th>
                            <th class="calendario" align="center" width="120">Sconfitte</th>
                            <th class="calendario" align="center" width="110">Giocate</th>
                            <th class="calendario" align="center" width="60">GF</th>
                            <th class="calendario" align="center" width="60">GS</th>
                        </tr>  
                        
                      <%  for (i=0;i<gestioneTorneiGuest.getClassifiche().length;i++)
                                {%>  
                                    <form name="viewForm<%=i%>" method="post" action="vediSquadra.jsp">
                                        <input type="hidden" name="IDSquadra" value="<%=gestioneTorneiGuest.getClassifiche(i).IDSquadra%>"/>
                                        
                                        <input type="hidden" name="vista" value="view"/>
                                        <input type="hidden" name="status" value="view"/>
                                    </form>
                                
                            <% if((gestioneTorneiGuest.getClassifiche(i).Sconfitte)==1)
                            {  %>
                              
                                <tr> 
                                    <td class="giu" align="center"><b><%= i+1 %>°</b></td>
                                    <td class="red" align="center"><a href="javascript:viewSquadra(<%=i%>)"><%=gestioneTorneiGuest.getNomeSquadreClassifica(i)%></a></td>
                                    <td class="red" align="center">ELIMINATA</td>
                                    <td class="red" align="center"></td>
                                    <td class="red" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Partite)%></td>
                                    <td class="red" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalFatti)%></td>
                                    <td class="red" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalSubiti)%></td> 
                                </tr>
                            
                         <% } else { %> 
                           
                                    <tr> 
                                        <td class="giu" align="center"><b><%= i+1 %>°</b></td>
                                        <td class="su" align="center"><a href="javascript:viewSquadra(<%=i%>)"><%=gestioneTorneiGuest.getNomeSquadreClassifica(i)%></a></td>
                                        <td class="su" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Vittorie)%></td>
                                        <td class="su" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Sconfitte)%></td>
                                        <td class="su" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).Partite)%></td>
                                        <td class="su" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalFatti)%></td>
                                        <td class="su" align="center"><%=(gestioneTorneiGuest.getClassifiche(i).GoalSubiti)%></td> 
                                    </tr>
                                    <%                                    
                                } 
                          }%>
         </table>                        
       
              <% } %>
              
              <br><br>
              <h3 align="center"> Informazioni sul Torneo </h3><br>
                   
             <h6> <%= request.getParameter("descrizione") %> </h6><br>
                   
          
          <br><br>
          <table align="center" width="900">
            <tr align="center">
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