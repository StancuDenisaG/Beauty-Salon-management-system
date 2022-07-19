/*
Procedura verifica daca produsele necesare unei programari ale carui cod il introducem sunt in stoc. Daca sunt se afiseaza mesajul „TOATE PRODUSELE SUNT IN STOC”, daca nu, exista doua cazuri:
1.Daca programarea este la minim 7 zile distanta produsele vor fi livrate pana atunci
2. Daca programarea este la o distanta mai mica de 7 zile, atunci se va sterge programarea din tabelul PROGRAMARE si se va afisa mesajul “PROGRAMAREA A FOST ANULATA” insotit de codul programarii si numele clientului.  Am tratat si exceptiile no_data_found si others
*/
set SERVEROUTPUT ON
create or replace procedure prog_stoc (id_prog programare.cod_programare%type default -1)  
is
TYPE rec IS RECORD ( 
id_prod produse.cod_produs%TYPE, 
nume_produs produse.denumire%TYPE, 
nr stoc.nr_stoc%TYPE, 
num_fur furnizor.nume%TYPE,
nr_tel furnizor.nr_tel%TYPE); 
TYPE prod_t IS TABLE OF rec INDEX BY BINARY_INTEGER;
pr_table prod_t;
c NUMBER(2);
nume_client VARCHAR(50); 
data programare.data_ora%TYPE;

begin  
c:=0;

select p.cod_produs, p.denumire, st.nr_stoc, f.nume , f.nr_tel BULK COLLECT INTO pr_table from produse p
join pentru t on p.cod_produs=t.cod_produs
join programare g on t.cod_servicii=g.cod_servicii
join stoc st on g.cod_locatie=st.cod_locatie and p.cod_produs=st.cod_produs
join furnizor f on p.cod_furnizor=f.cod_furnizor
where g.cod_programare=id_prog;

select nume||' '||prenume into nume_client from client where cod_client=(select cod_client from programare where cod_programare=id_prog);
 
select data_ora into data from programare where cod_programare=id_prog; 
 FOR i IN pr_table.FIRST..pr_table.LAST LOOP
           IF pr_table(i).nr=0 THEN
            DBMS_OUTPUT.NEW_LINE;
           DBMS_OUTPUT.PUT(pr_table(i).id_prod || '. '||pr_table(i).nume_produs||' nu este in stoc.');
            DBMS_OUTPUT.NEW_LINE;
           DBMS_OUTPUT.PUT(' DETALII COMANDA: ');
            DBMS_OUTPUT.NEW_LINE;
           DBMS_OUTPUT.PUT(' Furnizor: '||pr_table(i).num_fur||', nr tel: '||pr_table(i).nr_tel||' ');
            DBMS_OUTPUT.NEW_LINE;
           c:=c+1;
           END IF;
           
                END LOOP;
   IF c>0 and trunc(to_date(to_char(data, 'yyyy-mm-dd'),'yyyy-mm-dd')-sysdate )<7 THEN
        
           DBMS_OUTPUT.PUT('Programarea cu codul: '||id_prog||' a clientului '||nume_client|| 'a fost anulata');
           DELETE FROM programare WHERE cod_programare = id_prog;
    ELSIF c>0  and trunc(to_date(to_char(data, 'yyyy-mm-dd'),'yyyy-mm-dd')-sysdate )>7 THEN
           DBMS_OUTPUT.PUT('Produsele vor fi livrate pana la programare');
           
           
           
  ELSE
           DBMS_OUTPUT.PUT('Toate produsele sunt in stoc  ');
  END IF;

 DBMS_OUTPUT.NEW_LINE;
 
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 RAISE_APPLICATION_ERROR(-20000,
 'Nu exista programari cu acest cod');
 
 WHEN OTHERS THEN
 RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');

END  prog_stoc; 

/ 
--testare: 

EXECUTE prog_stoc(5001); 
EXECUTE prog_stoc(5999);
EXECUTE prog_stoc(5015);
EXECUTE prog_stoc(5016);









