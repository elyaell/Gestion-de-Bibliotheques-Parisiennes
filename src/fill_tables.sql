INSERT INTO bibliotheque (nom_bibliotheque,adresse_biliotheque) VALUES
(E'Bibliothèque Publique d\'Information', 'Centre Pompidou, 1 Rue Beaubourg, 75004 Paris'),
('Bibliothèque nationale de France', 'Quai François Mauriac, 75013 Paris'),
(E'Bibliothèque des sciences et de l\'industrie', '75019 Paris'),
('Bibliothèque des Grands Moulins', '59, quai Panhard et Levassor, 75013 Paris'),
('Bibliothèque interuniversitaire de Santé', E'12 Rue de l\'École de Médecine, 75006 Paris'),
('Bibliothèque Parmentier', '20 Avenue Parmentier, 75011 Paris'),
('Bibliothèque Couronnes','66 Rue des Couronnes, 75020 Paris'),
('Bibliothèque Germaine Tillion', '6 Rue du Commandant Schloesing, 75016 Paris'),
('Bibliothèque Sainte-Geneviève', '10 Place du Panthéon, 75005 Paris'),
('Bibliothèque François Villon', '81 Boulevard de la Villette, 75010 Paris');

INSERT INTO usager (nom_usager,prenom_usager,date_naissance,date_inscription,type_inscription) VALUES 
('Cardenas','Stewart','1989-01-29','2016-02-05','CD'),
('Haley','Ross','1965-02-26','2015-02-23','GRATUITE'),
('Mejia','Hiram','2005-01-09','2015-01-27','CD'),
('Shepard','Nevada','1988-10-20','2016-01-22','GRATUITE'),
('Contreras','Hilda','1950-01-19','2016-03-22','CD/DVD'),
('Britt','Harlan','1980-01-16','2016-02-11','CD'),
('Bailey','Nelle','1981-03-09','2015-06-29','GRATUITE'),
('Boyd','Zeph','1993-02-08','2016-01-10','CD/DVD'),
('Pearson','Lev','1999-01-21','2016-04-01','CD/DVD'),
('Walters','Jin','1993-08-17','2015-03-09','GRATUITE');

INSERT INTO date_courante (date_today) VALUES ('2016-04-15') ;

INSERT INTO document (titre, langue, auteur, editeur, annee, ISBN, type, format_document, prix_public)
	 VALUES ('Arretez la musique !', 'FR', 'Grenier, Christian', 'Rageot', 1999, '2-7002-2582-1', 'JEUNESSE', 'LIVRE', 6.99) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Enquete chez Tante Agathe', 'FR', 'Didier, Anne', 'Bayard presse', 2005, 'JEUNESSE', 'LIVRE', 5.90) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, ISBN, type, format_document, prix_public)
	 VALUES ('Pride and Prejudice', 'EN', 'Austen, Jane', 'London', 1989, '978-0-14-180445-3', 'ADULTE', 'LIVRE', 19.00) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, ISBN, type, format_document, prix_public)
	 VALUES ('Jane Eyre', 'EN', 'Bronte, Charlotte', 'Norton & company', 1971, '978-0-393-97542-0', 'ADULTE', 'LIVRE', 7.90) ;	
INSERT INTO document (titre, langue, auteur, editeur, annee, ISBN, type, format_document, prix_public)
	 VALUES ('Harry Potter et la coupe de feu', 'FR', 'Rowling, Joanne Kathleen', 'Gallimard', 2000, '2-07-054358-7', 'TOUT PUBLIC', 'LIVRE', 12.88) ;	

INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Premier livre pour piano', 'FR', 'Campo, Régis', 'Henry Lemoine', 2003, 'TOUT PUBLIC', 'PARTITION', 11.00) ;	
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Les cahiers du rythme', 'FR', 'Goyone, Daniel', 'Lemoine', 2008, 'TOUT PUBLIC', 'PARTITION', 17.00) ;	

INSERT INTO document (titre, langue, editeur, annee, type, format_document, prix_public)
	 VALUES ('Mad Max', 'EN', 'Warner Home Video', 2008, 'TOUT PUBLIC', 'DVD', 17.00) ;	
INSERT INTO document (titre, langue, editeur, annee, type, format_document, prix_public)
	 VALUES ('Saint Seiya', 'JP', 'Kana Home Vidéo', 2014, 'JEUNESSE', 'DVD', 35.53) ;	
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Juno', 'FR', 'Reitman, Jason', '20th Century Fox Home', 2008, 'ADULTE', 'DVD', 20.79) ;	
INSERT INTO document (titre, langue, editeur, annee, type, format_document, prix_public)
	 VALUES ('Home', 'FR', 'Blaq out', 2009, 'TOUT PUBLIC', 'DVD', 25.11) ;	

INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Springtime in Funen', 'DK', 'Nielsen, Carl', 'Unicorn-Kanchana', 1986, 'ADULTE', 'CD', 8.50) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Zaide', 'DE', 'Mozart, Wolfgang Amadeus', 'Sony BMG', 2006, 'ADULTE', 'CD', 15.21) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('Cancionista', 'MULT', 'Placer, Antonio', 'Le Chant du Monde', 2006, 'ADULTE', 'CD', 18.42) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES (E'Fragments d\'hebetude', 'FR', 'Thiefaine, Hubert-Felix', 'Distrib. Wotre Music', 1993, 'ADULTE', 'CD', 6.99) ;

INSERT INTO document (titre, langue, auteur, editeur, annee, type, format_document, prix_public)
	 VALUES ('A moi le monde !', 'FR', 'MAMEMO', 'Distrib. BMG', 1994, 'JEUNESSE', 'CD', 14.74) ;
INSERT INTO document (titre, langue, editeur, annee, type, format_document, prix_public)
	 VALUES ('Beliebte Weihnachtslieder', 'DE', 'Distrib. Hanssler-Verlag', 1988, 'JEUNESSE', 'CD', 10.40) ;

INSERT INTO document (titre, langue, editeur, auteur, annee, type, format_document, prix_public)
	 VALUES ('La fin du Faucon Noir', 'FR', 'Dargaud', 'Charlier, Jean-Michel', 1988, 'JEUNESSE', 'BANDE DESSINÉE', 19.99) ;
INSERT INTO document (titre, langue, editeur, auteur, annee, type, format_document, prix_public)
	 VALUES ('Old man river', 'FR', 'Clair de Lune, DL', 'Corteggiani, Francois', 2006, 'JEUNESSE', 'BANDE DESSINÉE', 19.99) ;
INSERT INTO document (titre, langue, auteur, editeur, annee, ISBN, type, format_document, prix_public)
	 VALUES ('Lady Grace - Un assassin a la cour', 'FR', 'Finney, Patricia', 'Flammarion', 2005, '978-2081-62-4733', 'JEUNESSE', 'BANDE DESSINÉE', 12.00) ;


INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (1,1,4),(2,1,4),(1,2,9),(1,16,5),(1,19,3),(1,18,3),(1,14,7),(4,18,3),(2,15,10),(1,15,4);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (5,9,9),(3,17,3),(3,9,3),(5,9,4),(1,10,5),(1,7,1),(2,17,5),(2,16,5),(2,18,3),(3,6,9);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (5,7,6),(4,8,4),(3,7,6),(1,18,9),(1,10,4),(5,7,7),(3,8,8),(3,9,2),(2,18,9),(1,10,3);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (2,10,2),(3,18,3),(2,8,6),(4,6,6),(1,2,7),(1,2,6),(2,13,10),(5,13,4),(2,4,7),(4,6,3);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (3,17,4),(1,6,10),(4,5,6),(3,6,3),(2,15,4),(5,3,6),(2,2,3),(1,2,3),(4,15,3),(2,9,1);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (2,5,1),(2,19,3),(3,4,5),(5,17,9),(3,15,6),(3,19,3),(1,15,10),(3,12,10),(5,18,3),(2,15,8);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (1,20,9),(5,15,7),(1,5,1),(4,5,2),(3,8,7),(1,18,6),(4,15,6),(1,16,8),(2,18,6),(1,19,1);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (2,10,5),(2,2,9),(2,12,9),(1,6,7),(4,12,5),(1,8,2),(1,2,2),(1,19,10),(3,10,2),(3,12,5);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (3,2,9),(5,4,7),(4,3,8),(4,12,2),(3,18,9),(1,11,3),(3,11,5),(2,7,1),(1,5,7),(1,15,8);
INSERT INTO exemplaire (id_exemplaire,id_document,id_bibliotheque) VALUES (1,11,10),(5,3,2),(2,13,6),(2,3,6),(1,18,5),(3,3,2),(3,15,10),(2,2,2),(5,9,3),(1,19,9);

INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (4, 5, 6, 2);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 15, 7, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 4, 7, 4);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 8, 6, 6);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 8, 6, 6);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 8, 6, 6);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 8, 6, 6);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 15, 7, 8);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 1, 4, 8);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 1, 4, 8);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 7, 6, 8);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 3, 2, 8);

INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (4, 5, 6, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 15, 7, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 3, 2, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 11, 3, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 3, 2, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 8, 2, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 15, 10, 5);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (4, 15, 6, 5);

