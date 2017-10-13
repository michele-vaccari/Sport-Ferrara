/* Conversazione GiocatoreManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class GiocatoreManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;
  
  private int SSNGiocatore;
  private String nome;
  private String cognome;
  private String nazionalità;
  private String dataNascita;
  private int numeroMaglia;
  private String ruolo;
  private String foto;
  private String flag;
  private String descrizione;
  private int goal;
  private int ammonizioni;
  private int espulsioni;
  private int IDSquadra;
  
  private int gestore;
  
  private Giocatore giocatore;
  private Giocatore[] giocatori;
  
  private Squadra squadra;
  
  /* Costruttore */
  public GiocatoreManagement() {}
  
  /* dettagliGiocatore status = modifyGiocatore */
  public void modificaGiocatoreVisualizza() {
    
    DataBase database=null;    

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      giocatore = GiocatoreService.getGiocatore(database, SSNGiocatore);

      giocatore.cognome = cognome;
      giocatore.nome = nome;
      giocatore.nazionalità = nazionalità;
      giocatore.dataNascita = dataNascita;
      giocatore.numeroMaglia = numeroMaglia;
      giocatore.ruolo = ruolo;
      giocatore.foto = foto;
      giocatore.descrizione = descrizione;

      giocatore.update(database);

      squadra = SquadraService.getSquadraGestore(database, gestore);
      
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
      setErrorMessage("Il giocatore inserito è già presente nel database.");
      database.rollBack();        
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* dettagliGiocatore status = insertGiocatore */
  public void inserisciGiocatoreVisualizza() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      SSNGiocatore = GiocatoreService.getSSNGiocatore(database, cognome, nome, IDSquadra);

      giocatore = GiocatoreService.inserimentoNuovoGiocatore(database, SSNGiocatore, nome, cognome, nazionalità, dataNascita, numeroMaglia, ruolo, foto, goal, ammonizioni, espulsioni, descrizione, IDSquadra);

      squadra = SquadraService.getSquadraGestore(database, gestore);
      
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
      setErrorMessage("Giocatore già presente, creazione nuovo giocatore FALLITA");
      database.rollBack();   
    } 
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }   
    }
  }

  /* dettagliGiocatore.jsp status = newGiocatore */
  public void visualizzaSquadra() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database=DBService.getDataBase();
      
      squadra = SquadraService.getSquadraGestore(database, gestore);
      
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

  /* giocatori.jsp status = view */
  public void visualizzaGiocatoriSquadra() {
    
    DataBase database = null;
    Vector vGiocatori = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      squadra = SquadraService.getSquadraGestore(database, gestore);
      
      vGiocatori = GiocatoreService.getGiocatori(database, gestore);  
      giocatori = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatori);
      
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

  /* giocatori.jsp status = delete */
  public void eliminaGiocatoriSquadraVisualizza() {
    
    DataBase database = null;
    Giocatore giocatore;
    Vector vGiocatori = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      giocatore = GiocatoreService.getGiocatore(database, SSNGiocatore);
      giocatore.delete(database); 

      squadra = SquadraService.getSquadraGestore(database, gestore);

      vGiocatori = GiocatoreService.getGiocatori(database, gestore);

      giocatori = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatori);
      
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
  
  /* Metodi getter e setter */
  public String getErrorMessage() {return errorMessage;}
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}

  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}

  public int getGestore() {return this.gestore;}
  public void setGestore(String G) {gestore = Integer.parseInt(G);}

  public String getNome() {return this.nome;}
  public void setNome(String nome) {this.nome = nome;}

  public String getCognome() {return this.cognome;}
  public void setCognome(String cognome) {this.cognome = cognome;}

  public String getNazionalità() {return this.nazionalità;}
  public void setNazionalità(String nazionalità) {this.nazionalità = nazionalità;}

  public String getDataNascita() {return this.dataNascita;}
  public void setDataNascita(String dataNascita) {this.dataNascita = dataNascita;}

  public int getNumeroMaglia() {return this.numeroMaglia;}    
  public void setNumeroMaglia(int numeroMaglia) {this.numeroMaglia = numeroMaglia;}

  public String getRuolo() {return this.ruolo;}    
  public void setRuolo(String ruolo) {this.ruolo = ruolo;}

  public String getFoto() {return this.foto;}     
  public void setFoto(String foto) {this.foto = foto;}

  public int getGoal() {return this.goal;}  
  public void setGoal(int goal) {this.goal = goal;}

  public int getAmmonizioni() {return this.ammonizioni;}    
  public void setAmmonizioni(int ammonizioni) {this.ammonizioni = ammonizioni;}

  public int getEspulsioni() {return this.espulsioni;}   
  public void setEspulsioni(int espulsioni) {this.espulsioni = espulsioni;}

  public String getDescrizione() {return this.descrizione;}   
  public void setDescrizione(String descrizione) {this.descrizione = descrizione;}

  public int getIDSquadra() {return this.IDSquadra;}    
  public void setIDSquadra(int IDSquadra) {this.IDSquadra = IDSquadra;}

  public int getSSNGiocatore() {return this.SSNGiocatore;}
  public void setSSNGiocatore(int SSNGiocatore) {this.SSNGiocatore = SSNGiocatore;}

  public Giocatore getGiocatori(int index) {return this.giocatori[index];}
  public Giocatore[] getGiocatori() {return this.giocatori;}
  public void setGiocatori(int index, Giocatore giocatori) {this.giocatori[index] = giocatori;}
  public void setGiocatori(Giocatore[] giocatori) {this.giocatori = giocatori;}

  public Giocatore getGiocatore() {return this.giocatore;}
  public void setGiocatore(Giocatore giocatore) {this.giocatore = giocatore;}  

  public Squadra getSquadra() {return this.squadra;}
  public void setSquadra(Squadra squadra) {this.squadra = squadra;}
}