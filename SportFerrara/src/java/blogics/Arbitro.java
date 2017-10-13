package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Arbitro extends Registrato {
  
  /* Property */
  public String data_n;
  public String nazionalità;
  public String carriera;
  public String foto;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Arbitro (int SSN, String nome, String cognome, String email, String password, String type, String indirizzo,
                  String telefono, int Admin, String foto, String data_n, String nazionalità, String carriera) {
    
    super(SSN, nome, cognome, email, password, type, indirizzo, telefono, Admin);
    this.data_n = data_n;
    this.nazionalità = nazionalità;
    this.carriera = carriera;
    this.foto = foto;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Arbitro (ResultSet resultSet) {
    
    super(resultSet);
    try {foto = resultSet.getString("Foto");} catch (SQLException sqle) {}
    try {data_n = resultSet.getString("Data_nascita");} catch (SQLException sqle) {}
    try {nazionalità = resultSet.getString("Nazionalita");} catch (SQLException sqle) {}
    try {carriera = resultSet.getString("Carriera");} catch (SQLException sqle) {}
  }
  
  /* Inserimento/Riattivazione di un Arbitro */
  /* DOCUMENTAZIONE BASI DI DATI */
  public void insert (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql_1;
    String sql_2;
    String sql_3;
    
    /* Check di unicità dell'email */
    sql_1 = " SELECT Email " +
            " FROM utente WHERE " +
            " Email= '" + Conversion.getDatabaseString(email) + "' " +
            " AND Attivo = 'Y' ";
    
    ResultSet resultSet = database.select(sql_1);
    
    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Arbitro: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Arbitro: insert(): Tentativo di inserimento di un arbitro già esistente");
    
    /* Verifico se esiste un utente disattivato con la stessa email */
    sql_1 = " SELECT Email " +
            " FROM utente WHERE " +
            " Email='" + Conversion.getDatabaseString(email) + "' AND Attivo='N'";
    
    resultSet = database.select(sql_1);
    
    exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Arbitro: insert(): Errore sul ResultSet.");
    }

    if (exist) {
      sql_1 = " UPDATE utente " +
              " SET " +
              " Attivo='Y', Tipo= 'R', " +
              " Nome='" + Conversion.getDatabaseString(nome) + "', " +
              " Cognome='" + Conversion.getDatabaseString(cognome) + "', " +
              " Password='" + Conversion.getDatabaseString(password) + "' " +
              " WHERE Email='" + Conversion.getDatabaseString(email) + "' ";
      sql_2 = " UPDATE registrato " +
              " SET " +
              " Telefono='" + Conversion.getDatabaseString(telefono) + "', " +
              " Indirizzo='" + Conversion.getDatabaseString(indirizzo) + "', " +
              " Id_Amministratore='" + Conversion.getDatabaseString(""+Admin) + "' " +
              " WHERE Id_Utente= ( SELECT Id_Utente " +
                            " FROM utente " +
                            " WHERE Email='" + Conversion.getDatabaseString(email) + "') ";
      sql_3 = " UPDATE arbitro " +
              " SET " +
              " Foto='" + Conversion.getDatabaseString(foto) + "', " +
              " Data_nascita='" + Conversion.getDatabaseString(data_n) + "', " +
              " Nazionalita='" + Conversion.getDatabaseString(nazionalità) + "', " +
              " Carriera='" + Conversion.getDatabaseString(carriera) + "' " +
              " WHERE Id_Registrato= ( SELECT Id_Utente " +
                            " FROM utente " +
                            " WHERE Email='" + Conversion.getDatabaseString(email) + "') ";
      
      database.modify(sql_1);
      database.modify(sql_2);
      database.modify(sql_3);
    }
    else {
      /* Ottengo un nuovo SSN per l'utente */
      String sql_SSN;
      sql_SSN = " SELECT MAX(Id_Utente) " +
                " FROM utente ";
      
      try {
        resultSet = database.select(sql_SSN);

        if (resultSet.next())
          SSN = (resultSet.getInt("MAX(Id_Utente)") + 1);
        else
          SSN = 1;
        
        resultSet.close();
       } 
      catch (SQLException e) {throw new ResultSetDBException("Arbitro: insert(): Errore sul ResultSet --> Impossibile calcolare Id utente.");}
      
      /* Inserimento di un nuovo Arbitro */
      sql_1 = " INSERT INTO utente " +
              " (Id_Utente, Nome, Cognome, Password, Email, Tipo, Attivo) " +
              " VALUES " +
              " ('" + Conversion.getDatabaseString("" + SSN) + "'," +
              " '" + Conversion.getDatabaseString(nome) + "'," +
              " '" + Conversion.getDatabaseString(cognome) + "'," +
              " '" + Conversion.getDatabaseString(password) + "'," +
              " '" + Conversion.getDatabaseString(email) + "'," +
              " 'R'," +
              " 'Y')";
      sql_2 = " INSERT INTO registrato " +
              " (Id_Utente, Telefono, Indirizzo, Id_Amministratore) " +
              " VALUES "+
              " ('" + Conversion.getDatabaseString("" + SSN) + "'," +
              " '" + Conversion.getDatabaseString(telefono) + "'," +
              " '" + Conversion.getDatabaseString(indirizzo) + "'," +
              " '" + Conversion.getDatabaseString("" + Admin) + "')";
      sql_3 = " INSERT INTO arbitro " +
              " (Id_Registrato, Foto, Data_nascita, Nazionalita, Carriera) " +
              " VALUES " +
              " ('"+ Conversion.getDatabaseString("" + SSN) + "'," +
              " '" + Conversion.getDatabaseString(foto) + "'," +
              " '" + Conversion.getDatabaseString(data_n) + "'," +
              " '" + Conversion.getDatabaseString(nazionalità) + "'," +
              " '" + Conversion.getDatabaseString(carriera) + "')";
      
      database.modify(sql_1);
      database.modify(sql_2);
      database.modify(sql_3);
   }        
 }
  
  /* Aggiornamento di un Arbitro */
  public void update (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql_1;
    String sql_2;
    String sql_3;
    
    /* Check di unicità */
    sql_1 = " SELECT COUNT(*) AS N " +
            " FROM utente WHERE " +
            " Email='" + Conversion.getDatabaseString(email) + "' AND Id_Utente <> " + SSN;
    
    ResultSet resultSet;

    boolean exist = false;
    
    try {
      resultSet = database.select(sql_1);
      
      if (resultSet.next())
        exist = resultSet.getInt("N") > 0;
      
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Arbitro: update(): Errore sul ResultSet.");
    }

    if (exist)
      throw new DuplicatedRecordDBException("Arbitro: update(): Tentativo di inserimento di un gestore già esistente");
    

    sql_1 = " UPDATE utente " +
            " SET " +
            " Attivo='Y',Tipo= 'R', " +
            " Nome='" + Conversion.getDatabaseString(nome) + "', " +
            " Cognome='" + Conversion.getDatabaseString(cognome) + "', " +
            " Password='" + Conversion.getDatabaseString(password) + "', " +
            " Email='" + Conversion.getDatabaseString(email) + "' " +
            " WHERE Id='" + Conversion.getDatabaseString("" + SSN) + "' ";
    sql_2 = " UPDATE registrato " +
            " SET " +
            " Telefono='" + Conversion.getDatabaseString(telefono) + "', " +
            " Indirizzo='" + Conversion.getDatabaseString(indirizzo) + "', " +
            " Id_Amministratore='" + Conversion.getDatabaseString("" + Admin) + "' " +
            " WHERE Id_Utente= ( SELECT Id_Utente " +
                          " FROM utente " +
                          " WHERE Id_Utente='" + Conversion.getDatabaseString("" + SSN) + "') ";
    sql_3 = " UPDATE arbitro " +
            " SET " +
            " Foto='" + Conversion.getDatabaseString(foto) + "', " +
            " Data_nascita='" + Conversion.getDatabaseString(data_n) + "', " +
            " Nazionalita='" + Conversion.getDatabaseString(nazionalità) + "', " +
            " Carriera='" + Conversion.getDatabaseString(carriera) + "' " +
            " WHERE Id_Registrato= ( SELECT Id_Utente " +
                          " FROM utente " +
                          " WHERE Id_Utente='" + Conversion.getDatabaseString("" + SSN) + "') ";
    
    database.modify(sql_1);
    database.modify(sql_2);
    database.modify(sql_3);         
  }
}