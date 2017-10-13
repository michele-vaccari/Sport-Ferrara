package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Gestore extends Registrato {
  
  /* Property */
  public String squadra;
  public int IDsquadra;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Gestore (int SSN, String nome, String cognome, String email, String password, String type, String indirizzo, String telefono, int Admin, String squadra) {
    
    super(SSN,nome,cognome,email,password,type,indirizzo,telefono,Admin);
    this.squadra = squadra;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Gestore (ResultSet resultSet) {
    
    super(resultSet);
    try {squadra = resultSet.getString("Nome_squadra");} catch (SQLException sqle) {}
  }
  
  /* Inserimento di un nuovo Gestore */
  public void insert (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql_1;
    String sql_2;
    String sql_3;
    String sql_squadra;
    
    /* Check di unicità */
    sql_1 = " SELECT Email " +
            " FROM utente WHERE " +
            " Email='" + Conversion.getDatabaseString(email) + "' " +
            " AND Attivo= 'Y'";
    
    ResultSet resultSet = database.select(sql_1);  

    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Gestore: insert(): Errore sul ResultSet.");
    }

    if (exist)
      throw new DuplicatedRecordDBException("Gestore: insert(): Tentativo di inserimento di un gestore già esistente");

    /* check di eventuale Gestore disattivato */
    sql_1 = " SELECT Email "+
            " FROM utente WHERE "+
            " Email='" + Conversion.getDatabaseString(email) + "' AND Attivo='N' ";
    resultSet = database.select(sql_1);

    exist = false;

    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Gestore: insert(): Errore sul ResultSet.");
    }

    if (exist) {
      
      sql_1 = " UPDATE utente " +
              " SET " +
              " Attivo= 'Y', Tipo= 'G', " +
              " Nome='" + Conversion.getDatabaseString(nome) + "', " +
              " Cognome='" + Conversion.getDatabaseString(cognome) + "', " +
              " Password='" + Conversion.getDatabaseString(password) + "' " +
              " WHERE Email='" + Conversion.getDatabaseString(email) + "' ";
      sql_2 = " UPDATE registrato " +
              " SET" +
              " Telefono='" + Conversion.getDatabaseString(telefono) + "', " +
              " Indirizzo='" + Conversion.getDatabaseString(indirizzo) + "', " +
              " Id_Amministratore='" + Conversion.getDatabaseString("" + Admin) + "' " +
              " WHERE Id_Utente= ( SELECT Id_Utente " +
                            " FROM utente " +
                            " WHERE Email='" + Conversion.getDatabaseString(email) + "')";
      
      sql_squadra = " UPDATE squadra " +
                    " SET Nome_squadra='" + Conversion.getDatabaseString(squadra) + "' " +
                    " WHERE ID_Gestore = ( SELECT Id_Utente " +
                                          " FROM utente " +
                                          " WHERE Email='" + Conversion.getDatabaseString(email) + "')";
      
      database.modify(sql_1);
      database.modify(sql_2);
      database.modify(sql_squadra);
    }
    else {
      /* Creazione SSN nuovo utente*/
      
      String sql_SSN;
      String sql_IDS;
      
      sql_SSN = " SELECT MAX(Id_Utente) FROM utente ";
      
      try {
        
        resultSet = database.select(sql_SSN);

        if (resultSet.next())
          SSN = (resultSet.getInt("MAX(Id_Utente)") + 1);
        else
          SSN = 1;
        
        resultSet.close();
      }
      catch (SQLException e) {throw new ResultSetDBException("Gestore: insert(): Errore sul ResultSet --> Impossibile calcolare Id.");}
      
      /* Creazione ID_Squadra nuova squadra */
      sql_IDS = "SELECT MAX(ID_Squadra) AS M FROM squadra";
      
      try {
        resultSet = database.select(sql_IDS);

        if (resultSet.next())
          IDsquadra = (resultSet.getInt("M") + 1);
        else
          IDsquadra = 1;

        resultSet.close();
      }
      catch (SQLException e) {throw new ResultSetDBException("Gestore: insert(): Errore sul ResultSet --> Impossibile calcolare ID_Squadra.");}
      
      /* Inserimento di un nuovo utente */
      sql_1 = " INSERT INTO utente " +
              " (Id_Utente, Nome, Cognome, Password, Email, Tipo, Attivo) " +
              " VALUES " +
              " ('" + Conversion.getDatabaseString("" + SSN) + "'," +
              " '" + Conversion.getDatabaseString(nome) + "'," +
              " '" + Conversion.getDatabaseString(cognome) + "'," +
              " '" + Conversion.getDatabaseString(password) + "'," +
              " '" + Conversion.getDatabaseString(email) + "'," +
              " 'G'," +
              " 'Y')" ;
      sql_2 = " INSERT INTO registrato " +
              " (Id_Utente, Telefono, Indirizzo, Id_Amministratore) " +
              " VALUES " +
              " ('" + Conversion.getDatabaseString("" + SSN) + "'," +
              " '" + Conversion.getDatabaseString(telefono) + "'," +
              " '" + Conversion.getDatabaseString(indirizzo) + "'," +
              " '" + Conversion.getDatabaseString("" + Admin) + "')";
      sql_3 = " INSERT INTO gestore_squadra (Id_Registrato) " +
              " VALUES " +
              " ('" + Conversion.getDatabaseString("" + SSN) + "')";
      
      sql_squadra = " INSERT INTO squadra (ID_Squadra, Nome_squadra, ID_Gestore, Attivo) " +
                    " VALUES " +
                    " ('" + Conversion.getDatabaseString("" + IDsquadra) + "'," +
                    " '" + Conversion.getDatabaseString(squadra) + "'," +
                    " '" + Conversion.getDatabaseString("" + SSN) + "', 'N')";

      database.modify(sql_1);
      database.modify(sql_2);
      database.modify(sql_3);
      database.modify(sql_squadra);
    }
 }  

  /* Aggiorno i dati del Gestore */
  public void update (DataBase database)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    String sql_1;
    String sql_2;
    String sql_squadra;
    
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
      throw new ResultSetDBException("Gestore: update(): Errore sul ResultSet.");
    }

    if (exist)
      throw new DuplicatedRecordDBException("Gestore: update(): Tentativo di inserimento di un gestore già esistente");
    

    sql_1 = " UPDATE utente " +
            " SET " +
            " Attivo= 'Y', Tipo= 'G', " +
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
    
    sql_squadra = " UPDATE squadra " +
                  " SET " +
                  " Nome_squadra='" + Conversion.getDatabaseString(squadra) + "' " +
                  " WHERE ID_Gestore = ( SELECT Id_Utente " +
                                        " FROM utente " +
                                         " WHERE Id_Utente='" + Conversion.getDatabaseString("" + SSN) + "')";
    
    database.modify(sql_1);
    database.modify(sql_2);
    database.modify(sql_squadra);         
  }
}