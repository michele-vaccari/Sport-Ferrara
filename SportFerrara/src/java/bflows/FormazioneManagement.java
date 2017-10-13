/* Conversazione FormazioneManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class FormazioneManagement implements java.io.Serializable {
  
  /* Property */
  private int result;
  private String errorMessage;

  private int SSNGiocatore;
  private int IDSquadra;
  private int IDReferto;
  private int gestore;

  private Referto referto;
  private Referto[] referti;

  private Giocatore giocatore;
  private Giocatore[] giocatori;

  private String[] nomeSquadreA;
  private String[] nomeSquadreB;

  private int[] titolari;
  private int[] riserve;
  
  /* Costruttore */
  public FormazioneManagement() {}
  
  /* sceltaGiocatori.jsp status = default */
  public void visualizzaGiocatori() {
    
    DataBase database = null;
    Vector vGiocatori = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vGiocatori = GiocatoreService.getGiocatori(database, gestore);  
      giocatori = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatori);
      
      /* Chiudo la connessione al database */
      database.commit(); 
    } 
    catch (NotFoundDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
    }
    catch (ResultSetDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* newFormazione.jsp status = view */
  public void visualizzaReferti() {
    
    DataBase database = null;
    Vector vReferti = new Vector();

    try {
      /* Apro la connessione al database */
      database=DBService.getDataBase();

      vReferti = FormazioneService.getReferti(database, gestore);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadreA = new String[referti.length];
      nomeSquadreB = new String[referti.length];

      for (int i = 0; i < referti.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraB);
      }
      
      /* Chiudo la connessione al database */
      database.commit();
    }
    catch (NotFoundDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
      database.rollBack();
    }
    catch (ResultSetDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
      database.rollBack();
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* newFormazione.jsp status = insert */
  public void inserisciFormazioneVisualizza() {
    
    DataBase database = null;
    Formazione formazione;
    Vector vReferti = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      formazione = FormazioneService.inserimentoNuovaFormazione(database, titolari, riserve, IDReferto, gestore);

      vReferti = FormazioneService.getReferti(database, gestore);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadreA = new String[referti.length];
      nomeSquadreB = new String[referti.length];

      for (int i = 0; i < referti.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraB);
      }
      /* Chiudo la connessione al database */
      database.commit();
    }
    catch (NotFoundDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
      database.rollBack();
    } 
    catch (ResultSetDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.UNRECOVERABLE_ERROR);
      database.rollBack();
    } 
    catch (DuplicatedRecordDBException ex) {
      EService.logAndRecover(ex);
      setResult(EService.RECOVERABLE_ERROR);
      setErrorMessage("La formazione relativa alla partita indicata risulta già presente nel DB. Inserimento nuova formazione FALLITO!");
      database.rollBack();  
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }
  
  /* Metodi getter e setter */
  public String getErrorMessage() {return errorMessage;}
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}
  
  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}
  
  public int getGestore() {return this.gestore;}
  public void setGestore(String G) {gestore = Integer.parseInt(G);}
  
  public Referto getReferti(int index) {return this.referti[index];}
  public Referto[] getReferti() {return this.referti;}
  public void setReferti(int index, Referto referti) {this.referti[index]=referti;}
  public void setReferti(Referto[] referti) {this.referti=referti;}
  
  public Referto getReferto() {return this.referto;}
  public void setReferto(Referto referto){this.referto=referto;}
  
  public Giocatore getGiocatori(int index) {return this.giocatori[index];}
  public Giocatore[] getGiocatori() {return this.giocatori;}
  public void setGiocatori(int index, Giocatore giocatori) {this.giocatori[index] = giocatori;}
  public void setGiocatori(Giocatore[] giocatori) {this.giocatori = giocatori;}
  
  public Giocatore getGiocatore() {return this.giocatore;}
  public void setGiocatore(Giocatore giocatore) {this.giocatore = giocatore;}
  
  public int getTitolari(int index) {return this.titolari[index];}
  public int[] getTitolari() {return this.titolari;}
  public void setTitolari(int index, int titolari) {this.titolari[index] = titolari;}
  public void setTitolari(int[] titolari) {this.titolari = titolari;}
  
  public int getRiserve(int index) {return this.riserve[index];}
  public int[] getRiserve() {return this.riserve;}
  public void setRiserve(int index, int riserve) {this.riserve[index] = riserve;}
  public void setRiserve(int[] riserve) {this.riserve = riserve;}
  
  public int getSSNGiocatore() {return this.SSNGiocatore;}
  public void setSSNGiocatore(int SSNGiocatore) {this.SSNGiocatore = SSNGiocatore;}
  
  public int getIDSquadra() {return this.IDSquadra;}    
  public void setIDSquadra(int IDSquadra) {this.IDSquadra = IDSquadra;}
  
  public int getIDReferto() {return this.IDReferto;}    
  public void setIDReferto(int IDReferto) {this.IDReferto = IDReferto;}
  
  public String[] getNomeSquadreA() {return nomeSquadreA;}
  public String getNomeSquadreA(int i) {return nomeSquadreA[i];}
  public void setNomeSquadreA(String[] nomeSquadreA) {this.nomeSquadreA = nomeSquadreA;}
  
  public String[] getNomeSquadreB() {return nomeSquadreB;}
  public String getNomeSquadreB(int i) {return nomeSquadreB[i];}
  public void setNomeSquadreB(String[] nomeSquadreB) {this.nomeSquadreB = nomeSquadreB;} 
}