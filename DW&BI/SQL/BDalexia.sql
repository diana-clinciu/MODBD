-- =====================================================
-- Crearea tabelelor OLTP pentru gestionarea hotelului
-- =====================================================

create table eveniment (
   id_eveniment   number primary key,
   nume_eveniment varchar2(50) not null,
   data_eveniment date not null,
   descriere      varchar2(200)
);

create table client (
   id_client number primary key,
   nume      varchar2(30) not null,
   prenume   varchar2(30) not null,
   email     varchar2(50) unique
);

create table rezervare (
   id_rezervare   number primary key,
   id_client      number not null,
   data_rezervare date not null,
   foreign key ( id_client )
      references client ( id_client )
);

create table serviciu (
   id_serviciu        number primary key,
   denumire           varchar2(50) not null,
   pret_serviciu      number(10,2) not null,
   data_achizitionare date,
   cantitate          number
);

create table camera (
   id_camera  number primary key,
   nr_camera  number unique not null,
   tip_camera varchar2(20) not null,
   pret       number(10,2) not null
);

create table rezervare_camera (
   id_rezervare   number,
   id_camera      number,
   nr_nopti       number not null,
   pret_rezervare number(10,2) not null,
   primary key ( id_rezervare,
                 id_camera ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare ),
   foreign key ( id_camera )
      references camera ( id_camera )
);

create table client_serviciu (
   id_client      number,
   id_serviciu    number,
   data_utilizare date default sysdate,
   primary key ( id_client,
                 id_serviciu ),
   foreign key ( id_client )
      references client ( id_client ),
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2),
   data_plata   date not null,
   metoda_plata varchar2(20) check ( metoda_plata in ( 'Cash',
                                                       'Card',
                                                       'Transfer' ) ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare )
);

create table angajat (
   id_angajat  number primary key,
   nume        varchar2(30) not null,
   prenume     varchar2(30) not null,
   functie     varchar2(30),
   salariu     number(10,2),
   id_serviciu number not null,
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

create table eveniment_client (
   id_eveniment number,
   id_client    number,
   primary key ( id_eveniment,
                 id_client ),
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
    -- Obține id_client din rezervare
   select id_client
     into v_id_client
     from rezervare
    where id_rezervare = :new.id_rezervare;
    
    -- Calculează prețul rezervării (suma tuturor camerelor * nr_nopti)
   select nvl(
      sum(rc.pret_rezervare),
      0
   )
     into v_pret_rezervare
     from rezervare_camera rc
    where rc.id_rezervare = :new.id_rezervare;
    
    -- Calculează prețul serviciilor utilizate de client
   select nvl(
      sum(s.pret_serviciu),
      0
   )
     into v_pret_servicii
     from client_serviciu cs
     join serviciu s
   on cs.id_serviciu = s.id_serviciu
    where cs.id_client = v_id_client;
    
    -- Setează suma totală
   :new.suma := v_pret_rezervare + v_pret_servicii;
end;
/

-- Trigger pentru generarea automata a ID-ului client
CREATE SEQUENCE CLIENT_SEQ
  START WITH 11
  INCREMENT BY 1
  NOCACHE;

CREATE OR REPLACE TRIGGER CLIENT_ID
BEFORE INSERT ON CLIENT
FOR EACH ROW
BEGIN
  IF :NEW.ID_CLIENT IS NULL THEN
    SELECT CLIENT_SEQ.NEXTVAL 
    INTO :NEW.ID_CLIENT 
    FROM dual;
  END IF;
END;
/

-- Trigger pentru generarea automata a ID-ului rezervare
CREATE SEQUENCE REZERVARE_SEQ
  START WITH 11
  INCREMENT BY 1
  NOCACHE;

CREATE OR REPLACE TRIGGER REZERVARE_ID
BEFORE INSERT ON REZERVARE
FOR EACH ROW
BEGIN
  IF :NEW.ID_REZERVARE IS NULL THEN
    SELECT REZERVARE_SEQ.NEXTVAL INTO :NEW.ID_REZERVARE FROM dual;
  END IF;
END;
/

-- Trigger pentru generarea automata a ID-ului camera
CREATE SEQUENCE CAMERA_SEQ
  START WITH 11
  INCREMENT BY 1
  NOCACHE;

CREATE OR REPLACE TRIGGER CAMERA_ID
BEFORE INSERT ON CAMERA
FOR EACH ROW
BEGIN
  IF :NEW.ID_CAMERA IS NULL THEN
    SELECT CAMERA_SEQ.NEXTVAL INTO :NEW.ID_CAMERA FROM dual;
  END IF;
END;
/

-- =====================================================
-- Inserare date exemple
-- =====================================================

-- EVENIMENTE
insert into eveniment values ( 1,
                               'Concert Rock',
                               to_date('2025-12-01','YYYY-MM-DD'),
                               'Concert de rock cu trupe locale' );
insert into eveniment values ( 2,
                               'Festival Jazz',
                               to_date('2025-12-05','YYYY-MM-DD'),
                               'Festival de jazz internațional' );
insert into eveniment values ( 3,
                               'Gala de Revelion',
                               to_date('2025-12-31','YYYY-MM-DD'),
                               'Gala anuală de Revelion' );
insert into eveniment values ( 4,
                               'Team Building Corporativ',
                               to_date('2025-12-12','YYYY-MM-DD'),
                               'Eveniment pentru echipe corporative' );
insert into eveniment values ( 5,
                               'Expoziție de Artă',
                               to_date('2025-12-15','YYYY-MM-DD'),
                               'Expoziție de artă contemporană' );
insert into eveniment values ( 6,
                               'Petrecere de Crăciun',
                               to_date('2025-12-25','YYYY-MM-DD'),
                               'Petrecere tematică de Crăciun' );
insert into eveniment values ( 7,
                               'Seminar Business',
                               to_date('2025-12-18','YYYY-MM-DD'),
                               'Seminar pentru antreprenori' );
insert into eveniment values ( 8,
                               'Concert Clasic',
                               to_date('2025-12-20','YYYY-MM-DD'),
                               'Concert de muzică clasică' );
insert into eveniment values ( 9,
                               'Atelier Culinar',
                               to_date('2025-12-22','YYYY-MM-DD'),
                               'Atelier de gătit cu chef-ul hotelului' );
insert into eveniment values ( 10,
                               'Seară de Film',
                               to_date('2025-12-28','YYYY-MM-DD'),
                               'Proiecție de film pentru oaspeți' );

-- CLIENȚI
insert into client values ( 1,
                            'Popescu',
                            'Ana',
                            'ana.popescu@email.ro' );
insert into client values ( 2,
                            'Ionescu',
                            'Maria',
                            'maria.ionescu@email.ro' );
insert into client values ( 3,
                            'Georgescu',
                            'Ioana',
                            'ioana.georgescu@email.ro' );
insert into client values ( 4,
                            'Dumitrescu',
                            'Alina',
                            'alina.dumitrescu@email.ro' );
insert into client values ( 5,
                            'Radu',
                            'Cristina',
                            'cristina.radu@email.ro' );
insert into client values ( 6,
                            'Marin',
                            'Elena',
                            'elena.marin@email.ro' );
insert into client values ( 7,
                            'Stan',
                            'Gabriela',
                            'gabriela.stan@email.ro' );
insert into client values ( 8,
                            'Vasilescu',
                            'Laura',
                            'laura.vasilescu@email.ro' );
insert into client values ( 9,
                            'Niculae',
                            'Irina',
                            'irina.niculae@email.ro' );
insert into client values ( 10,
                            'Florea',
                            'Andreea',
                            'andreea.florea@email.ro' );

-- SERVICII
insert into serviciu values ( 1,
                              'Spa și Masaj Relaxant',
                              150,
                              to_date('2025-01-15','YYYY-MM-DD'),
                              10 );
insert into serviciu values ( 2,
                              'Room Service 24/7',
                              50,
                              to_date('2025-01-10','YYYY-MM-DD'),
                              20 );
insert into serviciu values ( 3,
                              'Masaj Terapeutic',
                              120,
                              to_date('2025-02-05','YYYY-MM-DD'),
                              8 );
insert into serviciu values ( 4,
                              'Acces Piscină Interioară',
                              40,
                              to_date('2025-01-20','YYYY-MM-DD'),
                              15 );
insert into serviciu values ( 5,
                              'Tur Ghidat București',
                              180,
                              to_date('2025-03-01','YYYY-MM-DD'),
                              5 );
insert into serviciu values ( 6,
                              'Transport Aeroport',
                              100,
                              to_date('2025-01-15','YYYY-MM-DD'),
                              10 );
insert into serviciu values ( 7,
                              'Curățenie Suplimentară',
                              60,
                              to_date('2025-01-10','YYYY-MM-DD'),
                              25 );
insert into serviciu values ( 8,
                              'Spălătorie Express',
                              45,
                              to_date('2025-02-10','YYYY-MM-DD'),
                              12 );
insert into serviciu values ( 9,
                              'Sală Fitness Premium',
                              80,
                              to_date('2025-01-25','YYYY-MM-DD'),
                              15 );
insert into serviciu values ( 10,
                              'Cinema Privat',
                              90,
                              to_date('2025-02-20','YYYY-MM-DD'),
                              6 );

-- CAMERE
insert into camera values ( 1,
                            101,
                            'Single',
                            150 );
insert into camera values ( 2,
                            102,
                            'Double',
                            250 );
insert into camera values ( 3,
                            103,
                            'Suite',
                            450 );
insert into camera values ( 4,
                            104,
                            'Single',
                            150 );
insert into camera values ( 5,
                            105,
                            'Double',
                            250 );
insert into camera values ( 6,
                            106,
                            'Suite Premium',
                            550 );
insert into camera values ( 7,
                            107,
                            'Single',
                            180 );
insert into camera values ( 8,
                            108,
                            'Double',
                            280 );
insert into camera values ( 9,
                            109,
                            'Suite Deluxe',
                            600 );
insert into camera values ( 10,
                            110,
                            'Double',
                            260 );

-- ANGAJAȚI
insert into angajat values ( 1,
                             'Popa',
                             'Andrei',
                             'Recepționer',
                             3500,
                             2 );
insert into angajat values ( 2,
                             'Ionescu',
                             'Mihai',
                             'Bucătar Șef',
                             4500,
                             2 );
insert into angajat values ( 3,
                             'Marin',
                             'Sorina',
                             'Ospătar',
                             3200,
                             2 );
insert into angajat values ( 4,
                             'Dumitru',
                             'Raluca',
                             'Masor Terapeut',
                             3800,
                             3 );
insert into angajat values ( 5,
                             'Stan',
                             'Vlad',
                             'Instructor Fitness',
                             3400,
                             9 );
insert into angajat values ( 6,
                             'Vasilescu',
                             'Ioan',
                             'Șofer',
                             3300,
                             6 );
insert into angajat values ( 7,
                             'Niculae',
                             'Elena',
                             'Recepționer Senior',
                             3800,
                             2 );
insert into angajat values ( 8,
                             'Florea',
                             'Cristina',
                             'Supervizor Curățenie',
                             3000,
                             7 );
insert into angajat values ( 9,
                             'Georgescu',
                             'Alin',
                             'Responsabil Spălătorie',
                             2900,
                             8 );
insert into angajat values ( 10,
                             'Radu',
                             'Laura',
                             'Ghid Turistic',
                             3200,
                             5 );

-- REZERVĂRI
insert into rezervare values ( 1,
                               1,
                               to_date('2025-12-01','YYYY-MM-DD') );
insert into rezervare values ( 2,
                               2,
                               to_date('2025-12-03','YYYY-MM-DD') );
insert into rezervare values ( 3,
                               3,
                               to_date('2025-12-05','YYYY-MM-DD') );
insert into rezervare values ( 4,
                               4,
                               to_date('2025-12-07','YYYY-MM-DD') );
insert into rezervare values ( 5,
                               5,
                               to_date('2025-12-10','YYYY-MM-DD') );
insert into rezervare values ( 6,
                               6,
                               to_date('2025-12-12','YYYY-MM-DD') );
insert into rezervare values ( 7,
                               7,
                               to_date('2025-12-15','YYYY-MM-DD') );
insert into rezervare values ( 8,
                               8,
                               to_date('2025-12-18','YYYY-MM-DD') );
insert into rezervare values ( 9,
                               9,
                               to_date('2025-12-20','YYYY-MM-DD') );
insert into rezervare values ( 10,
                               10,
                               to_date('2025-12-23','YYYY-MM-DD') );

-- REZERVARE_CAMERA 
insert into rezervare_camera values ( 1,
                                      1,
                                      3,
                                      450 );   -- 3 nopți × 150
insert into rezervare_camera values ( 2,
                                      2,
                                      2,
                                      500 );   -- 2 nopți × 250
insert into rezervare_camera values ( 3,
                                      3,
                                      1,
                                      450 );   -- 1 noapte × 450
insert into rezervare_camera values ( 4,
                                      4,
                                      4,
                                      600 );   -- 4 nopți × 150
insert into rezervare_camera values ( 5,
                                      5,
                                      2,
                                      500 );   -- 2 nopți × 250
insert into rezervare_camera values ( 6,
                                      6,
                                      3,
                                      1650 );  -- 3 nopți × 550
insert into rezervare_camera values ( 7,
                                      7,
                                      2,
                                      360 );   -- 2 nopți × 180
insert into rezervare_camera values ( 8,
                                      8,
                                      3,
                                      840 );   -- 3 nopți × 280
insert into rezervare_camera values ( 9,
                                      9,
                                      2,
                                      1200 );  -- 2 nopți × 600
insert into rezervare_camera values ( 10,
                                      10,
                                      4,
                                      1040 );-- 4 nopți × 260

-- CLIENT_SERVICIU  
insert into client_serviciu values ( 1,
                                     1,
                                     to_date('2025-12-02','YYYY-MM-DD') );  -- Spa
insert into client_serviciu values ( 2,
                                     2,
                                     to_date('2025-12-04','YYYY-MM-DD') );  -- Room Service
insert into client_serviciu values ( 3,
                                     3,
                                     to_date('2025-12-06','YYYY-MM-DD') );  -- Masaj
insert into client_serviciu values ( 4,
                                     4,
                                     to_date('2025-12-08','YYYY-MM-DD') );  -- Piscină
insert into client_serviciu values ( 5,
                                     5,
                                     to_date('2025-12-11','YYYY-MM-DD') );  -- Tur Ghidat
insert into client_serviciu values ( 6,
                                     6,
                                     to_date('2025-12-13','YYYY-MM-DD') );  -- Transport
insert into client_serviciu values ( 7,
                                     7,
                                     to_date('2025-12-16','YYYY-MM-DD') );  -- Curățenie
insert into client_serviciu values ( 8,
                                     8,
                                     to_date('2025-12-19','YYYY-MM-DD') );  -- Spălătorie
insert into client_serviciu values ( 9,
                                     9,
                                     to_date('2025-12-21','YYYY-MM-DD') );  -- Fitness
insert into client_serviciu values ( 10,
                                     10,
                                     to_date('2025-12-24','YYYY-MM-DD') );-- Cinema

-- PLATI (suma se calculează automat prin trigger)
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 1,
           1,
           to_date('2025-11-25','YYYY-MM-DD'),
           'Card' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 2,
           2,
           to_date('2025-11-28','YYYY-MM-DD'),
           'Cash' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 3,
           3,
           to_date('2025-12-01','YYYY-MM-DD'),
           'Transfer' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 4,
           4,
           to_date('2025-12-03','YYYY-MM-DD'),
           'Card' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 5,
           5,
           to_date('2025-12-06','YYYY-MM-DD'),
           'Card' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 6,
           6,
           to_date('2025-12-08','YYYY-MM-DD'),
           'Transfer' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 7,
           7,
           to_date('2025-12-11','YYYY-MM-DD'),
           'Cash' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 8,
           8,
           to_date('2025-12-14','YYYY-MM-DD'),
           'Card' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 9,
           9,
           to_date('2025-12-16','YYYY-MM-DD'),
           'Transfer' );
insert into plata (
   id_plata,
   id_rezervare,
   data_plata,
   metoda_plata
) values ( 10,
           10,
           to_date('2025-12-19','YYYY-MM-DD'),
           'Card' );

-- EVENIMENT_CLIENT
insert into eveniment_client values ( 1,
                                      1 );
insert into eveniment_client values ( 2,
                                      2 );
insert into eveniment_client values ( 3,
                                      3 );
insert into eveniment_client values ( 4,
                                      4 );
insert into eveniment_client values ( 5,
                                      5 );
insert into eveniment_client values ( 6,
                                      6 );
insert into eveniment_client values ( 7,
                                      7 );
insert into eveniment_client values ( 8,
                                      8 );
insert into eveniment_client values ( 9,
                                      9 );
insert into eveniment_client values ( 10,
                                      10 );

commit;

-- Verificare sume calculate automat
select p.id_plata,
       p.id_rezervare,
       p.suma as suma_calculata_automat,
       p.data_plata,
       p.metoda_plata
  from plata p
 order by p.id_plata;

select *
  from client;
select owner,
       table_name
  from all_tables
 where table_name in ( 'CLIENT',
                       'REZERVARE',
                       'CAMERA' );


-- =====================================================
-- Crearea tabelelor pentru depozitul de date (Data Warehouse)
-- =====================================================
-- Dimensiuni
-- 3. Crearea bazei de date depozit și a utilizatorilor 

-- DIM CLIENT: tabel de dimensiune pentru clienti
create table dim_client (
   client_key     number primary key,
   id_client_oltp number,
   nume           varchar2(30),
   prenume        varchar2(30),
   email          varchar2(50)
);

-- DIM CAMERA: tabel de dimensiune pentru camere
create table dim_camera (
   camera_key     number primary key,
   id_camera_oltp number,
   nr_camera      number,
   tip_camera     varchar2(20),
   pret           number(10,2)
);

-- DIM SERVICIU: tabel de dimensiune pentru servicii
create table dim_serviciu (
   serviciu_key     number primary key,
   id_serviciu_oltp number,
   denumire         varchar2(50),
   pret_serviciu    number(10,2)
);

-- DIM EVENIMENT: tabel de dimensiune pentru evenimente
create table dim_eveniment (
   eveniment_key     number primary key,
   id_eveniment_oltp number,
   nume_eveniment    varchar2(50),
   data_eveniment    date
);

-- DIM TIMP: tabel de dimensiune pentru timp
create table dim_timp (
   timp_key      number primary key,
   data_completa date,
   zi            number,
   luna          number,
   an            number
);

-- DIM METODA PLATA: tabel de dimensiune pentru metoda de plata
create table dim_metoda_plata (
   metoda_plata_key number primary key,
   metoda_plata     varchar2(20),
   tip_tranzactie   varchar2(30)
);

-- FACT: tabel de fapte pentru rezervari
create table fact_rezervari (
   rezervare_key     number primary key,
   id_rezervare_oltp number,
   client_key        number,
   camera_key        number,
   serviciu_key      number,
   eveniment_key     number,
   timp_key          number,
   metoda_plata_key  number,
   suma_totala       number(10,2),
   foreign key ( client_key )
      references dim_client ( client_key ),
   foreign key ( camera_key )
      references dim_camera ( camera_key ),
   foreign key ( serviciu_key )
      references dim_serviciu ( serviciu_key ),
   foreign key ( eveniment_key )
      references dim_eveniment ( eveniment_key ),
   foreign key ( timp_key )
      references dim_timp ( timp_key ),
   foreign key ( metoda_plata_key )
      references dim_metoda_plata ( metoda_plata_key )
);

-- =====================================================
-- Populare dimensiuni din OLTP
-- =====================================================

--4. Popularea cu informații a bazei de date depozit folosind ca sursă datele din baza de date OLTP
insert into dim_client
   select id_client,
          id_client,
          nume,
          prenume,
          email
     from client;

insert into dim_camera
   select id_camera,
          id_camera,
          nr_camera,
          tip_camera,
          pret
     from camera;

insert into dim_serviciu
   select id_serviciu,
          id_serviciu,
          denumire,
          pret_serviciu
     from serviciu;

insert into dim_eveniment
   select id_eveniment,
          id_eveniment,
          nume_eveniment,
          data_eveniment
     from eveniment;

-- Dimensiune timp pe baza datei rezervarii
insert into dim_timp
   select dense_rank()
          over(
       order by data_rezervare
          ),
          data_rezervare,
          extract(day from data_rezervare),
          extract(month from data_rezervare),
          extract(year from data_rezervare)
     from (
      select distinct data_rezervare
        from rezervare
   );

insert into dim_metoda_plata
   select dense_rank()
          over(
       order by metoda_plata
          ) as metoda_plata_key,
          metoda_plata,
          case
             when metoda_plata = 'Card'     then
                'Electronic'
             when metoda_plata = 'Transfer' then
                'Electronic'
             when metoda_plata = 'Cash'     then
                'Numerar'
          end as tip_tranzactie
     from (
      select distinct metoda_plata
        from plata
   );

-- Populare fact table
-- Se selecteaza datele din OLTP si se leaga cu dimensiunile prin subquery-uri
insert into fact_rezervari (
   rezervare_key,
   id_rezervare_oltp,
   client_key,
   camera_key,
   serviciu_key,
   eveniment_key,
   timp_key,
   metoda_plata_key,
   suma_totala
)
   select r.id_rezervare,                               -- Surrogate key
          r.id_rezervare,                               -- OLTP id

   -- client_key din dim_client
          (
             select client_key
               from dim_client d
              where d.id_client_oltp = r.id_client
          ),

   -- prima camera folosită în rezervare
          (
             select camera_key
               from dim_camera d
              where d.id_camera_oltp = (
                select rc.id_camera
                  from rezervare_camera rc
                 where rc.id_rezervare = r.id_rezervare
                 fetch first 1 rows only
             )
          ),

   -- primul serviciu folosit de client
          (
             select serviciu_key
               from dim_serviciu d
              where d.id_serviciu_oltp = (
                select cs.id_serviciu
                  from client_serviciu cs
                 where cs.id_client = r.id_client
                 fetch first 1 rows only
             )
          ),

   -- primul eveniment la care a participat clientul
          (
             select eveniment_key
               from dim_eveniment d
              where d.id_eveniment_oltp = (
                select ec.id_eveniment
                  from eveniment_client ec
                 where ec.id_client = r.id_client
                 fetch first 1 rows only
             )
          ),

   -- timp_key bazat pe data rezervarii
          (
             select timp_key
               from dim_timp dt
              where dt.data_completa = r.data_rezervare
          ),

   -- metoda_plata_key
          (
             select metoda_plata_key
               from dim_metoda_plata dmp
              where dmp.metoda_plata = (
                select p.metoda_plata
                  from plata p
                 where p.id_rezervare = r.id_rezervare
                 fetch first 1 rows only
             )
          ),

   -- suma totala (din plata)
          (
             select suma
               from plata p
              where p.id_rezervare = r.id_rezervare
              fetch first 1 rows only
          )
     from rezervare r;

-- =====================================================
-- Creare constrangeri suplimentare si indexuri
-- =====================================================

--5. Definirea constrângerilor
-- DIM CLIENT
alter table dim_client modify
   nume not null;
alter table dim_client modify
   prenume not null;

-- DIM CAMERA
alter table dim_camera modify
   tip_camera not null;
alter table dim_camera modify
   pret check ( pret > 0 );

-- DIM SERVICIU
alter table dim_serviciu modify
   pret_serviciu check ( pret_serviciu >= 0 );

-- DIM EVENIMENT
alter table dim_eveniment modify
   nume_eveniment not null;

-- DIM TIMP
alter table dim_timp modify
   zi check ( zi between 1 and 31 );
alter table dim_timp modify
   luna check ( luna between 1 and 12 );
alter table dim_timp modify
   an check ( an between 1900 and 2100 );

-- DIM METODA_PLATA
alter table dim_metoda_plata modify
   metoda_plata not null;

alter table dim_metoda_plata modify
   tip_tranzactie not null;

-- Indexuri pentru performanta la interogari
create index idx_dim_client_nume on
   dim_client (
      nume,
      prenume
   );
create index idx_dim_camera_tip on
   dim_camera (
      tip_camera
   );
create index idx_dim_serviciu_denumire on
   dim_serviciu (
      denumire
   );
create index idx_dim_eveniment_nume on
   dim_eveniment (
      nume_eveniment
   );
create index idx_dim_timp_data on
   dim_timp (
      data_completa
   );

create index idx_fact_client on
   fact_rezervari (
      client_key
   );
create index idx_fact_camera on
   fact_rezervari (
      camera_key
   );
create index idx_fact_serviciu on
   fact_rezervari (
      serviciu_key
   );
create index idx_fact_eveniment on
   fact_rezervari (
      eveniment_key
   );
create index idx_fact_timp on
   fact_rezervari (
      timp_key
   );

create index idx_dim_metoda_plata_metoda on
   dim_metoda_plata (metoda_plata);

create index idx_dim_metoda_plata_tip on
   dim_metoda_plata (tip_tranzactie);

-- Verificare suma_totala pozitiva
alter table fact_rezervari modify
   suma_totala check ( suma_totala >= 0 );

-- =====================================================
-- Verificari finale
-- =====================================================

select count(*)
  from dim_client;
select count(*)
  from dim_camera;
select count(*)
  from dim_serviciu;
select count(*)
  from dim_eveniment;
select count(*)
  from dim_timp;
select count(*)
  from fact_rezervari;