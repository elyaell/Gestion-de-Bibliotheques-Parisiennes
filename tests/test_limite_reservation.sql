\echo ********** TEST LIMITE RESERVATION DOCUMENTS *************

INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 1, 4, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 1, 4, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 15, 4, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (5, 13, 4, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 17, 4, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 15, 4, 9);

INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (1, 16, 5, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 17, 5, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (2, 16, 5, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 4, 5, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (4, 12, 5, 9);
INSERT INTO reservation (id_exemplaire, id_document, id_bibliotheque, id_usager) VALUES (3, 12, 5, 9);