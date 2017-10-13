package blogics;

import java.sql.*;

public class Registrato extends Utente {
  
  /* Property */
  public String indirizzo;
  public String telefono;
  public int Admin;

  /* Costruttore con passaggio esplicito dei parametri */
  public Registrato (int SSN, String nome, String cognome, String email, String password, String type,
                     String indirizzo, String telefono, int Admin) {
    
    super(SSN, nome, cognome, email, password, type);
    this.Admin = Admin;
    this.telefono = telefono;
    this.indirizzo = indirizzo;
  }
  
  /* Costruttore con passaggio del ResultSet */
  public Registrato (ResultSet resultSet) {
    
    super(resultSet);
    try {Admin = resultSet.getInt("Id_Amministratore");} catch (SQLException sqle) {}
    try {telefono = resultSet.getString("Telefono");} catch (SQLException sqle) {}
    try {indirizzo = resultSet.getString("Indirizzo");} catch (SQLException sqle) {}
  }
}