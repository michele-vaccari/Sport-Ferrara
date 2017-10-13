package blogics;

import java.sql.*;

import util.*;
import services.databaseservice.*;
import services.databaseservice.exception.*;

public class Utente {
  
  /* Property */
  public int SSN;
  public String nome;
  public String cognome;
  public String email;
  public String password;
  public String type;
  public String flag;
  
  /* Costruttore con passaggio esplicito dei parametri */
  public Utente (int SSN, String nome, String cognome, String email, String password, String type) {
    
    this.SSN = SSN;
    this.nome = nome;
    this.cognome = cognome;
    this.email = email; 
    this.password = password;
    this.type = type;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Utente (ResultSet resultSet) {
    try {SSN = resultSet.getInt("Id_Utente");} catch (SQLException sqle) {}
    try {nome = resultSet.getString("Nome");} catch (SQLException sqle) {}
    try {cognome = resultSet.getString("Cognome");} catch (SQLException sqle) {}
    try {email = resultSet.getString("Email");} catch (SQLException sqle) {}
    try {password = resultSet.getString("Password");} catch (SQLException sqle) {}
    try {type = resultSet.getString("Tipo");} catch (SQLException sqle) {}
    try {flag = resultSet.getString("Attivo");} catch (SQLException sqle) {}
  }
  
  /* Cancellazione logica dell'utente */
  /* DOCUMENTAZIONE BASI DI DATI */
  public void delete (DataBase database)
  throws NotFoundDBException, ResultSetDBException {
    
    String sql;

    sql = " UPDATE utente " +
          " SET Attivo= 'N' " +
          " WHERE " +
          " Email='" + Conversion.getDatabaseString(email) + "' ";

    database.modify(sql);
  }
}