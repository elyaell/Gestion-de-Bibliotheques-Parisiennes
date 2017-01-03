\echo ********** RESERVATION **********

\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg

SELECT * FROM bibliotheque ;

\prompt 'Tapez le numero de la bibliotheque ou vous voulez reserver un document -> ' num_bibli

SELECT 
	id_document AS id_doc, 
	id_exemplaire AS id_ex, 
	titre, 
	langue, 
	auteur, 
	editeur, 
	type, 
	format_document AS format
FROM 
	exemplaire NATURAL JOIN document
WHERE 
	id_bibliotheque = :num_bibli;

\prompt 'Tapez le numero du document que vous voulez reserver -> ' num_doc
\prompt 'Tapez le numero de l\'exemplaire que vous voulez reserver -> ' num_exe

INSERT INTO 
	reservation (date_reservation, id_exemplaire, id_document, id_bibliotheque, id_usager) 
VALUES 
	((SELECT f_getCurrentDate()), 
	 :num_exe, 
	 :num_doc, 
	 :num_bibli, 
	 (SELECT 
	 	id_usager 
	 FROM 
	 	usager 
	 WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg));

