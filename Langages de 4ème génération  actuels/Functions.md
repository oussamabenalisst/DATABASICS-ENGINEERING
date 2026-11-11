# Annexe — Les fonctions SQL (Oracle)

Ce document résume et explique simplement le contenu de l'annexe « Les fonctions de lignes » et « Les fonctions de groupe » d'Oracle SQL.

---

## 1. Fonctions de caractères

Ces fonctions manipulent des chaînes de caractères (`VARCHAR2`, `CHAR`, `CLOB`).

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `LOWER(arg)` | Met en minuscule | `LOWER('Bonjour')` → `'bonjour'` |
| `UPPER(arg)` | Met en majuscule | `UPPER('bonjour')` → `'BONJOUR'` |
| `INITCAP(arg)` | Première lettre de chaque mot en majuscule, le reste en minuscule | `INITCAP('bonjour le monde')` → `'Bonjour Le Monde'` |
| `CONCAT(arg1, arg2)` | Concatène deux chaînes (équivalent à `\|\|`) | `CONCAT('Bon', 'jour')` → `'Bonjour'` |
| `SUBSTR(arg, m[, n])` | Extrait une sous-chaîne à partir de la position `m`, sur `n` caractères | `SUBSTR('Bonjour', 2, 4)` → `'onjo'` |
| `LENGTH(arg)` | Retourne la longueur en nombre de caractères | `LENGTH('Bonjour')` → `7` |
| `INSTR(arg, cc[, m][, n])` | Position de la sous-chaîne `cc` dans `arg`, à partir de `m`, occurrence `n` | `INSTR('Bonjour', 'jo')` → `4` |
| `LPAD(arg, m[, cc])` | Remplit à gauche avec `cc` jusqu'à `m` caractères | `LPAD('123', 5, '0')` → `'00123'` |
| `RPAD(arg, m[, cc])` | Remplit à droite avec `cc` jusqu'à `m` caractères | `RPAD('123', 5, '0')` → `'12300'` |
| `LTRIM(arg, cc)` | Supprime les caractères `cc` à gauche | `LTRIM('  Bonjour', ' ')` → `'Bonjour'` |
| `RTRIM(arg, cc)` | Supprime les caractères `cc` à droite | `RTRIM('Bonjour  ', ' ')` → `'Bonjour'` |
| `TRIM([LEADING\|TRAILING\|BOTH] cc FROM arg)` | Supprime `cc` des deux côtés par défaut (BOTH), ou d'un côté spécifique | `TRIM(BOTH ' ' FROM '  Bonjour  ')` → `'Bonjour'` |
| `REPLACE(arg, cc1[, cc2])` | Remplace `cc1` par `cc2` ; si `cc2` omis, supprime toutes les occurrences de `cc1` | `REPLACE('Bonjour', 'jour', 'soir')` → `'Bonsoir'` |

---

## 2. Fonctions numériques

Ces fonctions effectuent des opérations mathématiques sur des nombres.

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `ROUND(arg, n)` | Arrondit `arg` à `n` décimales. Si `n = 0`, arrondit à l'unité. Si `n < 0`, arrondit à gauche de la virgule | `ROUND(123.456, 2)` → `123.46` |
| `TRUNC(arg, n)` | Tronque `arg` à `n` décimales (sans arrondi) | `TRUNC(123.456, 2)` → `123.45` |
| `CEIL(arg)` | Plus petit entier supérieur ou égal | `CEIL(4.2)` → `5` |
| `FLOOR(arg)` | Plus grand entier inférieur ou égal | `FLOOR(4.9)` → `4` |
| `POWER(arg, n)` | `arg` à la puissance `n` | `POWER(2, 3)` → `8` |
| `EXP(arg)` | Exponentielle de `arg` (`e^arg`) | `EXP(1)` → `2.718...` |
| `SQRT(arg)` | Racine carrée de `arg` | `SQRT(16)` → `4` |
| `SIGN(arg)` | `-1` si négatif, `1` si positif, `0` sinon | `SIGN(-5)` → `-1` |
| `ABS(arg)` | Valeur absolue | `ABS(-10)` → `10` |
| `MOD(arg, n)` | Reste de la division de `arg` par `n` (modulo) | `MOD(10, 3)` → `1` |
| `LOG(m, arg)` | Logarithme de base `m` de `arg` | `LOG(10, 100)` → `2` |
| `SIN(arg)` | Sinus de `arg` (en radians) | `SIN(0)` → `0` |
| `COS(arg)` | Cosinus de `arg` (en radians) | `COS(0)` → `1` |

---

## 3. Fonctions de date

Oracle stocke les dates avec siècle, année, mois, jour, heure, minute et seconde. Le format par défaut est `DD-MON-YY`.

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `SYSDATE` | Date et heure système | `SELECT SYSDATE FROM DUAL` |
| `DATE1 + n` | Ajoute/soustrait `n` jours | `SYSDATE + 7` |
| `DATE1 - DATE2` | Différence en jours (nombre réel) | `DATE1 - DATE2` |
| `DATE1 + n/24` | Ajoute `n` heures | `SYSDATE + 2/24` |
| `MONTHS_BETWEEN(date1, date2)` | Différence en mois (nombre réel) | `MONTHS_BETWEEN('01-JAN-24', '01-JUL-24')` → `6` |
| `ADD_MONTHS(date1, n)` | Ajoute `n` mois | `ADD_MONTHS('01-JAN-24', 3)` → `'01-APR-24'` |
| `NEXT_DAY(date1, jour)` | Prochain jour nommé après `date1` | `NEXT_DAY(SYSDATE, 'Lundi')` |
| `LAST_DAY(date1)` | Dernier jour du mois de `date1` | `LAST_DAY('01-FEV-24')` → `'29-FEV-24'` |
| `ROUND(date1[, fmt])` | Arrondit la date selon le format `fmt` | `ROUND(date1, 'MM')` arrondit au mois |
| `TRUNC(date1[, fmt])` | Tronque la date selon le format `fmt` | `TRUNC(date1, 'MM')` → 1er du mois |

**Note :** Pour afficher la date système, utilisez la table virtuelle `DUAL` :
```sql
SELECT SYSDATE FROM DUAL;
```

---

## 4. Fonctions de conversion

Elles convertissent explicitement entre types de données. Oracle peut aussi convertir implicitement (ex: `VARCHAR2` ↔ `NUMBER`, `DATE` ↔ `VARCHAR2`).

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `TO_DATE(char, fmt)` | Convertit une chaîne en date selon le format `fmt` | `TO_DATE('23/10/2004', 'DD/MM/YYYY')` → `23-OCT-04` |
| `TO_CHAR(date, fmt)` | Convertit une date en chaîne avec le format `fmt` | `TO_CHAR(SYSDATE, 'DD/MM/YYYY')` → `22/10/2004` |
| `TO_CHAR(nombre, fmt)` | Convertit un nombre en chaîne formatée | `TO_CHAR(900, '$9.999')` → `$900.000` |
| `TO_NUMBER(char, fmt)` | Convertit une chaîne en nombre selon le format `fmt` | `TO_NUMBER('$1500', '$9999')` → `1500` |

---

## 5. Fonctions opérant sur tous les types de données

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `DECODE(arg, S1, v1, [S2, v2, …], default)` | Retourne `vi` si `arg = Si`, sinon `default` | `DECODE(sexe, 'M', 'Masculin', 'F', 'Féminin', 'Inconnu')` |
| `NVL(arg, val)` | Retourne `val` si `arg` est NULL, sinon `arg` | `NVL(commission, 0)` |
| `GREATEST(arg1, arg2, …)` | Retourne la plus grande valeur (date la plus récente si DATE) | `GREATEST(10, 25, 7)` → `25` |
| `LEAST(arg1, arg2, …)` | Retourne la plus petite valeur | `LEAST(10, 25, 7)` → `7` |
| `VSIZE(arg)` | Retourne la taille en octets | `VSIZE('Bonjour')` |

---

## 6. Fonctions de groupe (agrégats)

Ces fonctions opèrent sur un ensemble de lignes et retournent une seule valeur par groupe. Elles ignorent les valeurs NULL (sauf `COUNT(*)`).

| Fonction | Rôle | Exemple |
|----------|------|---------|
| `AVG([DISTINCT\|ALL] arg)` | Moyenne des valeurs | `AVG(salaire)` |
| `COUNT(*\|[DISTINCT]\|[ALL] arg)` | Nombre de lignes. `COUNT(*)` compte toutes les lignes y compris NULL et doublons | `COUNT(*)`, `COUNT(DISTINCT dept)` |
| `MAX([DISTINCT\|ALL] arg)` | Valeur maximale | `MAX(salaire)` |
| `MIN([DISTINCT\|ALL] arg)` | Valeur minimale | `MIN(salaire)` |
| `SUM([DISTINCT]/[ALL] arg)` | Somme des valeurs | `SUM(salaire)` |
| `VARIANCE([DISTINCT]/[ALL] arg)` | Variance des valeurs | `VARIANCE(salaire)` |
| `STDDEV([DISTINCT]/[ALL] arg)` | Écart type | `STDDEV(salaire)` |

**Remarque importante :** Toutes les fonctions de groupe ignorent les valeurs NULL dans leurs calculs, sauf `COUNT(*)`.

---

## 7. La clause GROUP BY

`GROUP BY` divise les lignes en groupes selon une ou plusieurs colonnes. Toutes les lignes d'un même groupe ont la même valeur pour la/les colonne(s) de groupement.

```sql
SELECT departement, AVG(salaire)
FROM employe
GROUP BY departement;
```

**Règle :** Dans la clause `SELECT`, on ne peut inclure que des fonctions de groupe et/ou les colonnes spécifiées dans `GROUP BY`.

---

## 8. Groupes dans des groupes (groupement multiniveaux)

On peut regrouper par plusieurs colonnes pour obtenir des sous-groupes :

```sql
SELECT departement, poste, AVG(salaire)
FROM employe
GROUP BY departement, poste;
```

---

## 9. La clause HAVING

`HAVING` filtre les **groupes** retournés par `GROUP BY`, de la même manière que `WHERE` filtre les lignes individuelles. Elle s'applique après le groupement.

```sql
SELECT departement, AVG(salaire)
FROM employe
GROUP BY departement
HAVING AVG(salaire) > 3000;
```

| Clause | Filtre | Appliqué à |
|--------|--------|------------|
| `WHERE` | Lignes individuelles | Avant `GROUP BY` |
| `HAVING` | Groupes | Après `GROUP BY` |

---

## 10. Récapitulatif visuel

```
Fonctions de caractères    → manipulation de texte (LOWER, UPPER, SUBSTR, REPLACE, …)
Fonctions numériques       → calculs mathématiques (ROUND, TRUNC, CEIL, SQRT, …)
Fonctions de date          → manipulation de dates (SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, …)
Fonctions de conversion    → changement de type (TO_CHAR, TO_DATE, TO_NUMBER)
Fonctions universelles     → DECODE, NVL, GREATEST, LEAST, VSIZE
Fonctions de groupe        → agrégats sur des ensembles (AVG, COUNT, MAX, MIN, SUM, …)
GROUP BY                   → création de groupes de lignes
HAVING                     → filtrage des groupes
```

---

*Source : Annexe « Les fonctions SQL » du cours Langages de 4ème génération actuels (Oracle).*
