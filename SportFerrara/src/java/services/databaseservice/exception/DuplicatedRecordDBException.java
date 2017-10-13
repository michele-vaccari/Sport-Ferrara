package services.databaseservice.exception;

import services.errorservice.*;

public class DuplicatedRecordDBException extends DBException implements Warning {
  
  /** Creates new NotFoundDBException */
  public DuplicatedRecordDBException (String msg) {
    super("Warning: " + msg);
    this.logMessage="Warning\n" + msg + "\n";
  }
  
  /** Ritorna il messaggio di Errore corrispondente al Warning **/
  public String getLogMessage () {
    return logMessage;
  }
}