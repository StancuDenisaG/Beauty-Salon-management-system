/*
  Procedura arata toate informatiile locatiilor(manager, contabil, angajati). 
Angajatii sunt impartiti pe categorii(cosmetolog, make_up artist etc) 
si la final se afiseaza si numarul de programari de la fiecare locatie.

*/
set SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ex7
 IS
contor NUMBER;
pr NUMBER;
CURSOR cursor_job IS SELECT  cod_locatie, adresa, cod_contabil, cod_manager FROM locatie;

v_man VARCHAR(50);
v_con VARCHAR(150);
v_loc locatie.cod_locatie%TYPE;
v_adresa locatie.adresa%TYPE;
v_contabil locatie.cod_contabil%TYPE; 
v_manager locatie.cod_manager%TYPE; 

BEGIN
OPEN cursor_job;
LOOP
contor:=1;
FETCH cursor_job INTO v_loc,v_adresa, v_contabil, v_manager;
EXIT WHEN cursor_job%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE ('              locatie : '||v_loc ||'('||v_adresa||')');
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');

SELECT nume || '  ' || prenume INTO v_man FROM manager WHERE  cod_manager=v_manager;
DBMS_OUTPUT.PUT_LINE ('MANAGER : '||v_man );
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');

SELECT c.nume || '  ' || c.prenume||'-'||f.nume INTO v_con FROM contabil c 
JOIN firma_contabilitate f ON c.cod_firma_contabilitate=f.cod_firma_contabilitate
WHERE  cod_contabil=v_contabil;
DBMS_OUTPUT.PUT_LINE ('CONTABIL : '||v_con);
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');

DBMS_OUTPUT.PUT_LINE('ANGAJATI:');
FOR t IN (SELECT DISTINCT tip FROM salariat) LOOP
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(UPPER(t.tip)|| ' :');
FOR v_emp IN (SELECT nume, prenume, salariu FROM salariat WHERE  cod_locatie=v_loc and tip=t.tip) LOOP
DBMS_OUTPUT.PUT_LINE(contor||'. '||v_emp.nume || '  ' || v_emp.prenume||' are salariul: ' ||v_emp.salariu||' lei');
contor:=contor+1;
END LOOP;
END LOOP;
select COUNT(*)into pr from programare where cod_locatie=v_loc;
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE( 'NR PROGRAMARI:'|| pr);
END LOOP;

CLOSE cursor_job;
END ex7;
/
--Testare:
begin
ex7();
end;
/
