\echo '********** AVANCER D\'UNE SEMAINE **********'
UPDATE date_courante SET date_today = date_today + interval '1 week' ;
