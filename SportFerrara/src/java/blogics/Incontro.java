package blogics;

import java.sql.ResultSet;
import java.sql.SQLException;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import util.Conversion;

public class Incontro {
  
  /* Property */
  public int IDSquadraA;
  public int IDSquadraB;
  public int IDTorneo;
  public int IDPartita;
  public int nomeAss;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Incontro (int IDSquadraA, int IDSquadraB, int IDTorneo, int IDPartita, int nomeAss) {
    
    this.IDSquadraA = IDSquadraA;
    this.IDSquadraB = IDSquadraB;
    this.IDTorneo = IDTorneo;
    this.IDPartita = IDPartita;
    this.nomeAss = nomeAss;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Incontro (ResultSet resultSet) {
    
    try {IDPartita = resultSet.getInt("ID_Partita"); } catch (SQLException sqle) {}
    try {IDSquadraA = resultSet.getInt("ID_SquadraA"); } catch (SQLException sqle) {}
    try {IDSquadraB = resultSet.getInt("ID_SquadraB"); } catch (SQLException sqle) {}
    try {IDTorneo = resultSet.getInt("ID_Torneo"); } catch (SQLException sqle) {}
    try {nomeAss = resultSet.getInt("Numero_giornata_o_fase"); } catch (SQLException sqle) {}
  }
  
  /* Aggiornamento di un incontro */
  public void update (DataBase database, int IDSquadra, int IDPartitaDopo, boolean casa, int nomeAss) 
  throws NotFoundDBException, ResultSetDBException {
    
    String Incontro;
    
    if (casa == true) {
      Incontro = " UPDATE giocano " +
                 " SET ID_SquadraA='" + Conversion.getDatabaseString("" + IDSquadra) + "' " +
                 " WHERE Numero_giornata_o_fase='" + Conversion.getDatabaseString("" + nomeAss) + "' AND " +
                 " ID_Partita='" + Conversion.getDatabaseString("" + IDPartitaDopo) + "'";
      database.modify(Incontro);
    }
    else {
      Incontro = " UPDATE giocano " +
                 " SET ID_SquadraB='" + Conversion.getDatabaseString("" + IDSquadra) + "' " +
                 " WHERE Numero_giornata_o_fase='" + Conversion.getDatabaseString("" + nomeAss) + "' AND " +
                 " ID_Partita='" + Conversion.getDatabaseString("" + IDPartitaDopo) + "'";
      database.modify(Incontro);
    }
  }
}