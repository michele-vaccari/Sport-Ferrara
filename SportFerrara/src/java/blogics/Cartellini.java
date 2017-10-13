package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Cartellini {
  
  /* Property */
  public int IDReferto;
  public int SSNGiocatore;
  public int numCart;
  public String flagGiallo;
  public String flagRosso;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Cartellini (int IDReferto, int SSNGiocatore, int numCart) {
    
    this.IDReferto = IDReferto;
    this.SSNGiocatore = SSNGiocatore;
    this.numCart = numCart;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Cartellini (ResultSet resultSet) {
    
    try {IDReferto = resultSet.getInt("ID_Referto"); } catch (SQLException sqle) {}
    try {SSNGiocatore = resultSet.getInt("ID_Giocatore"); } catch (SQLException sqle) {}
    try {numCart = resultSet.getInt("Numero"); } catch (SQLException sqle) {}
    try {flagGiallo = resultSet.getString("Ammonizione"); } catch (SQLException sqle) {} 
    try {flagRosso = resultSet.getString("Espulsione"); } catch (SQLException sqle) {} 
  }
  
  /* Inserimento di un nuovo cartellino */
  public void insert (DataBase database, boolean giallo, boolean rosso)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    String sql;
    
    /* Check di unicità */
    sql = " SELECT * " +
          " FROM cartellino WHERE " +
          " ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' AND " +
          " ID_Giocatore='" + Conversion.getDatabaseString("" + SSNGiocatore) + "'";

    ResultSet resultSet = database.select(sql);
    
    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Cartellini: insert(): Errore sul ResultSet.");
    }
    if (exist)
      throw new DuplicatedRecordDBException("Cartellini: insert(): Tentativo di inserimento di un cartellino già esistente");
    
    if (giallo == true && rosso == false) {
      
      sql = " INSERT INTO cartellino " +
            " (ID_Referto, ID_Giocatore, Numero, Ammonizione, Espulsione) " +
            " VALUES (" + Conversion.getDatabaseString("" + IDReferto) + ", " +
            " " + Conversion.getDatabaseString("" + SSNGiocatore) + ", " +
            " " + Conversion.getDatabaseString("" + numCart) + ", " +
            " 'Y', 'N')";
      
      database.modify(sql);
    }
    else if (giallo == false && rosso == true) {
      
      sql = " INSERT INTO cartellino " +
            " (ID_Referto, ID_Giocatore, Numero, Ammonizione, Espulsione) " +
            " VALUES (" + Conversion.getDatabaseString("" + IDReferto) + ", " +
            " " + Conversion.getDatabaseString("" + SSNGiocatore) + ", " +
            " " + Conversion.getDatabaseString("" + numCart) + ", " +
            " 'N', 'Y')";
      
      database.modify(sql);
    }
    else if(giallo == false && rosso == false) {
      
      sql = " INSERT INTO cartellino " +
            " (ID_Referto, ID_Giocatore, Numero, Ammonizione, Espulsione) " +
            " VALUES ("+Conversion.getDatabaseString("" + IDReferto) + ", " +
            " " + Conversion.getDatabaseString("" + SSNGiocatore) + ", " +
            " " + Conversion.getDatabaseString("" + numCart) + ", " +
            " 'N', 'N')";
      
      database.modify(sql);
    }
  }
}