package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class RefertoArbitroService {
  
  /* Costruttore privato */
  private RefertoArbitroService () {}
  
  /* Ritorna i giocatori di una squadra di un referto */
  public static Vector getGiocatori (DataBase database, int IDSquadra, int IDReferto)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore giocatore;
    Vector<Giocatore> giocatori = new Vector<Giocatore>();
    String sql;

    sql = " SELECT G.*, F.Riserva, F.ID_Referto FROM giocatore AS G, formazione AS F " +
          " WHERE F.ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "'" +
          " AND F.ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "'" +
          " AND G.ID_Squadra=F.ID_Squadra AND G.ID_Giocatore=F.ID_Giocatore " +
          " ORDER BY F.Riserva, G.Ruolo, G.Nome, G.Cognome";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        giocatore = new Giocatore(resultSet);
        giocatori.add(giocatore);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: getGiocatori():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return giocatori;
  }

  /* Ritorna i goal effettuati dai giocatori di un referto */
  public static Vector getGoalFormazione (DataBase database, int IDSquadraA, int IDSquadraB, int IDReferto)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore giocatore;
    Vector<Giocatore> giocatori = new Vector<Giocatore>();
    String sql;

    sql = " SELECT g.Nome, g.Cognome, g.Foto, g.Foto, g.ID_Giocatore, G.ID_Squadra, m.Goal " +
          " FROM giocatore AS g, marcatore AS m" +
          " WHERE M.ID_Giocatore=G.ID_Giocatore" +
          " AND M.ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' " +
          " AND (G.ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadraA) + "' " +
          " OR G.ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadraB) + "') ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        giocatore = new Giocatore(resultSet);
        giocatori.add(giocatore);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: getGoalFormazione():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return giocatori;
  }
  
  /* Ritorna i cartellini dei giocatori di un referto */
  /* DOCUMENTAZIONE BASI DI DATI */
  public static Vector getCartelliniFormazione (DataBase database, int IDSquadraA, int IDSquadraB, int IDReferto)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore giocatore;
    Vector<Giocatore> giocatori = new Vector<Giocatore>();
    String sql;
    
    sql = " SELECT g.Nome, g.Cognome, g.Foto, g.Foto, g.ID_Giocatore, G.ID_Squadra, c.Ammonizione as FlagAmmonito, c.Espulsione as FlagEspulso " +
          " FROM giocatore AS g, cartellino AS C" +
          " WHERE C.ID_Giocatore=G.ID_Giocatore" +
          " AND C.ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' " +
          " AND (G.ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadraA) + "' " +
          " OR G.ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadraB) + "') ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        giocatore = new Giocatore(resultSet);
        giocatori.add(giocatore);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: getCartelliniFormazione():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return giocatori;
  }
  
  /* Ritorna una classifica data una squadra e il torneo a cui partecipa */
  public static Classifica getClassifica (DataBase database, int IDSquadra, int IDTorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Classifica classifica;
    String sql;

    sql = " SELECT * " +
          " FROM classifica " +
          " WHERE ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
          " ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "'";
    
    ResultSet resultSet = database.select(sql);
    
    try 
    {
      if (resultSet.next()) 
        classifica = new Classifica(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: getClassifica():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return classifica;
  }
  
  /* Decreta il vincitore di un referto */
  public static void setVincitore (DataBase database, int IDSquadra, int IDTorneo, int IDPartita, int IDReferto)
  throws NotFoundDBException, ResultSetDBException {
    
    int i = 0, count = 0, IDPartitaDopo = 0;
    boolean casa = true;
    String sql, fase;
    Incontro incontro = null;
    Incontro incontroNew = null;
    
    sql = " SELECT * FROM giocano WHERE ID_Partita='" + Conversion.getDatabaseString("" + IDPartita) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) 
        incontro = new Incontro(resultSet);
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: setVincitore():  Errore nel ResultSet di Fase: " + ex.getMessage(), database);
    }
    
    /* Seleziono l'ID della partita successiva a quella disputata */
    sql = " SELECT * FROM giocano WHERE Numero_giornata_o_fase='" + Conversion.getDatabaseString("" + incontro.nomeAss) + "' " +
          " AND ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' " +
          " ORDER BY ID_Partita ";
    
    resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        incontroNew = new Incontro(resultSet);
        i++;
        if(incontroNew.IDPartita == IDPartita)
          count=i;                    
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoArbitroService: setVincitore():  Errore nel ResultSet di Calcolo referto: " + ex.getMessage(), database);
    }
    
    if ((incontro.nomeAss) == 4) {
      
      if(count == 1) {
        IDPartitaDopo = IDPartita + 8;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 2) {
        IDPartitaDopo = IDPartita + 7;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 3) {
        IDPartitaDopo = IDPartita + 7;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 4) {
        IDPartitaDopo = IDPartita + 6;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 5) {
        IDPartitaDopo = IDPartita + 6;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 6) {
        IDPartitaDopo = IDPartita + 5;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 7) {
        IDPartitaDopo = IDPartita + 5;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
      if(count == 8) {
        IDPartitaDopo = IDPartita + 4;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 3);
      }
    }
    else if ((incontro.nomeAss) == 3) {
      
      if(count == 1) {
        IDPartitaDopo = IDPartita + 4;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 2);
      }
      if(count == 2) {
        IDPartitaDopo = IDPartita + 3;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 2);
      }
      if(count == 3) {
        IDPartitaDopo = IDPartita + 3;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 2);
      }
      if(count == 4) {
        IDPartitaDopo = IDPartita + 2;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 2);
      }
    }
    else if ((incontro.nomeAss) == 2) {
      
      if(count == 1) {
        IDPartitaDopo = IDPartita + 2;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 1);
      }
      if(count == 2) {
        IDPartitaDopo = IDPartita + 1;
        casa = false;
        incontro.update(database, IDSquadra, IDPartitaDopo, casa, 1);
      }
    }
  }
}