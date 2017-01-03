\echo ********** RETOUR **********

\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg

SELECT * FROM emprunt where id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg) AND etat_retour IS NULL ;

\prompt 'Entrez le numero de l\'emprunt concerné -> ' num_emprunt
\prompt 'Quel est l\'etat du document -> ' etat

UPDATE 
	emprunt
SET 
	etat_retour = :etat
WHERE 
	id_emprunt = :num_emprunt
AND 
	id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg) AND etat_retour IS NULL ;
