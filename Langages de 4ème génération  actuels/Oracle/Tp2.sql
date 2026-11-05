CREATE TABLE departement (
id_dept NUMBER(3) PRIMARY KEY,
nom_dept VARCHAR2(40) NOT NULL,
ville VARCHAR2(30)
);
CREATE TABLE employe (
id_employe NUMBER(5) PRIMARY KEY,
nom VARCHAR2(40) NOT NULL,
prenom VARCHAR2(40) NOT NULL,
salaire NUMBER(8,2) NOT NULL CHECK (salaire >= 0),
date_embauche DATE NOT NULL,
poste VARCHAR2(40),
id_dept NUMBER(3) REFERENCES departement(id_dept)
);
INSERT INTO departement VALUES (10, 'Informatique', 'Tunis');
INSERT INTO departement VALUES (20, 'Finance', 'Sfax');
INSERT INTO departement VALUES (30, 'Ressources humaines', 'Tunis');
INSERT INTO departement VALUES (40, 'Marketing', 'Sousse'); -- aucun employé
INSERT INTO employe VALUES
(1,'Ben Salah','Amine',2200,DATE '2019-03-15','Développeur',10);
INSERT INTO employe VALUES
(2,'Trabelsi','Sana',3100,DATE '2016-09-01','Analyste financière',20);
INSERT INTO employe VALUES
(3,'Mejri','Youssef',1800,DATE '2022-01-10','Technicien',10);
INSERT INTO employe VALUES
(4,'Ayari','Leila',2700,DATE '2018-06-20','Chef de projet',10);
INSERT INTO employe VALUES
(5,'Khelifi','Karim',1500,DATE '2023-04-03','Assistant RH',30);
INSERT INTO employe VALUES
(6,'Hammami','Rania',3500,DATE '2014-05-12','Directrice financière',20);
COMMIT;