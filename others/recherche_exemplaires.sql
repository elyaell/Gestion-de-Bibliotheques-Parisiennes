DROP FUNCTION f_rechercheExemplaires(integer) ;

	/* Nombre d'exemplaires par document par bibliotheque */
CREATE OR REPLACE FUNCTION f_rechercheExemplaires(id_biblio integer) RETURNS TABLE(Titre varchar, Auteur varchar, Format varchar, Nombre_exemplaire bigint) AS $$
BEGIN
	RETURN QUERY SELECT document.titre, document.auteur, document.format_document, count(id_exemplaire) FROM exemplaire NATURAL JOIN document 
		WHERE document.id_document = exemplaire.id_document AND id_bibliotheque = id_biblio GROUP BY (id_bibliotheque, id_document, document.titre, document.auteur, format_document);
END ;
$$ LANGUAGE plpgsql ;


\echo 'Liste des bibliothèques '
SELECT * FROM bibliotheque ;
\prompt 'Rechercher tous les documents de quelle bibliothèque : ' id_biblio
SELECT * FROM f_rechercheExemplaires(:id_biblio) ;



