package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class TorneoService extends Object {
  
  /* Costruttore privato */
  private TorneoService(){}
  
  /* Ritorno un torneo noto il suo nome e l'SSN dell'ammininistratore */
  public static Torneo visualTorneo (DataBase database, String nomeTorneo, int creatore)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo = null;
    
    String sql = " SELECT * " +
                 " FROM torneo " +
                 " WHERE " +
                 " Nome= '" + util.Conversion.getDatabaseString(nomeTorneo) + "' AND" +
                 " ID_Amministratore='" + Conversion.getDatabaseString("" + creatore) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        torneo = new Torneo(resultSet);
      
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getvisualTorneo():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return torneo;
  }
  
  /* Creo un calendario */
  public static Calendario creaCalendario (DataBase database, int[] squadre, String tipologia, int idTorneo, int numSQ)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Calendario calendario;

    calendario = new Calendario(squadre, tipologia, idTorneo, numSQ);

    calendario.insert(database);

    return calendario;
  }
  
  /* Ritorno tutti gli incontri di un torneo */
  public static Vector getIncontri (DataBase database, String tipologia, int IDTorneo)
  throws NotFoundDBException, ResultSetDBException  {
    
    Incontro i;
    Vector<Incontro> incontri = new Vector<Incontro>();
    String sql ="";

    if (tipologia.equals("I")) {
      
      sql = " SELECT * FROM giocano" +
            " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' " +
            " ORDER BY Numero_giornata_o_fase ASC";
    }
    else {
      sql = " SELECT * FROM giocano" +
            " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' " +
            " ORDER BY Numero_giornata_o_fase DESC";
    }
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        i = new Incontro(resultSet);
        incontri.add(i);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getIncontri():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return incontri;
  }

  /* Ritorno gli incontri di un torneo */
  public static Vector getIncontriFase (DataBase database, int IDTorneo, String fase)
  throws NotFoundDBException, ResultSetDBException {
    
    Incontro incontro;
    Vector<Incontro> incontri = new Vector<Incontro>();
    String sql;
    
    if (fase.equals("Finale"))
      fase = "1";
    else if(fase.equals("Semifinale"))
      fase = "2";
    else if(fase.equals("Quarti di Finale"))
      fase = "3";
    else if(fase.equals("Ottavi di Finale"))
      fase = "4";
    else
      fase = fase.substring(9,10);
    
    sql = " SELECT * FROM giocano" +
          " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' AND " +
          " Numero_giornata_o_fase='" + Conversion.getDatabaseString(fase) + "' AND " +
          " ID_SquadraA<>'0' AND ID_SquadraB<>'0' AND " +
          " ID_Partita NOT IN (SELECT ID_Partita FROM referto) ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        incontro = new Incontro(resultSet);
        incontri.add(incontro);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getIncontriFase():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return incontri;
  }
  
  /* Ritorna il nome della squadra noto il suo ID */
  public static String visualSquadra (DataBase database, int ID)
  throws NotFoundDBException, ResultSetDBException
  {
    Squadra s;

    String sql = " SELECT Nome_Squadra " +
                 " FROM squadra " +
                 " WHERE " +
                 " ID_Squadra='" + Conversion.getDatabaseString("" + ID) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next()) 
          s = new Squadra(resultSet);
      else
          s = null;
      
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getvisualSquadra():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return s.nomeSquadra;
  }
  
  /* Ritorna tutte le squadre iscritte ad un torneo */
  public static Vector getPartecipanti (DataBase database, int IDtorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra s;
    Vector<Squadra> squadre = new Vector<Squadra>();
    String sql;

    sql = " SELECT S.ID_Squadra, S.Nome_squadra, S.Logo_squadra, S.Immagine_squadra, S.Nome_sponsor, S.Logo_sponsor, S.Sede, S.Descrizione , S.ID_Gestore " +
          " FROM SQUADRA AS S, PARTECIPANO AS P " +
          " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDtorneo) + "' AND P.ID_SQUADRA=S.ID_SQUADRA ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        s = new Squadra(resultSet);
        squadre.add(s);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getPartecipanti():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return squadre;
  }

  /* Ritorna tutti i tornei creati da un amministratore */
  public static Vector getTornei (DataBase database, int creatore)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    Vector<Torneo> tornei = new Vector<Torneo>();
    String sql;
    
    sql = " SELECT * FROM torneo " +
          " WHERE " +
          " ID_Amministratore='" + Conversion.getDatabaseString("" + creatore) + "' " +
          " ORDER BY nome";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        tornei.add(torneo);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getTornei(ID_Amministratore):  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return tornei;
  }

  /* Ritorna tutti i tornei */
  public static Vector getTornei (DataBase database)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    Vector<Torneo> tornei = new Vector<Torneo>();
    String sql;
    
    sql = " SELECT * FROM torneo " +
          " ORDER BY Nome";
    
    ResultSet resultSet=database.select(sql);
    
    try {
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        tornei.add(torneo);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getTornei(),del Guest:  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return tornei;
  }

  /* Ritorna i tornei a cui è iscritta una squadra dato il suo ID */
  public static Vector getTorneiSquadra (DataBase database, int ID)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    Vector<Torneo> tornei = new Vector<Torneo>();
    String sql;

    sql = " SELECT T.* FROM torneo AS T, partecipa AS P " +
          " WHERE T.ID_Torneo=P.ID_Torneo AND " +
          " P.ID_Squadra='" + Conversion.getDatabaseString("" + ID) + "' " +
          " ORDER BY Nome";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        tornei.add(torneo);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("TorneoService: getTornei(),del Guest:  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return tornei;
  }
  
  /* Creo un nuovo torneo */
  public static Torneo nuovoTorneo (DataBase database, int IDTorneo, String nome, String tipologia, String descrizione, int creatore, int[] squadra)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Torneo torneo;

    torneo = new Torneo(IDTorneo, nome, tipologia, descrizione, creatore, squadra);

    torneo.insert(database);

    return torneo;        
  }
}