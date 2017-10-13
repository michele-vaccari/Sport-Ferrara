package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Giocatore {
  
  /* Property */
  public int SSNGiocatore;
  public String nome;
  public String cognome;
  public String nazionalità;
  public String dataNascita;
  public int numeroMaglia;
  public String ruolo;
  public String foto;
  public String flag;
  public String descrizione;
  public int goal;
  public int ammonizioni;
  public int espulsioni;
  public int IDSquadra;
  public String FlagAmmonito;
  public String FlagEspulso;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Giocatore (int SSNGiocatore, String nome, String cognome, String nazionalità, String dataNascita, int numeroMaglia,
                    String ruolo, String foto, int goal, int ammonizioni, int espulsioni, String descrizione, int IDSquadra) {
    
    this.SSNGiocatore = SSNGiocatore;
    this.nome = nome;
    this.cognome = cognome;
    this.nazionalità = nazionalità;
    this.dataNascita = dataNascita;
    this.numeroMaglia = numeroMaglia;
    this.ruolo = ruolo;
    this.foto = foto;
    this.goal = goal;
    this.ammonizioni = ammonizioni;
    this.espulsioni = espulsioni;
    this.descrizione = descrizione;
    this.IDSquadra = IDSquadra;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Giocatore (ResultSet resultSet) {
    
    try {SSNGiocatore = resultSet.getInt("ID_Giocatore");} catch (SQLException sqle) {}
    try {nome = resultSet.getString("Nome"); } catch (SQLException sqle) {}
    try {cognome = resultSet.getString("Cognome"); } catch (SQLException sqle) {}
    try {nazionalità = resultSet.getString("Nazionalita"); } catch (SQLException sqle) {}
    try {dataNascita = resultSet.getString("Data_nascita"); } catch (SQLException sqle) {}
    try {numeroMaglia = resultSet.getInt("Numero_maglia"); } catch (SQLException sqle) {}
    try {ruolo = resultSet.getString("Ruolo"); } catch (SQLException sqle) {}
    try {foto = resultSet.getString("Foto"); } catch (SQLException sqle) {}
    try {goal = resultSet.getInt("Goal"); } catch (SQLException sqle) {}
    try {ammonizioni = resultSet.getInt("Ammonizioni"); } catch (SQLException sqle) {}
    try {espulsioni = resultSet.getInt("Espulsioni"); } catch (SQLException sqle) {}
    try {descrizione = resultSet.getString("Descrizione"); } catch (SQLException sqle) {}
    try {flag = resultSet.getString("Attivo");} catch (SQLException sqle) {}
    try {IDSquadra = resultSet.getInt("ID_Squadra"); } catch (SQLException sqle) {}
    try {FlagAmmonito = resultSet.getString("FlagAmmonito");} catch (SQLException sqle) {}
    try {FlagEspulso = resultSet.getString("FlagEspulso");} catch (SQLException sqle) {}
  }
  
  /* Inserimento di un nuovo giocatore */
  public void insert (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql_1;
    String sql_2;
    String sql_3;
    
    /* Check per non avere una rosa con più di 36 giocatori */
    sql_1 = " SELECT COUNT(*)" +
            " FROM giocatore " +
            " WHERE ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' " +
            " HAVING COUNT(*)>36";

    ResultSet resultSet = database.select(sql_1);
    
    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Giocatore: insert(): Errore sul ResultSet di rosa max36.");
    }
    
    if (exist) 
      throw new DuplicatedRecordDBException("Giocatore: insert(): Non puoi inserire più di 36 giocatori nella squadra, ROSA COMPLETA");
    
    /* Check di unicità */
    sql_1 = " SELECT Nome, Cognome, Numero_maglia" +
            " FROM giocatore WHERE " + 
            " Nome= '" + Conversion.getDatabaseString(nome) + "' AND " +
            " Cognome= '" + Conversion.getDatabaseString(cognome) + "' AND " +
            " Numero_maglia= '" + Conversion.getDatabaseString("" + numeroMaglia) + "' AND" +
            " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' " + 
            " AND Attivo = 'Y' "; 

    resultSet = database.select(sql_1);  

    exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Giocatore: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Giocatore: insert(): Tentativo di inserimento di un giocatore già presente nella squadra");

    /* Check di eventuale giocatore disattivato */
    sql_1 = " SELECT Nome,Cognome,Data_nascita " +
            " FROM giocatore WHERE " +
            " Nome= '" + Conversion.getDatabaseString(nome) + "' AND " +
            " Cognome= '" + Conversion.getDatabaseString(cognome) + "' AND " +
            " Data_nascita='" + Conversion.getDatabaseString(dataNascita) + "'AND " +
            " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
            " Attivo = 'N' ";
    
    resultSet = database.select(sql_1);

    exist = false;

    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Giocatore: insert(): Errore sul ResultSet.");
    }

    if (exist) {
      sql_1 = " UPDATE giocatore" +
              " SET Attivo='Y', " +
              " Numero_maglia='" + Conversion.getDatabaseString("" + numeroMaglia) + "', " +
              " Ruolo='" + Conversion.getDatabaseString(ruolo) + "', " +
              " Foto='" + Conversion.getDatabaseString(foto) + "', " +
              " descrizone='" + Conversion.getDatabaseString(descrizione) + "', " +
              " ID_Squadra='" + Conversion.getDatabaseString(""+IDSquadra) + "' " +
              " WHERE Nome='" + Conversion.getDatabaseString(nome) + "' AND " +
              " Data_nascita='" + Conversion.getDatabaseString(dataNascita) + "' AND " +
              " Cognome='" + Conversion.getDatabaseString(cognome) + "' ";
      
      database.modify(sql_1);
    }
    else {
      /* Creazione SSN nuovo giocatore */
      String sql_SSN;
      sql_SSN = " SELECT MAX(ID_Giocatore) " +
                " FROM giocatore ";
      
      try {
        resultSet = database.select(sql_SSN);

        if (resultSet.next())
          SSNGiocatore = (resultSet.getInt("MAX(ID_Giocatore)") + 1);
        else
          SSNGiocatore = 1;

        resultSet.close();
      } 
      catch (SQLException e) {throw new ResultSetDBException("Giocatore: insert(): Errore sul ResultSet --> Impossibile calcolare SSN giocatore.");}
      
      /* Inserimento di un nuovo giocatore */
      sql_1 = " INSERT INTO giocatore " +
              " (ID_Giocatore, Nome, Cognome, Nazionalita, Data_nascita, Numero_maglia,"+
              " Ruolo, Foto, Goal, Ammonizioni, Espulsioni, Attivo, Descrizione, ID_Squadra) "+
              " VALUES "+
              " ('" + Conversion.getDatabaseString("" + SSNGiocatore) + "'," +
              " '" + Conversion.getDatabaseString(nome) + "'," +
              " '" + Conversion.getDatabaseString(cognome) + "'," +
              " '" + Conversion.getDatabaseString(nazionalità) + "'," +
              " '" + Conversion.getDatabaseString(dataNascita) + "'," +
              " '" + Conversion.getDatabaseString("" + numeroMaglia) + "'," +
              " '" + Conversion.getDatabaseString(ruolo) + "'," +
              " '" + Conversion.getDatabaseString(foto) + "','0','0','0','Y'," +
              " '" + Conversion.getDatabaseString(descrizione) + "'," +
              " '" + Conversion.getDatabaseString("" + IDSquadra) + "')";
      
      database.modify(sql_1); 
    }
  }

  /* Cancellazione logica di un giocatore */
  public void delete (DataBase database)
  throws NotFoundDBException,ResultSetDBException {
    
    String sql;

    sql = " UPDATE giocatore " +
          " SET Attivo='N' " +
          " WHERE " +
          " ID_Giocatore='" + Conversion.getDatabaseString("" + SSNGiocatore) + "'";
    
    database.modify(sql);
  }
  
  /* Aggiornamento di un giocatore */
  public void update (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql;

    sql = " UPDATE giocatore " +
          " SET " +
          " Nome='" + Conversion.getDatabaseString(nome) + "', " +
          " Cognome='" + Conversion.getDatabaseString(cognome) + "', " +
          " Nazionalita='" + Conversion.getDatabaseString(nazionalità) + "', " +
          " Data_nascita='" + Conversion.getDatabaseString(dataNascita) + "', " +    
          " Numero_maglia='" + Conversion.getDatabaseString("" + numeroMaglia) + "', " +
          " Ruolo='" + Conversion.getDatabaseString(ruolo) + "', " +
          " Foto='" + Conversion.getDatabaseString(foto) + "', " + 
          " Descrizione='" + Conversion.getDatabaseString(descrizione) + "' " +
          " WHERE " +
          " ID_Giocatore='" + Conversion.getDatabaseString("" + SSNGiocatore) + "' ";
    
    database.modify(sql);       
  }
  
  /* Aggiornamento delle statistiche di un giocatore */
  public void updateStatistica (DataBase database, int gool, int amm, int esp)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql;

    sql = " UPDATE giocatore " +
          " SET " +
          " Goal = Goal+" + Conversion.getDatabaseString("" + gool) + ", " +
          " Ammonizioni = Ammonizioni+" + Conversion.getDatabaseString("" + amm) + ", " +
          " Espulsioni = Espulsioni+" + Conversion.getDatabaseString("" + esp) + " " +   
          " WHERE " +
          " ID_Giocatore = " + Conversion.getDatabaseString("" + SSNGiocatore) + "";
    
    database.modify(sql);       
  } 
}