# TD1 Révision SQL - Corrigé Complet

## Contexte

Une bibliothèque universitaire souhaite informatiser la gestion de ses ouvrages, de ses membres et des emprunts.

### Schéma relationnel
```text
AUTEUR(id_auteur, nom_auteur, prenom_auteur, nationalite)

CATEGORIE(id_categorie, libelle_categorie)

LIVRE(id_livre, titre, annee_publication, id_auteur, id_categorie)

MEMBRE(id_membre, nom, prenom, email, date_inscription, ville)

EMPRUNT(id_emprunt, id_membre, id_livre, date_emprunt, date_retour_prevue, date_retour_reelle)

```

---

# Exercice 1.1

## Question 1
Créer la table CATEGORIE.

```sql
CREATE TABLE CATEGORIE (
    id_categorie INT PRIMARY KEY,
    libelle_categorie VARCHAR(50) NOT NULL UNIQUE
);
```

## Question 2
Créer la table AUTEUR.

```sql
CREATE TABLE AUTEUR (
    id_auteur INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom_auteur VARCHAR(60) NOT NULL,
    prenom_auteur VARCHAR(60) NOT NULL,
    nationalite VARCHAR(50) DEFAULT 'Tunisienne'
);
```

## Question 3
Créer la table LIVRE.

```sql
CREATE TABLE LIVRE (
    id_livre INT PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    annee_publication INT CHECK (annee_publication >= 1800),
    id_auteur INT,
    id_categorie INT,
    FOREIGN KEY (id_auteur) REFERENCES AUTEUR(id_auteur),
    FOREIGN KEY (id_categorie) REFERENCES CATEGORIE(id_categorie)
);
```

# Exercice 1.2

## Question 4
```sql
INSERT INTO CATEGORIE VALUES (1,'Informatique');
INSERT INTO CATEGORIE VALUES (2,'Sciences');
INSERT INTO CATEGORIE VALUES (3,'Littérature');
```

## Question 5
```sql
INSERT INTO AUTEUR (nom_auteur,prenom_auteur,nationalite) VALUES ('Martin','Robert','Française');
INSERT INTO AUTEUR (nom_auteur,prenom_auteur,nationalite) VALUES ('Ben Salah','Amine','Tunisienne');
INSERT INTO AUTEUR (nom_auteur,prenom_auteur,nationalite) VALUES ('Smith','John','Américaine');
INSERT INTO AUTEUR (nom_auteur,prenom_auteur,nationalite) VALUES ('Ali','Mohamed','Égyptienne');
```

## Question 6
```sql
INSERT INTO LIVRE VALUES (1,'Introduction SQL',2020,1,1);
INSERT INTO LIVRE VALUES (2,'Bases de Données Avancées',2018,2,1);
INSERT INTO LIVRE VALUES (3,'Physique Moderne',2015,3,2);
INSERT INTO LIVRE VALUES (4,'La Révolution Scientifique',2010,4,2);
INSERT INTO LIVRE VALUES (5,'Les Misérables',1862,1,3);
```

# Exercice 2.1

## Question 7
```sql
SELECT * FROM LIVRE ORDER BY titre ASC;
```

## Question 8
```sql
SELECT titre, annee_publication
FROM LIVRE
WHERE annee_publication > 2000
ORDER BY annee_publication DESC;
```

## Question 9
```sql
SELECT nom, prenom
FROM MEMBRE
WHERE ville IN ('Tunis','Sfax');
```

## Question 10
```sql
SELECT titre
FROM LIVRE
WHERE id_categorie=1
AND annee_publication BETWEEN 2010 AND 2023;
```

## Question 11
```sql
SELECT nom, prenom
FROM MEMBRE
WHERE email LIKE '%@iteam.com%';
```

## Question 12
```sql
SELECT *
FROM LIVRE
WHERE titre LIKE 'Les%'
OR titre LIKE 'La%';
```

# Fonctions d'agrégation

## Question 13
```sql
SELECT COUNT(*) AS nombre_livres FROM LIVRE;
```

## Question 14
```sql
SELECT MIN(annee_publication) AS plus_ancienne,
MAX(annee_publication) AS plus_recente
FROM LIVRE;
```

## Question 15
```sql
SELECT ville, COUNT(*) AS nombre_membres
FROM MEMBRE
GROUP BY ville;
```

## Question 16
```sql
SELECT id_categorie, COUNT(*) AS nombre_livres
FROM LIVRE
GROUP BY id_categorie;
```

## Question 17
```sql
SELECT id_categorie, COUNT(*)
FROM LIVRE
GROUP BY id_categorie
HAVING COUNT(*) > 2;
```

## Question 18
```sql
SELECT id_auteur, COUNT(*) AS nombre_livres
FROM LIVRE
GROUP BY id_auteur
ORDER BY nombre_livres DESC;
```

# Requêtes avancées

## Question 19
```sql
SELECT m.nom,m.prenom,l.titre
FROM EMPRUNT e
JOIN MEMBRE m ON e.id_membre=m.id_membre
JOIN LIVRE l ON e.id_livre=l.id_livre
WHERE e.date_retour_reelle IS NULL;
```

## Question 20
```sql
SELECT id_membre, COUNT(*) AS nombre_emprunts
FROM EMPRUNT
GROUP BY id_membre;
```

## Question 21
```sql
SELECT id_membre, COUNT(*)
FROM EMPRUNT
GROUP BY id_membre
HAVING COUNT(*) > 3;
```

## Question 22
```sql
SELECT m.ville, COUNT(*) AS total_emprunts
FROM EMPRUNT e
JOIN MEMBRE m ON e.id_membre=m.id_membre
GROUP BY m.ville
HAVING COUNT(*) >= 2;
```

# Analyse et Correction

## Question 23
```sql
SELECT id_categorie, COUNT(*)
FROM LIVRE
GROUP BY id_categorie
HAVING COUNT(*) > 2;
```

## Question 24
```sql
SELECT id_categorie, titre, COUNT(*)
FROM LIVRE
GROUP BY id_categorie, titre;
```

## Question 25
```sql
SELECT id_auteur, COUNT(*)
FROM LIVRE
WHERE id_auteur IS NOT NULL
GROUP BY id_auteur;
```

# Questions théoriques

## Différence entre WHERE et HAVING
- WHERE filtre les lignes avant GROUP BY.
- HAVING filtre les groupes après GROUP BY.

## Pourquoi insérer CATEGORIE et AUTEUR avant LIVRE ?
Parce que LIVRE possède des clés étrangères vers ces tables.

## Différence entre COUNT(*) et COUNT(date_retour_reelle)
- COUNT(*) compte toutes les lignes.
- COUNT(date_retour_reelle) compte seulement les valeurs non NULL.
