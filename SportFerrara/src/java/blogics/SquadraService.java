package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class SquadraService extends Object {
  
  /* Costruttore privato */
  private SquadraService () {}
  
  /* Ritorna la squadra del gestore */
  public static Squadra getSquadraGestore (DataBase database, int gestore)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra squadra;
    
    String sql;
    
    sql = " SELECT * FROM squadra " +
          " WHERE ID_Gestore ='" + Conversion.getDatabaseString("" + gestore) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        squadra=new Squadra(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("SquadraService: getSquadra():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return squadra;
  }
  
  /* Ritorna tutte le squadre di un amministratore */
  public static Vector getSquadre (DataBase database, int admin)
  throws NotFoundDBException, ResultSetDBException {
    
    String sql;

    Squadra squadra;
    Vector<Squadra> squadre = new Vector<Squadra>();

    sql = " SELECT S.ID_Squadra, S.Nome_squadra, S.Logo_squadra, S.Immagine_squadra, S.Nome_sponsor, S.Logo_sponsor, S.Sede, S.Descrizione, S.ID_Gestore FROM squadra AS S, REGISTRATO AS R " +
          " WHERE R.Id_Amministratore='" + Conversion.getDatabaseString("" + admin)+"' AND" +
          " S.ID_Gestore=R.Id_Utente AND S.Nome_squadra<>'Riposo' AND S.Compilata<>'N' " +
          " ORDER BY S.Nome_squadra" ;

    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        squadra = new Squadra(resultSet);
        squadre.add(squadra);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("SquadraService: getSquadre():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return squadre;
  }
  
  /* Ritorna tutte le squadre */
  public static Vector getSquadre (DataBase database)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra squadra;
    Vector<Squadra> squadre = new Vector<Squadra>();
    String sql = "";
    
    sql = " SELECT * FROM squadra " +
          " WHERE Nome_squadra<>'Riposo' AND Sede<>'null'" +
          " ORDER BY Nome_squadra";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        squadra = new Squadra(resultSet);
        squadre.add(squadra);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("SquadraService: getSquadre():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return squadre;
  }
  
  /* Ritorna una squadra dato l'ID */
  public static Squadra visualSquadraGuest(DataBase database, int ID)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra s;

    String sql = " SELECT * " +
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
      throw new ResultSetDBException("SquadraService: getvisualSquadra():  ResultSetDBException: "+ex.getMessage(), database);
    }
    
    return s;
  }
}