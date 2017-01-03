\echo '********** AVANCER D\'UN MOIS **********'
UPDATE date_courante SET date_today = date_today + interval '1 month' ;
