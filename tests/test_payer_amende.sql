\echo ********** PAYER AMENDE **********
\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg

SELECT * FROM amende WHERE id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg) AND etat_amende = 'IMPAYEE' ;
UPDATE 
	amende 
SET 
	etat_amende = 'PAYEE'
WHERE 
	(id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg)) AND etat_amende = 'IMPAYEE' ;