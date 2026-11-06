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

create or replace procedure printf (
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

   printf('Employé : '
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
   printf('Nom complet : '
          || ligne_emp.prenom
          || ' ' || ligne_emp.nom);
   printf('Poste : ' || ligne_emp.poste);
   printf('Date d''embauche : ' || to_char(
      ligne_emp.date_embauche,
      'DD/MM/YYYY'
   ));
   printf('Salaire annuel : ' || ligne_emp.salaire * 12);
end;
/