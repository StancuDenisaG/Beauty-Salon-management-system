/* Introducand numele de familie al unui angajat functia gaseste numarul de programari
 ce pot fi indeplinite de acesta tinand cont de cod_servicii si cod_locatie.
 Functia numara programarile din ziua curenta dupa ora in care este apelata
(De exemplu, daca apelam functia la ora 14:00 nu va lua in calcul programarile facute 
in aceeasi zi mai devreme de ora 14:00)

*/


set SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION f_ex8
 (v_numesal salariat.nume%TYPE DEFAULT 'xyz')
RETURN NUMBER IS
nr_prog NUMBER(2);
v_cod salariat.cod_salariat%TYPE;
BEGIN

SELECT cod_salariat INTO v_cod
FROM salariat
WHERE nume=v_numesal;

 
select COUNT(*) into nr_prog from programare p
join presteaza s on p.cod_servicii=s.cod_servicii
join salariat l on s.cod_salariat = l.cod_salariat and p.cod_locatie=l.cod_locatie
where l.cod_salariat=v_cod and (TO_CHAR(data_ora,'dd/mm/yyyy')=TO_CHAR(sysdate, 'dd/mm/yyyy') and
(To_number(TO_CHAR(data_ora, 'HH24MI'))-To_number(TO_CHAR(sysdate, 'HH24MI')))>0);

RETURN nr_prog;

 EXCEPTION
WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20000,
 'Nu exista angajati cu numele dat');
 WHEN TOO_MANY_ROWS THEN
 RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu acelasi nume');

WHEN OTHERS THEN
 RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');

END f_ex8;
/


--testare:
begin
DBMS_OUTPUT.PUT_LINE('Numarul de programari disponibile este '|| f_ex8('Popa'));
end;
/ 


begin
DBMS_OUTPUT.PUT_LINE('Numarul de programari disponibile sunt '|| f_ex8('Joe'));
end;
/


begin
DBMS_OUTPUT.PUT_LINE('Numarul de programari disponibile este '|| f_ex8('Ion'));
end;
/
