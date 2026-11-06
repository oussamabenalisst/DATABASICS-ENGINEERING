create table departement (
   id_dept  number(3) primary key,
   nom_dept varchar2(40) not null,
   ville    varchar2(30)
);
create table employe (
   id_employe    number(5) primary key,
   nom           varchar2(40) not null,
   prenom        varchar2(40) not null,
   salaire       number(8,2) not null check ( salaire >= 0 ),
   date_embauche date not null,
   poste         varchar2(40),
   id_dept       number(3)
      references departement ( id_dept )
);
insert into departement values
   ( 10,
     'Informatique',
     'Tunis' );
insert into departement values
   ( 20,
     'Finance',
     'Sfax' );
insert into departement values
   ( 30,
     'Ressources humaines',
     'Tunis' );
insert into departement values
   ( 40,
     'Marketing',
     'Sousse' ); -- aucun employé
insert into employe values
   ( 1,
     'Ben Salah',
     'Amine',
     2200,
     date '2019-03-15',
     'Développeur',
     10 );
insert into employe values
   ( 2,
     'Trabelsi',
     'Sana',
     3100,
     date '2016-09-01',
     'Analyste financière',
     20 );
insert into employe values
   ( 3,
     'Mejri',
     'Youssef',
     1800,
     date '2022-01-10',
     'Technicien',
     10 );
insert into employe values
   ( 4,
     'Ayari',
     'Leila',
     2700,
     date '2018-06-20',
     'Chef de projet',
     10 );
insert into employe values
   ( 5,
     'Khelifi',
     'Karim',
     1500,
     date '2023-04-03',
     'Assistant RH',
     30 );
insert into employe values
   ( 6,
     'Hammami',
     'Rania',
     3500,
     date '2014-05-12',
     'Directrice financière',
     20 );
commit;

/*
Exercice 1 — Bloc anonyme et %TYPE ★
Écrire un bloc anonyme qui récupère le nom, le prénom et le salaire de l'employé n° 1 dans trois
variables déclarées avec %TYPE, puis affiche :
Employé : Amine Ben Salah - salaire : 2200
• Question : quel est l'intérêt de employe.nom%TYPE par rapport à VARCHAR2(40) ?
*/

create or replace procedure print (
   ch in varchar
) is
begin
   dbms_output.put_line(ch);
end;
/



declare
   v_nom     employe.nom%type;
   v_prenom  employe.prenom%type;
   v_salaire employe.salaire%type;
begin
   select nom,
          prenom,
          salaire
     into
      v_nom,
      v_prenom,
      v_salaire
     from employe
    where id_employe = 1;

   print('Employé : '
          || v_prenom
          || ' '
          || v_nom
          || ' - salaire : ' || v_salaire);
end;

/*
Exercice 2 — %ROWTYPE et constante ★
Récupérer toute la ligne de l'employé n° 4 dans une variable de type employe%ROWTYPE. Afficher
son nom complet, son poste, sa date d'embauche au format JJ/MM/AAAA et son salaire annuel,
calculé avec une constante c_nb_mois valant 12.
*/

declare
   ligne_emp employe%rowtype;
begin
   select *
     into ligne_emp
     from employe
    where id_employe = 4;
   print('Nom complet : '
          || ligne_emp.prenom
          || ' ' || ligne_emp.nom);
   print('Poste : ' || ligne_emp.poste);
   print('Date d''embauche : ' || to_char(
      ligne_emp.date_embauche,
      'DD/MM/YYYY'
   ));
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

declare
   v_salaire employe.salaire%type;
   v_categorie varchar2(20);
   v_prime numeric(8,2);
begin
   select salaire
     into v_salaire
     from employe
    where id_employe = 3;
    if v_salaire is null then
      v_categorie := 'Inconnu';
    elsif v_salaire <2000 then
        v_categorie:="Junior";
    elsif v_salaire <3000 then
        v_categorie:="Confirmé";
    else 
        v_categorie:="Senior";
    case v_categorie
        when 'Junior' then
            v_prime := v_salaire * 0.05;
        when 'Confirmé' then
            v_prime := v_salaire * 0.08;
        when 'Senior' then
            v_prime := v_salaire * 0.10;
        else
            v_prime := 0;
    end case;
    print('Catégorie : ' || v_categorie);
    print('Montant de la prime : ' || v_prime);
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

declare
   v_salaire employe.salaire%type := 2200;
   v_annees number := 0;
begin
    while v_salaire <= 3000 loop
        v_salaire := v_salaire * 1.05;
        v_annees := v_annees + 1;
    end loop;
    print('Nombre d''années : ' || v_annees);
    print('Salaire atteint : ' || round(v_salaire, 2));
    v_salaire := 2200;
    v_annees := 0;
    loop
        v_salaire := v_salaire * 1.05;
        v_annees := v_annees + 1;
        exit when v_salaire > 3000;
    end loop;
    print('Nombre d''années : ' || v_annees);
    print('Salaire atteint : ' || round(v_salaire, 2));
end;
/

/*
Exercice 5 — SELECT INTO et exceptions prédéfinies ★★
Écrire un bloc qui lit dans v_nom le nom de l'employé du département v_id_dept et l'affiche. Traiter
NO_DATA_FOUND, TOO_MANY_ROWS et OTHERS (avec SQLCODE et SQLERRM).
• Tester avec v_id_dept = 10, puis 30, puis 40. Pour chaque test, indiquer quelle branche est
exécutée et pourquoi.
*/

declare
   v_id_dept number(3) := 10;
   v_nom     employe.nom%type;
begin
   select nom
     into v_nom
     from employe
    where id_dept = v_id_dept;
   print('Nom de l''employé du département ' || v_id_dept || ' : ' || v_nom);
exception
   when NO_DATA_FOUND then
      print('Aucun employé trouvé pour le département ' || v_id_dept);
   when TOO_MANY_ROWS then
      print('Plusieurs employés trouvés pour le département ' || v_id_dept);
   when OTHERS then
      print('Erreur SQL : ' || SQLCODE || ' - ' || SQLERRM);
end;
/
