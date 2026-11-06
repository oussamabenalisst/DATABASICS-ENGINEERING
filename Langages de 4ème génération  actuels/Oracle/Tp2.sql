create table departement (
   id_dept number(3) primary key,
   nom_dept varchar2(40) not null,
   ville varchar2(30)
);
create table employe (
   id_employe number(5) primary key,
   nom varchar2(40) not null,
   prenom varchar2(40) not null,
   salaire number(8, 2) not null check (salaire >= 0),
   date_embauche date not null,
   poste varchar2(40),
   id_dept number(3) references departement (id_dept)
);
insert into departement
values (10, 'Informatique', 'Tunis');
insert into departement
values (20, 'Finance', 'Sfax');
insert into departement
values (30, 'Ressources humaines', 'Tunis');
insert into departement
values (40, 'Marketing', 'Sousse');
-- aucun employé
insert into employe
values (
      1,
      'Ben Salah',
      'Amine',
      2200,
      date '2019-03-15',
      'Développeur',
      10
   );
insert into employe
values (
      2,
      'Trabelsi',
      'Sana',
      3100,
      date '2016-09-01',
      'Analyste financière',
      20
   );
insert into employe
values (
      3,
      'Mejri',
      'Youssef',
      1800,
      date '2022-01-10',
      'Technicien',
      10
   );
insert into employe
values (
      4,
      'Ayari',
      'Leila',
      2700,
      date '2018-06-20',
      'Chef de projet',
      10
   );
insert into employe
values (
      5,
      'Khelifi',
      'Karim',
      1500,
      date '2023-04-03',
      'Assistant RH',
      30
   );
insert into employe
values (
      6,
      'Hammami',
      'Rania',
      3500,
      date '2014-05-12',
      'Directrice financière',
      20
   );
commit;
/*
 Exercice 1 — Bloc anonyme et %TYPE ★
 Écrire un bloc anonyme qui récupère le nom, le prénom et le salaire de l'employé n° 1 dans trois
 variables déclarées avec %TYPE, puis affiche :
 Employé : Amine Ben Salah - salaire : 2200
 • Question : quel est l'intérêt de employe.nom%TYPE par rapport à VARCHAR2(40) ?
 */
create or replace procedure print (ch in varchar) is begin dbms_output.put_line(ch);
end;
/
declare v_nom employe.nom %type;
v_prenom employe.prenom %type;
v_salaire employe.salaire %type;
begin
select nom,
   prenom,
   salaire into v_nom,
   v_prenom,
   v_salaire
from employe
where id_employe = 1;
print(
   'Employé : ' || v_prenom || ' ' || v_nom || ' - salaire : ' || v_salaire
);
end;
/*
 Exercice 2 — %ROWTYPE et constante ★
 Récupérer toute la ligne de l'employé n° 4 dans une variable de type employe%ROWTYPE. Afficher
 son nom complet, son poste, sa date d'embauche au format JJ/MM/AAAA et son salaire annuel,
 calculé avec une constante c_nb_mois valant 12.
 */
declare ligne_emp employe %rowtype;
begin
select * into ligne_emp
from employe
where id_employe = 4;
print(
   'Nom complet : ' || ligne_emp.prenom || ' ' || ligne_emp.nom
);
print('Poste : ' || ligne_emp.poste);
print(
   'Date d''embauche : ' || to_char(
      ligne_emp.date_embauche,
      'DD/MM/YYYY'
   )
);
print('Salaire annuel : ' || ligne_emp.salaire * 12);
end;
/
/*
 Exercice 3 — IF / ELSIF et CASE ★
 • a) Lire le salaire de l'employé n° 3 et déterminer sa catégorie : « Inconnu » si le salaire est
 NULL, « Junior » s'il est inférieur à 2000, « Confirmé » s'il est inférieur à 3000, « Senior »
 sinon. Utiliser IF / ELSIF.
 • b) Avec une expression CASE, déterminer le taux de prime selon la catégorie (Junior 5 %,
 Confirmé 8 %, Senior 10 %, 0 sinon) et afficher la catégorie et le montant de la prime.
 • Question : pourquoi faut-il tester IS NULL en premier ?
 */
declare v_salaire employe.salaire %type;
v_cat varchar2(20);
v_taux number(3, 2);
begin
select salaire into v_salaire
from employe
where id_employe = 3;
-- a) IF / ELSIF
if v_salaire is null then v_cat := 'Inconnu';
elsif v_salaire < 2000 then v_cat := 'Junior';
elsif v_salaire < 3000 then v_cat := 'Confirmé';
else v_cat := 'Senior';
end if;
-- b) CASE simple (sur une valeur)
v_taux := case
   v_cat
   when 'Junior' then 0.05
   when 'Confirmé' then 0.08
   when 'Senior' then 0.10
   else 0
end;
print('Catégorie : ' || v_cat);
print('Prime : ' || v_salaire * v_taux);
end;
/
/*
 Exercice 4 — Les trois boucles ★★
 • a) WHILE : un salaire de 2200 augmente de 5 % chaque année. Combien d'années faut-il
 pour qu'il dépasse strictement 3000 ? Afficher le nombre d'années et le salaire atteint
 (arrondi à 2 décimales).
 • b) Réécrire la question a) avec LOOP … EXIT WHEN.
 • c) Avec FOR … REVERSE, afficher un compte à rebours « Départ dans 5 » … « Départ dans 1
 ».
 */
declare v_salaire employe.salaire %type := 2200;
v_annees number := 0;
begin while v_salaire <= 3000 loop v_salaire := v_salaire * 1.05;
v_annees := v_annees + 1;
end loop;
print('Nombre d''années : ' || v_annees);
print(
   'Salaire atteint : ' || round(v_salaire, 2)
);
v_salaire := 2200;
v_annees := 0;
loop v_salaire := v_salaire * 1.05;
v_annees := v_annees + 1;
exit
when v_salaire > 3000;
end loop;
print('Nombre d''années : ' || v_annees);
print(
   'Salaire atteint : ' || round(v_salaire, 2)
);
end;
/
/*
 Exercice 5 — SELECT INTO et exceptions prédéfinies ★★
 Écrire un bloc qui lit dans v_nom le nom de l'employé du département v_id_dept et l'affiche. Traiter
 NO_DATA_FOUND, TOO_MANY_ROWS et OTHERS (avec SQLCODE et SQLERRM).
 • Tester avec v_id_dept = 10, puis 30, puis 40. Pour chaque test, indiquer quelle branche est
 exécutée et pourquoi.
 */
declare v_id_dept number(3) := 10;
v_nom employe.nom %type;
begin
select nom into v_nom
from employe
where id_dept = v_id_dept;
print(
   'Nom de l''employé du département ' || v_id_dept || ' : ' || v_nom
);
exception
when no_data_found then print(
   'Aucun employé trouvé pour le département ' || v_id_dept
);
when too_many_rows then print(
   'Plusieurs employés trouvés pour le département ' || v_id_dept
);
when others then print(
   'Erreur SQL : ' || sqlcode || ' - ' || sqlerrm
);
end;
/
/*
 Exercice 6 — DML et SQL%ROWCOUNT ★★
 Augmenter de 3 % les salaires des employés d'un département donné. Afficher « n salaire(s)
 augmenté(s) » ou « Aucun employé modifié », puis annuler la modification par ROLLBACK. Tester
 avec les départements 10 et 40.
 • Question : un UPDATE qui ne modifie aucune ligne lève-t-il NO_DATA_FOUND ?
 */
begin
update employe
set salaire = salaire * 1.03
where id_dept = 10;
if sql %rowcount = 0 then print('Aucun employé modifié');
else print(sql %rowcount || ' salaire(s) augmenté(s)');
end if;
rollback;
end;
/
/*
 Exercice 7 — Curseur explicite ★★
 Avec un curseur explicite (OPEN / FETCH / CLOSE), lister les employés du département 10 par salaire
 décroissant. Numéroter chaque ligne avec %ROWCOUNT et afficher à la fin le nombre total d'employés
 lus.
 */
declare numemp integer := 0;
cursor emp_cursor is
select *
from employe
where id_dept = 10
order by salaire desc;
emp_rec emp_cursor %rowtype;
begin open emp_cursor;
loop fetch emp_cursor into emp_rec;
exit
when emp_cursor %notfound;
numemp := numemp + 1;
print(
   'Employé n° ' || numemp || ' : ' || emp_rec.prenom || ' ' || emp_rec.nom || ' - salaire : ' || emp_rec.salaire
);
end loop;
close emp_cursor;
print('Total de employés : ' || numemp);
end;
/
/*
 Exercice 8 — Curseur paramétré et boucles imbriquées ★★★
 Pour chaque département (par ordre d'identifiant), afficher son nom, puis la liste de ses employés
 triés par nom (curseur paramétré par l'identifiant du département), puis sa masse salariale. Pour
 un département sans employé, afficher « (aucun employé) ».
 */
declare cursor c_dept is
select id_dept,
   nom_dept
from departement
order by id_dept;
cursor c_emp (p_dept employe.id_dept %type) is
select nom,
   prenom,
   salaire
from employe
where id_dept = p_dept
order by nom;
v_total number;
v_nb pls_integer;
begin for d in c_dept loop -- OPEN / FETCH / CLOSE implicites
dbms_output.put_line('== ' || d.nom_dept || ' ==');
v_total := 0;
v_nb := 0;
for e in c_emp(d.id_dept) loop -- curseur paramétré
dbms_output.put_line(
   '- ' || e.nom || ' ' || e.prenom || ' : ' || e.salaire
);
v_total := v_total + e.salaire;
v_nb := v_nb + 1;
end loop;
if v_nb = 0 then dbms_output.put_line('(aucun employé)');
end if;
dbms_output.put_line('Masse salariale : ' || v_total);
end loop;
end;
/
/*
 
 Exercice 9 — Procédure embaucher avec exceptions ★★★
 Créer la procédure embaucher(p_id, p_nom, p_prenom, p_salaire, p_poste, p_id_dept) qui
 insère un nouvel employé avec la date du jour comme date d'embauche. Règles :
 • salaire NULL ou inférieur à 1000 → RAISE_APPLICATION_ERROR(-20001, …) via une
 exception utilisateur ;
 • identifiant déjà utilisé → erreur -20002 ;
 • département inexistant (ORA-02291, à nommer avec PRAGMA EXCEPTION_INIT) → erreur -
 20003 ;
 • pas de COMMIT dans la procédure.
 Tester : un appel correct (employé 7, département 10), un salaire de 800, un identifiant 1 déjà pris
 et un département 99. Terminer par ROLLBACK.
 
 */
CREATE OR REPLACE PROCEDURE embaucher (
      p_id IN employe.id_employe %TYPE,
      p_nom IN employe.nom %TYPE,
      p_prenom IN employe.prenom %TYPE,
      p_salaire IN employe.salaire %TYPE,
      p_poste IN employe.poste %TYPE,
      p_id_dept IN employe.id_dept %TYPE
   ) IS c_salaire_min CONSTANT NUMBER := 1000;
e_salaire_invalide EXCEPTION;
-- exception utilisateur
e_dept_absent EXCEPTION;
PRAGMA EXCEPTION_INIT(e_dept_absent, -2291);
BEGIN IF p_salaire IS NULL
OR p_salaire < c_salaire_min THEN RAISE_APPLICATION_ERROR(-20001, 'Salaire invalide : ' || p_salaire);
END IF;
INSERT INTO employe (
      id_employe,
      nom,
      prenom,
      salaire,
      date_embauche,
      poste,
      id_dept
   )
VALUES (
      p_id,
      p_nom,
      p_prenom,
      p_salaire,
      SYSDATE,
      p_poste,
      p_id_dept
   );
print(
   'Employé ' || p_prenom || ' ' || p_nom || ' embauché avec succès.'
);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20002, 'Identifiant déjà utilisé : ' || p_id);
WHEN e_dept_absent THEN RAISE_APPLICATION_ERROR(-20003, 'Département inexistant : ' || p_id_dept);
END embaucher;
/*
 Exercice 10 — Procédure avec paramètres OUT ★★
 Créer stats_dept(p_id_dept IN, p_nb OUT, p_moy OUT, p_max OUT) qui renvoie l'effectif, le
 salaire moyen (2 décimales) et le salaire maximum d'un département. Si le département n'existe
 pas, lever l'erreur -20010. Appeler la procédure depuis un bloc anonyme pour les départements
 10, 40 et 99, en affichant « N/A » pour les valeurs NULL.
 */
CREATE OR REPLACE PROCEDURE stats_dept (
      p_id_dept IN departement.id_dept %TYPE,
      p_nb OUT NUMBER,
      p_moy OUT NUMBER,
      p_max OUT NUMBER
   ) IS v_existe NUMBER;
BEGIN
SELECT COUNT(*) INTO v_existe
FROM departement
WHERE id_dept = p_id_dept;
IF v_existe = 0 THEN RAISE_APPLICATION_ERROR(
   -20010,
   'Département ' || p_id_dept || ' inexistant'
);
END IF;
SELECT COUNT(*),
   ROUND(AVG(salaire), 2),
   MAX(salaire) INTO p_nb,
   p_moy,
   p_max
FROM employe
WHERE id_dept = p_id_dept;
END stats_dept;
/
DECLARE v_nb NUMBER;
v_moy NUMBER;
v_max NUMBER;
BEGIN stats_dept(10, v_nb, v_moy, v_max);
-- tester 10, 40, 99 
DBMS_OUTPUT.PUT_LINE(
   'Effectif : ' || v_nb || ' | Moyenne : ' || NVL(TO_CHAR(v_moy), 'N/A') || ' | Max : ' || NVL(TO_CHAR(v_max), 'N/A')
);
END;
/
/*
 
 Exercice 11 — Fonctions anciennete et prime_anciennete ★★
 • a) Créer la fonction anciennete(p_id) qui renvoie le nombre d'années complètes depuis
 l'embauche (MONTHS_BETWEEN, TRUNC), ou NULL si l'employé n'existe pas.
 • b) Écrire une requête SQL qui affiche nom, prénom et ancienneté de tous les employés, du
 plus ancien au plus récent.
 • c) Créer prime_anciennete(p_id) = salaire × 2 % × ancienneté, plafonnée à 1000 DT
 (réutiliser anciennete).
 • d) Question : pourquoi une fonction appelée dans un SELECT ne doit-elle pas contenir
 d'UPDATE 
 
 */
CREATE OR REPLACE FUNCTION anciennete (p_id IN employe.id_employe %TYPE) RETURN NUMBER IS v_date employe.date_embauche %TYPE;
BEGIN
SELECT date_embauche INTO v_date
FROM employe
WHERE id_employe = p_id;
RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_date) / 12);
EXCEPTION
WHEN NO_DATA_FOUND THEN RETURN NULL;
END anciennete;
/
CREATE OR REPLACE FUNCTION prime_anciennete (p_id IN employe.id_employe %TYPE) RETURN NUMBER IS c_taux CONSTANT NUMBER := 0.02;
c_plafond CONSTANT NUMBER := 1000;
v_salaire employe.salaire %TYPE;
BEGIN
SELECT salaire INTO v_salaire
FROM employe
WHERE id_employe = p_id;
RETURN LEAST(v_salaire * c_taux * anciennete(p_id), c_plafond);
EXCEPTION
WHEN NO_DATA_FOUND THEN RETURN NULL;
END prime_anciennete;
/
/*
 
 Exercice 12 — Chasse aux erreurs ★★
 Ce bloc doit afficher la moyenne des salaires puis le nom de l'employé le mieux payé. Il contient 6
 erreurs (de syntaxe et de logique). Les repérer toutes, puis écrire une version corrigée.
 
 */
DECLARE v_total NUMBER := 0;
v_nb NUMBER := 0;
v_nom employe.nom %TYPE;
CURSOR c_emp IS
SELECT nom,
   salaire
FROM employe;
BEGIN FOR r IN c_emp LOOP v_total := v_total + r.salaire;
v_nb := v_nb + 1;
END LOOP;
IF v_nb > 0 THEN -- bonus : évite ZERO_DIVIDE 
DBMS_OUTPUT.PUT_LINE('Moyenne : ' || ROUND(v_total / v_nb, 2));
ELSE DBMS_OUTPUT.PUT_LINE('Aucun employé');
END IF;
SELECT nom INTO v_nom
FROM employe
WHERE salaire = (
      SELECT MAX(salaire)
      FROM employe
   );
DBMS_OUTPUT.PUT_LINE('Le mieux payé : ' || v_nom);
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Table employe vide');
WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Plusieurs employés ex aequo au salaire maximum');
END;
/
/*
 
 Exercice 13 — Procédure rapport_dept ★★★
 Créer la procédure rapport_dept(p_id_dept) qui affiche :
 • le nom et la ville du département ;
 • une ligne par employé : nom et prénom, poste, salaire (2 décimales), ancienneté (fonction
 de l'exercice 11) ;
 • l'effectif, la moyenne et le maximum obtenus avec stats_dept (exercice 10) ;
 • « Aucun employé dans ce département » si le département est vide, et un message
 d'erreur clair s'il n'existe pas.
 Utiliser RPAD et TO_CHAR pour aligner les colonnes. Tester avec 10, 40 et 99.
 
 */
CREATE OR REPLACE PROCEDURE rapport_dept (p_id_dept IN departement.id_dept %TYPE) IS v_dept departement %ROWTYPE;
v_nb NUMBER;
v_moy NUMBER;
v_max NUMBER;
CURSOR c_emp IS
SELECT id_employe,
   nom,
   prenom,
   poste,
   salaire
FROM employe
WHERE id_dept = p_id_dept
ORDER BY nom;
BEGIN -- NO_DATA_FOUND si le département n'existe pas 
SELECT * INTO v_dept
FROM departement
WHERE id_dept = p_id_dept;
DBMS_OUTPUT.PUT_LINE(
   'Département : ' || v_dept.nom_dept || ' (' || v_dept.ville || ')'
);
DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
FOR e IN c_emp LOOP DBMS_OUTPUT.PUT_LINE(
   RPAD(e.nom || ' ' || e.prenom, 20) || RPAD(e.poste, 22) || TO_CHAR(e.salaire, '9990.00') || '  ' || anciennete(e.id_employe) || ' an(s)'
);
END LOOP;
stats_dept(p_id_dept, v_nb, v_moy, v_max);
-- réutilisation (exercice 10) 
DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
IF v_nb = 0 THEN DBMS_OUTPUT.PUT_LINE('Aucun employé dans ce département');
ELSE DBMS_OUTPUT.PUT_LINE(
   'Effectif : ' || v_nb || ' | Moyenne : ' || v_moy || ' | Max : ' || v_max
);
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE(
   'Erreur : département ' || p_id_dept || ' inexistant'
);
END rapport_dept;
/