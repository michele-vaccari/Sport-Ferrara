package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Calendario {
  
  /* Property */
  public String tipologia;
  public int[] squadre;
  public int IDTorneo;
  public int numSQ;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Calendario (int[] squadre, String tipologia, int IDtorneo, int numSQ) {
    
    this.squadre = squadre;
    this.tipologia = tipologia;
    this.IDTorneo = IDtorneo;
    this.numSQ = numSQ;
  }
  
  /* Sposta a sinistra */
  public int[] shiftLeft (int[] data, int add) {
    
    int[] temp = new int[data.length];
    for (int i = 0; i < data.length - 1; i++) {
      temp[i] = data[i + 1];
    }
    temp[data.length - 1] = add;
    return temp;
  }
  
  /* Sposta a destra */
  public int[] shiftRight (int[] data, int add) {
    
    int[] temp = new int[data.length];
    for (int i = 1; i < data.length; i++) {
      temp[i] = data[i - 1];
    }
    temp[0] = add;
    return temp;
  }
  
  /* Inserimento di un calendario */
  public void insert (DataBase database)
  throws NotFoundDBException,DuplicatedRecordDBException,ResultSetDBException {
    
    String sql;
    
    int i, j, k, fase, nomeAss, IDPartita = 0;
    
    fase = 0;
    
    /* Controllo se esiste un torneo con lo stesso nome */
    sql= " SELECT * " +
         " FROM giocano " +
         " WHERE ID_Torneo='" + Conversion.getDatabaseString("" + IDTorneo) + "'";

    ResultSet resultSet = database.select(sql);

    boolean exist = false;
    
    try {
      exist = resultSet.next();
      resultSet.close();
    }
    catch (SQLException e) {
      throw new ResultSetDBException("Calendario: insert(): Errore sul ResultSet.");
    }
    
    if (exist)
      throw new DuplicatedRecordDBException("Calendario: insert(): Tentativo di inserimento di un torneo già esistente");
    
    /* Inserimento di un torneo all'italiana */
    if (tipologia.equals("I")) {
      
      String sql_I;
      
      sql_I = " SELECT MAX(ID_Partita) AS N " +
              " FROM partita ";
      
      try {
        resultSet = database.select(sql_I);
        
        if (resultSet.next())
          IDPartita = (resultSet.getInt("N") + 1);
        else
          IDPartita = 1;
        
        resultSet.close();
      }
      catch (SQLException e) {throw new ResultSetDBException("Calendario: insert(): Errore sul ResultSet --> Impossibile calcolare il codice gara.");}

      int giornate = numSQ - 1;

      int casa[] = new int[numSQ/2];
      int trasferta[] = new int[numSQ/2];

      for(i = 0; i < numSQ/2; i++) {
        casa[i] = squadre[i];
        trasferta[i] = squadre[numSQ - 1 - i];    
      }
      
      for(i = 1; i <= giornate; i++) {
        if(i % 2 == 0) {
          for(j = 0; j < numSQ/2; j++) {
            
            k = 0;
            
            /* Genero l'andata */
            sql = " INSERT INTO partita "+
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'I' ) ";
            database.modify(sql);
            
            sql = " INSERT INTO giocano " +
                  " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                  " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                  " '" + Conversion.getDatabaseString("" + trasferta[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + casa[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                  " '" + Conversion.getDatabaseString("" + i) + "')";
            database.modify(sql);
            IDPartita++;
            
            k = i + giornate;
            /* Genero il ritorno */
            sql = " INSERT INTO partita "+
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'I' ) ";  
            database.modify(sql);
            
            sql = " INSERT INTO giocano " +
                  " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                  " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                  " '" + Conversion.getDatabaseString("" + casa[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + trasferta[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                  " '" + Conversion.getDatabaseString("" + k) + "')";
            database.modify(sql);
            IDPartita++;
          }
        }
        else {
          for(j = 0; j < numSQ/2; j++) {
            
            k = 0;
            
            /* Genero l'andata */
            sql = " INSERT INTO partita "+
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'I' ) ";  
            database.modify(sql);

            sql = " INSERT INTO giocano " +
                  " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                  " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                  " '" + Conversion.getDatabaseString("" + casa[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + trasferta[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                  " '" + Conversion.getDatabaseString("" + i) + "')";
            database.modify(sql);
            IDPartita++;

            k = i + giornate;
            
            /* Genero il ritorno */
            sql = " INSERT INTO partita " +
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'I' ) ";  
            database.modify(sql);

            sql = " INSERT INTO giocano " +
                  " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                  " VALUES ('"+Conversion.getDatabaseString("" + IDPartita) + "', " +
                  " '"+Conversion.getDatabaseString("" + trasferta[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + casa[j]) + "', " +
                  " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                  " '" + Conversion.getDatabaseString("" + k) + "')";
            database.modify(sql);
            IDPartita++;
          }
        }
        
        int pivot = casa[0];

        int riporto = trasferta[trasferta.length - 1];

        trasferta = shiftRight(trasferta, casa[1]);

        casa = shiftLeft(casa, riporto);

        casa[0] = pivot;
      }
    }
    else { /* Inserimento di un torneo ad eliminazione */
      
      String sql_SSN;

      if(numSQ == 2)
        fase = 1;
      else if(numSQ == 4)
        fase = 2;
      else if(numSQ == 8)
        fase = 3;
      else if(numSQ == 16)
        fase = 4;
      
      if(numSQ == 2) {
        
        sql_SSN = " SELECT MAX(ID_Partita) AS N " +
                  " FROM partita ";
        try {
          resultSet = database.select(sql_SSN);
          
          if (resultSet.next())
            IDPartita = (resultSet.getInt("N") + 1);
          else
            IDPartita = 1;

          resultSet.close();
        } 
        catch (SQLException e) {throw new ResultSetDBException("Calendario: insert(): Errore sul ResultSet --> Impossibile calcolare Id_Partita.");}
        
        sql = " INSERT INTO partita " +
              " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
              " 'E') ";  
              database.modify(sql);

        sql = " INSERT INTO giocano " +
              " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
              " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
              " '" + Conversion.getDatabaseString(""+squadre[0]) + "', " +
              " '" + Conversion.getDatabaseString(""+squadre[1]) + "', " +
              " '" + Conversion.getDatabaseString(""+IDTorneo) + "', " +
              " '" + Conversion.getDatabaseString(""+fase) + "')";
        database.modify(sql);
      }
      else {
        
        j = numSQ - 1;

        for (i = 0; i < numSQ/2; i++) {
          
          sql_SSN = " SELECT MAX(ID_Partita) AS N " +
                    " FROM partita ";
          try {
            resultSet = database.select(sql_SSN);

            if (resultSet.next())
              IDPartita = (resultSet.getInt("N") + 1);
            else
              IDPartita = 1;
            
            resultSet.close();
          } 
          catch (SQLException e) {throw new ResultSetDBException("Calendario: insert(): Errore sul ResultSet --> Impossibile calcolare Id_Partita.");}
          
          sql = " INSERT INTO partita " +
                " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                " 'E' ) ";  
          database.modify(sql);

          sql = " INSERT INTO giocano " +
                " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                " '" + Conversion.getDatabaseString("" + squadre[i]) + "', " +
                " '" + Conversion.getDatabaseString("" + squadre[j]) + "', " +
                " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                " '" + Conversion.getDatabaseString("" + fase) + "')";
          database.modify(sql);
          
          j--;
        }
        /* Aggiungo le partite delle fasi successive */
        if(fase == 2) {
          
          IDPartita++;

          sql = " INSERT INTO partita " +
                " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita)+ "'," +
                " 'E' ) ";  
          database.modify(sql);
          
          sql = " INSERT INTO giocano " +
                " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                " VALUES ('"+Conversion.getDatabaseString("" + IDPartita) + "', " +
                " '" + Conversion.getDatabaseString("0") + "', " +
                " '" + Conversion.getDatabaseString("0") + "', " +
                " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                " '" + Conversion.getDatabaseString("1") + "')";
          database.modify(sql);
        }
        
        if(fase == 3) {
          
          for(i = 0; i < 3; i++) {
            
            IDPartita++;
            
            sql = " INSERT INTO partita " +
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'E' ) "; 
            database.modify(sql);

            if(i < 2) {
              
              sql = " INSERT INTO giocano " +
                    " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                    " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                    " '" + Conversion.getDatabaseString("2") + "')";
              database.modify(sql);
              }
            else {
              sql = " INSERT INTO giocano " +
                    " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                    " VALUES ('"+Conversion.getDatabaseString("" + IDPartita) + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                    " '" + Conversion.getDatabaseString("1") + "')";
              database.modify(sql);
            }
          }
        }
        
        if (fase == 4) {

          for(i = 0; i < 7; i++) {
            
            IDPartita++;
            
            sql = " INSERT INTO partita " +
                  " (ID_Partita, Tipo) VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "'," +
                  " 'E' ) ";  
            database.modify(sql);
            
            if(i < 4) {
              
              sql = " INSERT INTO giocano " +
                    " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                    " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                    " '" + Conversion.getDatabaseString("3") + "')";
              database.modify(sql);
            }
            else if(i < 6) {
              
              sql = " INSERT INTO giocano " +
                    " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                    " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                    " '" + Conversion.getDatabaseString("2") + "')";
              database.modify(sql);
            }
            else {
              
              sql = " INSERT INTO giocano " +
                    " (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo, Numero_giornata_o_fase) " +
                    " VALUES ('" + Conversion.getDatabaseString("" + IDPartita) + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("0") + "', " +
                    " '" + Conversion.getDatabaseString("" + IDTorneo) + "', " +
                    " '" + Conversion.getDatabaseString("1") + "')";
              database.modify(sql);      
            }
          }
        }
      }
    }
  }
}