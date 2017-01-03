\echo ********** HISTORIQUE **********

\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prénom : ' prenom_usg

SELECT 
	*
FROM 
	archive 
WHERE 
	id_usager IN (SELECT id_usager FROM usager WHERE nom_usager = :nom_usg AND prenom_usager = :prenom_usg) ORDER BY date_archive DESC LIMIT 10 ;