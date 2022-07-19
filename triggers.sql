/*
Actualizarile, stergerile si inserarile in tabelul stoc se pot face doar vinerea de la 8:00 la 14:00.
*/


CREATE OR REPLACE TRIGGER stoc_trig
BEFORE INSERT OR DELETE OR UPDATE ON stoc
BEGIN
IF (TO_CHAR(SYSDATE,'DAY')<> 'VINERI')
 AND (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 14)
THEN
 IF INSERTING THEN
 RAISE_APPLICATION_ERROR(-20001,'Inserarea in tabel doar in ziua inventarului(vineri) intre orele 8:00-14:00');
 ELSIF DELETING THEN
 RAISE_APPLICATION_ERROR(-20002,'Stergerea din tabeleste permisa doar in ziua inventarului(vineri) intre orele 8:00-14:00');
ELSE
 RAISE_APPLICATION_ERROR(-20003,'Actualizarile in tabel sunt permise doar in ziua inventarului(vineri) intre orele 8:00-14:00');
 END IF;
END IF;
END;
/


--testare:

/* update stoc set nr_stoc=30 where cod_produs=10785 and cod_locatie=1;

DELETE FROM stoc WHERE cod_produs=10785 and cod_locatie=1;
   
INSERT INTO stoc VALUES(0001,10785, 39);   */


--Trigger-ul LMD asigura ca ora inserata sau actualizata este in timpul orelor de munca


CREATE OR REPLACE TRIGGER ex11_trigger
AFTER INSERT OR UPDATE OF DATA_ORA ON programare
 REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
 --v_data programare.DATA_ORA%TYPE;
 nr_ang NUMBER(2);
BEGIN
 /*/SELECT DATA_ORA
 INTO v_data
 FROM programare
 WHERE cod_programare IN (:NEW.cod_programare, :OLD.cod_programare);/*/
IF INSERTING THEN 
 IF TO_CHAR(:NEW.DATA_ORA,'HH24MI')  NOT BETWEEN 800 AND 1830 --am pus 'hh24mi' pt a verifica si minutele
 THEN RAISE_APPLICATION_ERROR(-20000,'Ora nu se afla in programul de lucru. Program de lucru: 8:00-18:30');
 
  
   END IF;

ELSIF UPDATING('DATA_ORA') THEN
 IF TO_CHAR(:NEW.DATA_ORA,'HH24MI')  NOT BETWEEN 800 AND 1830 --am pus 'hh24mi' pt a verifica si minutele
 THEN RAISE_APPLICATION_ERROR(-20000,'Ora nu se afla in programul de lucru. Program de lucru: 8:00-18:30');
 
 
END IF;

 
 END IF;
END;
/


--test:
/*INSERT INTO programare VALUES (5017, to_timestamp('04/12/2022 12:00:00','MM/DD/YYYY HH24:MI:SS.FF3'), 0005, 00080,125);
update programare set data_ora=to_timestamp('04/12/2022 19:00:00','MM/DD/YYYY HH24:MI:SS.FF3')where cod_programare=5001 ;
INSERT INTO programare VALUES (5017, to_timestamp('04/12/2022 19:00:00','MM/DD/YYYY HH24:MI:SS.FF3'), 0005, 00080,105)
*/




/*
Am creat un tabel in care se va insera fiecare schimbare (create, alter, drop) cu ajutorul trigger-ului LDD
*/


CREATE TABLE istoric_schimbari
(persoana VARCHAR2(30),
eveniment VARCHAR2(20),
tip VARCHAR2(30),
nume VARCHAR2(30),
data TIMESTAMP(3));
CREATE OR REPLACE TRIGGER istoric
 AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
 INSERT INTO istoric_schimbari
 VALUES (SYS.LOGIN_USER,
 SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE,
 SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
END;
/


--test:
/*CREATE TABLE test (c1 number(3));
ALTER TABLE test ADD (c2 VARCHAR(2));
INSERT INTO test VALUES (1,'c');
DROP TABLE test;
SELECT * FROM istoric_schimbari; */