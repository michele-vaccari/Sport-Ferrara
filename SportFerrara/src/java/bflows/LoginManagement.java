/* Conversazione LoginManagement */

package bflows;

import java.beans.*;
import javax.servlet.http.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;
import services.errorservice.*;
import services.sessionservice.*;
import blogics.*;

public class LoginManagement implements java.io.Serializable {
  
  /* Property */
  private String errorMessage;
  private int result;
  private String email;
  private String password;
  private int SSN;
  private Cookie[] cookies;
  
  /* Costruttore */
  public LoginManagement() {}
  
  /* login.jsp status = logon */
  public void logon() {
    
    DataBase database = null;
    
    try {
      /* Apro la connessione al database */
      database = DBService.getDataBase();
      
      Utente user = UtenteService.getUser(database,email);
      
      if (user == null || !user.password.equals(password)) {
        
        cookies = null;
        setResult(EService.RECOVERABLE_ERROR);
        setErrorMessage("Email e password errati!");
      }
      else {         
        cookies = Session.createCookie(database,user.email);
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
  
  /* login.jsp status = logout */
  public void logout() {
    cookies = Session.deleteCookie(cookies);                
  }
  
  /* Metodi getter e setter */
  public String getErrorMessage() {return errorMessage;}
  public void setErrorMessage(String errorMessage) {this.errorMessage = errorMessage;}
 
  public int getResult() {return this.result;}
  public void setResult(int result) {this.result = result;}
  
  public String getEmail() {return this.email;}
  public void setEmail(String email) {this.email = email;}
  
  public String getPassword() {return this.password;}
  public void setPassword(String password) {this.password = password;}
  
  public int getSSN() {return this.SSN;}
  public void setSSN(int SSN) {this.SSN = SSN;}
     
  public Cookie getCookies(int index) {return this.cookies[index];}
  public Cookie[] getCookies() {return this.cookies;}
  public void setCookies(int index, Cookie cookies) {this.cookies[index] = cookies;}
  public void setCookies(Cookie[] cookies) {this.cookies = cookies;}
}