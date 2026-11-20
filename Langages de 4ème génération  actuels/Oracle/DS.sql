CREATE TABLE produit(
    id_produit INTEGER PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL,
    categorie VARCHAR(50),
    prix NUMBER(8,2) NOT NULL,
    stock NUMBER(5) NOT NULL check (stock >= 0)
);

CREATE TABLE commande(
    id_commande NUMBER(6) PRIMARY KEY,
    id_produit NUMBER(4) NOT NULL REFERENCES produit(id_produit),
    quantite NUMBER(5) NOT NULL,
    date_cmd DATE DEFAULT SYSDATE,

);

INSERT INTO produit VALUES(101,"clavier USB","informatique",35.00,40);
INSERT INTO produit VALUES(102,"Souris","informatique",28.00,0);
INSERT INTO produit VALUES(103,"écran 24 pouces","informatique",420.00,6);
INSERT INTO produit VALUES(104,"Cahier A4","Papeterie",3.20,150);
INSERT INTO produit VALUES(105,"Stylo bleu","Papeterie",0.80,8);
INSERT INTO produit VALUES(106,"Classeur","Papeterie",6.50,3);