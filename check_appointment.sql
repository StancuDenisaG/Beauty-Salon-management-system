/*
Subprogramul primeste de la tastatura un cod al 
unui client si apoi afiseaza: locul, data, ora, tipul de serviciu, pretul si 
angajatii disponibili pentru fiecare programare a clientului
*/


set SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ex6
 (pcod programare.cod_client%TYPE )
 IS

TYPE tabel_indexat IS TABLE OF VARCHAR(50) INDEX BY PLS_INTEGER; 
t_prog tabel_indexat;

TYPE vector IS VARRAY(10) OF programare%ROWTYPE;
v vector:= vector();
adresa VARCHAR(50);
pret NUMBER(3);
card NUMBER(1);
tip_serv VARCHAR(20);
BEGIN


select count(*) into card from card_fidelitate where cod_client=pcod;

    
SELECT * BULK COLLECT INTO v
FROM programare where cod_client= pcod  ;


for i in v.FIRST..v.LAST loop


select locatie.adresa into adresa
from locatie where locatie.cod_locatie=v(i).cod_locatie;

select servicii.tip into tip_serv from
servicii where servicii.cod_servicii=v(i).cod_servicii;
select servicii.pret into pret from
servicii where servicii.cod_servicii=v(i).cod_servicii;
DBMS_OUTPUT.PUT(i||'. Programarea cu codul '||v(i).cod_programare||' are loc la data de '||TO_CHAR(v(i).data_ora, 'dd.mm.yyyy')
||' ora '||TO_CHAR(v(i).data_ora,'hh:mm')||' la adresa '||adresa);
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT('---Tip serviciu: '||tip_serv );
IF (pret>70 AND card<>0) THEN 
    pret:=pret-15;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT('---Pret redus pentru clientii fideli: '||pret );
ELSE
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT('---Pret: '||pret );
end if;

DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT('---Angajati disponibili: ' );

SELECT nume ||' ' || prenume BULK COLLECT INTO t_prog
FROM salariat
WHERE cod_salariat in 
(select cod_salariat from presteaza where cod_servicii=v(i).cod_servicii )and cod_locatie =v(i).cod_locatie;

     FOR i IN t_prog.FIRST..t_prog.LAST LOOP
           DBMS_OUTPUT.PUT(t_prog(i) || '   '); 
     END LOOP;
     

DBMS_OUTPUT.NEW_LINE;
end loop;

EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20001,'Nu exista programari cu acest cod al clientului');
 WHEN OTHERS THEN
 RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END ex6 ;
/


--testare:
begin
ex6(115);
end;
/

begin
ex6(999);
end;
/

