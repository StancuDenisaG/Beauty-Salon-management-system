CREATE TABLE FURNIZOR 
    ( cod_furnizor NUMBER(4) PRIMARY KEY,nume VARCHAR2(25) CONSTRAINT nume_mm NOT NULL)  
ALTER TABLE furnizor
ADD nr_tel NUMBER(10);

    
CREATE TABLE produse 
    ( cod_produs NUMBER(5) PRIMARY KEY, denumire VARCHAR2(25)   CONSTRAINT denumire_nn NOT NULL,cod_furnizor NUMBER(4) NOT NULL,
    CONSTRAINT cod_furnizor_fk FOREIGN KEY (cod_furnizor)REFERENCES FURNIZOR(cod_furnizor) )


CREATE TABLE  manageri
    ( cod_manager NUMBER(3) PRIMARY KEY , nume VARCHAR(25)  CONSTRAINT nume_rr NOT NULL, prenume VARCHAR(25) CONSTRAINT
    prenume_rr NOT NULL, salariu NUMBER(12))


    
CREATE TABLE client
    ( cod_client NUMBER(3) PRIMARY KEY , nume VARCHAR(25)  CONSTRAINT nume NOT NULL, prenume VARCHAR(25) CONSTRAINT
    prenume NOT NULL, varsta NUMBER(2))


    
CREATE TABLE firma_contabilitate
  (cod_firma_contabilitate NUMBER(4) PRIMARY KEY, nume VARCHAR(25))

CREATE TABLE contabil
  (cod_contabil NUMBER(2) PRIMARY KEY, nume VARCHAR(25)CONSTRAINT nume_pp NOT NULL , prenume VARCHAR(25)
  CONSTRAINT prenume_pp NOT NULL,cod_firma_contabilitate NUMBER(4) NOT NULL,CONSTRAINT cod_firma_contabilitate_fk 
  FOREIGN KEY (cod_firma_contabilitate)REFERENCES firma_contabilitate(cod_firma_contabilitate))


CREATE TABLE locatie
    (cod_locatie NUMBER(4) PRIMARY KEY, adresa VARCHAR(50) CONSTRAINT adresa NOT NULL, telefon NUMBER (10), 
    cod_manager NUMBER(3) NOT NULL,CONSTRAINT cod_manager_fk FOREIGN KEY (cod_manager)REFERENCES manageri(cod_manager), 
    cod_contabil NUMBER(2) NOT NULL,CONSTRAINT cod_contabil_fk FOREIGN KEY (cod_contabil)REFERENCES contabil(cod_contabil));


CREATE TABLE servicii
    (cod_servicii NUMBER(5) PRIMARY  KEY,
     tip VARCHAR2(20) CONSTRAINT tip_nn NOT NULL, pret NUMBER(3))

CREATE TABLE programare
    (cod_programare NUMBER(4) PRIMARY KEY, data_ora TIMESTAMP, cod_locatie NUMBER(4) NOT NULL,
    CONSTRAINT cod_locatie_fk FOREIGN KEY (cod_locatie)REFERENCES locatie(cod_locatie), cod_servicii NUMBER(5) NOT NULL,
    CONSTRAINT cod_servicii_fk FOREIGN KEY (cod_servicii)REFERENCES servicii(cod_servicii), cod_client NUMBER(3) NOT NULL,
    CONSTRAINT cod_client_ffk FOREIGN KEY (cod_client)REFERENCES client(cod_client));


CREATE TABLE  card_fidelitate
    (cod_card NUMBER(4) PRIMARY KEY, data_activare DATE, data_exp DATE, cod_client NUMBER(3) NOT NULL,
    CONSTRAINT cod_client_fk FOREIGN KEY (cod_client)REFERENCES client(cod_client),
    CONSTRAINT cod_client_um UNIQUE (cod_client))

CREATE TABLE salariat
   (cod_salariat NUMBER(3) PRIMARY  KEY,tip VARCHAR2(25) 
   CHECK (tip in('cosmetolog', 'makeup_artist', 'manichiurist', 'hair_stylist')) CONSTRAINT tip_zz NOT NULL,
   cod_locatie NUMBER(4) NOT NULL,
   CONSTRAINT cod_locaties_fk FOREIGN KEY (cod_locatie) REFERENCES locatie(cod_locatie),
   nume VARCHAR(25) CONSTRAINT nume_zz NOT NULL, prenume VARCHAR(25) CONSTRAINT prenume_zz NOT NULL , 
   salariu NUMBER(4) CONSTRAINT salariu_zz NOT NULL)

CREATE TABLE stoc
    (cod_locatie NUMBER(4) NOT NULL REFERENCES locatie(cod_locatie),
     cod_produs NUMBER(5) NOT NULL REFERENCES produse(cod_produs),
     CONSTRAINT stoc_pk PRIMARY KEY (cod_locatie, cod_produs), nr_stoc NUMBER(4))



CREATE TABLE pentru
    (cod_servicii NUMBER(5) NOT NULL REFERENCES servicii(cod_servicii),
     cod_produs NUMBER(5) NOT NULL REFERENCES produse(cod_produs),
     CONSTRAINT pentru_pk PRIMARY KEY (cod_servicii, cod_produs))


CREATE TABLE presteaza
     (cod_servicii NUMBER(5) NOT NULL REFERENCES servicii(cod_servicii),
     cod_salariat NUMBER(3) NOT NULL REFERENCES salariat(cod_salariat),
     CONSTRAINT presteza_pk PRIMARY KEY (cod_servicii, cod_salariat))