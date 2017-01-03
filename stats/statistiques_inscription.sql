\echo 'Statistiques d\'inscriptions pour chaque type d\'abonnements'
SELECT t1.*, ((t1.inscrits * 100) / t2.total) as pourcent
    FROM (SELECT DISTINCT type_inscription, count(*) AS inscrits FROM usager GROUP BY type_inscription ) AS t1 
    CROSS JOIN (SELECT DISTINCT count(*) as total FROM usager) AS t2  ;
