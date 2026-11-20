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

insert into commande values(1,101,5,"02/10/2026");
insert into commande values(2,103,2,"05/10/2026");
insert into commande values(3,104,30,"07/10/2026");
insert into commande values(4,101,3,"12/10/2026");



-- EX2

DECLARE
    prd produit%ROWTYPE;
BEGIN
    select * into prd from produit where id_produit = 103;
    DBMS_OUTPUT.PUT_LINE('Produit: ' || prd.libelle || ', Valeur de stock: ' || prd.prix*prd.stock);
    res := case 
        when prd.stock == 0 then 'Stock faible'
        when prd.stock <10 then "Stock faible"
        else 'Stock suffisant'
    end;
    DBMS_OUTPUT.PUT_LINE('Etat du stock: ' || res);
END;
/


-- EX3

--A
CREATE OR REPLACE FUNCTION valeur_commandes(p_id_produit NUMBER) RETURN NUMBER IS
res NUMBER;
BEGIN
    select p.prix*c.quantite into res from produit p, commande c where p.id_produit = c.id_produit and p.id_produit = p_id_produit;
    RETURN res;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;


