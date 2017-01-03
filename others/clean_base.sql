\echo ********** CLEAN UP **********

DELETE FROM emprunt WHERE etat_retour IS NOT NULL AND date_emprunt < f_getCurrentDate() - interval '2 month' ;