package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class GiocatoreService extends Object {
  
  /* Costruttore privato */
  private GiocatoreService () {}
  
  /* Restituisce un giocatore dato il suo SSN */
  public static Giocatore getGiocatore (DataBase database, int SSNGiocatore)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore giocatore;
    String sql;

    sql = " SELECT *" +
          " FROM giocatore " +
          " WHERE ID_Giocatore='" + Conversion.getDatabaseString("" + SSNGiocatore) + "' and Attivo= 'Y'";

    ResultSet resultSet = database.select(sql);    

    try {
      if (resultSet.next())
        giocatore = new Giocatore(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("GiocatoriService: getGiocatore():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return giocatore;
  }
  
  /* Restituisce tutti i giocatori di un dato gestore */
  public static Vector getGiocatori (DataBase database, int gestore)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore g;
    Vector<Giocatore> giocatori = new Vector<Giocatore>();
    String sql;

    sql = " SELECT * FROM giocatore " +
          " WHERE " +
          " ID_Squadra=(SELECT ID_Squadra FROM squadra WHERE ID_Gestore='" + Conversion.getDatabaseString("" + gestore) + "') AND Attivo= 'Y' " +
          " ORDER BY Ruolo DESC, Numero_maglia ";
    
    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        g = new Giocatore(resultSet);
        giocatori.add(g);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("GiocatoreService: getGiocatori():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    return giocatori;
  }
  
  /* Restituisce tutti i giocatori di una determinata squadra */
  public static Vector getGiocatoriGuest (DataBase database, int ID)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore g;
    Vector<Giocatore> giocatori = new Vector<Giocatore>();
    String sql;

    sql = " SELECT * FROM giocatore " +
          " WHERE " +
          " ID_Squadra='" + ID + "' AND Attivo= 'Y' " +
          " ORDER BY Ruolo DESC, Numero_maglia ";
    
    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        g = new Giocatore(resultSet);
        giocatori.add(g);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("GiocatoriService: getGiocatoriGuest():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return giocatori;
  }
  
  /* Restituisce tutti i dati di un giocatore dato il suo SSN */
  public static Giocatore visualGiocatoreGuest (DataBase database, int ID)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore g;
    
    String sql = " SELECT * " +
                 " FROM giocatore " +
                 " WHERE " +
                 " ID_Giocatore='" + Conversion.getDatabaseString("" + ID) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        g = new Giocatore(resultSet);
      else
          g = null;
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("GiocatoreService: getvisualSquadra():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return g;
  }
  
  /* Inserisce un nuovo giocatore */
  public static Giocatore inserimentoNuovoGiocatore (DataBase database, int SSNGiocatore, String nome, String cognome,  String nazionalità,
                                                     String dataNascita, int numeroMaglia, String ruolo, String foto, int goal, int ammonizioni,
                                                     int espulsioni, String descrizione, int IDSquadra)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Giocatore giocatore;
    
    giocatore = new Giocatore (SSNGiocatore, nome, cognome, nazionalità, dataNascita, numeroMaglia,
                               ruolo, foto, goal, ammonizioni, espulsioni, descrizione, IDSquadra);
    giocatore.insert(database);       
    return giocatore;
  }
  
  /* Ritorna l'SSN di un giocatore dati in ingresso nome, cognome e IDSquadra */
  public static int getSSNGiocatore (DataBase database,String cognome, String nome, int IDSquadra)
  throws NotFoundDBException, ResultSetDBException {
    
    Giocatore giocatore;
    String sql;

    sql = " SELECT ID_Giocatore FROM giocatore WHERE" +
          " Cognome='" + Conversion.getDatabaseString(cognome) + "' AND " +
          " Nome='" + Conversion.getDatabaseString(nome) + "' AND " +
          " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "'";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        giocatore=new Giocatore(resultSet);
      else
        return 0;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("GiocatoriService: getGiocatore():  Errore nel ResultSet: "+ex.getMessage(),database);
    }
    
    return giocatore.SSNGiocatore;
  }
}