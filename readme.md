# Guide des documents du projet

Ce répertoire regroupe les supports de cours et les exercices pratiques sur les bases de données et le langage SQL.

---

## Matériaux explicatifs (fichiers Markdown)

Les fichiers `.md` ci-dessous fournissent des explications détaillées pour chaque unité du cours.

| Unité | Fichier | Lien | Contenu |
|-------|---------|------|---------|
| Oracle / PL/SQL | `Oracle.md` | [Langages de 4ème génération actuels/Oracle/Oracle.md](Langages%20de%204ème%20génération%20actuels/Oracle/Oracle.md) | Explication complète de PL/SQL : blocs anonymes, `%TYPE`, `%ROWTYPE`, curseurs, procédures, fonctions, exceptions, bonnes pratiques. Exercices des fichiers `s1.sql`, `TP1.sql`, `tp2.sql`. |
| Fonctions SQL | `Functions.md` | [Langages de 4ème génération actuels/Functions.md](Langages%20de%204ème%20génération%20actuels/Functions.md) | Résumé et explication simplifiée des fonctions SQL Oracle (caractères, numériques, date, conversion, universelles, de groupe, `GROUP BY`, `HAVING`). Tiré de l'annexe PDF. |
| TD1 — Révision SQL | `TD1 Révision SQL.md` | [Sql Revision/TD1 Révision SQL.md](Sql%20Revision/TD1%20R%C3%A9vision%20SQL.md) | Corrigé complet du TD1 : création de tables, insertions, requêtes simples, fonctions d'agrégation, jointures, `GROUP BY`, `HAVING`, questions théoriques. |
| TD2 — Révision Bases de Données | `TD2 revision.md` | [Sql Revision/TD2 revision.md](Sql%20Revision/TD2%20revision.md) | Corrigé complet du TD2 : questions de cours (Vrai/Faux), modélisation E/A et relationnelle, algèbre relationnelle, LDD/LMD, interrogations SQL, normalisation, transactions ACID, index, triggers. |

---

## Fichiers sources SQL

Les fichiers `.sql` contiennent le code pratique à exécuter dans un SGBD.

| Répertoire | Fichier | Description |
|------------|---------|-------------|
| `Langages de 4ème génération actuels/Oracle/` | `s1.sql` | Blocs anonymes PL/SQL, variables, constantes, types, boucles, conditions, DML. |
| `Langages de 4ème génération actuels/Oracle/` | `TP1.sql` | Procédure d'augmentation de salaire, fonction de prime annuelle, bloc anonyme avec `AVG`. |
| `Langages de 4ème génération actuels/Oracle/` | `tp2.sql` | 13 exercices PL/SQL gradués : `%TYPE`, `%ROWTYPE`, curseurs, procédures, fonctions, gestion d'erreurs. |
| `Langages de 4ème génération actuels/PostgreSQL/` | `PostgreSQL.session.sql` | Session SQL pour PostgreSQL. |

---

## Arborescence simplifiée

```
database iteam/
├── README.md                                 # Ce fichier (guide des documents)
├── Langages de 4ème génération  actuels/
│   ├── Oracle/
│   │   ├── Oracle.md                         # Explication PL/SQL en français
│   │   ├── Functions.md                      # (voir Functions.md à la racine de l'unité)
│   │   ├── s1.sql
│   │   ├── TP1.sql
│   │   ├── tp2.sql
│   │   └── README.md                         # Guide spécifique à l'unité Oracle
│   ├── Functions.md                          # Résumé des fonctions SQL Oracle
│   ├── Annexe Les fonctions SQL.pdf
│   └── Serie_Exercices_PLSQL (1).pdf
│   └── PostgreSQL/
│       └── PostgreSQL.session.sql
└── Sql Revision/
    ├── TD1 Révision SQL.md                   # Corrigé TD1
    ├── TD1 Révision SQL.pdf
    ├── TD2 revision.md                       # Corrigé TD2
    └── TD2 révision.pdf
```

---

## Comment utiliser ce guide

1. Consultez les fichiers `.md` pour lire les explications et corrigés de chaque unité.
2. Ouvrez les fichiers `.sql` correspondants pour exécuter le code pratique dans votre SGBD (Oracle XE, PostgreSQL, etc.).
3. Les liens ci-dessus mènent directement aux fichiers Markdown depuis ce `README.md` racine.
