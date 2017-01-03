\echo ********** TEST LIMITE EMPRUNT DOCUMENT PAR BIBLIOTHEQUE *************

INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 1, 4, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 1, 4, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 15, 4, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 13, 4, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 17, 4, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 15, 4, 10);

INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 16, 5, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 17, 5, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 16, 5, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 4, 5, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (4, 12, 5, 10);
INSERT INTO emprunt (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 12, 5, 10);