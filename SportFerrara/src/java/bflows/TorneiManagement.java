/* Conversazione TorneiManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class TorneiManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;

  private int IDTorneo; 
  private String nome;
  private String descrizione;
  private String tipologia;
  private int creatore;

  private int[] squadra;
  private int numeroSquadre;
  private Torneo torneo;
  private Torneo[] tornei;
  private Incontro incontro;
  private Incontro[] incontri;
  private Squadra[] squadre;
  private Calendario calendario;
  private Classifica classifica;
  private Classifica[] classifiche;

  private String[] nomeSquadreA;
  private String[] nomeSquadreB;
  private String[] nomeSquadreClassifica;
  
  /* Costruttore */
  public TorneiManagement() {}
  
  /* calendario.jsp default */
  public void visualizzaCalendario() {
    
    DataBase database = null;
    Vector vIncontri = new Vector();
    int i,k = 0;
    int[] se;

    if (numeroSquadre % 2 != 0) {
      k = numeroSquadre + 1;
      se = new int[k];
      for (i = 0; i < numeroSquadre; i++)
          se[i] = squadra[i];
      se[numeroSquadre] = 0;
    }
    else {
      se = new int[numeroSquadre];
      for (i = 0; i < numeroSquadre; i++)
        se[i] = squadra[i];
    }
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      torneo = TorneoService.nuovoTorneo(database, IDTorneo, nome, tipologia, descrizione, creatore, squadra);
      
      torneo = TorneoService.visualTorneo(database, nome, creatore);
      
      /* Crea calendario */
      if (numeroSquadre % 2 != 0)
        TorneoService.creaCalendario(database, se, tipologia, torneo.IDTorneo, k);
      else
        TorneoService.creaCalendario(database, se, tipologia, torneo.IDTorneo, numeroSquadre);
      
      /* Visualizza incontri */
      vIncontri = TorneoService.getIncontri(database, torneo.tipologia, torneo.IDTorneo);
      incontri = new Incontro[vIncontri.size()];
      vIncontri.copyInto(incontri);
      
      nomeSquadreA = new String[incontri.length];
      nomeSquadreB = new String[incontri.length];
      
      for (i = 0; i < incontri.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraB);
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
      setErrorMessage("Il torneo < "+nome+" > risulta già presente nel DB. Creazione nuovo torneo FALLITA");
      database.rollBack();  
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* dettagliTorneo.jsp default */
  public void visualizzaTorneo() {
    
    DataBase database = null;
    Vector vIncontri = new Vector();
    Vector vClassifiche = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      torneo = TorneoService.visualTorneo(database, nome, creatore);

      vIncontri = TorneoService.getIncontri(database, torneo.tipologia, torneo.IDTorneo);
      incontri = new Incontro[vIncontri.size()];
      vIncontri.copyInto(incontri);

      vClassifiche = ClassificaService.getTorneoClassifiche(database, torneo.IDTorneo);
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

  /* selezionaSquadre.jsp default */
  public void visualizzaSquadre() {
    
    DataBase database = null;  
    Vector vSquadre= new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      vSquadre = SquadraService.getSquadre(database, creatore);     
      squadre = new Squadra[vSquadre.size()];
      vSquadre.copyInto(squadre);
      
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

  /* tornei.jsp default*/
  public void visualizzaTornei() {
    
    DataBase database = null;
    Vector vTornei = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      vTornei = TorneoService.getTornei(database, creatore);
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
  
  /* Metodi getter e setter */
  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}

  public String getErrorMessage() {return this.errorMessage;}  
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}

  public Torneo getTornei(int index) {return this.tornei[index];}
  public Torneo[] getTornei() {return this.tornei;}
  public void setTornei(int index, Torneo tornei) {this.tornei[index] = tornei;}
  public void setTornei(Torneo[] tornei) {this.tornei = tornei;}

  public int getCreatore() {return this.creatore;}
  public void setCreatore(String C) {creatore = Integer.parseInt(C);}

  public String getNome() {return this.nome;}
  public void setNome(String nome){this.nome = nome;}

  public String getDescrizione() {return this.descrizione;}
  public void setDescrizione(String descrizione) {this.descrizione = descrizione;}

  public String getTipologia() {return this.tipologia;}
  public void setTipologia(String tipologia) {this.tipologia = tipologia;}

  public int[] getSquadra() {return this.squadra;}
  public void setSquadra(int[] squadra) {this.squadra = squadra;}

  public int getSquadra(int index) {return this.squadra[index];}
  public void setSquadra(int index, int squadre) {this.squadra[index] = squadre;}

  public int getNumeroSquadre() {return this.numeroSquadre;}
  public void setNumeroSquadre(int numeroSquadre) {this.numeroSquadre = numeroSquadre;}

  public Squadra getSquadre(int index) {return this.squadre[index];}
  public void setSquadre(int index, Squadra squadre) {this.squadre[index] = squadre;}

  public Squadra[] getSquadre() {return this.squadre;}
  public void setSquadre(Squadra[] squadre) {this.squadre = squadre;}

  public Torneo getTorneo() {return this.torneo;}
  public void setTorneo(Torneo torneo) {this.torneo = torneo;}

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