package services.sessionservice;

import blogics.Utente;
import java.util.*;
import javax.servlet.http.*;

import services.databaseservice.*;
import services.databaseservice.exception.*;

import blogics.*;

public class Session
{
  /* Costruttore privato */
  private Session () {}
  
  public static Cookie[] createCookie (DataBase database, String email) 
  throws NotFoundDBException,ResultSetDBException {
    
    /* Definisco cosa salvare nei cookie */
    Cookie[] cookies;
    cookies = new Cookie[4];
    Cookie cookie;
    
    Utente user = UtenteService.getUser(database, email);
    
    cookie = new Cookie("SSN","" + user.SSN);
    cookies[0] = cookie;
    
    cookie = new Cookie("userName", user.nome + "#" + user.cognome);
    cookies[1] = cookie;
    
    cookie = new Cookie("type", user.type);
    cookies[2] = cookie;
    
    cookie = new Cookie("email", user.email);
    cookies[3] = cookie;
    
    /* Il cookie vale per tutta l'applicazione */
    for (int i = 0; i < cookies.length; i++) 
      cookies[i].setPath("/");
    
    return cookies;
  }
  
  public static String getValue (Cookie cookies[], String name, int position) {
    
    int i;
    boolean found = false;
    String value = null;
    
    for (i = 0; i < cookies.length && !found; i++)
      if (cookies[i].getName().equals(name)) {
        Vector oV = util.Conversion.tokenizeString(cookies[i].getValue(), "#");
        value = (String)oV.elementAt(position);
        found = true;
      }
    
    return value;
  }
  
  public static String getSSN (Cookie[] cookies) {
    return getValue(cookies, "SSN", 0);
  }
  
  public static String getUserNome (Cookie[] cookies) {
    return getValue(cookies, "userName", 0);
  }
  
  public static String getUserCognome (Cookie[] cookies) {
    return getValue(cookies, "userName", 1);
  }
  
  public static String getType (Cookie[] cookies) {
    return getValue(cookies, "type", 0);
  }
  
  public static String getUserEmail (Cookie[] cookies) {
    return getValue(cookies, "email", 0);
  }
  
  public static Cookie[] deleteCookie (Cookie[] cookies) {
    
    for (int i = 0; i < cookies.length; i++) {
      cookies[i].setMaxAge(0);
      cookies[i].setPath("/");
    }
    
    return cookies;
  }  
  
  public static void showCookies (Cookie[] cookies){
    
    util.Debug.println("Cookie presenti:" + cookies.length);
    int i;
    for (i = 0; i < cookies.length; i++)
      util.Debug.println("Nome:" + cookies[i].getName() + " Valore:" + cookies[i].getValue());
  }
}