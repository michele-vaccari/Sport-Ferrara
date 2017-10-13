/* Conversazione SquadraManagement */

package bflows;

import java.beans.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import blogics.*;

public class SquadraManagement {
  
  /* Property */
  private String errorMessage;
  private int result;

  public int ID_Squadra;
  public String nomeSquadra;
  public String logoSquadra;
  public String immagineSquadra;
  public String nomeSponsor;
  public String logoSponsor;
  public String sede;
  public String descrizione;
  public int gestore;
  public String flag;

  public Squadra squadra;

  /* Costruttore */
  public SquadraManagement() {}

  /* homeG.jsp status = default */
  /* squadre.jsp status = view */
  public void visualizzaSquadra() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

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

  /* squadre.jsp status = modifySquadra */
  public void modificaSquadreVisualizza() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();

      squadra = SquadraService.getSquadraGestore(database, gestore);

      squadra.ID_Squadra = ID_Squadra;
      squadra.nomeSquadra = nomeSquadra;
      squadra.logoSquadra = logoSquadra;
      squadra.immagineSquadra = immagineSquadra;
      squadra.nomeSponsor = nomeSponsor;      
      squadra.logoSponsor = logoSponsor;
      squadra.sede = sede;
      squadra.descrizione = descrizione;
      squadra.flag = flag;

      squadra.update(database);

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
      setErrorMessage("Squadra inserita già esistente.");
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
 
  public int getIDSquadra() {return this.ID_Squadra;}
  public void setIDSquadra(int ID_Squadra) {this.ID_Squadra = ID_Squadra;}
    
  public String getNomeSquadra() {return this.nomeSquadra;}
  public void setNomeSquadra(String nomeSquadra) {this.nomeSquadra = nomeSquadra;}
  
  public String getLogoSquadra() {return this.logoSquadra;}
  public void setLogoSquadra(String logoSquadra) {this.logoSquadra = logoSquadra;}
  
  public String getImmagineSquadra() {return this.immagineSquadra;}
  public void setImmagineSquadra(String immagineSquadra) {this.immagineSquadra = immagineSquadra;}
  
  public String getNomeSponsor() {return this.nomeSponsor;}
  public void setNomeSponsor(String nomeSponsor) {this.nomeSponsor = nomeSponsor;} 
    
  public String getLogoSponsor() {return this.logoSponsor;}
  public void setLogoSponsor(String logoSponsor) {this.logoSponsor = logoSponsor;} 
  
  public String getSede() {return this.sede;}
  public void setSede(String sede) {this.sede = sede;} 
    
  public String getDescrizione() {return this.descrizione;}
  public void setDescrizione(String descrizione) {this.descrizione = descrizione;} 
  
  public String getFlag() {return this.flag;}
  public void setFlag(String flag) {this.flag = flag;} 
  
  public Squadra getSquadra() {return this.squadra;}
  public void setSquadra(Squadra squadra) {this.squadra = squadra;}
}