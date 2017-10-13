package blogics;

import java.util.*;
import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class RefertoService extends Object {
  
  /* Costruttore privato */
  private RefertoService () {}
  
  /* Ritorna le fasi di un torneo */
  public static Vector getFasi (DataBase database, int IDTorneo)
  throws NotFoundDBException, ResultSetDBException {
    
    Incontro incontro;
    Torneo torneo;
    Vector<String> fasi = new Vector<String>();
    String sql;
    String tipologia = "";
    
    sql = " SELECT Tipologia FROM torneo " +
          " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        torneo = new Torneo(resultSet);
        tipologia = torneo.tipologia;
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getFasi():  Errore nel ResultSet di Torneo: " + ex.getMessage(), database);
    }
    
    sql = " SELECT DISTINCT Numero_giornata_o_fase FROM giocano " +
          " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "' " +
          " ORDER BY Numero_giornata_o_fase";

    resultSet = database.select(sql);
    
    try {
      if(tipologia.equals("I")) {
        while (resultSet.next()) {
          incontro = new Incontro(resultSet);
          fasi.add("Giornata " + incontro.nomeAss);
        }
      }
      else {
        while (resultSet.next()) {
          incontro = new Incontro(resultSet);
          if (incontro.nomeAss == 1) {
            fasi.add("Finale");
          }
          if (incontro.nomeAss == 2) {
            fasi.add("Semifinale");
          }
          if (incontro.nomeAss == 3) {
            fasi.add("Quarti di Finale");
          }
          if (incontro.nomeAss == 4) {
            fasi.add("Ottavi di Finale");
          }
        }
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getFasi():  Errore nel ResultSet di Incontro: " + ex.getMessage(), database);
    }
    
    return fasi;
  }
  
  /* Ritorna tutti i referti di un amministratore */
  /* DOCUMENTAZIONE BASI DI DATI */
  public static Vector getRefertiAdmin (DataBase database, int Admin)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    Vector<Referto> referti = new Vector<Referto>();
    String sql;

    sql = " SELECT Ref.ID_Referto, Ref.Risultato, Ref.Ora_inizio, Ref.Ora_fine, Ref.ID_Partita, Ref.Risultato, " +
          " Ref.Compilato, U.Nome AS nomeArbitro, U.cognome AS cognomeArbitro, T.ID_Torneo,T.tipologia as tipoTorneo, " +
          " T.Nome as nomeTorneo, P.Data_Partita, P.Luogo" +
          " FROM referto AS Ref, utente AS U, registrato AS Reg, giocano as G, torneo as T, partita as P " +
          " WHERE U.Attivo= 'Y' and U.Tipo= 'R' and U.Id_Utente= Reg.Id_Utente and U.Id_Utente= Ref.ID_Arbitro and" +
          " g.id_partita=Ref.ID_Partita and t.ID_Torneo=G.ID_Torneo and p.ID_Partita=G.ID_Partita " +
          " and Reg.Id_Amministratore='" + Conversion.getDatabaseString("" + Admin) + "' " +
          " order by Ref.ID_Referto ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        referto = new Referto(resultSet);
        referti.add(referto);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getRefertiAdmin():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referti;
  }
  
  /* Ritorna tutti i referti di un arbitro */
  public static Vector getRefertiArbitro (DataBase database, int Arbitro)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    Vector<Referto> referti = new Vector<Referto>();
    String sql;


    sql = " SELECT Ref.ID_Referto, Ref.Risultato, Ref.Ora_inizio, Ref.Ora_fine, Ref.ID_Partita, G.ID_SquadraA, G.ID_SquadraB, Ref.Risultato, Ref.Compilato, T.ID_Torneo,T.tipologia as tipoTorneo, T.Nome as nomeTorneo, P.Data_Partita " +
          " FROM referto as Ref, giocano as G, torneo as T, partita as P" +
          " WHERE Ref.ID_Arbitro='" + Conversion.getDatabaseString("" + Arbitro) + "' " +
          " and g.id_partita=Ref.ID_Partita and t.ID_Torneo=G.ID_Torneo and p.ID_Partita=G.ID_Partita" +
          " ORDER BY ID_Referto";
    
    ResultSet resultSet = database.select(sql);        

    try {
      while (resultSet.next()) {
          referto = new Referto(resultSet);
          referti.add(referto);
      }
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getRefertiArbitro():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referti;
  }
  
  /* Ritorna il nome della squadra casa di una partita */
  public static String visualSquadraCasa (DataBase database, int IDPartita)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra s;
    
    String sql = " SELECT S.nome_squadra " +
                 " FROM GIOCANO AS G, SQUADRA AS S " +
                 " WHERE G.ID_PARTITA ='" + Conversion.getDatabaseString("" + IDPartita) + "' " +
                 " AND S.Nome_Squadra in( SELECT Nome_squadra from squadra where ID_Squadra = G.ID_SquadraA )";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next())
        s = new Squadra(resultSet);
      else
        s = null;
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: visualSquadraCasa():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return s.nomeSquadra;
  }
  
  /* Ritorna il nome della squadra ospite di una partita */
  public static String visualSquadraOspite (DataBase database, int IDPartita)
  throws NotFoundDBException, ResultSetDBException {
    
    Squadra s;
    
    String sql = " SELECT S.nome_squadra " +
                 " FROM GIOCANO AS G, SQUADRA AS S " +
                 " WHERE G.ID_PARTITA ='" + Conversion.getDatabaseString("" + IDPartita) + "' " +
                 " AND S.Nome_Squadra in( SELECT Nome_squadra from squadra where ID_Squadra = G.ID_SquadraB )";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next()) {
        s = new Squadra(resultSet);
      }
      else
        s = null;
      resultSet.close();
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: visualSquadraOspite():  ResultSetDBException: " + ex.getMessage(), database);
    }
    
    return s.nomeSquadra;
  }
  
  /* Ritorna un referto dato l'ID della partita */
  public static Referto getRefertoGuest (DataBase database, int IDPartita)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    String sql;
    
    sql = " SELECT r.*, U.Nome AS nomeArbitro, U.cognome AS cognomeArbitro, a.foto AS fotoArbitro, p.data_partita, p.Luogo " +
          " FROM REFERTO as r, utente as u, arbitro as a, partita as p " +
          " WHERE r.ID_Partita='" + Conversion.getDatabaseString("" + IDPartita) + "' " +
          " AND p.ID_Partita=r.ID_Partita " +
          " AND u.Id_Utente= r.ID_Arbitro AND a.Id_Registrato=r.ID_Arbitro ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next()) 
        referto = new Referto(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getRefertoGuest():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referto;
  }
  
  /* Ritorna tutti i referti dato l'IDPartita */
  public static Vector getRefertiGuest (DataBase database, int IDPartita)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    Vector<Referto> referti = new Vector<Referto>();
    String sql;
    
    sql = " SELECT * FROM REFERTO " +
          " WHERE ID_Partita='" + Conversion.getDatabaseString("" + IDPartita) + "' ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      while (resultSet.next()) {
        referto = new Referto(resultSet);
        referti.add(referto);
      }
    } 
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getRefertiGuest():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referti;
  }
  
  /* Ritorna un referto dato l'IDReferto */
  public static Referto getReferto (DataBase database, int IDReferto)
  throws NotFoundDBException, ResultSetDBException {
    
    Referto referto;
    String sql;
    
    sql = " SELECT * " +
          " FROM REFERTO AS R, PARTITA AS P " +
          " WHERE R.ID_Referto='" + Conversion.getDatabaseString("" + IDReferto) + "' " +
          " AND P.ID_Partita=R.ID_Partita ";
    
    ResultSet resultSet = database.select(sql);
    
    try {
      if (resultSet.next()) 
        referto = new Referto(resultSet);
      else
        return null;
    }
    catch (SQLException ex) {
      throw new ResultSetDBException("RefertoService: getReferto():  Errore nel ResultSet: " + ex.getMessage(), database);
    }
    
    return referto;
  }
  
  /* Inserimento di un cartellino */
  public static Cartellini inserimentoCartellini (DataBase database, int IDReferto, int SSNGiocatore, int numero, boolean giallo, boolean rosso)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Cartellini cartellino;

    cartellino = new Cartellini(IDReferto, SSNGiocatore, numero);
    cartellino.insert(database, giallo, rosso);
    return cartellino;
  }
  
  /* Inserimento di un nuovo marcatore */
  public static Marcatore inserimentoMarcatore (DataBase database, int IDReferto, int SSNGiocatore, int goal)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Marcatore marcatore;
    marcatore = new Marcatore(IDReferto, SSNGiocatore, goal);
    marcatore.insert(database);
    return marcatore;
  }
  
  /* Inserimento di un nuovo referto */
  public static Referto inserimentoNuovoReferto (DataBase database, int IDReferto, int IDPartita, int Arbitro, String data, String ora, String luogo, int Admin)
  throws NotFoundDBException, DuplicatedRecordDBException, ResultSetDBException {
    
    Referto referto;
    referto = new Referto(IDReferto, data, "--:--", "--:--", "_-_", IDPartita, Arbitro, ora, luogo, Admin);
    referto.insert(database);
    return referto;
  }
}