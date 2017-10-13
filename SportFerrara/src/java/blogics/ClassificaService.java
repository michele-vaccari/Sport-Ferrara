package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class ClassificaService {
  
  /* Costruttore privato */
  private ClassificaService () {}
  
  /* Ritorna le classifiche di un torneo */
  public static Vector getTorneoClassifiche (DataBase database, int IDtorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Classifica classifica;
    Vector<Classifica> classifiche = new Vector<Classifica>();
    String sql;

    sql = " SELECT * " +
          " FROM classifica " +
          " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDtorneo) + "' " +
          " ORDER BY Punti DESC ";
    
    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        
        classifica = new Classifica(resultSet);
        classifiche.add(classifica);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("ClassificaService: getTorneoClassifiche():  Errore nel ResultSet: " + ex.getMessage(),database);
    }
    
    return classifiche;
  }
}