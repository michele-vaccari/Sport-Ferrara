package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class CalendarioService extends Object {
  
  /* Costruttore privato */
  private CalendarioService () {}
  
  /* Ritorno un vettore di tornei creati da un gestore */
  public static Vector getTornei (DataBase database, int gestore)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    Vector<Torneo> tornei = new Vector<Torneo>();
    String sql;

    sql = " SELECT * FROM torneo " +
          " WHERE " +
          " Nome IN (SELECT Torneo FROM partecipa WHERE Squadra=(" +
          " SELECT Nome FROM squadra WHERE Gestore='" + Conversion.getDatabaseString("" + gestore) + "')) " +
          " ORDER BY nome";
    
    util.Debug.println("EF> " + sql);
    
    ResultSet resultSet = database.select(sql);

    try {
      
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        tornei.add(torneo);
      }
    }
    catch (SQLException ex) {throw new ResultSetDBException("CalendarioService: getTornei():  Errore nel ResultSet: " + ex.getMessage(), database);}
    
    return tornei;
  }
  
  /* Ritorno la tipologia del torneo */
  public static String getTipologia (DataBase database, String NomeTorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    String sql;

    sql = " SELECT Tipologia FROM torneo" +
          " WHERE Nome='" + Conversion.getDatabaseString(NomeTorneo) + "'";
    
    util.Debug.println("EF> "+sql);

    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        return torneo.tipologia;
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("CalendarService: getTipologia():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return null;
  }
  
  /* Ritorno il numero delle squadre che partecipano al torneo */
  public static int getNumeroSQ (DataBase database, String NomeTorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Torneo torneo;
    String sql;
    int numero;

    sql = " SELECT COUNT(*) AS numero FROM partecipa" +
          " WHERE Torneo='" + Conversion.getDatabaseString(NomeTorneo) + "'";

    util.Debug.println("EF> " + sql);

    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        numero = (resultSet.getInt("numero"));
        resultSet.close();
        return numero;
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("CalendarService: getNumeroSQ(): Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return 0;
  }
}