package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Marcatore {
  
  public int IDReferto;
  public int SSNGiocatore;
  public int goal;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Marcatore (int IDReferto, int SSNGiocatore, int goal) {
    
    this.IDReferto = IDReferto;
    this.SSNGiocatore = SSNGiocatore;
    this.goal = goal;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Marcatore (ResultSet resultSet) {
    
    try {IDReferto = resultSet.getInt("ID_Referto"); } catch (SQLException sqle) {}
    try {SSNGiocatore = resultSet.getInt("ID_Giocatore"); } catch (SQLException sqle) {}
    try {goal = resultSet.getInt("Goal"); } catch (SQLException sqle) {}
  }
  
  /* Inserimento di un nuovo marcatore */
  /* DOCUMENTAZIONE BASI DI DATI */
  public void insert (DataBase database)
  throws NotFoundDBException,DuplicatedRecordDBException,ResultSetDBException {
    
    String sql;

    /* Check di unicità */
    sql = " SELECT * " +
          " FROM marcatore WHERE " +
          " ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' AND " +
          " ID_Giocatore='" + Conversion.getDatabaseString("" + SSNGiocatore) + "'";
    
    ResultSet resultSet = database.select(sql);

    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Marcatore: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Marcatore: insert(): Tentativo di inserimento di un marcatore già esistente");
    
    sql = " INSERT INTO marcatore " +
          " (ID_Referto, ID_Giocatore, Goal) " +
          " VALUES ('" + Conversion.getDatabaseString("" + IDReferto) + "', " +
          " '" + Conversion.getDatabaseString("" + SSNGiocatore) + "', " +
          " '" + Conversion.getDatabaseString("" + goal) + "') ";

    database.modify(sql);
  }
}