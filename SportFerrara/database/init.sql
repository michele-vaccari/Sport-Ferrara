CREATE TABLE IF NOT EXISTS utente (
	ID_Utente INT UNSIGNED NOT NULL,
	Email VARCHAR(30) NOT NULL,
	Password VARCHAR(16) NOT NULL,
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	Tipo VARCHAR(1) NOT NULL,
	Attivo VARCHAR(1) NOT NULL DEFAULT 'Y',
	PRIMARY KEY (ID_Utente)
);

CREATE TABLE IF NOT EXISTS amministratore (
	ID_Utente INT UNSIGNED NOT NULL,
	PRIMARY KEY (ID_Utente),
	FOREIGN KEY (ID_Utente) REFERENCES utente(ID_Utente)
);

CREATE TABLE IF NOT EXISTS registrato (
	ID_Utente INT UNSIGNED NOT NULL,
	ID_Amministratore INT UNSIGNED NOT NULL,
	Telefono VARCHAR(15) NOT NULL,
	Indirizzo VARCHAR(50) NOT NULL,
	PRIMARY KEY (ID_Utente),
	FOREIGN KEY (ID_Utente) REFERENCES utente(ID_Utente),
	FOREIGN KEY (ID_Amministratore) REFERENCES amministratore(ID_Utente)
);

CREATE TABLE IF NOT EXISTS arbitro (
	ID_Registrato INT UNSIGNED NOT NULL,
	Data_di_nascita VARCHAR(10) NOT NULL,
	Nazionalita VARCHAR(20) NOT NULL,
	Foto VARCHAR(50) NOT NULL,
	Carriera TEXT(5000),
	PRIMARY KEY (ID_Registrato),
	FOREIGN KEY (ID_Registrato) REFERENCES registrato(ID_Utente)
);

CREATE TABLE IF NOT EXISTS gestore_squadra (
	ID_Registrato INT UNSIGNED NOT NULL,
	PRIMARY KEY (ID_Registrato),
	FOREIGN KEY (ID_Registrato) REFERENCES registrato(ID_Utente)
);

CREATE TABLE IF NOT EXISTS torneo (
	ID_Torneo INT UNSIGNED NOT NULL,
	ID_Amministratore INT UNSIGNED NOT NULL,
	Tipologia CHAR(1) NOT NULL,
	Nome VARCHAR(30) NOT NULL,
	Descrizione TEXT(5000),
	PRIMARY KEY (ID_Torneo),
	FOREIGN KEY (ID_Amministratore) REFERENCES amministratore(ID_Utente)
);

CREATE TABLE IF NOT EXISTS partita (
	ID_Partita INT UNSIGNED NOT NULL,
	Tipo CHAR(1) NOT NULL,
	Luogo VARCHAR(30) NOT NULL,
	Data_partita VARCHAR(30) NOT NULL,
	Ora VARCHAR(5) NOT NULL,
	PRIMARY KEY (ID_Partita)
);

CREATE TABLE IF NOT EXISTS referto (
	ID_Referto INT UNSIGNED NOT NULL,
	ID_Partita INT UNSIGNED NOT NULL,
	ID_Arbitro INT UNSIGNED NOT NULL,
	Ora_inizio VARCHAR(5),
	Ora_fine VARCHAR(5),
	Risultato VARCHAR(10),
	Compilato VARCHAR(1) NOT NULL,
	PRIMARY KEY (ID_Referto),
	FOREIGN KEY (ID_Partita) REFERENCES partita(ID_Partita),
	FOREIGN KEY (ID_Arbitro) REFERENCES arbitro(ID_Registrato)
);

CREATE TABLE IF NOT EXISTS squadra (
	ID_Squadra INT UNSIGNED NOT NULL,
	ID_Gestore INT UNSIGNED NOT NULL,
	Compilata VARCHAR(1) NOT NULL,
	Nome_squadra VARCHAR(30) NOT NULL,
	Descrizione TEXT(5000),
	Sede VARCHAR(30),
	Logo_squadra VARCHAR(50),
	Immagine_squadra VARCHAR(50),
	Nome_sponsor VARCHAR(30),
	Logo_sponsor VARCHAR(50),
	PRIMARY KEY (ID_Squadra),
	FOREIGN KEY (ID_Gestore) REFERENCES gestore_squadra(ID_Registrato)
);

CREATE TABLE IF NOT EXISTS classifica (
	ID_Torneo INT UNSIGNED NOT NULL,
	ID_Squadra INT UNSIGNED NOT NULL,
	Punti INT UNSIGNED DEFAULT 0,
	Vittorie INT UNSIGNED DEFAULT 0,
	Sconfitte INT UNSIGNED DEFAULT 0,
	Pareggi INT UNSIGNED DEFAULT 0,
	Partite INT UNSIGNED DEFAULT 0,
	Goal_fatti INT UNSIGNED DEFAULT 0,
	Goal_subiti INT UNSIGNED DEFAULT 0,
	PRIMARY KEY (ID_Torneo, ID_Squadra),
	FOREIGN KEY (ID_Torneo) REFERENCES torneo(ID_Torneo),
	FOREIGN KEY (ID_Squadra) REFERENCES squadra(ID_Squadra)
);

CREATE TABLE IF NOT EXISTS giocatore (
	ID_Giocatore INT UNSIGNED NOT NULL,
	ID_Squadra INT UNSIGNED NOT NULL,
	Attivo VARCHAR(1) DEFAULT 'Y',
	Numero_maglia INT UNSIGNED,
	Ruolo VARCHAR(50) NOT NULL,
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	Data_nascita VARCHAR(10) NOT NULL,
	Nazionalita VARCHAR(20) NOT NULL,
	Foto VARCHAR(50) NOT NULL,
	Descrizione TEXT(5000),
	Goal INT UNSIGNED DEFAULT 0,
	Ammonizioni INT UNSIGNED DEFAULT 0,
	Espulsioni INT UNSIGNED DEFAULT 0,
	PRIMARY KEY (ID_Giocatore),
	FOREIGN KEY (ID_Squadra) REFERENCES squadra(ID_Squadra)
);

CREATE TABLE IF NOT EXISTS marcatore (
	ID_Referto INT UNSIGNED NOT NULL,
	ID_Giocatore INT UNSIGNED NOT NULL,
	Goal INT UNSIGNED DEFAULT 0,
	PRIMARY KEY (ID_Referto, ID_Giocatore),
	FOREIGN KEY (ID_Referto) REFERENCES referto(ID_Referto),
	FOREIGN KEY (ID_Giocatore) REFERENCES giocatore(ID_Giocatore)
);

CREATE TABLE IF NOT EXISTS partecipano (
	ID_Squadra INT UNSIGNED NOT NULL,
	ID_Torneo INT UNSIGNED NOT NULL,
	PRIMARY KEY (ID_Squadra, ID_Torneo),
	FOREIGN KEY (ID_Squadra) REFERENCES squadra(ID_Squadra),
	FOREIGN KEY (ID_Torneo) REFERENCES torneo(ID_Torneo)
);

CREATE TABLE IF NOT EXISTS cartellino (
	ID_Referto INT UNSIGNED NOT NULL,
	ID_Giocatore INT UNSIGNED NOT NULL,
	Numero INT UNSIGNED DEFAULT 0,
	Ammonizione VARCHAR(1),
	Espulsione VARCHAR(1),
	PRIMARY KEY (ID_Referto, ID_Giocatore),
	FOREIGN KEY (ID_Referto) REFERENCES referto(ID_Referto),
	FOREIGN KEY (ID_Giocatore) REFERENCES giocatore(ID_Giocatore)
);

CREATE TABLE IF NOT EXISTS scelto (
	ID_Partita INT UNSIGNED NOT NULL,
	ID_Arbitro INT UNSIGNED NOT NULL,
	ID_Amministratore INT UNSIGNED NOT NULL,
	PRIMARY KEY (ID_Partita, ID_Arbitro, ID_Amministratore),
	FOREIGN KEY (ID_Partita) REFERENCES partita(ID_Partita),
	FOREIGN KEY (ID_Arbitro) REFERENCES arbitro(ID_Registrato),
	FOREIGN KEY (ID_Amministratore) REFERENCES amministratore(ID_Utente)
);

CREATE TABLE IF NOT EXISTS formazione (
	ID_Referto INT UNSIGNED NOT NULL,
	ID_Squadra INT UNSIGNED NOT NULL,
	ID_Giocatore INT UNSIGNED NOT NULL,
	Riserva VARCHAR(1) NOT NULL,
	PRIMARY KEY (ID_Referto, ID_Squadra, ID_Giocatore),
	FOREIGN KEY (ID_Referto) REFERENCES referto(ID_Referto),
	FOREIGN KEY (ID_Squadra) REFERENCES squadra(ID_Squadra),
	FOREIGN KEY (ID_Giocatore) REFERENCES giocatore(ID_Giocatore)
);

CREATE TABLE IF NOT EXISTS giocano (
	ID_Partita INT UNSIGNED NOT NULL,
	ID_SquadraA INT UNSIGNED NOT NULL,
	ID_SquadraB INT UNSIGNED NOT NULL,
	ID_Torneo INT UNSIGNED NOT NULL,
	Nome_partita VARCHAR(30) NOT NULL,
	PRIMARY KEY (ID_Partita, ID_SquadraA, ID_SquadraB, ID_Torneo),
	FOREIGN KEY (ID_Partita) REFERENCES partita(ID_Partita),
	FOREIGN KEY (ID_SquadraA) REFERENCES squadra(ID_Squadra),
	FOREIGN KEY (ID_SquadraB) REFERENCES squadra(ID_Squadra),
	FOREIGN KEY (ID_Torneo) REFERENCES torneo(ID_Torneo)
);