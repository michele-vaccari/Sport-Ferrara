/* Conversazione RefertiManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class RefertiManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;
  
  private int creatore;
  private Torneo torneo;
  private Torneo[] tornei;
  
  private String fase;
  private String[] fasi;
  
  private Incontro incontro;
  private Incontro[] incontri;
  
  private Arbitro arbitro;
  private Arbitro[] arbitri;
  
  private Referto referto;
  private Referto[] referti;
  
  private int Arbitro;
  private int IDPartita;
  private int IDReferto;
  private String data;
  private String ora;
  private String luogo;
  
  private String[] nomeSquadraCasa;
  private String[] nomeSquadraOspite;
  
  private String[] nomeSquadreA;
  private String[] nomeSquadreB;
  
  /* referti.jsp status = default */
  /* refertiView.jsp = default */
  public void refertiVisualizza() {
    
    DataBase database = null;
    Vector vReferti = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vReferti = RefertoService.getRefertiAdmin(database, creatore);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadraCasa = new String[referti.length];
      nomeSquadraOspite = new String[referti.length];

      for (int i = 0; i < referti.length; i++) {
        nomeSquadraCasa[i] = RefertoService.visualSquadraCasa(database, referti[i].IDPartita);
        nomeSquadraOspite[i] = RefertoService.visualSquadraOspite(database, referti[i].IDPartita);
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

  /* referti.jsp status = newReferto */
  public void inserisciRefertoVisualizza() {
    
    DataBase database = null;
    Vector vReferti = new Vector();
    Referto referto;

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      referto = RefertoService.inserimentoNuovoReferto(database, IDReferto, IDPartita, Arbitro, data, ora, luogo, creatore);

      vReferti = RefertoService.getRefertiAdmin(database, creatore);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadraCasa = new String[referti.length];
      nomeSquadraOspite = new String[referti.length];

      for (int i = 0; i < referti.length; i++) {
        nomeSquadraCasa[i] = RefertoService.visualSquadraCasa(database, referti[i].IDPartita);
        nomeSquadraOspite[i] = RefertoService.visualSquadraOspite(database, referti[i].IDPartita);
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
      setErrorMessage("Il referto relativo all'incontro selezionato esiste già. Creazione nuovo referto FALLITA");
      database.rollBack();  
    } 
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* newReferto.jsp = default */
  public void visualizzaTornei() {
    
    DataBase database = null;
    Vector vTornei=new Vector();

    try{
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
  
  /* newReferto.jsp = modifica */
  public void visualizzaTorneiModifica (int IDTorneo) {
    
    DataBase database = null;
    Vector vTornei = new Vector();
    Vector vFasi = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      vTornei = TorneoService.getTornei(database, creatore);
      tornei = new Torneo[vTornei.size()];
      vTornei.copyInto(tornei);
      
      vFasi = RefertoService.getFasi(database, IDTorneo);
      fasi = new String[vFasi.size()];
      vFasi.copyInto(fasi);
      
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

  /* newReferto.jsp = conferma */
  public void visualizzaTorneiModificaConferma(int IDTorneo) {

    DataBase database = null;
    Vector vTornei=new Vector();
    Vector vFasi = new Vector();
    Vector vIncontri = new Vector();
    Vector vArbitri = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vTornei = TorneoService.getTornei(database, creatore);
      tornei = new Torneo[vTornei.size()];
      vTornei.copyInto(tornei);

      vFasi = RefertoService.getFasi(database, IDTorneo);
      fasi = new String[vFasi.size()];
      vFasi.copyInto(fasi);

      vIncontri = TorneoService.getIncontriFase(database, IDTorneo, fase);
      incontri = new Incontro[vIncontri.size()];
      vIncontri.copyInto(incontri);

      vArbitri = UtenteService.getArbitri(database,creatore);   
      arbitri = new Arbitro[vArbitri.size()];
      vArbitri.copyInto(arbitri);

      nomeSquadreA = new String[incontri.length];
      nomeSquadreB = new String[incontri.length];

      for (int i = 0; i < incontri.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, incontri[i].IDSquadraB);
      }

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
    
  /* Metodi getter e setter */
  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}

  public String getErrorMessage() {return this.errorMessage;}  
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}

  public int getCreatore() {return this.creatore;}
  public void setCreatore(String C) {creatore = Integer.parseInt(C);}

  public Torneo getTornei(int index) {return this.tornei[index];}
  public Torneo[] getTornei() {return this.tornei;}
  public void setTornei(int index, Torneo tornei) {this.tornei[index] = tornei;}
  public void setTornei(Torneo[] tornei) {this.tornei = tornei;}

  public Torneo getTorneo() {return this.torneo;}
  public void setTorneo(Torneo torneo) {this.torneo = torneo;}

  public String getFasi(int index) {return this.fasi[index];}
  public String[] getFasi() {return this.fasi;}
  public void setFasi(int index, String fasi) {this.fasi[index] = fasi;}
  public void setFasi(String[] fasi) {this.fasi = fasi;}

  public String getFase() {return this.fase;}
  public void setFase(String fase) {this.fase = fase;}

  public Incontro getIncontri(int index) {return this.incontri[index];}
  public Incontro[] getIncontri() {return this.incontri;}
  public void setIncontri(int index, Incontro incontri) {this.incontri[index] = incontri;}
  public void setIncontri(Incontro[] incontri) {this.incontri = incontri;}

  public Incontro getIncontro() {return this.incontro;}
  public void setIncontro(Incontro incontro) {this.incontro = incontro;}

  public Arbitro getArbitri(int index) {return this.arbitri[index];}
  public Arbitro[] getArbitri() {return this.arbitri;}
  public void setArbitri(int index, Arbitro arbitri) {this.arbitri[index] = arbitri;}
  public void setArbitri(Arbitro[] arbitri) {this.arbitri = arbitri;}

  public Arbitro getArbitro() {return this.arbitro;}
  public void setArbitro(Arbitro arbitro) {this.arbitro = arbitro;}

  public int getSSNArbitro() {return this.Arbitro;}
  public void setSSNArbitro(int Arbitro) {this.Arbitro = Arbitro;}

  public int getIDPartita() {return this.IDPartita;}
  public void setIDPartita(int IDPartita) {this.IDPartita = IDPartita;}

  public Referto getReferti(int index) {return this.referti[index];}
  public Referto[] getReferti() {return this.referti;}
  public void setReferti(int index, Referto referti) {this.referti[index] = referti;}
  public void setReferti(Referto[] referti) {this.referti = referti;}

  public Referto getReferto() {return this.referto;}
  public void setReferto(Referto referto){this.referto = referto;}

  public String getData() {return this.data;}
  public void setData(String data) {this.data = data;}

  public String getOra() {return this.ora;}
  public void setOra(String ora) {this.ora = ora;}

  public String getLuogo() {return this.luogo;}
  public void setLuogo(String luogo) {this.luogo = luogo;}

  public String[] getNomeSquadraCasa() {return nomeSquadraCasa;}
  public String getNomeSquadraCasa(int i) {return nomeSquadraCasa[i];}
  public void setNomeSquadraCasa(String[] nomeSquadraCasa) {this.nomeSquadraCasa = nomeSquadraCasa;}

  public String[] getNomeSquadraOspite() {return nomeSquadraOspite;}
  public String getNomeSquadraOspite(int i) {return nomeSquadraOspite[i];}
  public void setNomeSquadraOspite(String[] nomeSquadraOspite) {this.nomeSquadraOspite = nomeSquadraOspite;}

  public String[] getNomeSquadreA() {return nomeSquadreA;}
  public String getNomeSquadreA(int i) {return nomeSquadreA[i];}
  public void setNomeSquadreA(String[] nomeSquadreA) {this.nomeSquadreA = nomeSquadreA;}

  public String[] getNomeSquadreB() {return nomeSquadreB;}
  public String getNomeSquadreB(int i) {return nomeSquadreB[i];}
  public void setNomeSquadreB(String[] nomeSquadreB) {this.nomeSquadreB = nomeSquadreB;}
}