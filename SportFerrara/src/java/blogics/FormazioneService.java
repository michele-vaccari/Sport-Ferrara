package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class FormazioneService extends Object {
  
  /* Costruttore privato */
  private FormazioneService() {}
  
  /* Ritorna i referti di un gestore */
  /* DOCUMENTAZIONE BASI DI DATI */
  public static Vector getReferti (DataBase database, int gestore)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    Vector<Referto> referti = new Vector<Referto>();
    String sql;

    sql = " SELECT p.Data_partita, R.ID_Referto, g.*, r.Compilato, t.Nome as nomeTorneo " +
          " FROM referto as r, giocano as g, torneo as t, partita as p " +
          " WHERE r.Compilato='N' and G.ID_Partita=r.ID_Partita " +
          " AND g.ID_Torneo=t.ID_Torneo and r.ID_Partita=p.ID_Partita and g.ID_Partita=p.ID_Partita " +
          " AND (G.ID_SquadraA IN ( SELECT Id_SQUADRA FROM SQUADRA " +
                                  " WHERE ID_Gestore='" + Conversion.getDatabaseString("" + gestore) + "' " +
                                  " AND ID_Squadra<>'0') " +
          " OR G.ID_SquadraB IN ( SELECT Id_SQUADRA FROM SQUADRA " +
                                " WHERE ID_Gestore='" + Conversion.getDatabaseString("" + gestore) + "' " +
                                " AND ID_Squadra<>'0')) " +
          " AND R.ID_Referto NOT IN (SELECT ID_Referto FROM formazione WHERE ID_Squadra=(" +
              " SELECT ID_Squadra FROM squadra WHERE ID_Gestore='" + Conversion.getDatabaseString("" + gestore) + "'))" +
          " ORDER BY Id_referto";
    
    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
        referto = new Referto(resultSet);
        referti.add(referto);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("FormazioneService: getReferti():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referti;
  }
  
  /* Inserisce una nuova formazione */
  public static Formazione inserimentoNuovaFormazione (DataBase database, int[] titolari, int[] riserve, int IDReferto, int gestore)
  throws NotFoundDBException, ResultSetDBException, DuplicatedRecordDBException {
    
    Formazione formazione;
    Squadra squadra;
    
    String sql = " SELECT ID_Squadra FROM squadra WHERE ID_Gestore='" + Conversion.getDatabaseString("" + gestore) + "' ";

    ResultSet resultSet = database.select(sql);
    
    try {
      
      while(resultSet.next()) {
        squadra = new Squadra(resultSet);
        formazione = new Formazione(titolari, riserve, squadra.ID_Squadra, IDReferto);
        formazione.insert(database);
        return formazione;
      }
    }
    catch (SQLException ex) {
      formazione = null;
      throw new ResultSetDBException("FormazioneService: inserimentoNuovaFormazione():  Errore nel ResultSet: " + ex.getMessage(), database);          
    }
    return null;
  }
}
