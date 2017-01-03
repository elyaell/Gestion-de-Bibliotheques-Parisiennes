\echo 'Statistiques d\'emprunts en cours pour chaque bibliotheque'
SELECT t1.*, t2.nb_exemplaire, ((t1.nb_emprunt * 100) / t2.nb_exemplaire) as pourcent
    FROM (SELECT nom_bibliotheque, count(id_emprunt) as nb_emprunt
		FROM emprunt NATURAL JOIN bibliotheque WHERE bibliotheque.id_bibliotheque = emprunt.id_bibliotheque AND etat_retour IS NULL
		GROUP BY nom_bibliotheque) AS t1 
    LEFT JOIN (SELECT nom_bibliotheque, count(id_exemplaire) as nb_exemplaire
		FROM exemplaire NATURAL JOIN bibliotheque WHERE bibliotheque.id_bibliotheque = exemplaire.id_bibliotheque 
		GROUP BY nom_bibliotheque ) AS t2 ON t1.nom_bibliotheque = t2.nom_bibliotheque ;