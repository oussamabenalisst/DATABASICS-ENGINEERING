create table employe (
   id_employe integer primary key,
   nom        varchar(60) not null,
   salaire    numeric(10,2) not null check ( salaire >= 0 ),
   service    varchar(40)
);



insert into employe (
   id_employe,
   nom,
   salaire,
   service
) values
   ( 1,
     'Amine',
     2200,
     'Informatique' );
insert into employe (
   id_employe,
   nom,
   salaire,
   service
) values
   ( 2,
     'Sana',
     3100,
     'Finance' );
insert into employe (
   id_employe,
   nom,
   salaire,
   service
) values
   ( 3,
     'Youssef',
     1800,
     'Informatique' );


/*ex 3*/
create or replace procedure augmenter_salaire (
   p_id   in employe.id_employe%type,
   p_taux in numeric
) is
begin
   if p_taux < 0 then
      raise_application_error(
         -20001,
         'Le taux d''augmentation ne peut pas être négatif.'
      );
   end if;
   update employe
      set
      salaire = salaire + ( salaire * p_taux / 100 )
    where id_employe = p_id;
   if sql%rowcount = 0 then
      raise no_data_found;
   else
      dbms_output.put_line('Salaire de l''employé avec l''ID '
                           || p_id
                           || ' augmenté de '
                           || p_taux || '%.');
   end if;
exception
   when no_data_found then
      dbms_output.put_line('Aucun employé trouvé avec l''ID : ' || p_id);
   when others then
      dbms_output.put_line('Erreur lors de la mise à jour du salaire : ' || sqlerrm);
end augmenter_salaire;

/*ex4*/
create or replace function prime_annuelle (
   p_salaire in employe.salaire%type
) return numeric is
begin
   return p_salaire * 0.05 * 12;
end prime_annuelle;
/


declare
   v_salaire employe.salaire%type;
begin
   v_salaire := prime_annuelle(2200);
   dbms_output.put_line('La prime annuelle pour un salaire de 2200 est : ' || v_salaire);
end;
/

/* ex1*/
declare
   v_moyenne numeric(
      10,
      2
   );
begin
   select avg(salaire)
     into v_moyenne
     from employe;
   dbms_output.put_line('La moyenne des salaires est : ' || v_moyenne);
   if v_moyenne >= 2500 then
      dbms_output.put_line('La moyenne des salaires est supérieure à 2500.');
   else
      dbms_output.put_line('La moyenne des salaires est inférieure ou égale à 2500.');
   end if;
end;
/