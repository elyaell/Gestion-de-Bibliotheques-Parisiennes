\set VERBOSITY terse

DROP TABLE IF EXISTS archive CASCADE;
DROP TABLE IF EXISTS amende CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS emprunt CASCADE;
DROP TABLE IF EXISTS exemplaire CASCADE;
DROP TABLE IF EXISTS document CASCADE;
DROP TABLE IF EXISTS bibliotheque CASCADE;
DROP TABLE IF EXISTS usager CASCADE;
DROP TABLE IF EXISTS date_courante CASCADE ;

CREATE TABLE IF NOT EXISTS 	date_courante (
	date_today DATE NOT NULL
) ;

CREATE TABLE IF NOT EXISTS usager (
	id_usager SERIAL PRIMARY KEY,
	nom_usager VARCHAR(100) NOT NULL,
	prenom_usager VARCHAR(100) NOT NULL,
	date_naissance DATE NOT NULL,
	date_inscription DATE NOT NULL,
	fin_inscription DATE,
	type_inscription VARCHAR(10) NOT NULL
		CHECK (type_inscription IN ('GRATUITE', 'CD', 'CD/DVD'))
); 

CREATE TABLE IF NOT EXISTS amende (
	id_amende SERIAL PRIMARY KEY,
	id_usager INT REFERENCES usager(id_usager),
	total_amende DECIMAL NOT NULL DEFAULT 0,
	etat_amende VARCHAR(10) NOT NULL
		CHECK (etat_amende IN ('IMPAYEE', 'PAYEE'))
);

CREATE TABLE IF NOT EXISTS bibliotheque (
	id_bibliotheque SERIAL PRIMARY KEY,
	nom_bibliotheque VARCHAR(100) NOT NULL,
	adresse_biliotheque VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS document (
	id_document SERIAL PRIMARY KEY,
	titre VARCHAR(100) NOT NULL,
	langue VARCHAR(4),
	auteur VARCHAR(100),
	editeur VARCHAR(100),
	annee INT,
	ISBN VARCHAR(20),
	type VARCHAR(15) NOT NULL
		CHECK (type IN ('JEUNESSE', 'ADULTE', 'TOUT PUBLIC')),
	format_document VARCHAR(15) NOT NULL
		CHECK (format_document IN ('LIVRE', 'DVD', 'CD', 'BANDE DESSINÉE', 'PARTITION')),
	prix_public DECIMAL
);

CREATE TABLE IF NOT EXISTS exemplaire (
	id_exemplaire INT NOT NULL,
	id_document INT NOT NULL,
	id_bibliotheque INT NOT NULL,
	FOREIGN KEY (id_document) REFERENCES document(id_document) ON DELETE CASCADE,
	FOREIGN KEY (id_bibliotheque) REFERENCES bibliotheque(id_bibliotheque),
	PRIMARY KEY (id_exemplaire,id_document,id_bibliotheque)
);

/* Ajouter champ manquant */
CREATE TABLE IF NOT EXISTS emprunt (
	id_emprunt SERIAL PRIMARY KEY,
	id_usager INT NOT NULL,
	id_exemplaire INT NOT NULL,
	id_document INT NOT NULL,
	id_bibliotheque INT NOT NULL,
	date_emprunt DATE,
	date_retour DATE
		CHECK (date_retour > date_emprunt),
	etat_retour VARCHAR(20)
		CHECK (etat_retour IN ('RAS', 'PERDU', 'DÉGRADÉ')),
	nombre_renouvellement INT NOT NULL DEFAULT 0
		CHECK (nombre_renouvellement <= 2),
	FOREIGN KEY (id_usager) REFERENCES usager(id_usager),
	FOREIGN KEY (id_exemplaire,id_document,id_bibliotheque) REFERENCES exemplaire(id_exemplaire,id_document,id_bibliotheque)
);

/* Ajouter champ manquant */
CREATE TABLE IF NOT EXISTS reservation (
	id_reservation SERIAL PRIMARY KEY,
	id_usager INT NOT NULL,
	id_exemplaire INT NOT NULL,
	id_document INT NOT NULL,
	id_bibliotheque INT NOT NULL,
	date_reservation DATE,
	FOREIGN KEY (id_usager) REFERENCES usager(id_usager),
	FOREIGN KEY (id_exemplaire,id_document,id_bibliotheque) REFERENCES exemplaire(id_exemplaire,id_document,id_bibliotheque)	
);

CREATE TABLE IF NOT EXISTS archive (
	id_archive SERIAL PRIMARY KEY,
	id_usager INT NOT NULL REFERENCES usager(id_usager),
	id_bibliotheque INT REFERENCES bibliotheque(id_bibliotheque),
	date_archive DATE NOT NULL,
	type_action VARCHAR(20) NOT NULL
		CHECK (type_action IN ('EMPRUNT', 'RETOUR', 'INSCRIPTION', 'REINSCRIPTION', 'PERTE/DEGRADATION'))
);