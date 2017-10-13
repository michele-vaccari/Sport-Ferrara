package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Classifica {
  
  /* Property */
  public int IDSquadra;
  public int IDTorneo;
  public int Partite;
  public int Punti;
  public int Vittorie;
  public int Sconfitte;
  public int Pareggi;
  public int GoalFatti;
  public int GoalSubiti;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Classifica (int IDSquadra, int IDTorneo, int Partite, int Punti, int Vittorie, int Sconfitte, int Pareggi, int GoalFatti, int GoalSubiti) {
    
    this.IDSquadra = IDSquadra;
    this.IDTorneo = IDTorneo;
    this.Partite = Partite;
    this.Punti = Punti;
    this.Vittorie = Vittorie;
    this.Sconfitte = Sconfitte;
    this.Pareggi = Pareggi;
    this.GoalFatti = GoalFatti;
    this.GoalSubiti = GoalSubiti;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Classifica (ResultSet resultSet) {
    
    try {IDSquadra = resultSet.getInt("ID_Squadra"); } catch (SQLException sqle) {}
    try {IDTorneo = resultSet.getInt("ID_Torneo"); } catch (SQLException sqle) {}
    try {Partite = resultSet.getInt("Partite"); } catch (SQLException sqle) {}
    try {Punti = resultSet.getInt("Punti"); } catch (SQLException sqle) {}
    try {Vittorie = resultSet.getInt("Vittorie"); } catch (SQLException sqle) {}
    try {Pareggi = resultSet.getInt("Pareggi"); } catch (SQLException sqle) {}
    try {Sconfitte = resultSet.getInt("Sconfitte"); } catch (SQLException sqle) {}
    try {GoalFatti = resultSet.getInt("Goal_fatti"); } catch (SQLException sqle) {}
    try {GoalSubiti = resultSet.getInt("Goal_subiti"); } catch (SQLException sqle) {}
  }
  
  /* Aggiorno la classifica */
  public void update (DataBase database, boolean vittoria, boolean pareggio)
  throws NotFoundDBException, ResultSetDBException {
    
    /* Se vittoria == false e pareggio == false allora ho una sconfitta */  
    String sql;
    int punti;

    if (vittoria == true) {
      
      punti = 3;
      sql = " UPDATE classifica " +
            " SET " +
            " Vittorie=Vittorie+1 " +
            " WHERE " +
            " ID_Squadra=" + Conversion.getDatabaseString("" + IDSquadra) + " AND " +
            " ID_Torneo=" + Conversion.getDatabaseString("" + IDTorneo) + "";
      database.modify(sql);
    }
    else if (pareggio == true) {
      
      punti = 1;
      sql = " UPDATE classifica " +
            " SET " +
            " Pareggi=Pareggi+1 " +
            " WHERE " +
            " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
            " ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "'";
      database.modify(sql);
    }
    else {
      
      punti = 0;
      sql = " UPDATE classifica " +
            " SET " +
            " Sconfitte=Sconfitte+1 " +
            " WHERE " +
            " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
            " ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "'";
      database.modify(sql);
    }
    
    sql = " UPDATE classifica " +
          " SET " +
          " Partite=Partite+1, " +
          " Punti=Punti+'" + Conversion.getDatabaseString("" + punti) + "', " +
          " Goal_fatti=Goal_fatti+'" + Conversion.getDatabaseString("" + GoalFatti) + "', " +
          " Goal_subiti=Goal_subiti+'" + Conversion.getDatabaseString("" + GoalSubiti) + "' " +
          " WHERE " +
          " ID_Squadra='" + Conversion.getDatabaseString("" + IDSquadra) + "' AND " +
          " ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "'";
    database.modify(sql);
  }
}