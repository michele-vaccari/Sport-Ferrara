/* Conversazione ArbitroRefertiManagement */

package bflows;

import java.beans.*;
import java.util.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class ArbitroRefertiManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;

  private Arbitro arbitro;
  private Arbitro[] arbitri;

  private Referto referto;
  private Referto[] referti;

  private int Arbitro;
  private int IDPartita;
  private int IDReferto;

  private Squadra squadra;
  private Squadra[] squadre;

  private int IDSquadraA;
  private int IDSquadraB;

  private Giocatore[] giocatoriSquadraA;

  private Giocatore[] giocatoriSquadraB;

  private int[] goalCasa;
  private int[] goalOspite;

  private int autogoalCasa;
  private int autogoalOspite;

  private String oraInizio;
  private String oraFine;

  private String nomeTorneo;
  private int IDTorneo;
  private String tipoTorneo;

  private Classifica classifica;

  private int[] cartelliniCasa;
  private int[] cartelliniOspite;

  private Cartellini[] cartellini;
  private Marcatore[] marcatori;

  private String[] nomeSquadreA;
  private String[] nomeSquadreB;
  
  /* Costruttore */
  public ArbitroRefertiManagement() {}
  
  /* myReferti.jsp status = insert */
  /* referti.jsp status = newReferto */
  public void inserisciRefertoVisualizza() {
    
    DataBase database = null;
    Vector vReferti = new Vector();
    String Risultato;
    int i, goalHome = 0, goalGuest = 0;
    boolean pari, home, guest;
    
    for(i=0; i<goalCasa.length; i++)
      goalHome = goalHome + goalCasa[i];
    
    goalHome = goalHome + autogoalOspite;

    for(i = 0; i < goalOspite.length; i++)
      goalGuest = goalGuest + goalOspite[i];
    
    goalGuest = goalGuest + autogoalCasa;
    
    Risultato = goalHome + "-" + goalGuest;
    
    pari = false;
    home = false;
    guest = false;
    
    if(goalHome > goalGuest)
      home = true;
    else if(goalHome == goalGuest)
      pari = true;
    else
      guest = true;

    int ammonizione, espulsione;
    boolean giallo,rosso;
    Cartellini cartellino;
    Marcatore marcatore;
    
    Vector vGiocatori=new Vector();
    
    try {
      /* Apro la connessione con il database */
      database = DBService.getDataBase();

      /* SquadraA view */
      vGiocatori=RefertoArbitroService.getGiocatori(database, IDSquadraA, IDReferto);
      giocatoriSquadraA=new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraA);

      /* Squadra B view */
      vGiocatori=RefertoArbitroService.getGiocatori(database, IDSquadraB, IDReferto);
      giocatoriSquadraB=new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraB);
      
      referto=RefertoService.getReferto(database, IDReferto);

      referto.oraInizio= oraInizio;
      referto.oraFine= oraFine;
      referto.risultato=Risultato;

      referto.update(database);

      classifica = RefertoArbitroService.getClassifica(database, IDSquadraA, IDTorneo);

      classifica.GoalFatti = goalHome;
      classifica.GoalSubiti = goalGuest;
      
      classifica.update(database, home, pari);

      classifica.GoalFatti = goalGuest;
      classifica.GoalSubiti = goalHome;

      classifica.update(database, guest, pari);

      if((tipoTorneo).equals("E")) {
        if(home == true)
          RefertoArbitroService.setVincitore(database, IDSquadraA, IDTorneo, IDPartita, IDReferto);
        else
          RefertoArbitroService.setVincitore(database, IDSquadraB, IDTorneo, IDPartita, IDReferto);                   
      }

      /* Squadra Casa */
      for (i = 0; i < giocatoriSquadraA.length; i++) {

        ammonizione = 0;
        espulsione = 0;
        giallo = false;
        rosso = true;

        if(cartelliniCasa[i] == 1) {
          ammonizione = 1;
          giallo = true;
          rosso = false;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, 1, giallo, rosso);
        }
        else if(cartelliniCasa[i] == 2) {
          espulsione = 1;
          giallo = false;
          rosso = true;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, 2, giallo, rosso);
        } 

        if(goalCasa[i] != 0)
          marcatore = RefertoService.inserimentoMarcatore(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, goalCasa[i]);

        giocatoriSquadraA[i].goal = goalCasa[i];
        giocatoriSquadraA[i].ammonizioni = ammonizione;
        giocatoriSquadraA[i].espulsioni = espulsione;

        giocatoriSquadraA[i].updateStatistica(database, goalCasa[i], ammonizione, espulsione);
      }

      /* Squadra Ospite */
      for (i = 0; i < giocatoriSquadraB.length; i++) {

        ammonizione = 0;
        espulsione = 0;
        giallo = false;
        rosso = false;

        if(cartelliniOspite[i]==1) {
          ammonizione = 1;
          giallo = true;
          rosso = false;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, 1, giallo, rosso);
        }
        else if(cartelliniOspite[i] == 2) {

          espulsione = 1;
          giallo = false;
          rosso = true;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, 2, giallo, rosso);
        }

        if(goalOspite[i] != 0)
          marcatore = RefertoService.inserimentoMarcatore(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, goalOspite[i]);

        giocatoriSquadraB[i].goal=goalOspite[i];
        giocatoriSquadraB[i].ammonizioni=ammonizione;
        giocatoriSquadraB[i].espulsioni=espulsione;

        giocatoriSquadraB[i].updateStatistica(database, goalOspite[i], ammonizione, espulsione);
      }

      vReferti = RefertoService.getRefertiArbitro(database, Arbitro);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadreA = new String[referti.length];
      nomeSquadreB = new String[referti.length];

      for (i = 0; i < referti.length; i++) {
        nomeSquadreA[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraA);
        nomeSquadreB[i] = TorneoService.visualSquadra(database, referti[i].IDSquadraB);
      }
      
      /* Chiudo la connessione con il database */
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
      setErrorMessage("Il referto relativo alla partita tra "+IDPartita+" è già stato inserito."
                              + " Salvataggio referto FALLITO");
      database.rollBack();  
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* myReferti.jsp status = view*/
  public void visualizzaReferti() {
    
    DataBase database = null;
    Vector vReferti = new Vector();
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vReferti = RefertoService.getRefertiArbitro(database, Arbitro);
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

  /* referti.jsp status = insert */
  public void compilaReferto() {
    
    DataBase database = null;
    String Risultato;
    int i, goalHome = 0, goalGuest = 0;

    boolean pari, home, guest;

    /* Conto i goal per la squadra in casa */
    for(i = 0; i < goalCasa.length; i++)
        goalHome += goalCasa[i];

    goalHome += autogoalOspite;

    /* Conto i goal per la squadra ospite */
    for(i=0; i<goalOspite.length; i++)
        goalGuest += goalOspite[i];
    goalGuest += autogoalCasa;

    /* Creo il risultato */
    Risultato = goalHome + "-" + goalGuest;

    /* Stabilisco il vincitore */
    pari = false;
    home = false;
    guest = false;
    
    if(goalHome > goalGuest)
      home = true;
    else if(goalHome == goalGuest)
      pari = true;
    else
      guest = true;

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      /* Parte 1: creo il referto */
      referto = RefertoService.getReferto(database, IDReferto);
      
      referto.oraInizio = oraInizio;
      referto.oraFine = oraFine;
      referto.risultato = Risultato;

      referto.update(database);

      /* Parte 2: aggiorno la classifica */

      /* Per la squadra A */
      classifica = RefertoArbitroService.getClassifica(database, IDSquadraA, IDTorneo);

      classifica.GoalFatti = goalHome;
      classifica.GoalSubiti = goalGuest;

      classifica.update(database, home, pari);

      /* Per la squadra B */
      classifica = RefertoArbitroService.getClassifica(database, IDSquadraB, IDTorneo);

      classifica.GoalFatti = goalGuest;
      classifica.GoalSubiti = goalHome;

      classifica.update(database, guest, pari);

      if((tipoTorneo).equals("E")) {
        if(home == true)
          RefertoArbitroService.setVincitore(database, IDSquadraA, IDTorneo, IDPartita, IDReferto);
        else
          RefertoArbitroService.setVincitore(database, IDSquadraB, IDTorneo, IDPartita, IDReferto);                   
      }

      /* Parte 3: Aggiorno statistiche giocatore */
      int ammonizione, espulsione;
      boolean giallo,rosso;
      Cartellini cartellino;
      Marcatore marcatore;

      Vector vGiocatori = new Vector();

      vGiocatori = RefertoArbitroService.getGiocatori(database, IDSquadraA, IDReferto);
      giocatoriSquadraA = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraA);

      vGiocatori=RefertoArbitroService.getGiocatori(database, IDSquadraB, IDReferto);
      giocatoriSquadraB= new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraB);

      /* Squadra Casa */
      for (i = 0; i < giocatoriSquadraA.length; i++) {   
        ammonizione = 0;
        espulsione = 0;
        giallo = false;
        rosso = true;

        if(cartelliniCasa[i] == 1) {
          ammonizione = 1;
          giallo = true;
          rosso = false;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, 1, giallo, rosso);
        }
        else if(cartelliniCasa[i] == 2) {
          espulsione = 1;
          giallo = false;
          rosso = true;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, 2, giallo, rosso);
        }
        if(goalCasa[i] != 0)
          marcatore = RefertoService.inserimentoMarcatore(database, IDReferto, giocatoriSquadraA[i].SSNGiocatore, goalCasa[i]);

        giocatoriSquadraA[i].goal = goalCasa[i];
        giocatoriSquadraA[i].ammonizioni = ammonizione;
        giocatoriSquadraA[i].espulsioni = espulsione;

        giocatoriSquadraA[i].updateStatistica(database, goalCasa[i], ammonizione, espulsione);
      }

      /* Squadra Ospite */
      for (i = 0; i < giocatoriSquadraB.length; i++) {
        ammonizione = 0;
        espulsione = 0;
        giallo = false;
        rosso = false;

        if(cartelliniOspite[i] == 1) {
          ammonizione = 1;
          giallo = true;
          rosso = false;

          cartellino=RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, 1, giallo, rosso);
        }
        else if(cartelliniOspite[i] == 2) {
          espulsione = 1;
          giallo = false;
          rosso = true;

          cartellino = RefertoService.inserimentoCartellini(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, 2, giallo, rosso);
        }

        if(goalOspite[i] != 0)
          marcatore = RefertoService.inserimentoMarcatore(database, IDReferto, giocatoriSquadraB[i].SSNGiocatore, goalOspite[i]);

        giocatoriSquadraB[i].goal = goalOspite[i];
        giocatoriSquadraB[i].ammonizioni = ammonizione;
        giocatoriSquadraB[i].espulsioni = espulsione;

        giocatoriSquadraB[i].updateStatistica(database, goalOspite[i], ammonizione, espulsione);
      }

      /* Parte 4: Visualizza referti */
      Vector vReferti = new Vector();

      vReferti = RefertoService.getRefertiArbitro(database, Arbitro);
      referti = new Referto[vReferti.size()];
      vReferti.copyInto(referti);

      nomeSquadreA = new String[referti.length];
      nomeSquadreB = new String[referti.length];

      for (i = 0; i < referti.length; i++) {
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
      setErrorMessage("Il referto relativo alla partita tra "+IDPartita+" è già stato inserito."
                              + " Salvataggio referto FALLITO");
      database.rollBack();  
    }
    finally {
      try { database.close(); }
      catch (NotFoundDBException e) { EService.logAndRecover(e); }
    }
  }

  /* referti.jsp status = view */
  public void visualizzaRefertiArbitro() {
    
    DataBase database = null;
    Vector vReferti = new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vReferti = RefertoService.getRefertiArbitro(database, Arbitro);
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

  /* dettagliReferto.jsp status = default */
  public void visualizzaReferto(int IDSquadraA, int IDSquadraB, int IDReferto) {

    DataBase database=null;
    Vector vGiocatori=new Vector();

    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      vGiocatori = RefertoArbitroService.getGiocatori(database, IDSquadraA, IDReferto);
      giocatoriSquadraA = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraA);

      vGiocatori = RefertoArbitroService.getGiocatori(database, IDSquadraB, IDReferto);
      giocatoriSquadraB = new Giocatore[vGiocatori.size()];
      vGiocatori.copyInto(giocatoriSquadraB);
      
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

  public Arbitro getArbitri(int index) {return this.arbitri[index];}
  public Arbitro[] getArbitri() {return this.arbitri;}
  public void setArbitri(int index, Arbitro arbitri) {this.arbitri[index] = arbitri;}
  public void setArbitri(Arbitro[] arbitri) {this.arbitri = arbitri;}

  public Arbitro getArbitro() {return this.arbitro;}
  public void setArbitro(Arbitro arbitro) {this.arbitro = arbitro;}

  public int getSSNArbitro() {return this.Arbitro;}
  public void setSSNArbitro(int Arbitro) {this.Arbitro = Arbitro;}

  public int getIDTorneo() {return this.IDTorneo;}
  public void setIDTorneo(int IDTorneo) {this.IDTorneo = IDTorneo;}

  public int getIDPartita() {return this.IDPartita;}
  public void setIDPartita(int IDPartita) {this.IDPartita = IDPartita;}

  public Referto getReferti(int index) {return this.referti[index];}
  public Referto[] getReferti() {return this.referti;}
  public void setReferti(int index, Referto referti) {this.referti[index] = referti;}
  public void setReferti(Referto[] referti) {this.referti = referti;}

  public Referto getReferto() {return this.referto;}
  public void setReferto(Referto referto){this.referto = referto;}    

  public int getIDSquadraA() {return this.IDSquadraA;}  
  public void setIDSquadraA(int IDSquadraA) {this.IDSquadraA = IDSquadraA;}

  public int getIDSquadraB() {return this.IDSquadraB;}  
  public void setIDSquadraB(int IDSquadraB) {this.IDSquadraB = IDSquadraB;}

  public int getIDReferto() {return this.IDReferto;}  
  public void setIDReferto(int IDReferto) {this.IDReferto = IDReferto;}

  public Giocatore getGiocatoriSquadraA(int index) {return this.giocatoriSquadraA[index];}
  public Giocatore[] getGiocatoriSquadraA() {return this.giocatoriSquadraA;}
  public void setGiocatoriSquadraA(int index, Giocatore giocatoriSquadraA) {this.giocatoriSquadraA[index] = giocatoriSquadraA;}
  public void setGiocatoriSquadraA(Giocatore[] giocatoriSquadraA) {this.giocatoriSquadraA = giocatoriSquadraA;}

  public Giocatore getGiocatoriSquadraB(int index) {return this.giocatoriSquadraB[index];}
  public Giocatore[] getGiocatoriSquadraB() {return this.giocatoriSquadraB;}
  public void setGiocatoriSquadraB(int index, Giocatore giocatoriSquadraB) {this.giocatoriSquadraB[index] = giocatoriSquadraB;}
  public void setGiocatoriSquadraB(Giocatore[] giocatoriSquadraB) {this.giocatoriSquadraB = giocatoriSquadraB;}

  public String getOraInizio() {return this.oraInizio;}  
  public void setOraInizio(String oraInizio) {this.oraInizio = oraInizio;}

  public String getOraFine() {return this.oraFine;}  
  public void setOraFine(String oraFine) {this.oraFine = oraFine;}

  public String getTipoTorneo() {return this.tipoTorneo;}
  public void setTipoTorneo(String tipoTorneo) {this.tipoTorneo = tipoTorneo;}

  public int getGoalOspite(int index) {return this.goalOspite[index];}
  public int[] getGoalOspite() {return this.goalOspite;}
  public void setGoalOspite(int index, int goalOspite) {this.goalOspite[index] = goalOspite;}
  public void setGoalOspite(int[] goalOspite) {this.goalOspite = goalOspite;}

  public int getGoalCasa(int index) {return this.goalCasa[index];}
  public int[] getGoalCasa() {return this.goalCasa;}
  public void setGoalCasa(int index, int goalCasa) {this.goalCasa[index] = goalCasa;}
  public void setGoalCasa(int[] goalCasa) {this.goalCasa=goalCasa;}

  public int getAutogoalCasa() {return this.autogoalCasa;}     
  public void setAutogoalCasa(int autogoalCasa) {this.autogoalCasa = autogoalCasa;}

  public int getAutogoalOspite() {return this.autogoalOspite;}     
  public void setAutogoalOspite(int autogoalOspite) {this.autogoalOspite = autogoalOspite;}

  public Classifica getClassifica() {return this.classifica;}
  public void setClassifica(Classifica classifica){this.classifica = classifica;}

  public int getCartelliniCasa(int index) {return this.cartelliniCasa[index];}
  public int[] getCartelliniCasa() {return this.cartelliniCasa;}
  public void setCartelliniCasa(int index, int cartelliniCasa) {this.cartelliniCasa[index] = cartelliniCasa;}
  public void setCartelliniCasa(int[] cartelliniCasa) {this.cartelliniCasa = cartelliniCasa;}

  public int getCartelliniOspite(int index) {return this.cartelliniOspite[index];}
  public int[] getCartelliniOspite() {return this.cartelliniOspite;}
  public void setCartelliniOspite(int index, int cartelliniOspite) {this.cartelliniOspite[index] = cartelliniOspite;}
  public void setCartelliniOspite(int[] cartelliniOspite) {this.cartelliniOspite = cartelliniOspite;}

  public String[] getNomeSquadreA() {return nomeSquadreA;}
  public String getNomeSquadreA(int i) {return nomeSquadreA[i];}
  public void setNomeSquadreA(String[] nomeSquadreA) {this.nomeSquadreA = nomeSquadreA;}

  public String[] getNomeSquadreB() {return nomeSquadreB;}
  public String getNomeSquadreB(int i) {return nomeSquadreB[i];}
  public void setNomeSquadreB(String[] nomeSquadreB) {this.nomeSquadreB = nomeSquadreB;}
}