\echo ********** REINSCRIPTION **********
\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg
\prompt E'Dans quelle type d\'iscription désirez-vous vous réinscrire ? (Tapez : GRATUITE, CD ou CD/DVD) ' type_ins

UPDATE 
	usager 
SET 
	date_inscription = (SELECT f_getCurrentDate()),
	type_inscription = :type_ins
WHERE 
	(id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg) ) ;