\echo 'Statistiques d\'emprunts sur le dernier mois pour chaque bibliotheque'
SELECT t1.*, t2.nb_emprunt as emprunts_total, ((t1.nb_emprunt_sur_un_mois * 100) / t2.nb_emprunt) as pourcent
    FROM (SELECT nom_bibliotheque, count(id_emprunt) as nb_emprunt_sur_un_mois
		FROM emprunt NATURAL JOIN bibliotheque WHERE bibliotheque.id_bibliotheque = emprunt.id_bibliotheque 
			AND date_emprunt < f_getCurrentDate() 
			AND date_emprunt > f_getCurrentDate() - interval '29 days'
		GROUP BY nom_bibliotheque) AS t1 
    LEFT JOIN (SELECT nom_bibliotheque, count(id_emprunt) as nb_emprunt
		FROM emprunt NATURAL JOIN bibliotheque WHERE bibliotheque.id_bibliotheque = emprunt.id_bibliotheque 
		GROUP BY nom_bibliotheque) AS t2 ON t1.nom_bibliotheque = t2.nom_bibliotheque ;