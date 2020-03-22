package global;

public class Constants {
  
  /* Constants for language codes */
  public static final String CD_LANGUAGE_ITALIAN = "ITA";
  
  /* Contants for Mail Service.
   * Choose between (YES,NO,TEST).
   */
  public static final String ENABLE_MAIL_SERVICE = "NO";
  public static final String TEST_MAIL = "null@null.com";
  public static final String[] MAIL_GATEWAYS = {"151.99.250.122"};
  
  /* Constants for Debug */
  public static final boolean DEBUG=true; 
  
  /** Constants for db connection */
  public static final String DB_SERVER_ADDRESS    = "localhost";
  public static final String DB_PORT              = "3306";
  public static final String DB_USER_NAME         = "root";
  public static final String DB_PASSWORD          = "";
  public static final String DB_CONNECTION_STRING = "jdbc:mysql://" + DB_SERVER_ADDRESS + ":" + DB_PORT + "/sportferrara?user=" + DB_USER_NAME + "&password=" + DB_PASSWORD;
  
  /* Constants for log files*/
  public final static String LOG_DIR = "D:\\logs\\";
  public final static String FRONTEND_ERROR_LOG_FILE = LOG_DIR + "frontenderror.log";
  public final static String FATAL_LOG_FILE = LOG_DIR + "fatalerror.log";
  public final static String GENERAL_LOG_FILE = LOG_DIR + "generalerror.log";  
  public final static String GENERAL_EXCEPTION_LOG_FILE = LOG_DIR + "generalexception.log";
  public final static String WARNING_LOG_FILE = LOG_DIR + "warning.log";  
  public final static String DATABASE_SERVICE_LOG_FILE = LOG_DIR + "databaseservice.log";  
  public static final String APPLICATION_MANAGER_MAIL = "null@null.com";
}