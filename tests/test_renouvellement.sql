\echo ********** RENOUVELLEMENT **********

\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg

SELECT * FROM emprunt WHERE id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg) ;
 
\prompt 'Entrez le numero de l\'emprunt que vous voulez renouveler : ' num_emp

UPDATE 
	emprunt
SET 
	nombre_renouvellement = nombre_renouvellement + 1
WHERE 
	id_emprunt = :num_emp
AND 
	id_usager = (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg) AND etat_retour IS NULL ;

