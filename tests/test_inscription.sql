\echo ********** INSCRIPTION **********
\prompt 'Entrez votre nom : ' nom_usg
\prompt 'Entrez votre prenom : ' prenom_usg
\prompt 'Entrez votre date de naissance (FORMAT \'AAAA-MM-JJ\') : ' date_naiss
\prompt 'Quelle type d\'iscription desirez-vous avoir ? (Tapez : \'GRATUITE\', \'CD\' ou \'CD/DVD\') ' type_ins 


INSERT INTO 
	usager (nom_usager,prenom_usager,date_naissance,date_inscription,type_inscription) 
VALUES 
	(:nom_usg, :prenom_usg, :date_naiss, (SELECT f_getCurrentDate()), :type_ins);
