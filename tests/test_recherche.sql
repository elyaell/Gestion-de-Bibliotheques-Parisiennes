\echo ********** RECHERCHE **********

\prompt 'Entrez le titre d\'un livre ou le nom d\'un auteur \n (FORMAT \'titre\' OU \'Nom, Prenom\') : ' recherche

SELECT nom_bibliotheque, exemplaire.id_exemplaire as numero_exemplaire, titre, auteur,
	CASE WHEN id_reservation IS NOT NULL THEN 'RESERVE'
		 WHEN id_emprunt IS NULL THEN 'DISPONIBLE'
		 WHEN etat_retour IS NULL THEN 'EMPRUNTE'
		 WHEN etat_retour = 'RAS' THEN 'DISPONIBLE'
		 ELSE 'PERDU ou DEGRADE' END AS statut
FROM 
	 (((exemplaire 
LEFT JOIN 
	emprunt 
ON 
	emprunt.id_document = exemplaire.id_document
AND 
	emprunt.id_bibliotheque = exemplaire.id_bibliotheque
AND 
	emprunt.id_exemplaire = exemplaire.id_exemplaire)
LEFT JOIN
	bibliotheque
ON 
	exemplaire.id_bibliotheque = bibliotheque.id_bibliotheque)
LEFT JOIN
	document
ON
	document.id_document = exemplaire.id_document)
LEFT JOIN
	reservation
ON
	reservation.id_document = exemplaire.id_document
AND 
	reservation.id_bibliotheque = exemplaire.id_bibliotheque
AND 
	reservation.id_exemplaire = exemplaire.id_exemplaire
WHERE 
	titre LIKE '%'||:recherche||'%' 
OR 
	auteur LIKE '%'||:recherche||'%' ;
