package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Referto {
  
  /* Property */
  public int IDReferto;
  public String data;
  public String oraInizio;
  public String oraFine;
  public String risultato;
  public int IDPartita;
  public int Arbitro;
  public String flagReferto;
  public String flag;
  public String nomeArbitro;
  public String cognomeArbitro;
  public String fotoArbitro;
  public int IDSquadraA;
  public int IDSquadraB;
  public int IDTorneo;
  public String nomeTorneo;
  public String tipoTorneo;
  public String ora;
  public String luogo;
  public int Admin;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Referto (int IDReferto, String data, String oraInizio, String oraFine, String risultato, int IDPartita, int Arbitro, String ora, String luogo, int Admin) {

    this.IDReferto = IDReferto;
    this.oraInizio = oraInizio;
    this.oraFine = oraFine;
    this.risultato = risultato;
    this.IDPartita = IDPartita;
    this.Arbitro = Arbitro;
    this.data = data;
    this.ora = ora;
    this.luogo = luogo;
    this.Admin = Admin;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Referto (ResultSet resultSet) {

    try {IDReferto = resultSet.getInt("ID_Referto");} catch (SQLException sqle) {}
    try {oraInizio = resultSet.getString("Ora_inizio");} catch (SQLException sqle) {}
    try {oraFine = resultSet.getString("Ora_fine");} catch (SQLException sqle) {}
    try {risultato = resultSet.getString("Risultato");} catch (SQLException sqle) {}
    try {IDPartita = resultSet.getInt("ID_Partita");} catch (SQLException sqle) {}
    try {Arbitro = resultSet.getInt("ID_Arbitro");} catch (SQLException sqle) {}
    try {flagReferto = resultSet.getString("Compilato");} catch (SQLException sqle) {}
    try {nomeArbitro = resultSet.getString("nomeArbitro");} catch (SQLException sqle) {}
    try {cognomeArbitro = resultSet.getString("cognomeArbitro");} catch (SQLException sqle) {}
    try {fotoArbitro = resultSet.getString("fotoArbitro");} catch (SQLException sqle) {}
    try {IDSquadraA = resultSet.getInt("ID_SquadraA");} catch (SQLException sqle) {} 
    try {IDSquadraB = resultSet.getInt("ID_SquadraB");} catch (SQLException sqle) {} 
    try {nomeTorneo = resultSet.getString("nomeTorneo");} catch (SQLException sqle) {}
    try {tipoTorneo = resultSet.getString("tipoTorneo");} catch (SQLException sqle) {}
    try {IDTorneo = resultSet.getInt("ID_Torneo");} catch (SQLException sqle) {}
    try {data = resultSet.getString("Data_Partita");} catch (SQLException sqle) {}
    try {ora = resultSet.getString("Ora");} catch (SQLException sqle) {}
    try {luogo = resultSet.getString("Luogo");} catch (SQLException sqle) {}
    try {flag = resultSet.getString("Tipo");} catch (SQLException sqle) {}
  }
  
  /* Inserimento di un referto */
  public void insert (DataBase database) 
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    String sql;
    
    /* Check di unicità */
    sql = " SELECT ID_Referto" +
          " FROM referto WHERE " +
          " ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Referto: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Referto: insert(): Tentativo di inserimento di un referto già esistente");
    
    String sql_ID;
    sql_ID = " SELECT MAX(ID_Referto) " +
             " FROM referto ";
    
    try {
      resultSet = database.select(sql_ID);
      
      if (resultSet.next())
        IDReferto = (resultSet.getInt("MAX(ID_Referto)") + 1);
      else
        IDReferto = 1;
      
      resultSet.close();
    } 
    catch (SQLException e) {
      throw new ResultSetDBException("Referto: insert(): Errore sul ResultSet --> impossibile calcolare Id_Referto");
    }
    
    sql = " INSERT INTO referto " +
          " (ID_Referto, Risultato, Ora_inizio, Ora_fine, ID_Partita, ID_Arbitro, Compilato) " +
          " VALUES " + 
          "('" + Conversion.getDatabaseString("" + IDReferto) + "', " +
          " '" + Conversion.getDatabaseString(risultato) + "', " +
          " '" + Conversion.getDatabaseString(oraInizio) + "', " +
          " '" + Conversion.getDatabaseString(oraFine) + "', " +
          " '" + Conversion.getDatabaseString("" + IDPartita)+"', " +
          " '" + Conversion.getDatabaseString("" + Arbitro)+"', " +
          " 'N')";
    database.modify(sql);
    
    sql = " INSERT INTO scelto " +
          " (ID_Arbitro, Id_Amministratore, ID_Partita)" +
          " VALUES " + 
          "('" + Conversion.getDatabaseString("" + Arbitro) + "', " +
          " '" + Conversion.getDatabaseString("" + Admin) + "', " +
          " '" + Conversion.getDatabaseString("" + IDPartita) + "')";
    database.modify(sql);
    
    sql = " UPDATE partita " +
          " SET " +
          " Data_Partita='" + Conversion.getDatabaseString(data) + "', " + 
          " Luogo='" + Conversion.getDatabaseString(luogo) + "', " +
          " Ora='" + Conversion.getDatabaseString(ora) + "' " +
          " WHERE " +
          " ID_Partita='" + Conversion.getDatabaseString("" + IDPartita) + "'";
    database.modify(sql);
  }
  
  /* Aggiornamento di un referto */
  public void update (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql;
    
    sql = " UPDATE referto " +
          " SET " +
          " Risultato='" + Conversion.getDatabaseString(risultato) + "', " +
          " Ora_inizio='" + Conversion.getDatabaseString(oraInizio) + "', " +
          " Ora_fine='" + Conversion.getDatabaseString(oraFine) + "', " +
          " Compilato='Y'" +
          " WHERE " +
          " ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "'";

    database.modify(sql);
  }
}