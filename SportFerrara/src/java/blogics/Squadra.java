package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Squadra {
  
  /* Property */
  public int ID_Squadra;
  public String nomeSquadra;
  public String logoSquadra;
  public String immagineSquadra;
  public String nomeSponsor;
  public String logoSponsor;
  public String sede;
  public String descrizione;
  public String flag;
  public int gestore;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Squadra (int ID_Squadra, String nomeSquadra, String logoSquadra, String immagineSquadra, String descrizione,
                  String sede, String nomeSponsor, String logoSponsor, int gestore, String flag) {
    
    this.ID_Squadra = ID_Squadra;
    this.nomeSquadra = nomeSquadra;
    this.logoSquadra = logoSquadra;
    this.immagineSquadra = immagineSquadra;
    this.sede = sede; 
    this.nomeSponsor = nomeSponsor;
    this.logoSponsor = logoSponsor;
    this.descrizione = descrizione;
    this.gestore = gestore;
    this.flag = flag;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Squadra (ResultSet resultSet) {
    
    try {ID_Squadra = resultSet.getInt("ID_Squadra");} catch (SQLException sqle) {}
    try {nomeSquadra = resultSet.getString("Nome_squadra");} catch (SQLException sqle) {}
    try {logoSquadra = resultSet.getString("Logo_squadra");} catch (SQLException sqle) {}
    try {immagineSquadra = resultSet.getString("Immagine_squadra");} catch (SQLException sqle) {}
    try {sede = resultSet.getString("Sede");} catch (SQLException sqle) {}
    try {nomeSponsor = resultSet.getString("Nome_sponsor");} catch (SQLException sqle) {}
    try {logoSponsor = resultSet.getString("Logo_sponsor");} catch (SQLException sqle) {} 
    try {descrizione = resultSet.getString("Descrizione");} catch (SQLException sqle) {}
    try {gestore = resultSet.getInt("ID_Gestore");} catch (SQLException sqle) {} 
    try {flag = resultSet.getString("Compilata");} catch (SQLException sqle) {}
  }

  /* Aggiorno la squadra */
  /* DOCUMENTAZIONE BASI DI DATI */
  public void update (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql;
    
    /* Check di unicità */
    sql = " SELECT ID_Squadra, Nome_squadra " +
          " FROM squadra " +
          " WHERE " +
          " ID_Squadra='" + Conversion.getDatabaseString("" + ID_Squadra) + "' AND " +
          " Nome_squadra='" + Conversion.getDatabaseString(nomeSquadra) + "' AND " +
          " Sede='" + Conversion.getDatabaseString(sede) + "'";
    
    ResultSet resultSet = database.select(sql);
    
    boolean exist = false;

    try {
      exist = resultSet.next();
      resultSet.close();      
    }
    catch (SQLException e) {      
      throw new ResultSetDBException("Squadra: update(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Squadra: update(): Tentativo di inserimento di una squadra già esistente.");
    
    sql = " UPDATE squadra " +
          " SET " +
          " Nome_squadra = '" + Conversion.getDatabaseString(nomeSquadra) + "', " +
          " Logo_squadra = '" + Conversion.getDatabaseString(logoSquadra) + "', " +    
          " Immagine_squadra = '" + Conversion.getDatabaseString(immagineSquadra) + "', " +
          " Nome_sponsor = '" + Conversion.getDatabaseString(nomeSponsor) + "', " +
          " Logo_sponsor = '" + Conversion.getDatabaseString(logoSponsor) + "', " +
          " Sede = '" + Conversion.getDatabaseString(sede) + "', " +
          " Descrizione = '" + Conversion.getDatabaseString(descrizione) + "' , Compilata = 'Y' " +
          " WHERE " +
          " ID_Gestore = '" + Conversion.getDatabaseString("" + gestore)+"' ";
    
    database.modify(sql);
  }
}