\echo 'Statistiques d\'inscriptions sur le dernier mois'
 SELECT t1.*, t2.*, ((t1.inscrits_sur_le_dernier_mois * 100) / t2.inscrits_total) as pourcent
    FROM (SELECT count(*) AS inscrits_sur_le_dernier_mois FROM usager WHERE date_inscription > f_getCurrentDate() - interval '30 days') AS t1 
    CROSS JOIN (SELECT DISTINCT count(*) as inscrits_total FROM usager) AS t2  ;