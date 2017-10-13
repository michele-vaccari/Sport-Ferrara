package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Formazione {
  
  /* Property */
  public int[] titolari;
  public int[] riserve;
  public int SSNGiocatore; 
  public int IDSquadra;
  public int IDReferto;
  public String FlagRiserva;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Formazione (int[] titolari, int[] riserve, int IDSquadra, int IDReferto) {
    
    this.titolari = titolari;
    this.riserve = riserve;
    this.IDSquadra = IDSquadra;
    this.IDReferto = IDReferto;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Formazione (ResultSet resultSet) {
    
    try {SSNGiocatore = resultSet.getInt("ID_Giocatore");} catch (SQLException sqle) {}
    try {IDSquadra = resultSet.getInt("ID_Squarda");} catch (SQLException sqle) {}
    try {IDReferto = resultSet.getInt("ID_Referto");} catch (SQLException sqle) {}
    try {FlagRiserva = resultSet.getString("Riserva");} catch (SQLException sqle) {}
  }
  
  /* Inserimento di una Formazione */
  public void insert (DataBase database)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    int i;
    String sql;

    /* Check di unicità */
    sql = " SELECT * FROM formazione " +
          " WHERE ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
          " ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "'";

    ResultSet resultSet = database.select(sql);

    boolean exist = false;

    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Formazione: insert(): Errore sul ResultSet.");
    }
    
    /* Inserimento dei titolari */       
    for(i = 0; i < titolari.length; i++) {
      
      sql = " INSERT INTO formazione " +
            " (ID_Giocatore, ID_Squadra, ID_Referto, Riserva) " +
            " VALUES " +
            " ('" + Conversion.getDatabaseString("" + titolari[i]) + "'," +
            " '" + Conversion.getDatabaseString("" + IDSquadra) + "'," +
            " '" + Conversion.getDatabaseString("" + IDReferto) + "'," +
            " 'N')";
      database.modify(sql);
    }
    
    /* Inserimento delle riserve */
    for(i = 0; i < riserve.length; i++) {
      
      sql = " INSERT INTO formazione " +
            " (ID_Giocatore, ID_Squadra, ID_Referto, Riserva) " +
            " VALUES " +
            " ('" + Conversion.getDatabaseString("" + riserve[i]) + "'," +
            " '" + Conversion.getDatabaseString("" + IDSquadra) + "'," +
            " '" + Conversion.getDatabaseString("" + IDReferto) + "'," +
            " 'Y')";
      database.modify(sql);
    }
  }
}
