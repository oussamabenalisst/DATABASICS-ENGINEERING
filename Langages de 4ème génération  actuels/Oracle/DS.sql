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