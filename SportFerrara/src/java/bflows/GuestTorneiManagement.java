/* Conversazione GuestTorneiManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class GuestTorneiManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;

  private int IDTorneo; 
  private String nome;
  private String descrizione;
  private String tipologia;

  private Torneo torneo;
  private Torneo[] tornei;
  private Incontro incontro;
  private Incontro[] incontri;
  private Squadra[] squadre;
  private Squadra team;
  private Calendario calendario;
  private Classifica classifica;
  private Classifica[] classifiche;

  private Giocatore giocatore;
  private Giocatore[] giocatori;

  private Giocatore[] giocatoriSquadraA;
  private Giocatore[] giocatoriSquadraB;

  private Giocatore[] GoalGiocatori;
  private Giocatore[] CartelliniGiocatori;

  private Referto referto;
  public Referto[] referti;

  private String[] nomeSquadreA;
  private String[] nomeSquadreB;
  private String[] nomeSquadreClassifica;
  
  /* Costruttore */
  public GuestTorneiManagement() {}
  
  /* listaGiocatori.jsp status = view */
  public void visualizzaGiocatori(int ID) {
    
    DataBase database = null;
    Vector vGiocatori = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vGiocatori = GiocatoreService.getGiocatoriGuest(database, ID);
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

  /* listaSquadre.jsp status = default*/
  public void visualizzaSquadre() {
    
    DataBase database = null;  
    Vector vSquadre = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      vSquadre = SquadraService.getSquadre(database);
      squadre = new Squadra[vSquadre.size()];
      vSquadre.copyInto(squadre);
      
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

  /* listaTornei.jsp status = view*/
  public void visualizzaTornei() {
    
    DataBase database = null;
    Vector vTornei = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      vTornei = TorneoService.getTornei(database);
      tornei = new Torneo[vTornei.size()];
      vTornei.copyInto(tornei);
      
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

  /* listaTorneo.jsp status = squadra */
  public void visualizzaTorneo(int ID) {
    
    DataBase database = null;
    Vector vTornei=new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      vTornei = TorneoService.getTorneiSquadra(database, ID);
      tornei = new Torneo[vTornei.size()];
      vTornei.copyInto(tornei);
      
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
  
  /* vediGiocatore.jsp status = default */
  public void visualizzaGiocatore(int ID) {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      giocatore = GiocatoreService.visualGiocatoreGuest(database, ID);          
      
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

  /* vediSquadra.jsp status = default */
  public void visualizzaSquadra(int ID) {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      team = SquadraService.visualSquadraGuest(database, ID);
      
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

  /* vediTorneo.jsp status = default */
  public void visualizzaTorneo() {
    
    DataBase database = null;
    Vector vIncontri = new Vector();
    Vector vClassifiche = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      vIncontri = TorneoService.getIncontri(database, tipologia, IDTorneo);
      incontri = new Incontro[vIncontri.size()];
      vIncontri.copyInto(incontri);
      
      vClassifiche = ClassificaService.getTorneoClassifiche(database, IDTorneo);
      classifiche = new Classifica[vClassifiche.size()];
      vClassifiche.copyInto(classifiche);
      
      nomeSquadreA = new String[incontri.length];
      nomeSquadreB = new String[incontri.length];
      
      for (int i = 0; i < incontri.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraB);
      }
      
      nomeSquadreClassifica = new String[classifiche.length];
      
      for (int i = 0; i < classifiche.length; i++)
        nomeSquadreClassifica[i] = TorneoService.visualSquadra(database, classifiche[i].IDSquadra);
      
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

  /* vediReferto.jsp status = view */
  public void visualizzaReferto(int IDPartita, int IDSquadraA, int IDSquadraB) {
    
    DataBase database = null;
    Vector vReferti = new Vector();
    Vector vGiocatori = new Vector();

    try {
      /* Apro la connessione al database */
      database=DBService.getDataBase();

      referto = RefertoService.getRefertoGuest(database, IDPartita);

      vReferti = RefertoService.getRefertiGuest(database, IDPartita);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      if(referti.length != 0) {
        
        vGiocatori = RefertoArbitroService.getGiocatori(database, IDSquadraA, referto.IDReferto);
        giocatoriSquadraA = new Giocatore[vGiocatori.size()];
        vGiocatori.copyInto(giocatoriSquadraA);

        vGiocatori=RefertoArbitroService.getGiocatori(database, IDSquadraB, referto.IDReferto);
        giocatoriSquadraB = new Giocatore[vGiocatori.size()];
        vGiocatori.copyInto(giocatoriSquadraB);

        vGiocatori=RefertoArbitroService.getGoalFormazione(database, IDSquadraA, IDSquadraB, referto.IDReferto);
        GoalGiocatori=new Giocatore[vGiocatori.size()];
        vGiocatori.copyInto(GoalGiocatori);

        vGiocatori=RefertoArbitroService.getCartelliniFormazione(database, IDSquadraA, IDSquadraB, referto.IDReferto);
        CartelliniGiocatori=new Giocatore[vGiocatori.size()];
        vGiocatori.copyInto(CartelliniGiocatori);
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

  /* Metodi getter e setter */
  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}

  public String getErrorMessage() {return this.errorMessage;}  
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}

  public Torneo getTornei(int index) {return this.tornei[index];}
  public Torneo[] getTornei() {return this.tornei;}
  public void setTornei(int index, Torneo tornei) {this.tornei[index] = tornei;}
  public void setTornei(Torneo[] tornei) {this.tornei = tornei;}

  public Torneo getTorneo() {return this.torneo;}
  public void setTorneo(Torneo torneo) {this.torneo = torneo;}

  public int getIDTorneo() {return this.IDTorneo;}
  public void setIDTorneo(int IDTorneo){this.IDTorneo=IDTorneo;}

  public String getNome() {return this.nome;}
  public void setNome(String nome){this.nome = nome;}

  public String getDescrizione() {return this.descrizione;}
  public void setDescrizione(String descrizione) {this.descrizione=descrizione;}

  public String getTipologia() {return this.tipologia;}
  public void setTipologia(String tipologia) {this.tipologia=tipologia;}

  public Incontro getIncontri(int index) {return this.incontri[index];}
  public Incontro[] getIncontri() {return this.incontri;}

  public void setIncontri(int index, Incontro incontri) {this.incontri[index] = incontri;}
  public void setIncontri(Incontro[] incontri) {this.incontri = incontri;}

  public Incontro getIncontro() {return this.incontro;}
  public void setIncontro(Incontro incontro) {this.incontro = incontro;}

  public Calendario getCalendario() {return this.calendario;}
  public void setCalendario(Calendario calendario) {this.calendario = calendario;}

  public Classifica getClassifica() {return this.classifica;}
  public void setCalendario(Classifica classifica) {this.classifica = classifica;}

  public Classifica getClassifiche(int index) {return this.classifiche[index];}
  public Classifica[] getClassifiche() {return this.classifiche;}
  public void setClassifiche(int index, Classifica classifiche) {this.classifiche[index] = classifiche;}
  public void setClassifiche(Classifica[] classifiche) {this.classifiche = classifiche;}

  public Squadra getSquadra() {return this.team;}
  public void setSquadra(Squadra team) {this.team = team;}

  public Squadra getSquadre(int index) {return this.squadre[index];}
  public Squadra[] getSquadre() {return this.squadre;}
  public void setSquadre(int index, Squadra squadre) {this.squadre[index] = squadre;}
  public void setSquadre(Squadra[] squadre) {this.squadre = squadre;}

  public Giocatore getGiocatori(int index) {return this.giocatori[index];}
  public Giocatore[] getGiocatori() {return this.giocatori;}
  public void setGiocatori(int index, Giocatore giocatori) {this.giocatori[index] = giocatori;}
  public void setGiocatori(Giocatore[] giocatori) {this.giocatori = giocatori;}

  public Giocatore getGiocatore() {return this.giocatore;}
  public void setGiocatore(Giocatore giocatore) {this.giocatore = giocatore;} 

  public Referto getReferto() {return this.referto;}
  public void setReferto(Referto referto){this.referto=referto;}

  public int getIDReferto() {return this.referto.IDReferto;}
  public void setIDReferto(int ID){this.referto.IDReferto=ID;}

  public Referto getReferti(int index) {return this.referti[index];}
  public Referto[] getReferti() {return this.referti;}
  public void setReferti(int index, Referto referti) {this.referti[index]=referti;}
  public void setReferti(Referto[] referti) {this.referti=referti;}

  public Giocatore getGiocatoriSquadraA(int index) {return this.giocatoriSquadraA[index];}
  public Giocatore[] getGiocatoriSquadraA() {return this.giocatoriSquadraA;}
  public void setGiocatoriSquadraA(int index, Giocatore giocatoriSquadraA) {this.giocatoriSquadraA[index] = giocatoriSquadraA;}
  public void setGiocatoriSquadraA(Giocatore[] giocatoriSquadraA) {this.giocatoriSquadraA = giocatoriSquadraA;}

  public Giocatore getGiocatoriSquadraB(int index) {return this.giocatoriSquadraB[index];}
  public Giocatore[] getGiocatoriSquadraB() {return this.giocatoriSquadraB;}
  public void setGiocatoriSquadraB(int index, Giocatore giocatoriSquadraB) {this.giocatoriSquadraB[index] = giocatoriSquadraB;}
  public void setGiocatoriSquadraB(Giocatore[] giocatoriSquadraB) {this.giocatoriSquadraB = giocatoriSquadraB;}

  public Giocatore getCartelliniGiocatori(int index) {return this.CartelliniGiocatori[index];}
  public Giocatore[] getCartelliniGiocatori() {return this.CartelliniGiocatori;}
  public void setCartelliniGiocatori(int index, Giocatore CartelliniGiocatori) {this.CartelliniGiocatori[index] = CartelliniGiocatori;}
  public void setCartelliniGiocatori(Giocatore[] CartelliniGiocatori) {this.CartelliniGiocatori = CartelliniGiocatori;}

  public Giocatore getGoalFormazioni(int index) {return this.GoalGiocatori[index];}
  public Giocatore[] getGoalFormazioni() {return this.GoalGiocatori;}
  public void setGoalFormazioni(int index, Giocatore GoalGiocatori) {this.GoalGiocatori[index] = GoalGiocatori;}
  public void setGoalFormazioni(Giocatore[] GoalGiocatori) {this.GoalGiocatori = GoalGiocatori;}

  public String[] getNomeSquadreA() {return nomeSquadreA;}
  public String getNomeSquadreA(int i) {return nomeSquadreA[i];}
  public void setNomeSquadreA(String[] nomeSquadreA) {this.nomeSquadreA = nomeSquadreA;}

  public String[] getNomeSquadreB() {return nomeSquadreB;}
  public String getNomeSquadreB(int i) {return nomeSquadreB[i];}
  public void setNomeSquadreB(String[] nomeSquadreB) {this.nomeSquadreB = nomeSquadreB;}

  public String[] getNomeSquadreClassifica() {return nomeSquadreClassifica;}
  public String getNomeSquadreClassifica(int i) {return nomeSquadreClassifica[i];}
  public void setNomeSquadreClassifica(String[] nomeSquadreClassifica) {this.nomeSquadreClassifica = nomeSquadreClassifica;}
}