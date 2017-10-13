/* Conversazione UserManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class UserManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;
  
  private int SSN;
  private String email;
  private String nome;
  private String cognome;
  private String password;
  private String type;
  private String flag;
  private String indirizzo;
  private String telefono;
  private String nazionalità;
  private String carriera;
  private String data;
  private String foto;
  private int Admin;
  private String squadra;
  
  private Utente user;
  private Utente[] users; 
  private Registrato Uregistrato;
  private Registrato[] Uregistrati; 
  private Arbitro[] arbitri;
  public Arbitro arbitro;
  private Gestore gestore;
  private Gestore[] gestori;
  
  /* Costruttore */
  public UserManagement() {}
  
  /* dettagliUtente.jsp status = insertArbitro */
  public void inserisciArbitro() {
    
    DataBase database = null;
    Arbitro arbitro;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      SSN = UtenteService.getSSNUtente(database, email);
      arbitro = UtenteService.inserimentoNuovoArbitro(database, SSN, nome, cognome, email, password, type, indirizzo, telefono, Admin, foto, data, nazionalità, carriera);
      
      SSN = UtenteService.getSSNUtente(database, email);
      
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
      setErrorMessage("La mail: < "+email+" > non è disponibile, è già associata ad un altro utente. Creazione nuovo arbitro FALLITA");
      database.rollBack();   
    } 
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* dettagliUtente.jsp status = insertGestore */
  public void inserisciGestore() {
    
    DataBase database = null;
    Gestore gestore;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      SSN = UtenteService.getSSNUtente(database, email);
      gestore = UtenteService.inserimentoNuovoGestore(database, SSN, nome, cognome, email, password, type, indirizzo, telefono, Admin, squadra);
      
      SSN = UtenteService.getSSNUtente(database, email);
      
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
      setErrorMessage("La mail < "+email+" > non è disponibile,è già associata ad un altro utente. Creazione nuovo arbitro FALLITA");
      database.rollBack();  
    } 
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }  
    }
  }

  /* dettagliUtente.jsp status = modifyArbitro */
  public void modificaArbitro() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database=DBService.getDataBase();
      
      arbitro = UtenteService.getArbitro(database, SSN);

      arbitro.email = email;
      arbitro.password = password;
      arbitro.nome = nome;
      arbitro.cognome = cognome;
      arbitro.data_n = data;      
      arbitro.nazionalità = nazionalità;
      arbitro.telefono = telefono;
      arbitro.indirizzo = indirizzo;
      arbitro.type = type;
      arbitro.foto = foto;
      arbitro.carriera = carriera;

      arbitro.update(database);
      
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
      setErrorMessage("L'arbitro inserito è già esistente.");
      database.rollBack();
    } 
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
   } 

  /* dettagliUtente.jsp status = modifyGestore */
  public void modificaGestore() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      gestore = UtenteService.getGestore(database, SSN);
      
      gestore.email = email;
      gestore.password = password;
      gestore.nome = nome;
      gestore.cognome = cognome;
      gestore.squadra = squadra;
      
      gestore.update(database);
      
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
      setErrorMessage("Il Gestore squadra inserito è già esistente.");
      database.rollBack(); 
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* utenti.jsp status = delete */
  public void eliminaUtenteVisualizza() {
    
    DataBase database = null;
    Registrato registrato;
    Vector vUregistrati = new Vector();
    Vector vArbitri = new Vector();
    Vector vGestori = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      /* Elimina */
      registrato = UtenteService.getRegistrato(database, email);
      registrato.delete(database); //il metodo delete cambia soltanto il valore del flag active all'interno del DB

      /* Visualizza */
      vUregistrati = UtenteService.getRegistrati(database,Admin); 
      Uregistrati = new Registrato[vUregistrati.size()];
      vUregistrati.copyInto(Uregistrati);

      vArbitri = UtenteService.getArbitri(database,Admin);
      arbitri=new Arbitro[vArbitri.size()];
      vArbitri.copyInto(arbitri);

      vGestori = UtenteService.getGestori(database,Admin);
      gestori = new Gestore[vGestori.size()];
      vGestori.copyInto(gestori);
      
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

  /* utenti.jsp status = view */
  public void visualizzaUtenti() {
    
    DataBase database = null;
    Vector vUregistrati = new Vector();
    Vector vArbitri = new Vector();
    Vector vGestori = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vUregistrati = UtenteService.getRegistrati(database,Admin); 
      Uregistrati = new Registrato[vUregistrati.size()];
      vUregistrati.copyInto(Uregistrati);

      vArbitri = UtenteService.getArbitri(database,Admin);
      arbitri = new Arbitro[vArbitri.size()];
      vArbitri.copyInto(arbitri);

      vGestori = UtenteService.getGestori(database,Admin);
      gestori = new Gestore[vGestori.size()];
      vGestori.copyInto(gestori);

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
  
  public int getAdmin() {return this.Admin;}
  public void setAdmin(String A) {Admin = Integer.parseInt(A);}
  
  public Registrato getUtentiReg(int index) {return this.Uregistrati[index];}
  public Registrato[] getUtentiReg() {return this.Uregistrati;}
  
  public void setUtentiReg(int index, Registrato Uregistrati) {this.Uregistrati[index] = Uregistrati;}
  public void setUtentiReg(Registrato[] Uregistrati) {this.Uregistrati = Uregistrati;}
  
  public Arbitro getArbitri(int index) {return this.arbitri[index];}
  public Arbitro[] getArbitri() {return this.arbitri;}
  
  public void setArbitri(int index, Arbitro arbitri) {this.arbitri[index] = arbitri;}
  public void setArbitri(Arbitro[] arbitri) {this.arbitri = arbitri;}
  
  public Arbitro getArbitro() {return this.arbitro;}
  public void setArbitro(Arbitro arbitro) {this.arbitro = arbitro;}
  
  public Gestore getGestori(int index) {return this.gestori[index];}
  public Gestore[] getGestori() {return this.gestori;}
  
  public void setGestori(int index, Gestore gestori) {this.gestori[index] = gestori;}
  public void setGestori(Gestore[] gestori) {this.gestori = gestori;}
  
  public Gestore getGestore() {return this.gestore;}
  public void setGestore(Gestore gestore) {this.gestore = gestore;}
  
  public String getNome() {return this.nome;}
  public void setNome(String nome) {this.nome = nome;}
  
  public String getCognome() {return this.cognome;}
  public void setCognome(String cognome) {this.cognome = cognome;}
  
  public String getPassword() {return this.password;}
  public void setPassword(String password) {this.password = password;}
  
  public String getData() {return this.data;}
  public void setData(String data) {this.data = data;}
  
  public String getNazionalità() {return this.nazionalità;}
  public void setNazionalità(String nazionalità) {this.nazionalità = nazionalità;}
  
  public String getCarriera() {return this.carriera;}
  public void setCarriera(String carriera) {this.carriera = carriera;}
  
  public String getIndirizzo() {return this.indirizzo;}
  public void setIndirizzo(String indirizzo) {this.indirizzo = indirizzo;}
  
  public String getTelefono() {return this.telefono;}
  public void setTelefono(String telefono) {this.telefono = telefono;}
  
  public String getEmail() {return this.email;}
  public void setEmail(String email) {this.email = email;}
  
  public String getTipo () {return this.type;}
  public void setTipo (String type) {this.type = type;}
  
  public Utente getUtente() {return this.user;}
  public void setUtente(Utente utente) {this.user = utente;}
  
  public String getFoto() {return this.foto;}
  public void setFoto(String foto) {this.foto = foto;}
  
  public String getSquadra() {return this.squadra;}
  public void setSquadra(String squadra) {this.squadra = squadra;}
  
  public int getSSN() {return this.SSN;}
  public void setSSN(int SSN) {this.SSN = SSN;}
}