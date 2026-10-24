# Corrigé Complet - TD2 Révision Bases de Données

## Exercice 1 : Questions de cours

### A. Vrai ou Faux

**a)** Une clé étrangère peut prendre la valeur NULL.

Réponse : **Vrai**. Une clé étrangère peut être NULL sauf si la contrainte NOT NULL est définie.

**b)** Toute relation en 3NF est nécessairement en BCNF.

Réponse : **Faux**. La BCNF est plus stricte que la 3NF.

**c)** COUNT(*) et COUNT(colonne) retournent toujours le même résultat.

Réponse : **Faux**. COUNT(colonne) ignore les valeurs NULL.

**d)** Une vue stocke physiquement une copie des données.

Réponse : **Faux**. Une vue stocke seulement la requête.

### B. Questions courtes

#### 1. Définir un SGBD
Un SGBD est un Système de Gestion de Base de Données.

Fonctions :
- Stockage des données.
- Sécurité et gestion des accès.
- Gestion des transactions.
- Sauvegarde et restauration.

#### 2. Différence entre clé candidate, primaire et étrangère
- Clé candidate : identifie un tuple de manière unique.
- Clé primaire : clé candidate choisie.
- Clé étrangère : référence la clé primaire d'une autre table.

#### 3. DELETE, TRUNCATE et DROP
- DELETE : supprime des lignes.
- TRUNCATE : vide la table.
- DROP TABLE : supprime la table.

#### 4. WHERE vs HAVING
- WHERE filtre les lignes.
- HAVING filtre les groupes.

Exemple :
```sql
SELECT ville, COUNT(*)
FROM ADHERENT
GROUP BY ville
HAVING COUNT(*) > 5;
```

---

# Exercice 2 : Modélisation

## Q1. Modèle E/A

Entités :

### CATEGORIE
- codeCategorie (Id)
- libelle

### OUVRAGE
- ISBN (Id)
- titre
- anneeEdition
- nbPages

### AUTEUR
- idAuteur (Id)
- nom
- nationalite

### EXEMPLAIRE
- ISBN
- numEx
- etat

### ADHERENT
- numAdh (Id)
- nom
- prenom
- email
- dateInscription

### EMPRUNT
- dateEmprunt
- dateRetourPrevue
- dateRetourEffective

Cardinalités :
- CATEGORIE (1,N) OUVRAGE
- OUVRAGE (1,N) EXEMPLAIRE
- OUVRAGE (1,N) AUTEUR
- ADHERENT (0,N) EMPRUNT
- EXEMPLAIRE (0,N) EMPRUNT

## Q2. Schéma relationnel

```text
CATEGORIE(
 codeCategorie,
 libelle
)

OUVRAGE(
 ISBN,
 titre,
 anneeEdition,
 nbPages,
 #codeCategorie
)

AUTEUR(
 idAuteur,
 nom,
 nationalite
)

ECRIRE(
 #ISBN,
 #idAuteur
)

EXEMPLAIRE(
 #ISBN,
 numEx,
 etat
)

ADHERENT(
 numAdh,
 nom,
 prenom,
 email,
 dateInscription
)

EMPRUNT(
 #numAdh,
 #ISBN,
 #numEx,
 dateEmprunt,
 dateRetourPrevue,
 dateRetourEffective
)
```

Clé EMPRUNT :
(numAdh, ISBN, numEx, dateEmprunt)

---

# Exercice 3 : Algèbre relationnelle

## Q1
```text
π titre (σ libelle='Informatique' (OUVRAGE ⨝ CATEGORIE))
```

## Q2
```text
π nom,prenom ((ADHERENT ⨝ EMPRUNT ⨝ OUVRAGE)
WHERE anneeEdition > 2020)
```

## Q3
```text
π numAdh(ADHERENT)
-
π numAdh(EMPRUNT)
```

## Q4
Division relationnelle.

```text
π numAdh(EMPRUNT ÷ OUVRAGES_INFORMATIQUE)
```

---

# Exercice 4 : SQL LDD et LMD

## Q1
```sql
CREATE TABLE OUVRAGE(
 ISBN VARCHAR(20) PRIMARY KEY,
 titre VARCHAR(200) NOT NULL,
 anneeEdition INT,
 nbPages INT NOT NULL CHECK(nbPages>0),
 codeCategorie INT NOT NULL,
 FOREIGN KEY(codeCategorie)
 REFERENCES CATEGORIE(codeCategorie)
);

CREATE TABLE EMPRUNT(
 numAdh INT,
 isbn VARCHAR(20),
 numEx INT,
 dateEmprunt DATE NOT NULL,
 dateRetourPrevue DATE NOT NULL,
 dateRetourEffective DATE,
 PRIMARY KEY(numAdh,isbn,numEx,dateEmprunt),
 FOREIGN KEY(numAdh)
 REFERENCES ADHERENT(numAdh)
 ON DELETE CASCADE,
 CHECK(dateRetourPrevue>=dateEmprunt)
);
```

## Q2
```sql
ALTER TABLE EXEMPLAIRE
ADD prixAchat DECIMAL(10,2);
```

## Q3
```sql
INSERT INTO ADHERENT
VALUES(
120,
'Amine',
'Ben Salah',
'amine.bensalah@mail.tn',
CURRENT_DATE
);
```

## Q4
```sql
UPDATE EMPRUNT
SET dateRetourEffective=CURRENT_DATE
WHERE isbn='9782100545261'
AND numEx=2
AND numAdh=12
AND dateRetourEffective IS NULL;
```

## Q5
```sql
DELETE FROM ADHERENT
WHERE dateInscription < '2015-01-01'
AND numAdh NOT IN
(SELECT DISTINCT numAdh FROM EMPRUNT);
```

---

# Exercice 5 : SQL Interrogation

## Q1
```sql
SELECT titre, anneeEdition
FROM OUVRAGE
WHERE anneeEdition > 2018
ORDER BY anneeEdition DESC;
```

## Q2
```sql
SELECT c.libelle,
COUNT(o.ISBN)
FROM CATEGORIE c
LEFT JOIN OUVRAGE o
ON c.codeCategorie=o.codeCategorie
GROUP BY c.libelle;
```

## Q3
```sql
SELECT a.nom,a.prenom,
COUNT(*) nb_emprunts
FROM ADHERENT a
JOIN EMPRUNT e
ON a.numAdh=e.numAdh
GROUP BY a.numAdh,a.nom,a.prenom
HAVING COUNT(*)>=5;
```

## Q4
```sql
SELECT titre
FROM OUVRAGE
WHERE ISBN NOT IN
(SELECT isbn FROM EMPRUNT);
```

## Q5
```sql
SELECT a.nom,a.prenom,
       o.titre,
       e.dateRetourPrevue
FROM ADHERENT a
JOIN EMPRUNT e ON a.numAdh=e.numAdh
JOIN OUVRAGE o ON o.ISBN=e.isbn
WHERE e.dateRetourEffective IS NULL
AND e.dateRetourPrevue<CURRENT_DATE;
```

## Q6
```sql
SELECT o.titre
FROM OUVRAGE o
JOIN EMPRUNT e
ON o.ISBN=e.isbn
GROUP BY o.titre
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROW ONLY;
```

## Q7
```sql
CREATE VIEW V_RETARDS AS
SELECT a.nom,a.prenom,o.titre,e.dateRetourPrevue
FROM ADHERENT a
JOIN EMPRUNT e ON a.numAdh=e.numAdh
JOIN OUVRAGE o ON o.ISBN=e.isbn
WHERE e.dateRetourEffective IS NULL
AND e.dateRetourPrevue<CURRENT_DATE;
```

Intérêt : simplification des requêtes, sécurité et réutilisation.

---

# Exercice 6 : Normalisation

## Partie A

### Q1
Clé candidate :

```text
(numCommande, codeProduit)
```

### Q2
La relation est en 1NF mais pas en 2NF.

Anomalie : modifier le nom d'un client nécessite plusieurs mises à jour.

### Q3
Décomposition 3NF

```text
COMMANDE(numCommande, dateCommande, codeClient)

CLIENT(codeClient, nomClient, villeClient)

PRODUIT(codeProduit, designation, prixUnitaire)

LIGNE_COMMANDE(
 numCommande,
 codeProduit,
 quantite
)
```

## Partie B

### Q4 Fermetures

A+ = {A,B}

(AC)+ = {A,B,C,D,E}

(AE)+ = {A,B,C,D,E}

### Q5 Clés candidates

```text
AC
AE
```

### Q6
2NF : Oui.

3NF : Non.

Car D → E et E → C représentent des dépendances transitives.

---

# Exercice 7 : Ingénierie des Bases de Données

## Q1 ACID

- Atomicité : tout ou rien.
- Cohérence : respect des contraintes.
- Isolation : transactions indépendantes.
- Durabilité : données conservées après validation.

## Q2 Transaction

```sql
BEGIN TRANSACTION;

UPDATE COMPTE
SET solde=solde-200
WHERE numCompte=101;

UPDATE COMPTE
SET solde=solde+200
WHERE numCompte=202;

COMMIT;
```

En cas de panne : ROLLBACK.

Propriété concernée : Atomicité.

## Q3 Index

R1 : Oui
```sql
CREATE INDEX idx_ouvrage_titre
ON OUVRAGE(titre);
```

R2 : Non.

R3 : Non.

Inconvénient : ralentit INSERT, UPDATE et DELETE et consomme de l'espace disque.

## Q4 Trigger

```sql
CREATE TRIGGER trg_no_delete_adherent
BEFORE DELETE ON ADHERENT
FOR EACH ROW
BEGIN
 IF EXISTS(
    SELECT 1
    FROM EMPRUNT
    WHERE numAdh=:OLD.numAdh
    AND dateRetourEffective IS NULL
 ) THEN
    RAISE_APPLICATION_ERROR(
    -20001,
    'Suppression interdite : emprunt non rendu');
 END IF;
END;
/
```
