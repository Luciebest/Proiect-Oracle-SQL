-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2023-05-29 10:03:55 EEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

create or replace package delete_package 
is 
    procedure delete_client(v_id_client in clienti.id_client%type);
    procedure delete_film(v_id_film in filme.id_film%type);
    procedure delete_detaliu_film(v_id_film in filme.id_film%type);
    procedure delete_rezervare(v_id_rezervare in rezervari.id_rezervare%type);
    procedure delete_programare(v_id_programare in programari.id_programare%type);
end;
/

create or replace package insert_package 
is 
procedure insert_client(v_nume_client in clienti.nume_client%type, v_telefon in clienti.telefon%type, v_email in clienti.email%type);
procedure insert_film(v_nume_film in filme.nume_film%type, v_durata in filme.durata%type, v_pret in filme.pret%type);
procedure insert_detaliu_film(v_an_aparitie in detalii_film.an_aparitie%type, v_regizor in detalii_film.regizor%type,v_gen in detalii_film.gen%type, v_id_film in filme.id_film%type);
procedure insert_rezervare(v_numar_locuri in rezervari.numar_locuri%type, v_id_programare in rezervari.id_programare%type,v_id_client in rezervari.id_client%type);
procedure insert_programare(v_data_incepere in programari.data_incepere%type, v_data_finalizare in programari.data_finalizare%type,v_id_film in programari.id_film%type, v_locuri_ramase in programari.locuri_ramase%type);
end;
/

CREATE OR REPLACE PACKAGE print_package 
IS 
    PROCEDURE print_film;
    PROCEDURE print_detaliu_film;
    PROCEDURE print_client;
    PROCEDURE print_programare;
    PROCEDURE print_rezervare;
END;
/

CREATE OR REPLACE PACKAGE test_package 
IS 

    PROCEDURE process_rezervare;
    PROCEDURE attempt_rezervare(
    v_numar_locuri IN rezervari.numar_locuri%TYPE,
    v_id_programare IN rezervari.id_programare%TYPE,
    v_id_client IN rezervari.id_client%TYPE);
    
END;
/

CREATE OR REPLACE PACKAGE update_package 
IS 
    PROCEDURE update_client(v_id_client in clienti.id_client%type, v_nume_client in clienti.nume_client%type, v_telefon in clienti.telefon%type, v_email in clienti.email%type);
    PROCEDURE update_film(v_id_film in filme.id_film%type, v_nume_film in filme.nume_film%type, v_durata in filme.durata%type, v_pret in filme.pret%type);
    PROCEDURE update_detaliu_film(v_id_film in filme.id_film%type, v_an_aparitie in detalii_film.an_aparitie%type, v_regizor in detalii_film.regizor%type, v_gen in detalii_film.gen%type);
    PROCEDURE update_programare(v_id_programare in programari.id_programare%type, v_data_incepere in programari.data_incepere%type, v_data_finalizare in programari.data_finalizare%type, v_id_film in programari.id_film%type, v_locuri_ramase in programari.locuri_ramase%type);
    PROCEDURE update_rezervare(v_id_rezervare in rezervari.id_rezervare%type, v_numar_locuri in rezervari.numar_locuri%type, v_id_programare in rezervari.id_programare%type, v_id_client in rezervari.id_client%type);
END;
/

CREATE TABLE clienti (
    id_client   NUMBER(6) NOT NULL,
    nume_client VARCHAR2(30) NOT NULL,
    telefon     VARCHAR2(10) NOT NULL,
    email       VARCHAR2(30) NOT NULL
)
LOGGING;

ALTER TABLE clienti
    ADD CONSTRAINT clienti_telefon_ck CHECK ( length(telefon) = 10 );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_email_ck CHECK ( REGEXP_LIKE ( email,
                                                          '[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}' ) );

ALTER TABLE clienti ADD CONSTRAINT clienti_pk PRIMARY KEY ( id_client );

CREATE TABLE detalii_film (
    an_aparitie   NUMBER(4) NOT NULL,
    regizor       VARCHAR2(30) NOT NULL,
    gen           VARCHAR2(10) NOT NULL,
    filme_id_film NUMBER(6) NOT NULL
)
LOGGING;

ALTER TABLE detalii_film
    ADD CONSTRAINT detalii_film_an_aparitie_ck CHECK ( an_aparitie BETWEEN 1800 AND 2022 );

ALTER TABLE detalii_film
    ADD CONSTRAINT detalii_film_gen_ck CHECK ( gen IN ( 'SF', 'actiune', 'animatie', 'comedie', 'documentar', 'drama', 'horror', 'mister'
    , 'thriller', 'western' ) );

ALTER TABLE detalii_film ADD CONSTRAINT detalii_film_pk PRIMARY KEY ( filme_id_film );

CREATE TABLE filme (
    id_film   NUMBER(6) NOT NULL,
    nume_film VARCHAR2(40) NOT NULL,
    durata    INTEGER NOT NULL,
    pret      FLOAT(3) NOT NULL
)
LOGGING;

ALTER TABLE filme ADD CONSTRAINT filme_durata_ck CHECK ( durata > 0 );

ALTER TABLE filme ADD CONSTRAINT filme_pret_ck CHECK ( pret > 0 );

ALTER TABLE filme ADD CONSTRAINT filme_pk PRIMARY KEY ( id_film );

CREATE TABLE programari (
    id_programare   NUMBER(6) NOT NULL,
    data_incepere   DATE NOT NULL,
    data_finalizare DATE NOT NULL,
    id_film         NUMBER(6) NOT NULL,
    locuri_ramase   NUMBER(3) NOT NULL
)
LOGGING;

ALTER TABLE programari ADD CONSTRAINT programari_locuri_ramase_ck CHECK ( locuri_ramase >= 0 );

ALTER TABLE programari ADD CONSTRAINT programari_pk PRIMARY KEY ( id_programare );

CREATE TABLE rezervari (
    id_rezervare  NUMBER(6) NOT NULL,
    numar_locuri  NUMBER(3) NOT NULL,
    id_programare NUMBER(6) NOT NULL,
    id_client     NUMBER(6) NOT NULL
)
LOGGING;

ALTER TABLE rezervari ADD CONSTRAINT rezervari_numar_locuri_ck CHECK ( numar_locuri >= 1 );

ALTER TABLE rezervari ADD CONSTRAINT rezervari_pk PRIMARY KEY ( id_rezervare );

ALTER TABLE detalii_film
    ADD CONSTRAINT detalii_film_filme_fk FOREIGN KEY ( filme_id_film )
        REFERENCES filme ( id_film )
    NOT DEFERRABLE;

ALTER TABLE programari
    ADD CONSTRAINT programari_filme_fk FOREIGN KEY ( id_film )
        REFERENCES filme ( id_film )
    NOT DEFERRABLE;

ALTER TABLE rezervari
    ADD CONSTRAINT rezervari_clienti_fk FOREIGN KEY ( id_client )
        REFERENCES clienti ( id_client )
    NOT DEFERRABLE;

ALTER TABLE rezervari
    ADD CONSTRAINT rezervari_programari_fk FOREIGN KEY ( id_programare )
        REFERENCES programari ( id_programare )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER trg_programari_data_finalizare 
    BEFORE INSERT OR UPDATE ON Programari 
    FOR EACH ROW 
BEGIN
IF( :new.data_finalizare <= :new.data_incepere )
THEN
RAISE_APPLICATION_ERROR( -20001,
'Data invalida: ' || TO_CHAR( :new.data_finalizare, 'DD.MM.YYYY HH24:MI:SS' ) || ' trebuie sa fie mai mare decat data incepere.' );
END IF;
END; 
/

CREATE OR REPLACE TRIGGER trg_programari_data_incepere 
    BEFORE INSERT OR UPDATE ON Programari 
    FOR EACH ROW 
BEGIN
IF( :new.data_incepere <= SYSDATE )
THEN
RAISE_APPLICATION_ERROR( -20001,
'Data invalida: ' || TO_CHAR( :new.data_incepere, 'DD.MM.YYYY HH24:MI:SS' ) || ' trebuie sa fie mai mare decat data curenta.' );
END IF;
END; 
/

CREATE OR REPLACE TRIGGER trigger_locuri_disponibile 
    BEFORE INSERT OR UPDATE OR DELETE ON Rezervari 
    FOR EACH ROW 
declare
v_locuri_ramase programari.locuri_ramase%type;
v_dif_update programari.locuri_ramase%type;
begin 
if deleting then
    update programari set locuri_ramase=locuri_ramase+:old.numar_locuri
    where id_programare=:old.id_programare;
elsif inserting then
    select locuri_ramase into v_locuri_ramase from programari where id_programare=:new.id_programare;
    if v_locuri_ramase>:new.numar_locuri then 
        update programari set locuri_ramase=locuri_ramase-:new.numar_locuri
        where id_programare=:new.id_programare;
    end if;
else
    v_dif_update:=:new.numar_locuri-:old.numar_locuri;
    select locuri_ramase into v_locuri_ramase from programari where id_programare=:new.id_programare;
    if v_locuri_ramase>v_dif_update then 
        update programari set locuri_ramase=locuri_ramase-v_dif_update
        where id_programare=:new.id_programare;
    end if;
    
end if;
end; 
/

CREATE OR REPLACE PACKAGE BODY delete_package IS

    PROCEDURE delete_detaliu_film (
        v_id_film IN filme.id_film%TYPE
    ) IS
    BEGIN
        DELETE FROM detalii_film
        WHERE
            filme_id_film = v_id_film;

    END delete_detaliu_film;

    PROCEDURE delete_rezervare (
        v_id_rezervare IN rezervari.id_rezervare%TYPE
    ) IS
    BEGIN
        DELETE FROM rezervari
        WHERE
            id_rezervare = v_id_rezervare;

    END delete_rezervare;

    PROCEDURE delete_client (
        v_id_client IN clienti.id_client%TYPE
    ) IS
    BEGIN
        DELETE FROM clienti
        WHERE
            id_client = v_id_client;

    END delete_client;

    PROCEDURE delete_programare (
        v_id_programare IN programari.id_programare%TYPE
    ) IS
    BEGIN
        DELETE FROM programari
        WHERE
            id_programare = v_id_programare;

    END delete_programare;

    PROCEDURE delete_film (
        v_id_film IN filme.id_film%TYPE
    ) IS
    BEGIN
        DELETE FROM filme
        WHERE
            id_film = v_id_film;

    END delete_film;

END;
/

CREATE OR REPLACE PACKAGE BODY insert_package IS

    PROCEDURE insert_detaliu_film (
        v_an_aparitie IN detalii_film.an_aparitie%TYPE,
        v_regizor     IN detalii_film.regizor%TYPE,
        v_gen         IN detalii_film.gen%TYPE,
        v_id_film     IN filme.id_film%TYPE
    ) IS
    BEGIN
        INSERT INTO detalii_film VALUES (
            v_an_aparitie,
            v_regizor,
            v_gen,
            v_id_film
        );

    END insert_detaliu_film;

    PROCEDURE insert_rezervare (
        v_numar_locuri  IN rezervari.numar_locuri%TYPE,
        v_id_programare IN rezervari.id_programare%TYPE,
        v_id_client     IN rezervari.id_client%TYPE
    ) IS
    BEGIN
        INSERT INTO rezervari VALUES (
            NULL,
            v_numar_locuri,
            v_id_programare,
            v_id_client
        );

    END insert_rezervare;

    PROCEDURE insert_client (
        v_nume_client IN clienti.nume_client%TYPE,
        v_telefon     IN clienti.telefon%TYPE,
        v_email       IN clienti.email%TYPE
    ) IS
    BEGIN
        INSERT INTO clienti VALUES (
            NULL,
            v_nume_client,
            v_telefon,
            v_email
        );

    END insert_client;

    PROCEDURE insert_programare (
        v_data_incepere   IN programari.data_incepere%TYPE,
        v_data_finalizare IN programari.data_finalizare%TYPE,
        v_id_film         IN programari.id_film%TYPE,
        v_locuri_ramase   IN programari.locuri_ramase%TYPE
    ) IS
    BEGIN
        INSERT INTO programari VALUES (
            NULL,
            v_data_incepere,
            v_data_finalizare,
            v_id_film,
            v_locuri_ramase
        );

    END insert_programare;

    PROCEDURE insert_film (
        v_nume_film IN filme.nume_film%TYPE,
        v_durata    IN filme.durata%TYPE,
        v_pret      IN filme.pret%TYPE
    ) IS
    BEGIN
        INSERT INTO filme (
            nume_film,
            durata,
            pret
        ) VALUES (
            v_nume_film,
            v_durata,
            v_pret
        );

    END insert_film;

END;
/

CREATE OR REPLACE PACKAGE BODY print_package IS

    PROCEDURE print_film IS
        CURSOR c IS
        SELECT
            *
        FROM
            filme;

    BEGIN
        FOR r IN c LOOP
            dbms_output.put_line('Film ID: '
                                 || r.id_film
                                 || ', Nume film: '
                                 || r.nume_film
                                 || ', Durata: '
                                 || r.durata
                                 || ', Pret: '
                                 || r.pret);
        END LOOP;
    END print_film;

    PROCEDURE print_detaliu_film IS
        CURSOR c IS
        SELECT
            *
        FROM
            detalii_film;

    BEGIN
        FOR r IN c LOOP
            dbms_output.put_line('Detaliu_film ID: '
                                 || r.filme_id_film
                                 || ', An aparitie: '
                                 || r.an_aparitie
                                 || ', Regizor: '
                                 || r.regizor
                                 || ', Gen: '
                                 || r.gen);
        END LOOP;
    END print_detaliu_film;

    PROCEDURE print_client IS
        CURSOR c IS
        SELECT
            *
        FROM
            clienti;

    BEGIN
        FOR r IN c LOOP
            dbms_output.put_line('Client ID: '
                                 || r.id_client
                                 || ', Nume client: '
                                 || r.nume_client
                                 || ', Telefon: '
                                 || r.telefon
                                 || ', Email: '
                                 || r.email);
        END LOOP;
    END print_client;

    PROCEDURE print_programare IS
        CURSOR c IS
        SELECT
            *
        FROM
            programari;

    BEGIN
        FOR r IN c LOOP
            dbms_output.put_line('Programare ID: '
                                 || r.id_programare
                                 || ', Data incepere: '
                                 || to_char(
                                           r.data_incepere,
                                           'YYYY-MM-DD HH24:MI'
                                    )
                                 || ', Data finalizare: '
                                 || to_char(
                                           r.data_finalizare,
                                           'YYYY-MM-DD HH24:MI'
                                    )
                                 || ', Film ID: '
                                 || r.id_film
                                 || ', Locuri ramase: '
                                 || r.locuri_ramase);
        --DBMS_OUTPUT.PUT_LINE('Programare ID: ' || r.id_programare || ', Data incepere: ' || r.data_incepere || ', Data finalizare: ' || r.data_finalizare || ', Film ID: ' || r.id_film || ', Locuri ramase: ' || r.locuri_ramase);
        END LOOP;
    END print_programare;

    PROCEDURE print_rezervare IS
        CURSOR c IS
        SELECT
            *
        FROM
            rezervari;

    BEGIN
        FOR r IN c LOOP
            dbms_output.put_line('Rezervare ID: '
                                 || r.id_rezervare
                                 || ', Numar locuri: '
                                 || r.numar_locuri
                                 || ', Programare ID: '
                                 || r.id_programare
                                 || ', Client ID: '
                                 || r.id_client);
        END LOOP;
    END print_rezervare;

END;
/

CREATE OR REPLACE PACKAGE BODY test_package IS

    PROCEDURE process_rezervare AS
-- Declaram variabila pentru id-ul unei rezervari
        v_id_rezervare rezervari.id_rezervare%TYPE;
    BEGIN
    -- Selectam id-ul maxim curent din tabelul rezervari
        SELECT
            nvl(
                MAX(id_rezervare), 0
            )
        INTO v_id_rezervare
        FROM
            rezervari;

    -- Incrementam acest id cu 1 pentru a obtine id-ul unei noi rezervari
        v_id_rezervare := v_id_rezervare + 1;
    
    -- Afisam situatia tabelelor inainte de inserare
        dbms_output.put_line('Before insert:');
        FOR r IN (
            SELECT
                *
            FROM
                programari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_programare
                                 || ', Locuri ramase: '
                                 || r.locuri_ramase);
        END LOOP;

        FOR r IN (
            SELECT
                *
            FROM
                rezervari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_rezervare
                                 || ', Numar locuri: '
                                 || r.numar_locuri);
        END LOOP;

   -- Facem o inserare de rezervare
        insert_package.insert_rezervare(
                                       2,
                                       1,
                                       1
        );

    -- Afisam situatia tabelelor dupa inserare
        dbms_output.put_line('After insert:');
        FOR r IN (
            SELECT
                *
            FROM
                programari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_programare
                                 || ', Locuri ramase: '
                                 || r.locuri_ramase);
        END LOOP;

        FOR r IN (
            SELECT
                *
            FROM
                rezervari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_rezervare
                                 || ', Numar locuri: '
                                 || r.numar_locuri);
        END LOOP;

    -- Facem o operatie de update pe rezervare
        UPDATE rezervari
        SET
            numar_locuri = 5
        WHERE
            id_rezervare = v_id_rezervare;

    -- Afisam situatia tabelelor dupa operatia de update
        dbms_output.put_line('After update:');
        FOR r IN (
            SELECT
                *
            FROM
                programari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_programare
                                 || ', Locuri ramase: '
                                 || r.locuri_ramase);
        END LOOP;

        FOR r IN (
            SELECT
                *
            FROM
                rezervari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_rezervare
                                 || ', Numar locuri: '
                                 || r.numar_locuri);
        END LOOP;

    -- Stergem rezervarea pe care tocmai am inserat-o
        DELETE rezervari
        WHERE
            id_rezervare = v_id_rezervare;

    -- Afisam situatia tabelelor dupa operatia de stergere
        dbms_output.put_line('After delete:');
        FOR r IN (
            SELECT
                *
            FROM
                programari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_programare
                                 || ', Locuri ramase: '
                                 || r.locuri_ramase);
        END LOOP;

        FOR r IN (
            SELECT
                *
            FROM
                rezervari
        ) LOOP
            dbms_output.put_line('ID: '
                                 || r.id_rezervare
                                 || ', Numar locuri: '
                                 || r.numar_locuri);
        END LOOP;

    END process_rezervare;

    PROCEDURE attempt_rezervare (
        v_numar_locuri  IN rezervari.numar_locuri%TYPE,
        v_id_programare IN rezervari.id_programare%TYPE,
        v_id_client     IN rezervari.id_client%TYPE
    ) IS
        v_locuri_ramase programari.locuri_ramase%TYPE;
    BEGIN
        SELECT
            locuri_ramase
        INTO v_locuri_ramase
        FROM
            programari
        WHERE
            id_programare = v_id_programare;

    -- Verifica daca locurile ramase sunt suficiente pt rezervare
        IF v_locuri_ramase >= v_numar_locuri THEN
        -- Fac rezervarea
            insert_package.insert_rezervare(
                                           v_numar_locuri,
                                           v_id_programare,
                                           v_id_client
            );

       -- Nu mai facem update la locurile ramase, deoarece triggerul se va ocupa de asta
        ELSE
        -- Output mesaj zicand ca rezervarea nu poate fi facuta daca nu sunt suficiente locuri ramase in tabela programari
            dbms_output.put_line('Nu putem face rezervarea: nu sunt suficiente locuri ramase in programarea filmului dorit.');
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
        -- Output mesaj zicand ca rezervarea nu poate fi facuta daca id-ul programarii nu exista in tabela programari
            dbms_output.put_line('Nu putem face rezervarea: programarea nu exista.');
    END attempt_rezervare;

END;
/

CREATE OR REPLACE PACKAGE BODY update_package IS

    PROCEDURE update_film (
        v_id_film   IN filme.id_film%TYPE,
        v_nume_film IN filme.nume_film%TYPE,
        v_durata    IN filme.durata%TYPE,
        v_pret      IN filme.pret%TYPE
    ) IS
        film_exists NUMBER;
    BEGIN
    -- Check if a different film with the same name already exists
        SELECT
            COUNT(*)
        INTO film_exists
        FROM
            filme
        WHERE
            nume_film = v_nume_film
            AND id_film != v_id_film;

        IF film_exists = 0 THEN
        -- If not, perform the update
            UPDATE filme
            SET
                nume_film = v_nume_film,
                durata = v_durata,
                pret = v_pret
            WHERE
                id_film = v_id_film;

        ELSE
        -- If yes, output an error message
            dbms_output.put_line('Another film with name '
                                 || v_nume_film
                                 || ' already exists. No update made.');
        END IF;

    END update_film;

    PROCEDURE update_client (
        v_id_client   IN clienti.id_client%TYPE,
        v_nume_client IN clienti.nume_client%TYPE,
        v_telefon     IN clienti.telefon%TYPE,
        v_email       IN clienti.email%TYPE
    ) IS
    BEGIN
        UPDATE clienti
        SET
            nume_client = v_nume_client,
            telefon = v_telefon,
            email = v_email
        WHERE
            id_client = v_id_client;

    END update_client;

    PROCEDURE update_detaliu_film (
        v_id_film     IN filme.id_film%TYPE,
        v_an_aparitie IN detalii_film.an_aparitie%TYPE,
        v_regizor     IN detalii_film.regizor%TYPE,
        v_gen         IN detalii_film.gen%TYPE
    ) IS
    BEGIN
        UPDATE detalii_film
        SET
            an_aparitie = v_an_aparitie,
            regizor = v_regizor,
            gen = v_gen
        WHERE
            filme_id_film = v_id_film;

    END update_detaliu_film;

    PROCEDURE update_programare (
        v_id_programare   IN programari.id_programare%TYPE,
        v_data_incepere   IN programari.data_incepere%TYPE,
        v_data_finalizare IN programari.data_finalizare%TYPE,
        v_id_film         IN programari.id_film%TYPE,
        v_locuri_ramase   IN programari.locuri_ramase%TYPE
    ) IS
    BEGIN
        UPDATE programari
        SET
            data_incepere = v_data_incepere,
            data_finalizare = v_data_finalizare,
            id_film = v_id_film,
            locuri_ramase = v_locuri_ramase
        WHERE
            id_programare = v_id_programare;

    END update_programare;

    PROCEDURE update_rezervare (
        v_id_rezervare  IN rezervari.id_rezervare%TYPE,
        v_numar_locuri  IN rezervari.numar_locuri%TYPE,
        v_id_programare IN rezervari.id_programare%TYPE,
        v_id_client     IN rezervari.id_client%TYPE
    ) IS
    BEGIN
        UPDATE rezervari
        SET
            numar_locuri = v_numar_locuri,
            id_programare = v_id_programare,
            id_client = v_id_client
        WHERE
            id_rezervare = v_id_rezervare;

    END update_rezervare;

END;
/

CREATE SEQUENCE clienti_id_client_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER clienti_id_client_trg BEFORE
    INSERT ON clienti
    FOR EACH ROW
    WHEN ( new.id_client IS NULL )
BEGIN
    :new.id_client := clienti_id_client_seq.nextval;
END;
/

CREATE SEQUENCE filme_id_film_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER filme_id_film_trg BEFORE
    INSERT ON filme
    FOR EACH ROW
    WHEN ( new.id_film IS NULL )
BEGIN
    :new.id_film := filme_id_film_seq.nextval;
END;
/

CREATE SEQUENCE programari_id_programare_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER programari_id_programare_trg BEFORE
    INSERT ON programari
    FOR EACH ROW
    WHEN ( new.id_programare IS NULL )
BEGIN
    :new.id_programare := programari_id_programare_seq.nextval;
END;
/

CREATE SEQUENCE rezervari_id_rezervare_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER rezervari_id_rezervare_trg BEFORE
    INSERT ON rezervari
    FOR EACH ROW
    WHEN ( new.id_rezervare IS NULL )
BEGIN
    :new.id_rezervare := rezervari_id_rezervare_seq.nextval;
END;
/



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             0
-- ALTER TABLE                             17
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           5
-- CREATE PACKAGE BODY                      5
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           7
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          4
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
