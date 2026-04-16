-- 1.
-- Creare useri si link BD EU
-- definire useri (trebuie creati cu userul sys)
-- user BD OLPT
CREATE USER bdd_all IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd_all;
ALTER USER bdd_all QUOTA UNLIMITED ON USERS;

-- user global
CREATE USER bdd_global IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd_global;
ALTER USER bdd_global QUOTA UNLIMITED ON USERS;

-- user local eu
CREATE USER bdd IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd;
ALTER USER bdd QUOTA UNLIMITED ON USERS;

-- definire link eu -> apac
GRANT CREATE PUBLIC DATABASE LINK TO bdd;

CREATE PUBLIC DATABASE LINK bd_apac
   CONNECT TO bdd IDENTIFIED BY password
   USING '(DESCRIPTION =
            (ADDRESS_LIST =
              (ADDRESS = (PROTOCOL = TCP)(HOST = oracle-apac)(PORT = 1521))
            )
            (CONNECT_DATA =
              (SERVICE_NAME = FREEPDB1)
            )
          )';

-- test
SELECT * FROM dual@bd_apac;

-- Create useri si link BD APAC
-- definire useri (creati cu sys)
-- user local apac
CREATE USER bdd IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO bdd;
ALTER USER bdd QUOTA UNLIMITED ON USERS;

-- definire link apac -> eu
GRANT CREATE PUBLIC DATABASE LINK TO bdd;

CREATE PUBLIC DATABASE LINK bd_eu
   CONNECT TO bdd IDENTIFIED BY password
   USING '(DESCRIPTION =
            (ADDRESS_LIST =
              (ADDRESS = (PROTOCOL = TCP)(HOST = oracle-eu)(PORT = 1521))
            )
            (CONNECT_DATA =
              (SERVICE_NAME = FREEPDB1)
            )
          )';

-- test
SELECT * FROM dual@bd_eu;


-- ============================================================================================
-- Crearea tabelelor OLTP pentru gestionarea hotelului (Baza de date centralizata, aflata pe EU)  -- create cu userul bdd_all
-- ============================================================================================
-- 1. CATALOG: TIP_CAMERA
create table tip_camera (
   id_tip_camera    number primary key,
   tip_camera       varchar2(20) not null,
   clasa_confort    varchar2(20) not null,
   categorie_camera varchar2(30) not null,
   pret             number(10,2) not null
);

-- 2. HOTEL
create table hotel (
   id_hotel    number primary key,
   nume_hotel  varchar2(50) not null,
   oras        varchar2(30) not null,
   nr_stele    number,
   capacitate  number
);

-- 3. CAMERA
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

-- 4. CATALOG: SERVICIU
create table serviciu (
   id_serviciu   number primary key,
   denumire      varchar2(50) not null,
   pret_serviciu number(10,2) not null
);

-- 5. DEPARTAMENT
create table departament (
   id_departament   number primary key,
   nume_departament varchar2(50) not null
);

-- 6. ANGAJAT
create table angajat (
   id_angajat     number primary key,
   nume           varchar2(30) not null,
   prenume        varchar2(30) not null,
   functie        varchar2(30),
   salariu        number(10,2),
   id_departament number not null,
   id_serviciu    number,
   foreign key ( id_departament )
      references departament ( id_departament ),
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

-- 7. CLIENT
create table client (
   id_client number primary key,
   nume      varchar2(30) not null,
   prenume   varchar2(30) not null,
   email     varchar2(50) unique
);

-- 8. REZERVARE
create table rezervare (
   id_rezervare number primary key,
   id_client    number not null,
   data_start   date not null,
   data_final   date not null,
   foreign key ( id_client )
      references client ( id_client ),
   constraint interal_data_valid check ( data_start <= data_final )
);

-- 9. REZERVARE_CAMERA
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

-- 10. CLIENT_SERVICIU
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

-- 11. PLATA
create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2),
   data_plata   date not null,
   metoda_plata varchar2(20) check ( metoda_plata in ( 'Cash', 'Card', 'Transfer' ) ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare )
);

-- 12. SALA_EVENIMENT
create table sala_eveniment (
   id_sala_eveniment number primary key,
   nume_sala         varchar2(50) not null,
   capacitate_maxima number not null,
   etaj              number
);

-- 13. EVENIMENT
create table eveniment (
   id_eveniment      number primary key,
   nume_eveniment    varchar2(50) not null,
   data_eveniment    date not null,
   descriere         varchar2(200),
   id_sala_eveniment number,
   foreign key ( id_sala_eveniment )
      references sala_eveniment ( id_sala_eveniment )
);

-- 14. EVENIMENT_CLIENT
create table eveniment_client (
   id_eveniment number,
   id_client    number,
   primary key ( id_eveniment, id_client ),
   foreign key ( id_eveniment )
      references eveniment ( id_eveniment ),
   foreign key ( id_client )
      references client ( id_client )
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

create sequence eveniment_seq start with 11 increment by 1 nocache;
create or replace trigger eveniment_id before insert on eveniment for each row begin if :new.id_eveniment is null then select eveniment_seq.nextval into :new.id_eveniment from dual; end if; end; /

create sequence tip_camera_seq start with 1 increment by 1 nocache;
create or replace trigger tip_camera_id before insert on tip_camera for each row begin if :new.id_tip_camera is null then select tip_camera_seq.nextval into :new.id_tip_camera from dual; end if; end; /

create sequence departament_seq start with 1 increment by 1 nocache;
create or replace trigger departament_id before insert on departament for each row begin if :new.id_departament is null then select departament_seq.nextval into :new.id_departament from dual; end if; end; /

create sequence sala_eveniment_seq start with 1 increment by 1 nocache;
create or replace trigger sala_eveniment_id before insert on sala_eveniment for each row begin if :new.id_sala_eveniment is null then select sala_eveniment_seq.nextval into :new.id_sala_eveniment from dual; end if; end; /


-- =====================================================
-- Inserare Date
-- =====================================================

-- DATE CATALOG: TIP_CAMERA
insert into tip_camera values ( 1, 'Single', 'Standard', 'Single Standard', 150 );
insert into tip_camera values ( 2, 'Double', 'Standard', 'Double Family', 250 );
insert into tip_camera values ( 3, 'Suite', 'Standard', 'Suite Economy', 450 );
insert into tip_camera values ( 4, 'Suite', 'Luxury', 'Suite Deluxe', 550 );
insert into tip_camera values ( 5, 'Double', 'Luxury', 'Double Royal', 600 );

-- HOTELURI
insert into hotel values ( 1, 'Grand Hotel Bucuresti', 'Bucuresti', 5, 200 );
insert into hotel values ( 2, 'Royal Hotel Constanta', 'Constanta', 4, 150 );

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
insert into angajat values ( 1, 'Popa', 'Andrei', 'Recepționer', 3500, 1, null );
insert into angajat values ( 2, 'Ionescu', 'Mihai', 'Bucătar Șef', 4500, 2, 2 );
insert into angajat values ( 3, 'Marin', 'Sorina', 'Ospătar', 3200, 2, 2 );
insert into angajat values ( 4, 'Dumitru', 'Raluca', 'Masor Terapeut', 3800, 3, 3 );
insert into angajat values ( 5, 'Stan', 'Vlad', 'Instructor Fitness', 3400, 3, 9 );
insert into angajat values ( 6, 'Vasilescu', 'Ioan', 'Șofer', 3300, 5, 6 );
insert into angajat values ( 7, 'Niculae', 'Elena', 'Recepționer Senior', 3800, 1, null );
insert into angajat values ( 8, 'Florea', 'Cristina', 'Supervizor Curățenie', 3000, 4, 7 );
insert into angajat values ( 9, 'Georgescu', 'Alin', 'Responsabil Spălătorie', 2900, 4, 8 );
insert into angajat values ( 10, 'Radu', 'Laura', 'Ghid Turistic', 3200, 5, 5 );

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

-- SALI_EVENIMENT
insert into sala_eveniment values (1, 'Grand Ballroom', 200, 1);
insert into sala_eveniment values (2, 'Sala de Conferinte A', 50, 2);
insert into sala_eveniment values (3, 'Sala Polivalenta', 100, 1);
insert into sala_eveniment values (4, 'Terasa RoofTop', 80, 5);

-- EVENIMENTE
insert into eveniment values ( 1, 'Concert Rock', to_date('2025-12-01','YYYY-MM-DD'), 'Concert de rock cu trupe locale', 1 );
insert into eveniment values ( 2, 'Festival Jazz', to_date('2025-12-05','YYYY-MM-DD'), 'Festival de jazz internațional', 4 );
insert into eveniment values ( 3, 'Gala de Revelion', to_date('2025-12-31','YYYY-MM-DD'), 'Gala anuală de Revelion', 1 );
insert into eveniment values ( 4, 'Team Building Corporativ', to_date('2025-12-12','YYYY-MM-DD'), 'Eveniment pentru echipe corporative', 2 );
insert into eveniment values ( 5, 'Expoziție de Artă', to_date('2025-12-15','YYYY-MM-DD'), 'Expoziție de artă contemporană', 3 );
insert into eveniment values ( 6, 'Petrecere de Crăciun', to_date('2025-12-25','YYYY-MM-DD'), 'Petrecere tematică de Crăciun', 1 );
insert into eveniment values ( 7, 'Seminar Business', to_date('2025-12-18','YYYY-MM-DD'), 'Seminar pentru antreprenori', 2 );
insert into eveniment values ( 8, 'Concert Clasic', to_date('2025-12-20','YYYY-MM-DD'), 'Concert de muzică clasică', 1 );
insert into eveniment values ( 9, 'Atelier Culinar', to_date('2025-12-22','YYYY-MM-DD'), 'Atelier de gătit cu chef-ul hotelului', 3 );
insert into eveniment values ( 10, 'Seară de Film', to_date('2025-12-28','YYYY-MM-DD'), 'Proiecție de film pentru oaspeți', 4 );

-- EVENIMENT_CLIENT
insert into eveniment_client values ( 1, 1 );
insert into eveniment_client values ( 2, 2 );
insert into eveniment_client values ( 3, 3 );
insert into eveniment_client values ( 4, 4 );
insert into eveniment_client values ( 5, 5 );
insert into eveniment_client values ( 6, 6 );
insert into eveniment_client values ( 7, 7 );
insert into eveniment_client values ( 8, 8 );
insert into eveniment_client values ( 9, 9 );
insert into eveniment_client values ( 10, 10 );

commit;

-- Verificari finale
select p.id_plata, p.id_rezervare, p.suma as suma_calculata_automat, p.data_plata, p.metoda_plata
  from plata p
 order by p.id_plata;

 


 -- =====================================================================
-- Crearea fragmentelor orizontale
-- =====================================================================

-- Fragment Orizontal HOTEL1 - creat pe EU (user bdd)
CREATE TABLE hotel1 AS
SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate
FROM bdd_all.hotel
WHERE oras = 'Bucuresti';

GRANT SELECT, INSERT, UPDATE, DELETE ON hotel1 TO bdd_global;

-- Fragment Orizontal HOTEL2 - creat pe APAC (user bdd)
CREATE TABLE hotel2 AS
SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate
FROM bdd_all.hotel@bd_eu
WHERE oras = 'Constanta';

-- Fragment Derivat CAMERA1 - creat pe EU (user bdd)
CREATE TABLE camera1 AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel
FROM bdd_all.camera
WHERE id_hotel = 1;

GRANT SELECT, INSERT, UPDATE, DELETE ON camera1 TO bdd_global;

-- Fragment Derivat CAMERA2 - creat pe APAC (user bdd)
CREATE TABLE camera2 AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel
FROM bdd_all.camera@bd_eu
WHERE id_hotel = 2;

-- =====================================================================
-- Transparenta pentru fragmentele orizontale (EU-bdd_global)
-- =====================================================================

-- VIEW global care reconstituie HOTEL
CREATE OR REPLACE VIEW hotel_global AS
SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate FROM bdd.hotel1
UNION ALL
SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate FROM bdd.hotel2@bd_apac;

SELECT * FROM hotel_global ORDER BY id_hotel;

-- Triggere INSTEAD OF pe hotel_global
CREATE OR REPLACE TRIGGER trg_hotel_global_ins
INSTEAD OF INSERT ON hotel_global
FOR EACH ROW
BEGIN
   IF :NEW.oras = 'Bucuresti' THEN
      INSERT INTO bdd.hotel1 (id_hotel, nume_hotel, oras, nr_stele, capacitate)
      VALUES (:NEW.id_hotel, :NEW.nume_hotel, :NEW.oras, :NEW.nr_stele, :NEW.capacitate);
   ELSIF :NEW.oras = 'Constanta' THEN
      INSERT INTO bdd.hotel2@bd_apac (id_hotel, nume_hotel, oras, nr_stele, capacitate)
      VALUES (:NEW.id_hotel, :NEW.nume_hotel, :NEW.oras, :NEW.nr_stele, :NEW.capacitate);
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_hotel_global_upd
INSTEAD OF UPDATE ON hotel_global
FOR EACH ROW
BEGIN
   IF :OLD.oras = 'Bucuresti' THEN
      UPDATE bdd.hotel1
      SET nume_hotel = :NEW.nume_hotel, oras = :NEW.oras,
          nr_stele = :NEW.nr_stele, capacitate = :NEW.capacitate
      WHERE id_hotel = :OLD.id_hotel;
   ELSIF :OLD.oras = 'Constanta' THEN
      UPDATE bdd.hotel2@bd_apac
      SET nume_hotel = :NEW.nume_hotel, oras = :NEW.oras,
          nr_stele = :NEW.nr_stele, capacitate = :NEW.capacitate
      WHERE id_hotel = :OLD.id_hotel;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_hotel_global_del
INSTEAD OF DELETE ON hotel_global
FOR EACH ROW
BEGIN
   IF :OLD.oras = 'Bucuresti' THEN
      DELETE FROM bdd.hotel1 WHERE id_hotel = :OLD.id_hotel;
   ELSIF :OLD.oras = 'Constanta' THEN
      DELETE FROM bdd.hotel2@bd_apac WHERE id_hotel = :OLD.id_hotel;
   END IF;
END;
/

-- Test INSERT prin view + rollback
INSERT INTO hotel_global VALUES (3, 'Test Hotel', 'Bucuresti', 3, 80);
SELECT * FROM hotel_global ORDER BY id_hotel;
ROLLBACK;

-- VIEW global care reconstituie CAMERA
CREATE OR REPLACE VIEW camera_global AS
SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM bdd.camera1
UNION ALL
SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM bdd.camera2@bd_apac;

SELECT * FROM camera_global ORDER BY id_camera;

-- Triggere INSTEAD OF pe camera_global
CREATE OR REPLACE TRIGGER trg_camera_global_ins
INSTEAD OF INSERT ON camera_global
FOR EACH ROW
BEGIN
   IF :NEW.id_hotel = 1 THEN
      INSERT INTO bdd.camera1 (id_camera, nr_camera, id_tip_camera, id_hotel)
      VALUES (:NEW.id_camera, :NEW.nr_camera, :NEW.id_tip_camera, :NEW.id_hotel);
   ELSIF :NEW.id_hotel = 2 THEN
      INSERT INTO bdd.camera2@bd_apac (id_camera, nr_camera, id_tip_camera, id_hotel)
      VALUES (:NEW.id_camera, :NEW.nr_camera, :NEW.id_tip_camera, :NEW.id_hotel);
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_camera_global_upd
INSTEAD OF UPDATE ON camera_global
FOR EACH ROW
BEGIN
   IF :OLD.id_hotel = 1 THEN
      UPDATE bdd.camera1
      SET nr_camera = :NEW.nr_camera, id_tip_camera = :NEW.id_tip_camera,
          id_hotel = :NEW.id_hotel
      WHERE id_camera = :OLD.id_camera;
   ELSIF :OLD.id_hotel = 2 THEN
      UPDATE bdd.camera2@bd_apac
      SET nr_camera = :NEW.nr_camera, id_tip_camera = :NEW.id_tip_camera,
          id_hotel = :NEW.id_hotel
      WHERE id_camera = :OLD.id_camera;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_camera_global_del
INSTEAD OF DELETE ON camera_global
FOR EACH ROW
BEGIN
   IF :OLD.id_hotel = 1 THEN
      DELETE FROM bdd.camera1 WHERE id_camera = :OLD.id_camera;
   ELSIF :OLD.id_hotel = 2 THEN
      DELETE FROM bdd.camera2@bd_apac WHERE id_camera = :OLD.id_camera;
   END IF;
END;
/

-- Test INSERT prin view + rollback
INSERT INTO camera_global VALUES (11, 111, 1, 1);
SELECT * FROM camera_global ORDER BY id_camera;
ROLLBACK;

-- =====================================================================
-- Transparenta pentru tabelele stocate in alta baza de date (APAC-bdd)
-- =====================================================================

-- Sinonime pe APAC pentru acces transparent la fragmentele de pe EU
CREATE OR REPLACE SYNONYM hotel1 FOR bdd.hotel1@bd_eu;
CREATE OR REPLACE SYNONYM camera1 FOR bdd.camera1@bd_eu;

-- Verificare
SELECT * FROM hotel1;
SELECT * FROM camera1;