package services.databaseservice;

import java.sql.*;

import global.*;
import services.databaseservice.exception.*;

public class DBService extends Object {
  
  /* Costruttore privato */
  private DBService () {}
  
  public static synchronized DataBase getDataBase ()
  throws NotFoundDBException {
    
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection connection = DriverManager.getConnection(Constants.DB_CONNECTION_STRING);               
      return new DataBase(connection);
    }
    catch (Exception e) {
      throw new NotFoundDBException("DBService: Impossibile creare la Connessione al DataBase: " + e);
    }
  }
}