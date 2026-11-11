# Oracle PL/SQL — Explication en français

Ce répertoire contient trois fichiers SQL illustrant PL/SQL (Procedural Language/Structured Query Language), l'extension procédurale d'Oracle à SQL :

- `s1.sql` — blocs anonymes, types de blocs, variables, constantes, types, boucles, SQL embarqué
- `TP1.sql` — procédures, fonctions, blocs anonymes, agrégats
- `tp2.sql` — `%TYPE`, `%ROWTYPE`, conditions, boucles, curseurs, procédures, fonctions, gestion d'erreurs

---

## 1. Qu'est-ce que PL/SQL ?

PL/SQL est un langage procédural intégré à Oracle Database qui permet d'écrire du code imperatif (variables, boucles, conditions, sous-programmes) autour des instructions SQL. Il s'exécute côté serveur, ce qui réduit les allers-retours entre l'application et la base de données.

## 2. Structure d'un bloc PL/SQL

Un bloc PL/SQL comporte jusqu'à trois sections :

```sql
DECLARE
   -- déclarations de variables, constantes, curseurs, exceptions
BEGIN
   -- instructions exécutables (SQL et PL/SQL)
EXCEPTION
   -- gestion des erreurs
END;
/
```

- `DECLARE` : optionnelle, définit les éléments utilisés dans le bloc.
- `BEGIN` : obligatoire, contient le corps du bloc.
- `EXCEPTION` : optionnelle, intercepte les erreurs d'exécution.
- `/` : exécute le bloc dans SQL*Plus / SQL Developer.

### Types de blocs

| Type | Stocké | Nommé | Réutilisable |
|------|--------|-------|--------------|
| Bloc anonyme | Non | Non | Non |
| Procédure | Oui | Oui | Oui |
| Fonction | Oui | Oui | Oui (retourne une valeur) |
| Package | Oui | Oui | Oui (regroupe procédures/fonctions) |
| Trigger | Oui | Oui | Oui (déclenché par un événement) |

Les blocs peuvent être imbriqués ; une variable déclarée dans un bloc interne masque celle du bloc externe du même nom.

## 3. Variables, constantes et types

### Déclaration de variable

```sql
v_nom employe.nom %TYPE;
v_salaire employe.salaire %TYPE := 2200;
v_nb PLS_INTEGER := 0;
v_message VARCHAR2(100) DEFAULT 'Bonjour';
v_actif BOOLEAN := TRUE;
```

### Intérêt de `%TYPE`

`employe.nom %TYPE` déduit automatiquement le type de la colonne `nom` de la table `employe`. Si la définition de la colonne change (par exemple `VARCHAR2(40)` devient `VARCHAR2(60)`), la variable est automatiquement adaptée sans modification du code PL/SQL. C'est plus robuste que de coder en dur `VARCHAR2(40)`.

### Constante

```sql
c_salaire_min CONSTANT NUMBER := 1000;
c_nb_mois CONSTANT NUMBER := 12;
c_taux CONSTANT NUMBER := 0.02;
c_plafond CONSTANT NUMBER := 1000;
```

Une constante ne peut pas être modifiée après son initialisation.

### `%ROWTYPE`

```sql
v_etu etudiant%ROWTYPE;
```

Déclare une variable dont la structure correspond à une ligne entière de la table. On accède aux champs avec la notation pointée : `v_etu.id`, `v_etu.nom`, `v_etu.prenom`.

### Types couramment utilisés

- `NUMBER` / `NUMBER(p, s)` : nombres entiers ou décimaux
- `PLS_INTEGER` : entiers, plus efficace pour les compteurs de boucle
- `VARCHAR2(n)` : chaînes de caractères
- `DATE` : dates et heures
- `BOOLEAN` : vrai/faux (uniquement dans PL/SQL, pas en SQL pur)

## 4. SQL embarqué dans PL/SQL

### SELECT INTO

```sql
SELECT nom, prenom, salaire
  INTO v_nom, v_prenom, v_salaire
  FROM employe
 WHERE id_employe = 1;
```

`SELECT INTO` retourne exactement une ligne. Si aucune ligne n'est retournée, l'exception `NO_DATA_FOUND` est levée. Si plusieurs lignes sont retournées, `TOO_MANY_ROWS` est levée.

### DML (INSERT, UPDATE, DELETE) et `SQL%ROWCOUNT`

```sql
UPDATE employe
   SET salaire = salaire * 1.03
 WHERE id_dept = 10;

IF SQL%ROWCOUNT = 0 THEN
   DBMS_OUTPUT.PUT_LINE('Aucun employé modifié');
ELSE
   DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' salaire(s) augmenté(s)');
END IF;
```

`SQL%ROWcount` indique le nombre de lignes affectées par la dernière instruction DML. Un `UPDATE` qui ne modifie aucune ligne ne lève **pas** `NO_DATA_FOUND` ; il suffit de tester `SQL%ROWCOUNT = 0`.

### Transactions

`COMMIT` valide les modifications, `ROLLBACK` les annule. Une procédure stockée ne doit en général pas contenir de `COMMIT` pour laisser l'appelant gérer la transaction.

## 5. Structures de contrôle

### Condition `IF / ELSIF / ELSE`

```sql
IF v_salaire IS NULL THEN
   v_cat := 'Inconnu';
ELSIF v_salaire < 2000 THEN
   v_cat := 'Junior';
ELSIF v_salaire < 3000 THEN
   v_cat := 'Confirmé';
ELSE
   v_cat := 'Senior';
END IF;
```

**Pourquoi tester `IS NULL` en premier ?** Parce qu'une comparaison avec `NULL` (par exemple `v_salaire < 2000`) renvoie toujours `NULL` (inconnu), jamais `VRAI`. Si le salaire est NULL et que l'on teste d'abord `< 2000`, la condition n'est jamais satisfaite et l'employé serait mal classé. Il faut donc traiter explicitement le cas `NULL` avant les comparaisons.

### `CASE`

```sql
v_taux := CASE v_cat
             WHEN 'Junior'    THEN 0.05
             WHEN 'Confirmé'  THEN 0.08
             WHEN 'Senior'    THEN 0.10
             ELSE 0
          END;
```

### Boucles

| Boucle | Syntaxe | Cas d'usage |
|--------|---------|-------------|
| `LOOP ... EXIT WHEN` | `LOOP ... EXIT WHEN condition; END LOOP;` | Nombre d'itérations inconnu, sortie conditionnelle |
| `WHILE ... LOOP` | `WHILE condition LOOP ... END LOOP;` | Tant qu'une condition est vraie |
| `FOR ... LOOP` | `FOR i IN 1..10 LOOP ... END LOOP;` | Itération sur une plage d'entiers (compteur implicite) |
| `FOR ... REVERSE` | `FOR i IN REVERSE 1..5 LOOP ... END LOOP;` | Compte à rebours |

Exemple de compte à rebours :

```sql
FOR k IN REVERSE 1..5 LOOP
   DBMS_OUTPUT.PUT_LINE('Départ dans ' || k);
END LOOP;
```

## 6. Curseurs

Un curseur permet de traiter ligne par ligne le résultat d'une requête.

### Curseur implicite

Utilisé automatiquement avec les boucles `FOR ... IN` :

```sql
FOR d IN c_dept LOOP
   DBMS_OUTPUT.PUT_LINE(d.nom_dept);
END LOOP;
```

Oracle ouvre, récupère et ferme le curseur implicitement.

### Curseur explicite (`OPEN / FETCH / CLOSE`)

```sql
CURSOR emp_cursor IS
   SELECT * FROM employe
   WHERE id_dept = 10
   ORDER BY salaire DESC;

emp_rec emp_cursor%ROWTYPE;

BEGIN
   OPEN emp_cursor;
   LOOP
      FETCH emp_cursor INTO emp_rec;
      EXIT WHEN emp_cursor%NOTFOUND;
      -- traitement de emp_rec
   END LOOP;
   CLOSE emp_cursor;
END;
```

- `%NOTFOUND` : TRUE lorsque la dernière récupération n'a retourné aucune ligne.
- `%ROWCOUNT` : nombre de lignes déjà récupérées.

### Curseur paramétré

```sql
CURSOR c_emp (p_dept employe.id_dept%TYPE) IS
   SELECT nom, prenom, salaire
     FROM employe
    WHERE id_dept = p_dept
    ORDER BY nom;
```

Appel :

```sql
FOR e IN c_emp(d.id_dept) LOOP
   ...
END LOOP;
```

## 7. Sous-programmes stockés

### Procédure

Une procédure effectue une action sans retourner de valeur (sauf via des paramètres `OUT`).

```sql
CREATE OR REPLACE PROCEDURE embaucher (
   p_id      IN employe.id_employe%TYPE,
   p_nom     IN employe.nom%TYPE,
   p_prenom  IN employe.prenom%TYPE,
   p_salaire IN employe.salaire%TYPE,
   p_poste   IN employe.poste%TYPE,
   p_id_dept IN employe.id_dept%TYPE
) IS
   c_salaire_min CONSTANT NUMBER := 1000;
   e_dept_absent EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_dept_absent, -2291);
BEGIN
   IF p_salaire IS NULL OR p_salaire < c_salaire_min THEN
      RAISE_APPLICATION_ERROR(-20001, 'Salaire invalide : ' || p_salaire);
   END IF;

   INSERT INTO employe (...) VALUES (..., SYSDATE, ...);

EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20002, 'Identifiant déjà utilisé : ' || p_id);
   WHEN e_dept_absent THEN
      RAISE_APPLICATION_ERROR(-20003, 'Département inexistant : ' || p_id_dept);
END embaucher;
/
```

- `IN` : valeur d'entrée (par défaut).
- `OUT` : valeur de retour.
- `IN OUT` : entrée et sortie.
- `RAISE_APPLICATION_ERROR(-20xxx, 'message')` : lève une erreur applicative personnalisée.
- `PRAGMA EXCEPTION_INIT` : associe un nom d'exception utilisateur à un code d'erreur Oracle (ici `-2291` pour violation de clé étrangère).
- `DUP_VAL_ON_INDEX` : violation de contrainte d'unicité / clé primaire.

### Fonction

Une fonction retourne une valeur et peut être appelée dans du SQL ou du PL/SQL.

```sql
CREATE OR REPLACE FUNCTION anciennete (
   p_id IN employe.id_employe%TYPE
) RETURN NUMBER IS
   v_date employe.date_embauche%TYPE;
BEGIN
   SELECT date_embauche INTO v_date
     FROM employe
    WHERE id_employe = p_id;
   RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_date) / 12);
EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN NULL;
END anciennete;
/
```

Une fonction appelée dans un `SELECT` ne doit pas contenir d'`INSERT`, `UPDATE` ou `DELETE` (ni de `COMMIT`), car cela violerait la règle de non-modification des données pendant une requête et pourrait causer des erreurs de mutation ou des résultats incohérents.

### Paramètres `OUT`

```sql
CREATE OR REPLACE PROCEDURE stats_dept (
   p_id_dept IN departement.id_dept%TYPE,
   p_nb      OUT NUMBER,
   p_moy     OUT NUMBER,
   p_max     OUT NUMBER
) IS ...
```

Les paramètres `OUT` permettent de renvoyer plusieurs valeurs à l'appelant.

## 8. Gestion des exceptions

Oracle définit des exceptions prédéfinies :

| Exception | Signification |
|-----------|---------------|
| `NO_DATA_FOUND` | `SELECT INTO` n'a retourné aucune ligne |
| `TOO_MANY_ROWS` | `SELECT INTO` a retourné plusieurs lignes |
| `ZERO_DIVIDE` | Division par zéro |
| `DUP_VAL_ON_INDEX` | Valeur dupliquée sur un index unique / clé primaire |
| `OTHERS` | Toute autre erreur (à utiliser en dernier) |

Fonctions utiles dans un gestionnaire d'erreurs :

- `SQLCODE` : code numérique de l'erreur
- `SQLERRM` : message texte de l'erreur

```sql
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Aucune donnée trouvée');
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Plusieurs lignes retournées');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLCODE || ' - ' || SQLERRM);
```

## 9. Formatage et affichage

### `DBMS_OUTPUT.PUT_LINE`

Affiche du texte dans la console. Pour voir la sortie, il faut l'activer dans l'outil :

```sql
SET SERVEROUTPUT ON;
```

### `TO_CHAR` et `RPAD`

```sql
TO_CHAR(ligne_emp.date_embauche, 'DD/MM/YYYY')
TO_CHAR(e.salaire, '9990.00')
RPAD(e.nom || ' ' || e.prenom, 20)
```

`TO_CHAR` formate dates et nombres. `RPAD` complète une chaîne à droite pour aligner les colonnes.

## 10. Fonctions utiles Oracle

| Fonction | Rôle |
|----------|------|
| `SYSDATE` | Date et heure du serveur |
| `MONTHS_BETWEEN(d1, d2)` | Nombre de mois entre deux dates |
| `TRUNC(n)` | Partie entière d'un nombre |
| `ROUND(n, p)` | Arrondi à p décimales |
| `LEAST(a, b)` | Plus petite des deux valeurs |
| `NVL(val, def)` | Remplace NULL par une valeur par défaut |
| `||` | Concaténation de chaînes |

## 11. Récapitulatif des exercices

| Fichier | Exercices | Concepts couverts |
|---------|-----------|-------------------|
| `s1.sql` | Blocs, variables, boucles, conditions, DML | Bloc anonyme, `%TYPE`, `%ROWTYPE`, `IF/ELSIF`, `CASE`, `LOOP/WHILE/FOR`, `SQL%ROWCOUNT`, `ROLLBACK` |
| `TP1.sql` | Moyenne, procédure d'augmentation, fonction de prime | Bloc anonyme, `AVG`, procédure, `RAISE_APPLICATION_ERROR`, fonction, agrégats |
| `tp2.sql` | 13 exercices gradués | `%TYPE`, `%ROWTYPE`, constantes, `IF/ELSIF/CASE`, 3 boucles, exceptions prédéfinies, curseurs explicites/paramétrés, procédures avec `PRAGMA EXCEPTION_INIT`, paramètres `OUT`, fonctions récursives, `rapport_dept` complet |

## 12. Bonnes pratiques

1. Privilégier `%TYPE` et `%ROWTYPE` plutôt que de coder les types en dur.
2. Tester `IS NULL` avant les comparaisons sur des colonnes pouvant être nulles.
3. Ne pas mettre de `COMMIT` dans une procédure stockée (laisser l'appelant gérer la transaction).
4. Utiliser `SQL%ROWCOUNT` après un DML plutôt que d'attendre `NO_DATA_FOUND`.
5. Fermer les curseurs explicites avec `CLOSE` (ou utiliser les curseurs implicites `FOR ... IN`).
6. Gérer explicitement `NO_DATA_FOUND` et `TOO_MANY_ROWS` avec `SELECT INTO`.
7. Utiliser `RAISE_APPLICATION_ERROR` pour les erreurs métier avec des codes dans l'intervalle `-20000` à `-20999`.
8. Activer `SET SERVEROUTPUT ON` pour voir les affichages `DBMS_OUTPUT`.
