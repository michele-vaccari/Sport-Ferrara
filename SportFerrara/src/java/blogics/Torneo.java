package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Torneo {
  
  /* Property */
  public String nome;
  public int IDTorneo;
  public String tipologia;
  public String descrizione;
  public int creatore;
  public int[] squadra;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Torneo (int IDTorneo, String nome, String tipologia, String descrizione, int creatore, int[] squadra) {
    
    this.IDTorneo = IDTorneo;
    this.nome = nome;
    this.tipologia = tipologia;
    this.descrizione = descrizione;
    this.creatore = creatore;
    this.squadra = squadra;    
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Torneo(ResultSet resultSet) {
    
    try {IDTorneo = resultSet.getInt("ID_Torneo");} catch (SQLException sqle) {}
    try {nome = resultSet.getString("Nome");} catch (SQLException sqle) {}
    try {tipologia = resultSet.getString("Tipologia");} catch (SQLException sqle) {}
    try {descrizione = resultSet.getString("Descrizione");} catch (SQLException sqle) {}
    try {creatore = resultSet.getInt("ID_Amministratore");} catch (SQLException sqle) {}
  }
  
  /* Inserimento di un torneo */
  public void insert (DataBase database)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    int i;
    String sql;
    
    /* Check di unicità */
    sql = " SELECT Nome,ID_Amministratore " +
          " FROM torneo WHERE " +
          " Nome='" + Conversion.getDatabaseString(nome) + "' AND" +
          " ID_Amministratore='" + Conversion.getDatabaseString("" + creatore) + "' ";

    ResultSet resultSet = database.select(sql);

    boolean exist = false;

    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Torneo: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Torneo: insert(): Tentativo di creazione di un torneo già esistente");

    String sql_ID;
    sql_ID = " SELECT MAX(ID_Torneo) " +
             " FROM torneo ";
    
    try {
      resultSet = database.select(sql_ID);

      if (resultSet.next())
        IDTorneo = (resultSet.getInt("MAX(ID_Torneo)")+1);
      else
        IDTorneo = 1;

      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Torneo: insert(): Errore sul ResultSet --> impossibile calcolare Id_Torneo");
    }
    
    sql = " INSERT INTO torneo " +
          " (ID_Torneo, Nome, Tipologia, Descrizione, ID_Amministratore) " +
          " VALUES " +
          "('" + Conversion.getDatabaseString(""+IDTorneo) + "', " +
          " '" + Conversion.getDatabaseString(nome) + "', " +
          " '" + Conversion.getDatabaseString(tipologia) + "', " +
          " '" + Conversion.getDatabaseString(descrizione) + "', " +
          " '" + Conversion.getDatabaseString("" + creatore) + "') ";
    database.modify(sql);

    for(i = 0; i < squadra.length; i++){
      
      sql = " INSERT INTO partecipa " +
            " (ID_Torneo, ID_Squadra) " +
            " VALUES ('" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
            " '" + Conversion.getDatabaseString("" + squadra[i]) + "')";  
      database.modify(sql);

      sql = " INSERT INTO classifica " +
            " (ID_Torneo, ID_Squadra) " +
            " VALUES ('" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
            " '" + Conversion.getDatabaseString("" + squadra[i]) + "')";  
      database.modify(sql);
    }
  }
}
