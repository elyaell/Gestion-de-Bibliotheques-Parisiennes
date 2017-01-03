

/*                 FIN INSCRIPTION                    */


DROP FUNCTION f_fin_inscription() CASCADE ;

CREATE OR REPLACE FUNCTION f_fin_inscription() RETURNS trigger AS $$
DECLARE
	date_fin DATE ;
BEGIN
	date_fin = NEW.date_inscription +  interval '1 year' ;
	NEW.fin_inscription = date_fin ;
	RAISE NOTICE 'Votre inscription prend fin le %, merci de nous avoir rejoint !', date_fin ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_insert_fin_inscription
BEFORE INSERT ON usager
FOR EACH ROW 
	EXECUTE PROCEDURE f_fin_inscription() ;

CREATE TRIGGER t_update_fin_inscription
BEFORE UPDATE OF date_inscription ON usager
FOR EACH ROW 
	EXECUTE PROCEDURE f_fin_inscription() ;


/* 				  FONCTIONS UTILES 									*/

CREATE OR REPLACE FUNCTION f_getUsager(id_user int) RETURNS RECORD AS $$
DECLARE
	utilisateur RECORD ;
BEGIN
	SELECT * INTO utilisateur FROM usager WHERE id_usager = id_user ;
	RETURN utilisateur ;
END ;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION f_getDocument(id_doc int) RETURNS RECORD AS $$
DECLARE
	doc RECORD ;
BEGIN
	SELECT * INTO doc FROM document WHERE id_document = id_doc ;
	RETURN doc ;
END ;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION f_getCurrentDate() RETURNS date AS $$
DECLARE
	current RECORD ;
BEGIN
	SELECT * INTO current FROM date_courante LIMIT 1 ;
	RETURN current.date_today ;
END ;
$$ LANGUAGE plpgsql ;

/* 				  ALERTES AUTOMATIQUES LIEES À LA DATE 				*/

DROP FUNCTION f_update_date() CASCADE ;

CREATE OR REPLACE FUNCTION f_alerte_retours(nouvelle date) RETURNS void AS $$
DECLARE
	retours RECORD ;
	document RECORD ;
	utilisateur RECORD ;
	nb_jours int ;
BEGIN
	FOR retours IN 
		SELECT * FROM emprunt WHERE etat_retour IS NULL AND date_retour < nouvelle + interval '2 days'
	LOOP 
		utilisateur = f_getUsager(retours.id_usager)  ;
		document = f_getDocument(retours.id_document) ;
		IF (retours.date_retour < nouvelle) THEN
			nb_jours = nouvelle - retours.date_retour ;
			RAISE NOTICE E'Le document %, emprunté par %, % est en retard de % jours.', 
				document.titre, utilisateur.nom_usager, utilisateur.prenom_usager, nb_jours ;
		ELSIF (retours.date_retour < nouvelle + interval '2 days') THEN
			RAISE NOTICE E'Le document %, emprunté par %, % doit être rendu d\'ici deux jours (% renouvellement(s) effectué(s)).', 
				document.titre, utilisateur.nom_usager, utilisateur.prenom_usager, retours.nombre_renouvellement  ;
		END IF; 
	END LOOP ;
END ;
$$ LANGUAGE plpgsql ;


CREATE OR REPLACE FUNCTION f_alerte_inscription(nouvelle date) RETURNS void AS $$
DECLARE
	utilisateurs RECORD ;
BEGIN
	FOR utilisateurs IN 
		SELECT * FROM usager
	LOOP 
		IF (nouvelle + interval '11 days' < utilisateurs.fin_inscription) THEN
			RAISE NOTICE E'L\'inscription de %, % (compte n°%) arrive à expiration.', utilisateurs.nom_usager, utilisateurs.prenom_usager, utilisateurs.id_usager ;
		ELSIF (nouvelle > utilisateurs.fin_inscription) THEN
			RAISE NOTICE E'L\'inscription de %, % (compte n°%) est expirée.', utilisateurs.nom_usager, utilisateurs.prenom_usager, utilisateurs.id_usager ;
		END IF ;
	END LOOP ;
END ;
$$ LANGUAGE plpgsql ;


CREATE OR REPLACE FUNCTION f_amende(ancienne date, nouvelle date) RETURNS void AS $$
DECLARE
	retards RECORD ;
	current DATE ;
	utilisateur RECORD ;
	amendes RECORD ;
	new_amende decimal ;
	nb_jours int ;
BEGIN 
	nb_jours = nouvelle - ancienne ;
	FOR retards IN 
		SELECT * FROM emprunt WHERE etat_retour IS NULL AND date_retour < ancienne 
	LOOP
		utilisateur = f_getUsager(retards.id_usager) ;
		SELECT * INTO amendes FROM amende WHERE id_usager = utilisateur.id_usager AND etat_amende = 'IMPAYEE';
		IF NOT FOUND THEN
			INSERT INTO amende (id_usager,total_amende,etat_amende) VALUES (utilisateur.id_usager, 0.15, 'IMPAYEE') ;
		ELSE
			new_amende = amendes.total_amende + (nb_jours * 0.15) ;
			UPDATE amende SET total_amende = new_amende WHERE id_amende = amendes.id_amende ;
			IF (new_amende = 15) THEN
				RAISE NOTICE E'L\'amende de %, % a atteint 15 euros, vous ne pouvez plus emprunter ni réserver un livre jusqu\'au payement de cette dernière',
					utilisateur.nom_usager, utilisateur.prenom_usager ;
			ELSIF (new_amende > 15) THEN
				RAISE NOTICE E'L\'amende de %, % est supérieure à 15 euros (% euros), veuillez la régler au plus vite.',
					utilisateur.nom_usager, utilisateur.prenom_usager, new_amende ;
			END IF;	
		END IF ;
	END LOOP ;
END ;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION f_update_date() RETURNS TRIGGER AS $$ 
BEGIN
	EXECUTE f_alerte_inscription(NEW.date_today) ;
	EXECUTE f_alerte_retours(NEW.date_today) ;
	EXECUTE f_amende(OLD.date_today, NEW.date_today) ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_update_date
BEFORE UPDATE ON date_courante
FOR EACH ROW 
	EXECUTE PROCEDURE f_update_date() ;


/*                EMPRUNT DOCUMENT                    */


DROP FUNCTION f_emprunt() CASCADE ;

		/* Vérification de l'âge de l'utilisateur */

CREATE OR REPLACE FUNCTION f_verification_age(id_user int, type_doc varchar) RETURNS boolean AS $$
DECLARE
	utilisateur RECORD ;
	current DATE ;
BEGIN
	current = f_getCurrentDate() ;
	SELECT * INTO utilisateur FROM usager WHERE id_usager = id_user ;
	IF NOT FOUND THEN
		RAISE NOTICE E'Le compte n°% n\'existe pas', id_usager ;
		RETURN FALSE ;
	ELSIF (current - utilisateur.date_naissance < 18) THEN
		IF(type_doc = 'ADULTE') THEN
			RAISE NOTICE E'L\'usager % % est trop jeune pour cet ouvrage', 
				utilisateur.nom_usager, utilisateur.prenom_usager ;
			RETURN FALSE ;
		END IF ;
	END IF ;
	RETURN TRUE ;
END ;
$$ LANGUAGE plpgsql ;

		/* Vérification existence utilisateur */

CREATE OR REPLACE FUNCTION f_verification_utilisateur(id_user int) RETURNS boolean AS $$
DECLARE
	utilisateur RECORD ;
BEGIN 
	SELECT * INTO utilisateur FROM usager WHERE id_usager = id_user ;
	IF NOT FOUND THEN
		RAISE NOTICE E'Le compte n°% n\'existe pas', id_usager ;
		RETURN FALSE ;
	ELSE
		RAISE NOTICE E'Merci d\'utiliser nos services, Mr/Mme % %', utilisateur.nom_usager, utilisateur.prenom_usager ;
		RETURN TRUE ;
	END IF;
END ;
$$ LANGUAGE plpgsql ;

		/* Verification de l'expiration de l'inscription */

CREATE OR REPLACE FUNCTION f_verification_expiration(id_user int) RETURNS boolean AS $$
DECLARE
	utilisateur RECORD ;
	current DATE ;
BEGIN
	SELECT * INTO utilisateur FROM usager WHERE id_usager = id_user ;
	current = f_getCurrentDate() ;
	IF (utilisateur.fin_inscription < current) THEN
		RAISE NOTICE E'Votre inscription est expirée, veuillez la renouveller pour pouvoir profiter à nouveau de nos services' ;
		RETURN FALSE ;
	ELSE 
		RETURN TRUE ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;

		/* Vérification du type de l'inscription */

CREATE OR REPLACE FUNCTION f_verification_inscription(id_user int, format_doc varchar) RETURNS boolean AS $$
DECLARE
	utilisateur RECORD ;
BEGIN 
	SELECT * INTO utilisateur FROM usager WHERE id_usager = id_user ;
	IF (utilisateur.type_inscription = 'GRATUITE') THEN
		IF (format_doc = 'CD' OR format_doc = 'DVD') THEN
			RAISE NOTICE E'Votre inscription % ne vous permet pas d\'emprunter ou de réserver ce document', utilisateur.type_inscription ;
			RETURN FALSE ;
		END IF ;
	ELSIF (utilisateur.type_inscription = 'CD') THEN
		IF (format_doc = 'DVD') THEN
			RAISE NOTICE E'Votre inscription % ne vous permet pas d\'emprunter ou de réserver ce document', utilisateur.type_inscription ;
			RETURN FALSE ;
		END IF ;
	END IF ;
	RETURN TRUE ;
END ;
$$ LANGUAGE plpgsql ;

		/*Vérification de l'existence d'une amende impayée */

CREATE OR REPLACE FUNCTION f_verification_amende(id_user INT) RETURNS boolean AS $$
DECLARE
	amendes RECORD ;
BEGIN
	SELECT * INTO amendes FROM amende WHERE (id_usager = id_user AND etat_amende = 'IMPAYEE' AND total_amende >= 15) ;
	IF NOT FOUND THEN
		RETURN TRUE ;
	ELSE 
		RAISE NOTICE E'Vous avez actuellement une amende de %€ impayée, veuillez la régler avant d\'emprunter ou de réserver', 
			amendes.total_amende ;
		RETURN FALSE ;
	END IF ;
	RETURN FALSE ;
END ;
$$ LANGUAGE plpgsql ;

		/** Vérification du respect de la limite des emprunts **/

CREATE OR REPLACE FUNCTION f_verification_emprunts(id_user INT, id_bibli INT, format VARCHAR) RETURNS boolean AS $$
DECLARE
	emprunts RECORD ;
BEGIN	
	IF(format = 'DVD') THEN
		SELECT count(*) AS total INTO emprunts FROM emprunt 
			WHERE (id_usager = id_user AND etat_retour IS NULL AND id_document IN (SELECT id_document FROM document WHERE format_document = 'DVD')) ;
		IF(emprunts.total = 5) THEN
			RAISE NOTICE E'Vous avez atteint la limite d\'emprunt autorisée pour ce type de document (%)', format ;
			RETURN FALSE ;
		END IF ;
	ELSE 
		SELECT count(*) AS total INTO emprunts FROM emprunt WHERE (id_usager = id_user AND etat_retour IS NULL) ;
		IF(emprunts.total = 20) THEN 
			RAISE NOTICE E'Vous avez atteint la limite d\'emprunts autorisée' ;
			RETURN FALSE ;
		ELSE 
			SELECT count(*) AS total INTO emprunts FROM emprunt 
			WHERE (id_usager = id_user AND etat_retour IS NULL AND id_bibliotheque = id_bibli AND id_document NOT IN (SELECT id_document FROM document WHERE format_document = 'DVD')) ;
			IF(emprunts.total = 10) THEN
				RAISE NOTICE E'Vous avez atteint la limite d\'emprunt autorisée pour cette bibliothèque' ;
				RETURN FALSE ;
			END IF ;
		END IF ;
	END IF ;
	RETURN TRUE ;
END ;
$$ LANGUAGE plpgsql ;


		/* Vérification existence */
CREATE OR REPLACE FUNCTION f_verification_existence(id_ex int, id_doc int, id_bibli int) RETURNS boolean AS $$
DECLARE 
	verification RECORD ;
BEGIN
	SELECT * INTO verification FROM exemplaire WHERE id_exemplaire = id_ex AND id_document = id_doc AND id_bibliotheque = id_bibli ;
	IF NOT FOUND THEN
		RAISE NOTICE E'Cet exemplaire n\'existe pas dans cette bibliothèque' ;
		RETURN FALSE ;
	ELSE 
		RETURN TRUE ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;

		/* Vérification disponibilité */
CREATE OR REPLACE FUNCTION f_verification_disponibilite_emprunt(id_ex int, id_doc int, id_bibli int) RETURNS boolean AS $$
DECLARE 
	verification RECORD ;
BEGIN
	SELECT * INTO verification FROM emprunt WHERE id_exemplaire = id_ex AND id_document = id_doc AND id_bibliotheque = id_bibli AND etat_retour IS NULL ;
	IF NOT FOUND THEN
		RETURN TRUE ;
	ELSE
		RAISE NOTICE E'Cet exemplaire n\'est actuellement pas disponible à l\'emprunt, réservez le ou choisissez en un autre.' ;
		RETURN FALSE ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;		

CREATE OR REPLACE FUNCTION f_verification_disponibilite_reservation (id_ex int, id_doc int, id_bibli int) RETURNS boolean AS $$
DECLARE 
	verification RECORD ;
BEGIN
	SELECT * INTO verification FROM reservation WHERE id_exemplaire = id_ex AND id_document = id_doc AND id_bibliotheque = id_bibli ;
	IF NOT FOUND THEN
		RETURN TRUE ;
	ELSE
		RAISE NOTICE E'Cet exemplaire est actuellement réservé pour un autre utilisateur, choisissez en un autre.' ;
		RETURN FALSE ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;


		/*Tests pour les emprunts */

CREATE OR REPLACE FUNCTION f_emprunt() RETURNS trigger AS $$
DECLARE
	doc RECORD ;
	current DATE ;
	date_retour DATE ;
	date_emprunt DATE ;
BEGIN
	doc = f_getDocument(NEW.id_document) ;
	current = f_getCurrentDate() ;
	IF (f_verification_utilisateur(NEW.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_amende(NEW.id_usager) = FALSE) THEN 
		RETURN NULL ;
	ELSIF (f_verification_expiration(NEW.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_age(NEW.id_usager, doc.type) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_inscription(NEW.id_usager, doc.format_document) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_existence(NEW.id_exemplaire, NEW.id_document, NEW.id_bibliotheque) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_disponibilite_emprunt(NEW.id_exemplaire, NEW.id_document, NEW.id_bibliotheque) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_disponibilite_reservation(NEW.id_exemplaire, NEW.id_document, NEW.id_bibliotheque) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_emprunts(NEW.id_usager, NEW.id_bibliotheque, doc.format_document) = FALSE) THEN
		RETURN NULL ;
	END IF ;
	date_emprunt = current ;
	date_retour = current + interval '3 weeks' ;
	NEW.date_emprunt = date_emprunt ;
	NEW.date_retour = date_retour ;
	RAISE NOTICE E'Votre document est à rendre le %, n\'oubliez pas !', date_retour ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_emprunt
BEFORE INSERT ON emprunt
FOR EACH ROW 
	EXECUTE PROCEDURE f_emprunt() ;


/*             RENOUVELLEMENT EMPRUNT                 */

DROP FUNCTION f_emprunt_renouvellement() CASCADE ;

CREATE OR REPLACE FUNCTION f_emprunt_retard(emprunt_id int) RETURNS boolean AS $$
DECLARE 
	retard RECORD ;
	current DATE ;
BEGIN
	current = f_getCurrentDate() ;
	SELECT * INTO retard FROM emprunt WHERE id_emprunt = emprunt_id AND date_retour < current  ;
	IF NOT FOUND THEN
		RETURN TRUE ;
	ELSE 
		RETURN FALSE ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;



CREATE OR REPLACE FUNCTION f_emprunt_renouvellement() RETURNS trigger AS $$
DECLARE 
	current DATE ;
BEGIN
	current = f_getCurrentDate() ;
	IF(OLD.nombre_renouvellement = 2) THEN
		RAISE NOTICE 'Vous ne pouvez plus renouveller cet emprunt.' ;
		RETURN NULL ;
	ELSIF (f_emprunt_retard(OLD.id_emprunt) = FALSE) THEN
		RAISE NOTICE 'Vous ne pouvez pas renouveller cet emprunt : rendez les précédents.' ;
		RETURN NULL ;
	ELSIF (f_verification_amende(OLD.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_disponibilite_reservation(OLD.id_exemplaire, OLD.id_document, OLD.id_bibliotheque) = FALSE) THEN
		RAISE NOTICE 'Vous ne pouvez pas renouveller cet emprunt : document réservé.' ;
		RETURN NULL ;
	ELSE			 
		NEW.date_retour = current + interval '3 weeks' ;
		NEW.nombre_renouvellement = OLD.nombre_renouvellement + 1 ;
		RAISE NOTICE 'Votre nouvelle date de rendu est le %', NEW.date_retour ;
		RETURN NEW ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_emprunt_renouvellement
BEFORE UPDATE of nombre_renouvellement ON emprunt 
FOR EACH ROW 
	EXECUTE PROCEDURE f_emprunt_renouvellement() ;


/* Document rendu perdu/dégradé */

DROP FUNCTION f_verification_etat_retour() CASCADE ;

CREATE OR REPLACE FUNCTION f_verification_etat_retour() RETURNS trigger AS $$
DECLARE
	etats RECORD ;
	amendes RECORD ;
	doc RECORD ;
	utilisateur RECORD ;
BEGIN 
	utilisateur = f_getUsager(OLD.id_usager) ;
	SELECT * INTO etats FROM emprunt WHERE id_emprunt = NEW.id_emprunt ;
	IF NOT FOUND THEN
		RAISE NOTICE 'Cet emprunt ne figure pas dans notre historique' ;
		RETURN NULL ;
	ELSIF (NEW.etat_retour <> 'RAS' ) THEN
		RAISE NOTICE E'L\'amende de %, % a été augmentée du prix public du document endommagé/perdu',
			utilisateur.nom_usager, utilisateur.prenom_usager ;
		SELECT * INTO doc FROM document WHERE id_document = OLD.id_document ;
		SELECT * INTO amendes FROM amende WHERE id_usager = OLD.id_usager AND etat_amende = 'IMPAYEE';
		IF NOT FOUND THEN
			INSERT INTO amende (id_usager,total_amende,etat_amende) VALUES (OLD.id_usager, doc.prix_public, 'IMPAYEE') ;
		ELSE
			UPDATE amende SET total_amende = amende.total_amende + doc.prix_public WHERE id_amende = amende.id_amende ;
		END IF;
	END IF ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_verification_etat_retour
BEFORE UPDATE ON emprunt 
FOR EACH ROW 
	EXECUTE PROCEDURE f_verification_etat_retour() ;

/* Vérificaton nombre limite de reservation */
CREATE OR REPLACE FUNCTION f_verification_nb_reservation(id_user int) RETURNS boolean AS $$
DECLARE
	res RECORD ;
	nb_res INT ;
BEGIN 
	SELECT * INTO res FROM reservation WHERE id_usager = id_user ;
	IF NOT FOUND THEN
		RETURN TRUE ;
	ELSE 
		SELECT COUNT(*) INTO nb_res FROM reservation WHERE id_usager = id_user;
		IF (nb_res = 5) THEN
			RAISE NOTICE 'Vous avez atteint le nombre maximum de réservations !' ;
			RETURN FALSE ;
		ELSE RETURN TRUE ;
		END IF ;
	END IF ;
	RETURN TRUE ;
END ;
$$ LANGUAGE plpgsql ;

/* Vérificaton disponibilités tous les exemplaires */
CREATE OR REPLACE FUNCTION f_verification_dispo_exemplaire(id_ex int, id_doc int, id_bibli int) RETURNS boolean AS $$
DECLARE 
	verification RECORD ;
	exemplaires RECORD ;
	nb_emp INT ;
	nb_exe INT ; 
BEGIN
	SELECT * INTO verification FROM emprunt WHERE id_exemplaire = id_ex AND id_document = id_doc AND id_bibliotheque = id_bibli AND etat_retour IS NULL ;
	IF NOT FOUND THEN
		RAISE NOTICE E'Cet exemplaire est disponible à l\'emprunt sans réservation !' ;
		RETURN FALSE;
	ELSE
		SELECT count(*) INTO nb_emp FROM emprunt WHERE id_document = id_doc AND id_bibliotheque = id_bibli AND etat_retour IS NULL ;
		SELECT count(*) INTO nb_exe FROM exemplaire WHERE id_document = id_doc AND id_bibliotheque = id_bibli ;
		IF (nb_emp = nb_exe) THEN
			RETURN TRUE ;
		ELSE
			RAISE NOTICE E'Il existe d\'autres exemplaires de ce document que vous pouvez emprunter sans réservation !';
			RETURN FALSE;
		END IF ;
	END IF ;
END ;
$$ LANGUAGE plpgsql ;

/* Reservation */

CREATE OR REPLACE FUNCTION f_reservation() RETURNS trigger AS $$
DECLARE
	doc RECORD ;
BEGIN
	SELECT * INTO doc FROM document WHERE id_document = NEW.id_document ;
	IF (f_verification_utilisateur(NEW.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_amende(NEW.id_usager) = FALSE) THEN 
		RETURN NULL ;
	ELSIF (f_verification_expiration(NEW.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_age(NEW.id_usager, doc.type) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_inscription(NEW.id_usager, doc.format_document) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_existence(NEW.id_exemplaire, NEW.id_document, NEW.id_bibliotheque) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_nb_reservation(NEW.id_usager) = FALSE) THEN
		RETURN NULL ;
	ELSIF (f_verification_dispo_exemplaire(NEW.id_exemplaire, NEW.id_document, NEW.id_bibliotheque) = FALSE) THEN
		RETURN NULL ;
	END IF ;
	RAISE NOTICE 'Reservation effectuée !' ;	
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_reservation
BEFORE INSERT ON reservation
FOR EACH ROW 
	EXECUTE PROCEDURE f_reservation() ;


CREATE OR REPLACE FUNCTION f_archive_inscription() RETURNS trigger AS $$
DECLARE
	user RECORD ;
BEGIN 
	CASE
		WHEN TG_OP = 'INSERT' THEN
			INSERT INTO archive (id_usager,date_archive,type_action) VALUES (NEW.id_usager, NEW.date_inscription, 'INSCRIPTION') ;
		WHEN TG_OP = 'UPDATE' THEN	
			INSERT INTO archive (id_usager,date_archive,type_action) VALUES (NEW.id_usager, NEW.date_inscription, 'REINSCRIPTION') ;
	END CASE ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_archive_inscription
AFTER INSERT OR UPDATE ON usager 
FOR EACH ROW 
	EXECUTE PROCEDURE f_archive_inscription() ;


CREATE OR REPLACE FUNCTION f_archive_emprunt() RETURNS trigger AS $$
DECLARE
	emprunts RECORD ;
BEGIN 
	CASE
		WHEN TG_OP = 'INSERT' THEN
			INSERT INTO archive (id_usager,id_bibliotheque,date_archive,type_action) VALUES (NEW.id_usager,NEW.id_bibliotheque, NEW.date_emprunt, 'EMPRUNT') ;
		WHEN TG_OP = 'UPDATE' THEN
			IF (new.etat_retour = 'RAS') THEN
				INSERT INTO archive (id_usager,id_bibliotheque,date_archive,type_action) VALUES (NEW.id_usager,NEW.id_bibliotheque, NEW.date_emprunt, 'RETOUR') ;
			ELSIF (new.etat_retour = 'PERDU' OR new.etat_retour = 'DÉGRADÉ') THEN
				INSERT INTO archive (id_usager,id_bibliotheque,date_archive,type_action) VALUES (NEW.id_usager,NEW.id_bibliotheque, NEW.date_emprunt, 'PERTE/DEGRADATION') ;
			END IF ;
	END CASE ;
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_archive_emprunt
AFTER INSERT OR UPDATE ON emprunt 
FOR EACH ROW 
	EXECUTE PROCEDURE f_archive_emprunt() ;

CREATE OR REPLACE FUNCTION f_alerte_resa() RETURNS trigger AS $$
DECLARE
	retours RECORD ;
	utilisateur RECORD ;
BEGIN
	SELECT * INTO retours FROM reservation 
		WHERE id_exemplaire = OLD.id_exemplaire AND id_document = OLD.id_document AND id_bibliotheque = OLD.id_bibliotheque LIMIT 1 ; 
	IF NOT FOUND THEN
		RETURN OLD ;
	END IF ;
	utilisateur = f_getUsager(retours.id_usager) ;
	IF (NEW.etat_retour = 'DÉGRADÉ' OR NEW.etat_retour = 'PERDU') THEN 
	RAISE NOTICE E'A l\'attention de Mr/Mme %, % -> L\'exemplaire % du document % a été perdu ou dégradé par un autre utilisateur et ne peut plus etre emprunté, veuillez choisir un autre exemplaire du document', 
			utilisateur.nom_usager, utilisateur.prenom_usager, NEW.id_exemplaire, NEW.id_document;
		DELETE FROM reservation WHERE id_reservation = retours.id_reservation;
	ELSE
		RAISE NOTICE E'A l\'attention de Mr/Mme %, % -> L\'exemplaire % du document % a été rendu.', 
			utilisateur.nom_usager, utilisateur.prenom_usager, NEW.id_exemplaire, NEW.id_document;
		DELETE FROM reservation WHERE id_reservation = retours.id_reservation;
	END IF;  
	RETURN NEW ;
END ;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER t_alerte_resa
AFTER UPDATE OF etat_retour ON emprunt 
FOR EACH ROW 
	EXECUTE PROCEDURE f_alerte_resa() ;
