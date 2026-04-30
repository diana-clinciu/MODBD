-- 1.
-- Creare useri si link BD BUCURESTI
-- definire useri (trebuie creati cu userul sys)
-- user BD OLPT
CREATE USER bdd_all IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd_all;
ALTER USER bdd_all QUOTA UNLIMITED ON USERS;

-- user global
CREATE USER bdd_global IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd_global;
ALTER USER bdd_global QUOTA UNLIMITED ON USERS;

-- user local bucuresti
CREATE USER bdd IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd;
ALTER USER bdd QUOTA UNLIMITED ON USERS;

-- definire link bucuresti -> constanta
GRANT CREATE PUBLIC DATABASE LINK TO bdd;

CREATE PUBLIC DATABASE LINK bd_constanta
   CONNECT TO bdd IDENTIFIED BY password
   USING '(DESCRIPTION =
            (ADDRESS_LIST =
              (ADDRESS = (PROTOCOL = TCP)(HOST = oracle-constanta)(PORT = 1521))
            )
            (CONNECT_DATA =
              (SERVICE_NAME = FREEPDB1)
            )
          )';

-- test
SELECT * FROM dual@bd_constanta;

-- Create useri si link BD CONSTANTA
-- definire useri (creati cu sys)
-- user local apac
CREATE USER bdd IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd;
ALTER USER bdd QUOTA UNLIMITED ON USERS;

-- definire link constanta -> bucuresti
GRANT CREATE PUBLIC DATABASE LINK TO bdd;

CREATE PUBLIC DATABASE LINK bd_bucuresti
   CONNECT TO bdd IDENTIFIED BY password
   USING '(DESCRIPTION =
            (ADDRESS_LIST =
              (ADDRESS = (PROTOCOL = TCP)(HOST = oracle-bucuresti)(PORT = 1521))
            )
            (CONNECT_DATA =
              (SERVICE_NAME = FREEPDB1)
            )
          )';

-- test
SELECT * FROM dual@bd_bucuresti;

-- ============================================================================================
-- Crearea tabelelor OLTP pentru gestionarea hotelului (Baza de date centralizata, aflata pe BUCURESTI)  -- create cu userul bdd_all
-- ============================================================================================
-- 1. CATALOG: TIP_CAMERA
create table tip_camera (
   id_tip_camera    number primary key,
   tip_camera       varchar2(20) not null,
   clasa_confort    varchar2(20) not null,
   categorie_camera varchar2(30) not null,
   pret             number(10,2) not null
);

-- 2. ORAS
create table oras (
   id_oras    number primary key,
   oras       varchar2(50) not null
);

-- 3. HOTEL
create table hotel (
   id_hotel    number primary key,
   nume_hotel  varchar2(50) not null,
   nr_stele    number,
   capacitate  number,
   id_oras     number not null,
   foreign key ( id_oras )
      references oras ( id_oras )
);

-- 4. CAMERA
create table camera (
   id_camera     number primary key,
   nr_camera     number unique not null,
   id_tip_camera number not null,
   id_hotel      number not null,
   foreign key ( id_tip_camera )
      references tip_camera ( id_tip_camera ),
   foreign key ( id_hotel )
      references hotel ( id_hotel )
);

-- 5. CATALOG: SERVICIU
create table serviciu (
   id_serviciu   number primary key,
   denumire      varchar2(50) not null,
   pret_serviciu number(10,2) not null
);

-- 6. DEPARTAMENT
create table departament (
   id_departament   number primary key,
   nume_departament varchar2(50) not null
);

-- 7. ANGAJAT
create table angajat (
   id_angajat     number primary key,
   nume           varchar2(30) not null,
   prenume        varchar2(30) not null,
   functie        varchar2(30),
   salariu        number(10,2),
   cnp            varchar2(30) not null,
   data_angajare  date not null,
   id_departament number not null,
   id_serviciu    number,
   id_hotel       number not null,
   foreign key ( id_departament )
      references departament ( id_departament ),
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu ),
   foreign key ( id_hotel )
      references hotel ( id_hotel )
);

-- 8. CLIENT
create table client (
   id_client number primary key,
   nume      varchar2(30) not null,
   prenume   varchar2(30) not null,
   email     varchar2(50) unique
);

-- 9. REZERVARE
create table rezervare (
   id_rezervare number primary key,
   id_client    number not null,
   data_start   date not null,
   data_final   date not null,
   foreign key ( id_client )
      references client ( id_client ),
   constraint interval_data_valid check ( data_start <= data_final )
);

-- 10. REZERVARE_CAMERA
create table rezervare_camera (
   id_rezervare   number,
   id_camera      number,
   nr_nopti       number not null,
   pret_rezervare number(10,2) not null,
   primary key ( id_rezervare, id_camera ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare ),
   foreign key ( id_camera )
      references camera ( id_camera )
);

-- 11. CLIENT_SERVICIU
create table client_serviciu (
   id_client      number,
   id_serviciu    number,
   data_utilizare date default sysdate,
   cantitate      number default 1 not null,
   primary key ( id_client, id_serviciu, data_utilizare ),
   foreign key ( id_client )
      references client ( id_client ),
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

-- 12. PLATA
create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2),
   data_plata   date not null,
   metoda_plata varchar2(20) check ( metoda_plata in ( 'Cash', 'Card', 'Transfer' ) ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare )
);

-- =====================================================
-- Trigger pentru calcularea automata a sumei la plata
-- =====================================================
create or replace trigger trg_calculeaza_suma_plata before
   insert or update on plata
   for each row
declare
   v_pret_rezervare number := 0;
   v_pret_servicii  number := 0;
   v_id_client      number;
begin
    -- Obtine id_client din rezervare
   select id_client
     into v_id_client
     from rezervare
    where id_rezervare = :new.id_rezervare;

    -- Calculeaza pretul rezervarii
   select nvl(sum(rc.pret_rezervare), 0)
     into v_pret_rezervare
     from rezervare_camera rc
    where rc.id_rezervare = :new.id_rezervare;

    -- Calculeaza pretul serviciilor utilizate de client (inmultit cu cantitatea)
   select nvl(sum(s.pret_serviciu * cs.cantitate), 0)
     into v_pret_servicii
     from client_serviciu cs
     join serviciu s on cs.id_serviciu = s.id_serviciu
    where cs.id_client = v_id_client;

    -- Seteaza suma totala
   :new.suma := v_pret_rezervare + v_pret_servicii;
end;
/

-- =====================================================
-- Secvente si Triggere de Auto-Increment (Generare PK)
-- =====================================================

create sequence client_seq start with 11 increment by 1 nocache;
create or replace trigger client_id before insert on client for each row begin if :new.id_client is null then select client_seq.nextval into :new.id_client from dual; end if; end; /

create sequence rezervare_seq start with 11 increment by 1 nocache;
create or replace trigger rezervare_id before insert on rezervare for each row begin if :new.id_rezervare is null then select rezervare_seq.nextval into :new.id_rezervare from dual; end if; end; /

create sequence camera_seq start with 11 increment by 1 nocache;
create or replace trigger camera_id before insert on camera for each row begin if :new.id_camera is null then select camera_seq.nextval into :new.id_camera from dual; end if; end; /

create sequence serviciu_seq start with 11 increment by 1 nocache;
create or replace trigger serviciu_id before insert on serviciu for each row begin if :new.id_serviciu is null then select serviciu_seq.nextval into :new.id_serviciu from dual; end if; end; /

create sequence plata_seq start with 11 increment by 1 nocache;
create or replace trigger plata_id before insert on plata for each row begin if :new.id_plata is null then select plata_seq.nextval into :new.id_plata from dual; end if; end; /

create sequence angajat_seq start with 11 increment by 1 nocache;
create or replace trigger angajat_id before insert on angajat for each row begin if :new.id_angajat is null then select angajat_seq.nextval into :new.id_angajat from dual; end if; end; /

create sequence tip_camera_seq start with 1 increment by 1 nocache;
create or replace trigger tip_camera_id before insert on tip_camera for each row begin if :new.id_tip_camera is null then select tip_camera_seq.nextval into :new.id_tip_camera from dual; end if; end; /

create sequence departament_seq start with 1 increment by 1 nocache;
create or replace trigger departament_id before insert on departament for each row begin if :new.id_departament is null then select departament_seq.nextval into :new.id_departament from dual; end if; end; /

-- =====================================================
-- Inserare Date
-- =====================================================

-- DATE CATALOG: TIP_CAMERA
insert into tip_camera values ( 1, 'Single', 'Standard', 'Single Standard', 150 );
insert into tip_camera values ( 2, 'Double', 'Standard', 'Double Family', 250 );
insert into tip_camera values ( 3, 'Suite', 'Standard', 'Suite Economy', 450 );
insert into tip_camera values ( 4, 'Suite', 'Luxury', 'Suite Deluxe', 550 );
insert into tip_camera values ( 5, 'Double', 'Luxury', 'Double Royal', 600 );

-- ORASE
insert into oras values ( 1, 'Bucuresti' );
insert into oras values ( 2, 'Constanta' );


-- HOTELURI
insert into hotel values ( 1, 'Grand Hotel Bucuresti', 5, 200, 1 );
insert into hotel values ( 2, 'Royal Hotel Constanta',  4, 150, 2 );

-- CAMERE
insert into camera values ( 1, 101, 1, 1 );
insert into camera values ( 2, 102, 2, 1 );
insert into camera values ( 3, 103, 3, 1 );
insert into camera values ( 4, 104, 1, 1 );
insert into camera values ( 5, 105, 2, 1 );
insert into camera values ( 6, 106, 4, 2 );
insert into camera values ( 7, 107, 4, 2 );
insert into camera values ( 8, 108, 5, 2 );
insert into camera values ( 9, 109, 5, 2 );
insert into camera values ( 10, 110, 2, 2 );

-- DATE CATALOG: DEPARTAMENTE
insert into departament values (1, 'Receptie');
insert into departament values (2, 'Restaurant & Bar');
insert into departament values (3, 'Spa & Wellness');
insert into departament values (4, 'Curatenie & Mentenanta');
insert into departament values (5, 'Transport & Turism');

-- DATE CATALOG: SERVICII
insert into serviciu values ( 1, 'Spa și Masaj Relaxant', 150 );
insert into serviciu values ( 2, 'Room Service 24/7', 50 );
insert into serviciu values ( 3, 'Masaj Terapeutic', 120 );
insert into serviciu values ( 4, 'Acces Piscină Interioară', 40 );
insert into serviciu values ( 5, 'Tur Ghidat București', 180 );
insert into serviciu values ( 6, 'Transport Aeroport', 100 );
insert into serviciu values ( 7, 'Curățenie Suplimentară', 60 );
insert into serviciu values ( 8, 'Spălătorie Express', 45 );
insert into serviciu values ( 9, 'Sală Fitness Premium', 80 );
insert into serviciu values ( 10, 'Cinema Privat', 90 );

-- ANGAJAȚI
insert into angajat
values (1, 'Popa', 'Andrei', 'Recepționer', 3500, '111111111', date '2025-01-01', 1, null, 1);
insert into angajat
values (2, 'Ionescu', 'Mihai', 'Bucătar Șef', 4500, '262262626', date '2025-05-24', 2, 2, 1);
insert into angajat
values (3, 'Marin', 'Sorina', 'Ospătar', 3200, '363737373', date '2004-05-01', 2, 2, 1);
insert into angajat
values (4, 'Dumitru', 'Raluca', 'Masor Terapeut', 3800, '123456789', date '2026-03-11', 3, 3, 1);
insert into angajat
values (5, 'Stan', 'Vlad', 'Instructor Fitness', 3400, '987654321', date '2022-02-21', 3, 9, 2);
insert into angajat
values (6, 'Vasilescu', 'Ioan', 'Șofer', 3300, '152346789', date '2025-02-11', 5, 6, 2);
insert into angajat
values (7, 'Niculae', 'Elena', 'Recepționer Senior', 3800, '987653421', date '2025-11-01', 1, null, 2);
insert into angajat
values (8, 'Florea', 'Cristina', 'Supervizor Curățenie', 3000, '768543219', date '2025-01-11', 4, 7, 2);
insert into angajat
values (9, 'Georgescu', 'Alin', 'Responsabil Spălătorie', 2900, '758961324', date '2024-01-11', 4, 8, 2);
insert into angajat
values (10, 'Radu', 'Laura', 'Ghid Turistic', 3200, '758901324', date '2025-04-01', 5, 5, 2);

-- CLIENȚI
insert into client values ( 1, 'Popescu', 'Ana', 'ana.popescu@email.ro' );
insert into client values ( 2, 'Ionescu', 'Maria', 'maria.ionescu@email.ro' );
insert into client values ( 3, 'Georgescu', 'Ioana', 'ioana.georgescu@email.ro' );
insert into client values ( 4, 'Dumitrescu', 'Alina', 'alina.dumitrescu@email.ro' );
insert into client values ( 5, 'Radu', 'Cristina', 'cristina.radu@email.ro' );
insert into client values ( 6, 'Marin', 'Elena', 'elena.marin@email.ro' );
insert into client values ( 7, 'Stan', 'Gabriela', 'gabriela.stan@email.ro' );
insert into client values ( 8, 'Vasilescu', 'Laura', 'laura.vasilescu@email.ro' );
insert into client values ( 9, 'Niculae', 'Irina', 'irina.niculae@email.ro' );
insert into client values ( 10, 'Florea', 'Andreea', 'andreea.florea@email.ro' );

-- REZERVĂRI
insert into rezervare values ( 1, 1, to_date('2025-12-01','YYYY-MM-DD'), to_date('2025-12-07','YYYY-MM-DD') );
insert into rezervare values ( 2, 2, to_date('2025-12-03','YYYY-MM-DD'), to_date('2025-12-10','YYYY-MM-DD') );
insert into rezervare values ( 3, 3, to_date('2025-12-05','YYYY-MM-DD'), to_date('2025-12-07','YYYY-MM-DD') );
insert into rezervare values ( 4, 4, to_date('2025-12-07','YYYY-MM-DD'), to_date('2025-12-14','YYYY-MM-DD') );
insert into rezervare values ( 5, 5, to_date('2025-12-10','YYYY-MM-DD'), to_date('2025-12-14','YYYY-MM-DD') );
insert into rezervare values ( 6, 6, to_date('2025-12-12','YYYY-MM-DD'), to_date('2025-12-21','YYYY-MM-DD') );
insert into rezervare values ( 7, 7, to_date('2025-12-15','YYYY-MM-DD'), to_date('2025-12-20','YYYY-MM-DD') );
insert into rezervare values ( 8, 8, to_date('2025-12-18','YYYY-MM-DD'), to_date('2025-12-23','YYYY-MM-DD') );
insert into rezervare values ( 9, 9, to_date('2025-12-20','YYYY-MM-DD'), to_date('2025-12-30','YYYY-MM-DD') );
insert into rezervare values ( 10, 10, to_date('2025-12-23','YYYY-MM-DD'), to_date('2025-12-28','YYYY-MM-DD') );

-- REZERVARE_CAMERA
insert into rezervare_camera values ( 1, 1, 6, 900 );
insert into rezervare_camera values ( 2, 2, 7, 1750 );
insert into rezervare_camera values ( 3, 3, 2, 900 );
insert into rezervare_camera values ( 4, 4, 7, 1050 );
insert into rezervare_camera values ( 5, 5, 4, 1000 );
insert into rezervare_camera values ( 6, 6, 9, 4950 );
insert into rezervare_camera values ( 7, 7, 5, 900 );
insert into rezervare_camera values ( 8, 8, 5, 1400 );
insert into rezervare_camera values ( 9, 9, 10, 6000 );
insert into rezervare_camera values ( 10, 10, 5, 1300 );

-- CLIENT_SERVICIU
insert into client_serviciu values ( 1, 1, to_date('2025-12-02','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 2, 2, to_date('2025-12-04','YYYY-MM-DD'), 3 );
insert into client_serviciu values ( 3, 3, to_date('2025-12-06','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 4, 4, to_date('2025-12-08','YYYY-MM-DD'), 2 );
insert into client_serviciu values ( 5, 5, to_date('2025-12-11','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 6, 6, to_date('2025-12-13','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 7, 7, to_date('2025-12-16','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 8, 8, to_date('2025-12-19','YYYY-MM-DD'), 2 );
insert into client_serviciu values ( 9, 9, to_date('2025-12-21','YYYY-MM-DD'), 1 );
insert into client_serviciu values ( 10, 10, to_date('2025-12-24','YYYY-MM-DD'), 4 );

-- PLATI
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 1, 1, to_date('2025-11-25','YYYY-MM-DD'), 'Card' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 2, 2, to_date('2025-11-28','YYYY-MM-DD'), 'Cash' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 3, 3, to_date('2025-12-01','YYYY-MM-DD'), 'Transfer' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 4, 4, to_date('2025-12-03','YYYY-MM-DD'), 'Card' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 5, 5, to_date('2025-12-06','YYYY-MM-DD'), 'Card' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 6, 6, to_date('2025-12-08','YYYY-MM-DD'), 'Transfer' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 7, 7, to_date('2025-12-11','YYYY-MM-DD'), 'Cash' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 8, 8, to_date('2025-12-14','YYYY-MM-DD'), 'Card' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 9, 9, to_date('2025-12-16','YYYY-MM-DD'), 'Transfer' );
insert into plata ( id_plata, id_rezervare, data_plata, metoda_plata ) values ( 10, 10, to_date('2025-12-19','YYYY-MM-DD'), 'Card' );

commit;

-- Verificari finale
select p.id_plata, p.id_rezervare, p.suma as suma_calculata_automat, p.data_plata, p.metoda_plata
  from plata p
 order by p.id_plata;

 


 -- =====================================================================
-- Crearea si popularea fragmentelor orizontale
-- =====================================================================

-- Fragment Orizontal ORAS1 - creat pe BUCURESTI (user bdd)
CREATE TABLE oras1 AS
SELECT id_oras, oras
FROM bdd_all.oras
WHERE oras = 'Bucuresti';

GRANT SELECT, INSERT, UPDATE, DELETE ON oras1 TO bdd_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON oras TO bdd;

-- Fragment Orizontal ORAS2 - creat pe BUCURESTI (user bdd)
CREATE TABLE oras2 AS
SELECT id_oras, oras
FROM bdd_all.oras@bd_bucuresti
WHERE oras = 'Constanta';

-- Fragment Orizontal HOTEL1 - creat pe BUCURESTI (user bdd)
CREATE TABLE hotel1 AS
SELECT id_hotel, nume_hotel, nr_stele, capacitate, id_oras
FROM bdd_all.hotel
JOIN bdd_all.oras USING (id_oras)
WHERE oras = 'Bucuresti';

GRANT SELECT, INSERT, UPDATE, DELETE ON hotel1 TO bdd_global;

-- Fragment Orizontal HOTEL2 - creat pe CONSTANTA (user bdd)
CREATE TABLE hotel2 AS
SELECT id_hotel, nume_hotel, nr_stele, capacitate, id_oras
FROM bdd_all.hotel@bd_bucuresti
JOIN bdd_all.oras@bd_bucuresti USING (id_oras)
WHERE oras = 'Constanta';

-- Fragment Derivat CAMERA1 - creat pe BUCURESTI (user bdd)
CREATE TABLE camera1 AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel
FROM bdd_all.camera
WHERE id_hotel = 1;

GRANT SELECT, INSERT, UPDATE, DELETE ON camera1 TO bdd_global;

-- Fragment Derivat CAMERA2 - creat pe CONSTANTA (user bdd)
CREATE TABLE camera2 AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel
FROM bdd_all.camera@bd_bucuresti
WHERE id_hotel = 2;

-- Fragment Derivat REZERVARE_CAMERA1 - creat pe BUCURESTI (user bdd)
CREATE TABLE rezervare_camera1 AS
SELECT id_rezervare, rc.id_camera, nr_nopti, pret_rezervare
FROM bdd_all.rezervare_camera rc
JOIN bdd_all.camera c ON c.id_camera = rc.id_camera
JOIN bdd_all.hotel h ON c.id_hotel = h.id_hotel
JOIN bdd_all.oras o ON o.id_oras = h.id_oras
WHERE o.oras = 'Bucuresti';

GRANT SELECT, INSERT, UPDATE, DELETE ON rezervare_camera1 TO bdd_global;

-- Fragment Derivat REZERVARE_CAMERA2 - creat pe CONSTANTA (user bdd)
CREATE TABLE rezervare_camera2 AS
SELECT id_rezervare, rc.id_camera, nr_nopti, pret_rezervare
FROM bdd_all.rezervare_camera@bd_bucuresti rc
JOIN bdd_all.camera@bd_bucuresti c ON c.id_camera = rc.id_camera
JOIN bdd_all.hotel@bd_bucuresti h ON c.id_hotel = h.id_hotel
JOIN bdd_all.oras@bd_bucuresti o ON o.id_oras = h.id_oras
WHERE o.oras = 'Constanta';

-- =====================================================================
-- Transparenta pentru fragmentele orizontale (BUCURESTI-bdd_global)
-- =====================================================================

-- VIEW global care reconstituie ORAS
CREATE OR REPLACE VIEW oras_global AS
SELECT id_oras, oras FROM bdd.oras1
UNION ALL
SELECT id_oras, oras FROM bdd.oras2@bd_constanta;

SELECT * FROM oras_global ORDER BY id_oras;

-- Triggere INSTEAD OF pe ORAS
CREATE OR REPLACE TRIGGER trg_oras_global_ins
INSTEAD OF INSERT ON oras_global
FOR EACH ROW
BEGIN
   IF :NEW.oras = 'Bucuresti' THEN
      INSERT INTO bdd.oras1 (id_oras, oras)
      VALUES (:NEW.id_oras, :NEW.oras);
   ELSIF :NEW.oras = 'Constanta' THEN
      INSERT INTO bdd.oras2@bd_constanta (id_oras, oras)
      VALUES (:NEW.id_oras, :NEW.oras);
   END IF;
END;
/
-- test
INSERT INTO oras_global VALUES (3, 'Bucuresti');
SELECT * FROM oras_global WHERE id_oras = 3;
SELECT * FROM bdd.oras1 WHERE id_oras = 3;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_oras_global_upd
INSTEAD OF UPDATE ON oras_global
FOR EACH ROW
BEGIN
   IF :OLD.oras = 'Bucuresti' THEN
      UPDATE bdd.oras1
      SET oras = :NEW.oras
      WHERE id_oras = :OLD.id_oras;
   ELSIF :OLD.oras = 'Constanta' THEN
      UPDATE bdd.oras2@bd_constanta
      SET oras = :NEW.oras
      WHERE id_oras = :OLD.id_oras;
   END IF;
END;
/
-- test
UPDATE oras_global
SET oras = 'BUCURESTI'
WHERE id_oras = 1;
SELECT * FROM oras_global WHERE id_oras = 1;
SELECT * FROM bdd.oras1 WHERE id_oras = 1;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_oras_global_del
INSTEAD OF DELETE ON oras_global
FOR EACH ROW
BEGIN
   IF :OLD.oras = 'Bucuresti' THEN
      DELETE FROM bdd.oras1 WHERE id_oras = :OLD.id_oras;
   ELSIF :OLD.oras = 'Constanta' THEN
      DELETE FROM bdd.oras2@bd_constanta WHERE id_oras = :OLD.id_oras;
   END IF;
END;
/
-- test
DELETE FROM oras_global WHERE id_oras = 1;
SELECT * FROM oras_global WHERE id_oras = 1;
SELECT * FROM bdd.oras1 WHERE id_oras = 1;
ROLLBACK;


-- VIEW global care reconstituie HOTEL
CREATE OR REPLACE VIEW hotel_global AS
SELECT id_hotel, nume_hotel, nr_stele, capacitate, id_oras FROM bdd.hotel1
UNION ALL
SELECT id_hotel, nume_hotel, nr_stele, capacitate, id_oras FROM bdd.hotel2@bd_constanta;

SELECT * FROM hotel_global ORDER BY id_hotel;

-- Triggere INSTEAD OF pe hotel_global
CREATE OR REPLACE TRIGGER trg_hotel_global_ins
INSTEAD OF INSERT ON hotel_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras FROM oras_global WHERE id_oras = :NEW.id_oras;
   IF v_oras = 'Bucuresti' THEN
      INSERT INTO bdd.hotel1 (id_hotel, nume_hotel, nr_stele, capacitate, id_oras)
      VALUES (:NEW.id_hotel, :NEW.nume_hotel, :NEW.nr_stele, :NEW.capacitate, :NEW.id_oras);
   ELSIF v_oras = 'Constanta' THEN
      INSERT INTO bdd.hotel2@bd_constanta (id_hotel, nume_hotel, nr_stele, capacitate, id_oras)
      VALUES (:NEW.id_hotel, :NEW.nume_hotel, :NEW.nr_stele, :NEW.capacitate, :NEW.id_oras);
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/

-- Test INSERT prin view + rollback
INSERT INTO hotel_global VALUES (3, 'Test Hotel', 3, 300, 1);
SELECT * FROM hotel_global ORDER BY id_hotel;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_hotel_global_upd
INSTEAD OF UPDATE ON hotel_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras FROM oras_global WHERE id_oras = :OLD.id_oras;

   IF v_oras = 'Bucuresti' THEN
      UPDATE bdd.hotel1
      SET nume_hotel = :NEW.nume_hotel, nr_stele = :NEW.nr_stele,
          capacitate = :NEW.capacitate, id_oras = :NEW.id_oras
      WHERE id_hotel = :OLD.id_hotel;
   ELSIF v_oras = 'Constanta' THEN
      UPDATE bdd.hotel2@bd_constanta
      SET nume_hotel = :NEW.nume_hotel, nr_stele = :NEW.nr_stele,
          capacitate = :NEW.capacitate, id_oras = :NEW.id_oras
      WHERE id_hotel = :OLD.id_hotel;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- TEST
UPDATE hotel_global
SET nume_hotel = 'Nume hotel modificat', nr_stele = 5, capacitate=999
WHERE id_hotel = 1;
SELECT * FROM hotel_global WHERE id_hotel = 1;
SELECT * FROM bdd.hotel1 WHERE id_hotel = 1;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_hotel_global_del
INSTEAD OF DELETE ON hotel_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras FROM oras_global WHERE id_oras = :OLD.id_oras;

   IF v_oras = 'Bucuresti' THEN
      DELETE FROM bdd.hotel1 WHERE id_hotel = :OLD.id_hotel;
   ELSIF v_oras = 'Constanta' THEN
      DELETE FROM bdd.hotel2@bd_constanta WHERE id_hotel = :OLD.id_hotel;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- TEST
DELETE FROM hotel_global WHERE id_hotel = 1;
SELECT * FROM hotel_global WHERE id_hotel = 1;
SELECT * FROM bdd.hotel1 WHERE id_hotel = 1;
ROLLBACK;


-- VIEW global care reconstituie CAMERA
CREATE OR REPLACE VIEW camera_global AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM bdd.camera1
UNION ALL
SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM bdd.camera2@bd_constanta;

SELECT * FROM camera_global ORDER BY id_camera;

-- Triggere INSTEAD OF pe camera_global
CREATE OR REPLACE TRIGGER trg_camera_global_ins
INSTEAD OF INSERT ON camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras
   FROM hotel_global h JOIN oras_global o ON h.id_oras = o.id_oras
   WHERE id_hotel = :NEW.id_hotel;

   IF v_oras = 'Bucuresti' THEN
      INSERT INTO bdd.camera1 (id_camera, nr_camera, id_tip_camera, id_hotel)
      VALUES (:NEW.id_camera, :NEW.nr_camera, :NEW.id_tip_camera, :NEW.id_hotel);
   ELSIF v_oras = 'Constanta' THEN
      INSERT INTO bdd.camera2@bd_constanta (id_camera, nr_camera, id_tip_camera, id_hotel)
      VALUES (:NEW.id_camera, :NEW.nr_camera, :NEW.id_tip_camera, :NEW.id_hotel);
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- Test INSERT prin view + rollback
INSERT INTO camera_global VALUES (11, 111, 1, 1);
SELECT * FROM camera_global ORDER BY id_camera;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_camera_global_upd
INSTEAD OF UPDATE ON camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras
   FROM hotel_global h JOIN oras_global o ON h.id_oras = o.id_oras
   WHERE id_hotel = :OLD.id_hotel;

   IF v_oras = 'Bucuresti' THEN
      UPDATE bdd.camera1
      SET nr_camera = :NEW.nr_camera, id_tip_camera = :NEW.id_tip_camera,
          id_hotel = :NEW.id_hotel
      WHERE id_camera = :OLD.id_camera;
   ELSIF v_oras = 'Constanta' THEN
      UPDATE bdd.camera2@bd_constanta
      SET nr_camera = :NEW.nr_camera, id_tip_camera = :NEW.id_tip_camera,
          id_hotel = :NEW.id_hotel
      WHERE id_camera = :OLD.id_camera;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- TEST
UPDATE camera_global
SET nr_camera = 666, id_tip_camera = 1
WHERE id_camera = 1;
SELECT * FROM camera_global WHERE id_camera = 1;
SELECT * FROM bdd.camera1 WHERE id_camera = 1;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_camera_global_del
INSTEAD OF DELETE ON camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR2(255);
BEGIN
   SELECT oras INTO v_oras
   FROM hotel_global h JOIN oras_global o ON h.id_oras = o.id_oras
   WHERE id_hotel = :OLD.id_hotel;

   IF v_oras = 'Bucuresti' THEN
      DELETE FROM bdd.camera1 WHERE id_camera = :OLD.id_camera;
   ELSIF v_oras = 'Constanta' THEN
      DELETE FROM bdd.camera2@bd_constanta WHERE id_camera = :OLD.id_camera;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- test
DELETE FROM camera_global WHERE id_camera = 1;
SELECT * FROM camera_global WHERE id_camera = 1;
SELECT * FROM bdd.camera1 WHERE id_camera = 1;
ROLLBACK;


-- VIEW global care reconstituie REZERVARE_CAMERA
CREATE OR REPLACE VIEW rezervare_camera_global AS
SELECT id_rezervare, id_camera, nr_nopti, pret_rezervare FROM bdd.rezervare_camera1
UNION ALL
SELECT id_rezervare, id_camera, nr_nopti, pret_rezervare FROM bdd.rezervare_camera2@bd_constanta;

SELECT * FROM rezervare_camera_global;

-- Triggere INSTEAD OF pe rezervare_camera_global
CREATE OR REPLACE TRIGGER trg_rezervare_camera_global_ins
INSTEAD OF INSERT ON rezervare_camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR(255);
BEGIN
   SELECT oras INTO v_oras
   FROM camera_global c
   JOIN hotel_global h ON c.id_hotel = h.id_hotel
   JOIN oras_global o ON h.id_oras = o.id_oras
   WHERE c.id_camera = :NEW.id_camera;

   IF v_oras = 'Bucuresti' THEN
      INSERT INTO bdd.rezervare_camera1 (id_rezervare, id_camera, nr_nopti, pret_rezervare)
      VALUES (:NEW.id_rezervare, :NEW.id_camera, :NEW.nr_nopti, :NEW.pret_rezervare);
   ELSIF v_oras = 'Constanta' THEN
      INSERT INTO bdd.rezervare_camera2@bd_constanta (id_rezervare, id_camera, nr_nopti, pret_rezervare)
      VALUES (:NEW.id_rezervare, :NEW.id_camera, :NEW.nr_nopti, :NEW.pret_rezervare);
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- test
INSERT INTO rezervare_camera_global VALUES (100, 1, 1, 100);
SELECT * FROM rezervare_camera_global WHERE id_rezervare = 100 AND id_camera=1;
SELECT * FROM bdd.rezervare_camera1 WHERE id_rezervare = 100 AND id_camera=1;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_rezervare_camera_global_upd
INSTEAD OF UPDATE ON rezervare_camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR(255);
BEGIN
   SELECT oras INTO v_oras
   FROM camera_global c
   JOIN hotel_global h ON c.id_hotel = h.id_hotel
   JOIN oras_global o ON o.id_oras = h.id_oras
   WHERE c.id_camera = :OLD.id_camera;

   IF v_oras = 'Bucuresti' THEN
      UPDATE bdd.rezervare_camera1
      SET nr_nopti = :NEW.nr_nopti, pret_rezervare = :NEW.pret_rezervare
      WHERE id_camera = :OLD.id_camera AND id_rezervare = :OLD.id_rezervare;
   ELSIF v_oras = 'Constanta' THEN
      UPDATE bdd.rezervare_camera2@bd_constanta
      SET nr_nopti = :NEW.nr_nopti, pret_rezervare = :NEW.pret_rezervare
      WHERE id_camera = :OLD.id_camera AND id_rezervare = :OLD.id_rezervare;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- test
UPDATE rezervare_camera_global
SET nr_nopti = 1000, pret_rezervare = 56000
WHERE id_camera = 1 AND id_rezervare = 1;
SELECT * FROM rezervare_camera_global WHERE id_camera = 1 AND id_rezervare = 1;
SELECT * FROM bdd.rezervare_camera1 WHERE id_camera = 1 AND id_rezervare = 1;
ROLLBACK;

CREATE OR REPLACE TRIGGER trg_rezervare_camera_global_del
INSTEAD OF DELETE ON rezervare_camera_global
FOR EACH ROW
DECLARE
    v_oras VARCHAR(255);
BEGIN
   SELECT oras INTO v_oras
   FROM camera_global c
   JOIN hotel_global h ON c.id_hotel = h.id_hotel
   JOIN oras_global o ON o.id_oras = h.id_oras
   WHERE c.id_camera = :OLD.id_camera;

   IF v_oras = 'Bucuresti' THEN
      DELETE FROM bdd.rezervare_camera1 WHERE id_camera = :OLD.id_camera AND id_rezervare = :OLD.id_rezervare;
   ELSIF v_oras = 'Constanta' THEN
      DELETE FROM bdd.rezervare_camera2@bd_constanta WHERE id_camera = :OLD.id_camera AND id_rezervare = :OLD.id_rezervare;
   END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/
-- test
DELETE FROM rezervare_camera_global WHERE id_camera = 1 AND id_rezervare = 1;
SELECT * FROM rezervare_camera_global WHERE id_camera = 1 AND id_rezervare = 1;
SELECT * FROM bdd.rezervare_camera1 WHERE id_camera = 1 AND id_rezervare = 1;
ROLLBACK;

-- =====================================================================
-- Transparenta pentru tabelele stocate in alta baza de date (APAC-bdd)
-- =====================================================================

-- Sinonime pe APAC pentru acces transparent la fragmentele de pe EU
CREATE OR REPLACE SYNONYM hotel1 FOR bdd.hotel1@bd_bucuresti;
CREATE OR REPLACE SYNONYM camera1 FOR bdd.camera1@bd_bucuresti;

-- Verificare
SELECT * FROM hotel1;
SELECT * FROM camera1;

-- =====================================================================
-- REPLICARE
-- =====================================================================

-- BD_BUCURESTI

-- TIP_CAMERA (replica)
create table tip_camera (
   id_tip_camera    number primary key,
   tip_camera       varchar2(20) not null,
   clasa_confort    varchar2(20) not null,
   categorie_camera varchar2(30) not null,
   pret             number(10,2) not null
);
insert into tip_camera
select * from bdd_all.tip_camera;

-- SERVICIU (replica)
create table serviciu (
   id_serviciu   number primary key,
   denumire      varchar2(50) not null,
   pret_serviciu number(10,2) not null
);

insert into serviciu
select * from bdd_all.serviciu;

-- DEPARTAMENT (replica)
create table departament (
   id_departament   number primary key,
   nume_departament varchar2(50) not null
);

insert into departament
select * from bdd_all.departament;

-- CLIENT (replica)
create table client (
   id_client number primary key,
   nume      varchar2(30) not null,
   prenume   varchar2(30) not null,
   email     varchar2(50) unique
);

insert into client
select * from bdd_all.client;

-- CLIENT_SERVICIU (replica)
create table client_serviciu (
   id_client      number,
   id_serviciu    number,
   data_utilizare date default sysdate,
   cantitate      number default 1 not null,
   primary key ( id_client, id_serviciu, data_utilizare )
);

insert into client_serviciu
select * from bdd_all.client_serviciu;

-- REZERVARE (replica)
create table rezervare (
   id_rezervare number primary key,
   id_client    number not null,
   data_start   date not null,
   data_final   date not null,
   constraint interval_data_valid check ( data_start <= data_final )
);

insert into rezervare
select * from bdd_all.rezervare;

-- PLATA (replica)
create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2),
   data_plata   date not null,
   metoda_plata varchar2(20) check ( metoda_plata in ( 'Cash', 'Card', 'Transfer' ) )
);

insert into plata
select * from bdd_all.plata;

-- BD_CONSTANTA

-- TIP_CAMERA (replica)
create table tip_camera (
   id_tip_camera    number primary key,
   tip_camera       varchar2(20) not null,
   clasa_confort    varchar2(20) not null,
   categorie_camera varchar2(30) not null,
   pret             number(10,2) not null
);
insert into tip_camera
select * from bdd_all.tip_camera@bd_bucuresti;

-- SERVICIU (replica)
create table serviciu (
   id_serviciu   number primary key,
   denumire      varchar2(50) not null,
   pret_serviciu number(10,2) not null
);

insert into serviciu
select * from bdd_all.serviciu@bd_bucuresti;

-- DEPARTAMENT (replica)
create table departament (
   id_departament   number primary key,
   nume_departament varchar2(50) not null
);

insert into departament
select * from bdd_all.departament@bd_bucuresti;

-- CLIENT (replica)
create table client (
   id_client number primary key,
   nume      varchar2(30) not null,
   prenume   varchar2(30) not null,
   email     varchar2(50) unique
);

insert into client
select * from bdd_all.client@bd_bucuresti;

-- CLIENT_SERVICIU (replica)
create table client_serviciu (
   id_client      number,
   id_serviciu    number,
   data_utilizare date default sysdate,
   cantitate      number default 1 not null,
   primary key ( id_client, id_serviciu, data_utilizare )
);

insert into client_serviciu
select * from bdd_all.client_serviciu@bd_bucuresti;

-- REZERVARE (replica)
create table rezervare (
   id_rezervare number primary key,
   id_client    number not null,
   data_start   date not null,
   data_final   date not null,
   constraint interval_data_valid check ( data_start <= data_final )
);

insert into rezervare
select * from bdd_all.rezervare@bd_bucuresti;

-- PLATA (replica)
create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2),
   data_plata   date not null,
   metoda_plata varchar2(20) check ( metoda_plata in ( 'Cash', 'Card', 'Transfer' ) )
);

insert into plata
select * from bdd_all.plata@bd_bucuresti;

-- =====================================================================
-- CONSTRANGERE DE UNICITATE LOCALA
-- =====================================================================

-- BD_BUCURESTI
ALTER TABLE hotel1
ADD CONSTRAINT uq_hotel1_nume_hotel UNIQUE (nume_hotel);

ALTER TABLE camera1
ADD CONSTRAINT uq_camera1_nr_camera UNIQUE (nr_camera);

-- BD_CONSTANTA
ALTER TABLE hotel2
ADD CONSTRAINT uq_hotel2_nume_hotel UNIQUE (nume_hotel);

ALTER TABLE camera2
ADD CONSTRAINT uq_camera2_nr_camera UNIQUE (nr_camera);

-- =====================================================================
-- CONSTRANGERE DE UNICITATE GLOBALA FRAGMENTE ORIZONTALE
-- =====================================================================

-- BD_BUCURESTI
CREATE OR REPLACE TRIGGER trg_unique_hotel1
BEFORE INSERT OR UPDATE ON hotel1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM hotel2@bd_constanta
    WHERE nume_hotel = :NEW.nume_hotel;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala: Acest nume_hotel exista deja in bd_constanta!');
    END IF;
END;
/

-- test
INSERT INTO hotel1 VALUES (3, 'Royal Hotel Constanta', 'Bucuresti', 4, 400);

CREATE OR REPLACE TRIGGER trg_unique_camera1
BEFORE INSERT OR UPDATE ON camera1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM camera2@bd_constanta
    WHERE nr_camera = :NEW.nr_camera;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala: Acest nr_camera exista deja in bd_constanta!');
    END IF;
END;
/

-- test
INSERT INTO camera1 VALUES (20, 110, 2, 1);


-- BD_CONSTANTA
CREATE OR REPLACE TRIGGER trg_unique_hotel2
BEFORE INSERT OR UPDATE ON hotel2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM hotel1@bd_bucuresti
    WHERE nume_hotel = :NEW.nume_hotel;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala: Acest nume_hotel exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
INSERT INTO hotel2 VALUES (4, 'Grand Hotel Bucuresti', 'Constanta', 4, 400);


CREATE OR REPLACE TRIGGER trg_unique_camera2
BEFORE INSERT OR UPDATE ON camera2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM camera1@bd_bucuresti
    WHERE nr_camera = :NEW.nr_camera;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala: Acest nr_camera exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
INSERT INTO camera2 VALUES (30, 101, 2, 2);

-- =====================================================================
-- CONSTRANGERE DE UNICITATE GLOBALA FRAGMENTE VERTICALE
-- =====================================================================

-- UNIQUE (nume, prenume, id_departament)
-- BD BUCURESTI (bdd_global)
CREATE OR REPLACE TRIGGER trg_unique_nume_deptartament_global
    INSTEAD OF INSERT OR UPDATE
    ON angajat_global
    FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(1)
    INTO v_count
    FROM bdd.angajat_identitate ai
    JOIN bdd.angajat_salarizare@bd_constanta asal ON asal.id_angajat = ai.id_angajat
    WHERE ai.nume = :NEW.nume
      AND ai.prenume = :NEW.prenume
      AND asal.id_departament = :NEW.id_departament
      AND ai.id_angajat != :NEW.id_angajat;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'Constangere de unicitate pe nume, prenume si id_departament incalcata!');
    END IF;
END;

-- test
INSERT INTO angajat_global values (13, 'Popa', 'Andrei', 'Sofer', 1000, 1, null);

-- =====================================================================
-- CONSTRANGERE DE CHEIE PRIMARA
-- =====================================================================

-- BD_BUCURESTI

ALTER TABLE oras1
ADD CONSTRAINT pk_oras1 PRIMARY KEY (id_oras);

ALTER TABLE hotel1
ADD CONSTRAINT pk_hotel1 PRIMARY KEY (id_hotel);

ALTER TABLE camera1
ADD CONSTRAINT pk_camera1 PRIMARY KEY (id_camera);

ALTER TABLE rezervare_camera1
ADD CONSTRAINT pk_rezervare_camera1 PRIMARY KEY (id_camera, id_rezervare);

-- (deja definita in definitia tabelului)
ALTER TABLE angajat_identitate
ADD CONSTRAINT pk_angajat_identitate PRIMARY KEY (id_angajat);

CREATE OR REPLACE TRIGGER trg_unique_pk_oras1
BEFORE INSERT OR UPDATE ON oras1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM oras2@bd_constanta
    WHERE id_oras = :NEW.id_oras;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_constanta!');
    END IF;
END;
/

-- test
insert into oras1 values (2, 'Bucuresti');

CREATE OR REPLACE TRIGGER trg_unique_pk_hotel1
BEFORE INSERT OR UPDATE ON hotel1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM hotel2@bd_constanta
    WHERE id_hotel = :NEW.id_hotel;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_constanta!');
    END IF;
END;
/

-- test
insert into hotel1 values (2, 'nume hotel', 'Bucuresti', 1, 100);

CREATE OR REPLACE TRIGGER trg_unique_pk_camera1
BEFORE INSERT OR UPDATE ON camera1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM camera2@bd_constanta
    WHERE id_camera = :NEW.id_camera;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_constanta!');
    END IF;
END;
/

-- test
insert into camera1 values (10, 1000, 2, 1);

CREATE OR REPLACE TRIGGER trg_unique_pk_rezervare_camera1
BEFORE INSERT OR UPDATE ON rezervare_camera1
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM rezervare_camera2@bd_constanta
    WHERE id_camera = :NEW.id_camera AND id_rezervare = :NEW.id_rezervare;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_constanta!');
    END IF;
END;
/

-- test
insert into rezervare_camera1 values (6, 6, 2, 100);


-- BD CONSTANTA

ALTER TABLE oras2
ADD CONSTRAINT pk_oras2 PRIMARY KEY (id_oras);

ALTER TABLE hotel2
ADD CONSTRAINT pk_hotel2 PRIMARY KEY (id_hotel);

ALTER TABLE camera2
ADD CONSTRAINT pk_camera2 PRIMARY KEY (id_camera);

ALTER TABLE rezervare_camera2
ADD CONSTRAINT pk_rezervare_camera2 PRIMARY KEY (id_camera, id_rezervare);

-- (deja definita in definitia tabelului)
ALTER TABLE angajat_salarizare
ADD CONSTRAINT pk_angajat_salarizare PRIMARY KEY (id_angajat);

CREATE OR REPLACE TRIGGER trg_unique_pk_oras2
BEFORE INSERT OR UPDATE ON oras2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM oras1@bd_bucuresti
    WHERE id_oras = :NEW.id_oras;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
insert into oras2 values (1, 'Constanta');

CREATE OR REPLACE TRIGGER trg_unique_pk_hotel2
BEFORE INSERT OR UPDATE ON hotel2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM hotel1@bd_bucuresti
    WHERE id_hotel = :NEW.id_hotel;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
insert into hotel2 values (1, 'nume hotel', 'Constanta', 1, 100);

CREATE OR REPLACE TRIGGER trg_unique_pk_camera2
BEFORE INSERT OR UPDATE ON camera2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM camera1@bd_bucuresti
    WHERE id_camera = :NEW.id_camera;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
insert into camera2 values (1, 1000, 2, 2);

CREATE OR REPLACE TRIGGER trg_unique_pk_rezervare_camera2
BEFORE INSERT OR UPDATE ON rezervare_camera2
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM rezervare_camera1@bd_bucuresti
    WHERE id_camera = :NEW.id_camera AND id_rezervare = :NEW.id_rezervare;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Eroare de unicitate globala a cheii primare: Aceasta cheie priamra exista deja in bd_bucuresti!');
    END IF;
END;
/

-- test
insert into rezervare_camera2 values (1, 1, 2, 200);


-- =====================================================================
-- CONSTRANGERE DE CHEIE EXTERNA
-- =====================================================================
-- BD_BUCURESTI
ALTER TABLE hotel1
ADD CONSTRAINT fk_id_oras
FOREIGN KEY (id_oras) REFERENCES oras1 (id_oras);

ALTER TABLE camera1
ADD CONSTRAINT fk_id_hotel
FOREIGN KEY (id_hotel) REFERENCES hotel1 (id_hotel);

ALTER TABLE camera1
ADD CONSTRAINT fk_id_tip_camera
FOREIGN KEY (id_tip_camera) REFERENCES tip_camera (id_tip_camera);

ALTER TABLE rezervare_camera1
ADD CONSTRAINT fk_id_camera
FOREIGN KEY (id_camera) REFERENCES camera1 (id_camera);

ALTER TABLE rezervare_camera1
ADD CONSTRAINT fk_id_rezervare
FOREIGN KEY (id_rezervare) REFERENCES rezervare (id_rezervare);

-- ALTER TABLE angajat_identitate
-- ADD CONSTRAINT fk_id_serviciu
-- FOREIGN KEY (id_serviciu) REFERENCES serviciu (id_serviciu);

ALTER TABLE rezervare
ADD CONSTRAINT fk_id_client
FOREIGN KEY (id_client) REFERENCES client (id_client);

ALTER TABLE plata
ADD CONSTRAINT fk_id_rezervare_plata
FOREIGN KEY (id_rezervare) REFERENCES rezervare (id_rezervare);

ALTER TABLE client_serviciu
ADD CONSTRAINT fk_id_client_serviciu
FOREIGN KEY (id_client) REFERENCES client (id_client);

ALTER TABLE client_serviciu
ADD CONSTRAINT fk_id_serciviu
FOREIGN KEY (id_serviciu) REFERENCES serviciu (id_serviciu);

-- BD_CONSTANTA
ALTER TABLE hotel2
ADD CONSTRAINT fk_id_oras
FOREIGN KEY (id_oras) REFERENCES oras2 (id_oras);

ALTER TABLE camera2
ADD CONSTRAINT fk_id_hotel
FOREIGN KEY (id_hotel) REFERENCES hotel2 (id_hotel);

ALTER TABLE camera2
ADD CONSTRAINT fk_id_tip_camera
FOREIGN KEY (id_tip_camera) REFERENCES tip_camera (id_tip_camera);

ALTER TABLE rezervare_camera2
ADD CONSTRAINT fk_id_camera
FOREIGN KEY (id_camera) REFERENCES camera2 (id_camera);

ALTER TABLE rezervare_camera2
ADD CONSTRAINT fk_id_rezervare
FOREIGN KEY (id_rezervare) REFERENCES rezervare (id_rezervare);

-- ALTER TABLE angajat_salarizare
-- ADD CONSTRAINT fk_id_departament
-- FOREIGN KEY (id_departament) REFERENCES departament (id_departament);

ALTER TABLE rezervare
ADD CONSTRAINT fk_id_client
FOREIGN KEY (id_client) REFERENCES client (id_client);

ALTER TABLE plata
ADD CONSTRAINT fk_id_rezervare_plata
FOREIGN KEY (id_rezervare) REFERENCES rezervare (id_rezervare);

ALTER TABLE client_serviciu
ADD CONSTRAINT fk_id_client_serviciu
FOREIGN KEY (id_client) REFERENCES client (id_client);

ALTER TABLE client_serviciu
ADD CONSTRAINT fk_id_serciviu
FOREIGN KEY (id_serviciu) REFERENCES serviciu (id_serviciu);

-- =====================================================================
-- CONSTRANGERE DE VALIDARE
-- =====================================================================
-- BD_BUCURESTI
ALTER TABLE hotel1
ADD CONSTRAINT capacitate_pozitiva CHECK (capacitate > 0);
ALTER TABLE hotel1
ADD CONSTRAINT nr_stele CHECK (nr_stele >= 1 and nr_stele <= 5);

ALTER TABLE tip_camera
ADD CONSTRAINT pret_pozitiv CHECK (pret > 0);

ALTER TABLE serviciu
ADD CONSTRAINT pret_serviciu_pozitiv CHECK (pret_serviciu > 0);

-- constrangere la nivel global pe fragmente diferinte
-- managerul trebuie sa aiba salariu intre 5000 si 10000 lei
CREATE OR REPLACE TRIGGER trg_salariu_manager_identitate
BEFORE INSERT OR UPDATE ON angajat_identitate
FOR EACH ROW
DECLARE
    v_salariu NUMBER;
BEGIN
    IF :NEW.functie = 'Manager Hotel' THEN
        SELECT salariu INTO v_salariu
        FROM angajat_salarizare@bd_constanta
        WHERE id_angajat = :NEW.id_angajat;

        IF v_salariu > 10000 OR v_salariu < 5000 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Constrangere incalcata: managerul trebuie sa aiba salariul intre 5000 si 10000 lei!');
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/

-- TEST: inserare din fragment bucuresti
INSERT INTO angajat_salarizare@bd_constanta VALUES (100, 1000, 1);
INSERT INTO angajat_identitate VALUES (100, 'nume', 'prenume', 'Manager Hotel', 1);
SELECT * FROM angajat_salarizare@bd_constanta WHERE id_angajat = 100;
SELECT * FROM angajat_identitate WHERE id_angajat = 100;
ROLLBACK;

-- BD_CONSTANTA
ALTER TABLE hotel2
ADD CONSTRAINT capacitate_pozitiva CHECK (capacitate > 0);
ALTER TABLE hotel2
ADD CONSTRAINT nr_stele CHECK (nr_stele >= 1 and nr_stele <= 5);

ALTER TABLE angajat_salarizare
ADD CONSTRAINT salariu_pozitiv CHECK (salariu > 0);

ALTER TABLE tip_camera
ADD CONSTRAINT pret_pozitiv CHECK (pret > 0);

ALTER TABLE serviciu
ADD CONSTRAINT pret_serviciu_pozitiv CHECK (pret_serviciu > 0);

-- constrangere la nivel global pe fragmente diferinte
-- managerul trebuie sa aiba salariu intre 5000 si 10000 lei
CREATE OR REPLACE TRIGGER trg_salariu_manager_salarizare
BEFORE INSERT OR UPDATE ON angajat_salarizare
FOR EACH ROW
DECLARE
    v_functie VARCHAR2(200);
BEGIN
    SELECT functie INTO v_functie
    FROM angajat_identitate@bd_bucuresti
    WHERE id_angajat = :NEW.id_angajat;

    IF v_functie = 'Manager Hotel' AND (:NEW.salariu > 10000 OR :NEW.salariu < 5000) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Constrangere incalcata: managerul trebuie sa aiba salariul intre 5000 si 10000 lei!');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
END;
/

-- TEST: inserare din fragment constanta
INSERT INTO angajat_identitate@bd_bucuresti VALUES (100, 'nume', 'prenume', 'Manager Hotel', 1);
INSERT INTO angajat_salarizare VALUES (100, 1000, 1);
SELECT * FROM angajat_salarizare WHERE id_angajat = 100;
SELECT * FROM angajat_identitate@bd_bucuresti WHERE id_angajat = 100;
ROLLBACK;

-- TEST: inserare din view-ul global
INSERT INTO angajat_global
VALUES (100, 'nume', 'prenume', 'Manager Hotel', 90000, 1, NULL);
SELECT * FROM angajat_global WHERE id_angajat = 100;
SELECT * FROM bdd.angajat_identitate WHERE id_angajat = 100;
SELECT * FROM angajat_salarizare@bd_constanta WHERE id_angajat = 100;


-- =====================================================================
-- OPTIMIZARE CERERE SQL PROPUSA IN MODULUL DE ANALIZA
-- =====================================================================
-- cerere sql intiala:
--  Să afișeze primii 3 cei mai bine plătiți angajați din departamentul 'Spa & Wellness'.
--  Se va afisa numele, prenumele, funcția și poziția în clasament a angajatului.

SELECT *
FROM (SELECT
          ai.nume,
          ai.prenume,
          ai.functie,
          asz.salariu,
          d.nume_departament,
          DENSE_RANK() OVER (ORDER BY asz.salariu DESC) rank_salariu
      FROM bdd.angajat_identitate ai
               JOIN bdd.angajat_salarizare@bd_constanta asz ON asz.id_angajat = ai.id_angajat
               JOIN bdd.departament d ON asz.id_departament = d.id_departament
      WHERE d.nume_departament = 'Spa & Wellness')
WHERE rank_salariu <= 3;

-- A. plan intital optimizator regula
ALTER SESSION SET OPTIMIZER_MODE = RULE;

EXPLAIN PLAN SET STATEMENT_ID = 'plan_regula_angajat' FOR
SELECT *
FROM (SELECT
          ai.nume,
          ai.prenume,
          ai.functie,
          asz.salariu,
          d.nume_departament,
          DENSE_RANK() OVER (ORDER BY asz.salariu DESC) rank_salariu
      FROM bdd.angajat_identitate ai
               JOIN bdd.angajat_salarizare@bd_constanta asz ON asz.id_angajat = ai.id_angajat
               JOIN bdd.departament d ON asz.id_departament = d.id_departament
      WHERE d.nume_departament = 'Spa & Wellness')
WHERE rank_salariu <= 3;
SELECT plan_table_output
FROM table(dbms_xplan.display('PLAN_TABLE', 'plan_regula_angajat', 'SERIAL'));

-- B. plan intital optimizator cost
ANALYZE TABLE bdd.angajat_identitate COMPUTE STATISTICS; -- bd_bucuresti
ANALYZE TABLE bdd.departament COMPUTE STATISTICS; -- bd_bucuresti
ANALYZE TABLE bdd.angajat_salarizare COMPUTE STATISTICS; -- bd_constanta
ANALYZE TABLE bdd.departament COMPUTE STATISTICS; -- bd_constanta

ALTER SESSION SET OPTIMIZER_MODE = CHOOSE;

EXPLAIN PLAN SET STATEMENT_ID = 'plan_cost_angajat' FOR
SELECT /*+ ALL_ROWS */ *
FROM (SELECT
          ai.nume,
          ai.prenume,
          ai.functie,
          asz.salariu,
          d.nume_departament,
          DENSE_RANK() OVER (ORDER BY asz.salariu DESC) rank_salariu
      FROM bdd.angajat_identitate ai
               JOIN bdd.angajat_salarizare@bd_constanta asz ON asz.id_angajat = ai.id_angajat
               JOIN bdd.departament d ON asz.id_departament = d.id_departament
      WHERE d.nume_departament = 'Spa & Wellness')
WHERE rank_salariu <= 3;
SELECT * FROM TABLE(dbms_xplan.display('PLAN_TABLE', 'plan_cost_angajat', 'SERIAL'));

-- C. Optimizare:
-- C.1. optimizare cu index
CREATE INDEX index_nume_dep ON bdd.departament(nume_departament);

-- plan optimizator de cost cu index
EXPLAIN PLAN SET STATEMENT_ID = 'plan_cost_angajat_index' FOR
SELECT /*+ ALL_ROWS */ *
FROM (SELECT
          ai.nume,
          ai.prenume,
          ai.functie,
          asz.salariu,
          d.nume_departament,
          DENSE_RANK() OVER (ORDER BY asz.salariu DESC) rank_salariu
      FROM bdd.angajat_identitate ai
               JOIN bdd.angajat_salarizare@bd_constanta asz ON asz.id_angajat = ai.id_angajat
               JOIN bdd.departament d ON asz.id_departament = d.id_departament
      WHERE d.nume_departament = 'Spa & Wellness')
WHERE rank_salariu <= 3;
SELECT * FROM TABLE(dbms_xplan.display('PLAN_TABLE', 'plan_cost_angajat_index', 'SERIAL'));

