package blogics;

import java.sql.*;
import java.util.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class UtenteService {
  
  /* Costruttore privato */
  private UtenteService () {}
  
  /* Ritorna un utente nota la sua email */
  public static Utente getUser (DataBase database, String email)
  throws NotFoundDBException, ResultSetDBException {
    
    Utente user = null;

    String sql = " SELECT * " +
                 " FROM utente " +
                 " WHERE " +
                 " Email= '" + util.Conversion.getDatabaseString(email) + "' AND Attivo= 'Y' ";
   
    ResultSet resultSet = database.select(sql);
   
    try {
      if (resultSet.next())
        user = new Utente(resultSet);
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getUser():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return user;
  }
  
  /* Ritorna un utente nota la sua email */
  public static Registrato getRegistrato (DataBase database, String email)
  throws NotFoundDBException, ResultSetDBException {
    
    Registrato reg = null;
    
    String sql = " SELECT * " +
                 " FROM utente " +
                 " WHERE " +
                 " Email= '" + util.Conversion.getDatabaseString(email) + "' AND Attivo= 'Y' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        reg = new Registrato(resultSet);
      
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getRegistrato():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return reg;
  }
  
  /* Ritorna un arbitro noto il suo SSN */
  public static Arbitro getArbitro (DataBase database, int SSN)
  throws NotFoundDBException, ResultSetDBException {
    
    Arbitro arbitro;
    String sql;
    
    sql = " SELECT U.Id_Utente, U.NOME, U.COGNOME, U.Email, U.PASSWORD, U.Tipo, U.Attivo, R.INDIRIZZO, R.TELEFONO, R.Id_Amministratore, A.FOTO, A.Data_nascita, A.CARRIERA " +
          " FROM utente AS U, registrato AS R, arbitro AS A " +
          " WHERE U.Attivo= 'Y' AND U.Id_Utente= R.Id_Utente " +
          " AND A.Id_Registrato ='" + Conversion.getDatabaseString("" + SSN) + "' AND R.Id_Utente= A.Id_Registrato ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        arbitro = new Arbitro(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getArbitro():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return arbitro;
  }
  
  /* Ritorna un gestore noto il suo SSN */
  public static Gestore getGestore (DataBase database, int SSN)
  throws NotFoundDBException, ResultSetDBException {
    
    Gestore gestore;
    String sql;
    
     sql = " SELECT * FROM utente AS U, registrato AS R, GESTORE_SQUADRA AS G " +
           " WHERE U.Attivo= 'Y' AND U.Id_Utente = R.Id_Utente" +
           " AND G.Id_Registrato ='" + Conversion.getDatabaseString("" + SSN) + "' AND R.Id_Utente= G.Id_Registrato ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        gestore = new Gestore(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getGestore():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return gestore;
  }
  
  /* Ritorna tutti gli utenti creati da un amministratore */
  public static Vector getRegistrati (DataBase database, int Admin)
  throws NotFoundDBException, ResultSetDBException {
    
    Registrato r;
    Vector<Registrato> registrati = new Vector<Registrato>();
    String sql_1;
    
    sql_1 = " SELECT * FROM utente AS U, registrato AS R " +
            " WHERE R.Id_Amministratore ='" + Conversion.getDatabaseString("" + Admin) + "' " +
            " AND U.Attivo= 'Y' AND U.Id_Utente = R.Id_Utente "+
            " ORDER BY COGNOME, NOME ";
    
    util.Debug.println("EF> " + sql_1);
    
    ResultSet resultSet = database.select(sql_1);        
    
    try {
      while (resultSet.next()) {
        r = new Registrato(resultSet);
        registrati.add(r);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtentiService: getRegistrati():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return registrati;
  }
  
  /* Ritorna tutti gli arbitri creati da un amministratore */
  public static Vector getArbitri (DataBase database, int Admin)
  throws NotFoundDBException, ResultSetDBException {
    
    Arbitro a;
    Vector<Arbitro> arbitri = new Vector<Arbitro>();
    String sql_1;
    
    sql_1 = " SELECT * FROM utente AS U, registrato AS R, arbitro AS A " +
            " WHERE R.Id_Amministratore ='" + Conversion.getDatabaseString("" + Admin) + "' " +
            " AND U.Attivo= 'Y' AND U.Id_Utente = R.Id_Utente AND R.Id_Utente = A.Id_Registrato " +
            " ORDER BY COGNOME, NOME ";
    
    util.Debug.println("EF> "+sql_1);
    
    ResultSet resultSet = database.select(sql_1);        
    
    try {
      while (resultSet.next()) {
        a = new Arbitro(resultSet);
        arbitri.add(a);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getArbitri():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return arbitri;
  }
    
  /* Ritorna tutti i gestori di sqadra creati da un amministratore */
  public static Vector getGestori (DataBase database, int Admin)
  throws NotFoundDBException, ResultSetDBException {
    
    Gestore g;
    Vector<Gestore> gestori = new Vector<Gestore>();
    String sql_1;

    sql_1 = " SELECT * FROM utente AS U, registrato AS R, GESTORE_SQUADRA AS G, SQUADRA AS S " +
            " WHERE R.Id_Amministratore ='" + Conversion.getDatabaseString("" + Admin) + "' " +
            " AND U.Attivo= 'Y' AND U.Id_Utente = R.Id_Utente AND R.Id_Utente = G.Id_Registrato AND G.Id_Registrato = S.ID_Gestore" +
            " ORDER BY COGNOME, NOME ";
    
    util.Debug.println("EF> " + sql_1);
    
    ResultSet resultSet = database.select(sql_1);        
    
    try {
      while (resultSet.next()) {
        g = new Gestore(resultSet);
        gestori.add(g);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getGestori():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return gestori;
  }
  
  /* Ritorna l'SSN di un utente nota la sua email */
  public static int getSSNUtente (DataBase database, String email)
  throws NotFoundDBException, ResultSetDBException {
    
    Utente utente;
    String sql;

    sql = " SELECT Id_Utente FROM utente WHERE " +
          " Email='" + util.Conversion.getDatabaseString(email) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        utente = new Utente(resultSet);
      else
        return 0;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("UtenteService: getGiocatore():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return utente.SSN;
  }
   
  /* Inserimento di un arbitro */
  public static Arbitro inserimentoNuovoArbitro (DataBase database, int SSN,String nome, String cognome, String email, String password,
                                                 String type, String indirizzo, String telefono, int Admin, String foto, String data_n,
                                                 String nazionalità, String carriera)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    Arbitro arbitro;
    
    arbitro = new Arbitro(SSN, nome, cognome, email, password, type, indirizzo, telefono, Admin, foto, data_n, nazionalità, carriera);
    
    arbitro.insert(database);
    
    return arbitro;
   }     
  
  /* Inserimento di un gestore */
  public static Gestore inserimentoNuovoGestore (DataBase database, int SSN,String nome, String cognome, String email, String password,
                                                 String type, String indirizzo, String telefono, int Admin, String squadra)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    Gestore gestore;
    
    gestore= new Gestore(SSN, nome, cognome, email, password, type, indirizzo, telefono, Admin, squadra);
    
    gestore.insert(database);
    
    return gestore;
  }
}