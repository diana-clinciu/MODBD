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
   data_start date not null,
   data_final date not null,
   foreign key ( id_client )
      references client ( id_client ),
   constraint interal_data_valid check ( data_start <= data_final )
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
   categorie_camera varchar2(20) not null,
   clasa_confort varchar2(20) not null,
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
create sequence client_seq start with 11 increment by 1 nocache;

create or replace trigger client_id before
   insert on client
   for each row
begin
   if :new.id_client is null then
      select client_seq.nextval
        into :new.id_client
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului rezervare
create sequence rezervare_seq start with 11 increment by 1 nocache;

create or replace trigger rezervare_id before
   insert on rezervare
   for each row
begin
   if :new.id_rezervare is null then
      select rezervare_seq.nextval
        into :new.id_rezervare
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului camera
create sequence camera_seq start with 11 increment by 1 nocache;

create or replace trigger camera_id before
   insert on camera
   for each row
begin
   if :new.id_camera is null then
      select camera_seq.nextval
        into :new.id_camera
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului serviciu
create sequence serviciu_seq start with 11 increment by 1 nocache;

create or replace trigger serviciu_id before
   insert on serviciu
   for each row
begin
   if :new.id_serviciu is null then
      select serviciu_seq.nextval
        into :new.id_serviciu
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului plata
create sequence plata_seq start with 11 increment by 1 nocache;

create or replace trigger plata_id before
   insert on plata
   for each row
begin
   if :new.id_plata is null then
      select plata_seq.nextval
        into :new.id_plata
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului angajat
create sequence angajat_seq start with 11 increment by 1 nocache;

create or replace trigger angajat_id before
   insert on angajat
   for each row
begin
   if :new.id_angajat is null then
      select angajat_seq.nextval
        into :new.id_angajat
        from dual;
   end if;
end;
/

-- Trigger pentru generarea automata a ID-ului eveniment
create sequence eveniment_seq start with 11 increment by 1 nocache;

create or replace trigger eveniment_id before
   insert on eveniment
   for each row
begin
   if :new.id_eveniment is null then
      select eveniment_seq.nextval
        into :new.id_eveniment
        from dual;
   end if;
end;
/

create sequence timp_seq start with 1 increment by 1 nocache
nocycle;
/

create sequence metoda_plata_seq start with 1 increment by 1 nocache
nocycle;
/
-- =====================================================
-- Inserare date
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
                           'Basic',
                           'Standard',
                            150 );
insert into camera values ( 2,
                            102,
                            'Double',
                           'Family',
                           'Standard',
                            250 );
insert into camera values ( 3,
                            103,
                            'Suite',
                           'Economy',
                           'Standard',
                            450 );
insert into camera values ( 4,
                            104,
                            'Single',
                           'Basic',
                           'Standard',
                            150 );
insert into camera values ( 5,
                            105,
                            'Double',
                           'Family',
                           'Standard',
                            250 );
insert into camera values ( 6,
                            106,
                            'Suite',
                           'Deluxe',
                           'Luxury',
                            550 );
insert into camera values ( 7,
                            107,
                            'Single',
                           'Deluxe',
                           'Luxury',
                            180 );
insert into camera values ( 8,
                            108,
                            'Double',
                           'Royal',
                           'Luxury',
                            280 );
insert into camera values ( 9,
                            109,
                            'Suite',
                           'Royal',
                           'Luxury',
                            600 );
insert into camera values ( 10,
                            110,
                            'Double',
                           'Deluxe',
                           'Luxury',
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
                               to_date('2025-12-01','YYYY-MM-DD'),
                               to_date('2025-12-07','YYYY-MM-DD') );
insert into rezervare values ( 2,
                               2,
                               to_date('2025-12-03','YYYY-MM-DD'),
                               to_date('2025-12-10','YYYY-MM-DD') );
insert into rezervare values ( 3,
                               3,
                               to_date('2025-12-05','YYYY-MM-DD'),
                               to_date('2025-12-07','YYYY-MM-DD') );
insert into rezervare values ( 4,
                               4,
                               to_date('2025-12-07','YYYY-MM-DD'),
                               to_date('2025-12-14','YYYY-MM-DD') );
insert into rezervare values ( 5,
                               5,
                               to_date('2025-12-10','YYYY-MM-DD'),
                               to_date('2025-12-14','YYYY-MM-DD') );
insert into rezervare values ( 6,
                               6,
                               to_date('2025-12-12','YYYY-MM-DD'),
                               to_date('2025-12-21','YYYY-MM-DD') );
insert into rezervare values ( 7,
                               7,
                               to_date('2025-12-15','YYYY-MM-DD'),
                               to_date('2025-12-20','YYYY-MM-DD') );
insert into rezervare values ( 8,
                               8,
                               to_date('2025-12-18','YYYY-MM-DD'),
                               to_date('2025-12-23','YYYY-MM-DD') );
insert into rezervare values ( 9,
                               9,
                               to_date('2025-12-20','YYYY-MM-DD'),
                               to_date('2025-12-30','YYYY-MM-DD') );
insert into rezervare values ( 10,
                               10,
                               to_date('2025-12-23','YYYY-MM-DD'),
                               to_date('2025-12-28','YYYY-MM-DD') );

-- REZERVARE_CAMERA
insert into rezervare_camera values (1,
                                     1,
                                     6,
                                     900); -- 6 nopți * 150
insert into rezervare_camera values (2,
                                     2,
                                     7,
                                     1750); -- 7 nopți * 250
insert into rezervare_camera values (3,
                                     3,
                                     2,
                                     900); -- 2 nopți * 450
insert into rezervare_camera values (4,
                                     4,
                                     7,
                                     1050); -- 7 nopți * 150
insert into rezervare_camera values (5,
                                     5,
                                     4,
                                     1000); -- 4 nopți * 250
insert into rezervare_camera values (6,
                                     6,
                                     9,
                                     4950); -- 9 nopți * 550
insert into rezervare_camera values (7,
                                     7,
                                     5,
                                     900); -- 5 nopți * 180
insert into rezervare_camera values (8,
                                     8,
                                     5,
                                     1400); -- 5 nopți * 280
insert into rezervare_camera values (9,
                                     9,
                                     10,
                                     6000); -- 10 nopți * 600
insert into rezervare_camera values (10,
                                     10,
                                     5,
                                     1300); -- 5 nopți * 260

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
   id_client_dim     number primary key,
   id_client_oltp number,
   nume           varchar2(30),
   prenume        varchar2(30),
   email          varchar2(50)
);

-- DIM CAMERA: tabel de dimensiune pentru camere
create table dim_camera (
   id_camera_dim     number primary key,
   id_camera_oltp number,
   nr_camera      number,
   tip_camera     varchar2(20),
   categorie_camera varchar2(20),
   clasa_confort varchar2(20),
   pret           number(10,2)
);

-- DIM SERVICIU: tabel de dimensiune pentru servicii
create table dim_serviciu (
   id_serviciu_dim     number primary key,
   id_serviciu_oltp number,
   denumire         varchar2(50),
   pret_serviciu    number(10,2)
);

-- DIM EVENIMENT: tabel de dimensiune pentru evenimente
create table dim_eveniment (
   id_eveniment_dim     number primary key,
   id_eveniment_oltp number,
   nume_eveniment    varchar2(50),
   data_eveniment    date
);

-- DIM TIMP: tabel de dimensiune pentru timp
create table dim_timp (
   --id_timp_dim      number primary key,
   data_completa date primary key,
   zi            number,
   luna          number,
   an            number,
   luna_an       varchar2(20)
);

-- DIM METODA PLATA: tabel de dimensiune pentru metoda de plata
create table dim_metoda_plata (
   id_metoda_plata_dim number primary key,
   metoda_plata     varchar2(20),
   tip_tranzactie   varchar2(30)
);

-- FACT: tabel de fapte pentru rezervari
create table fact_rezervari (
   id_rezervare         number primary key,
   id_rezervare_oltp    number,
   id_client_dim        number,
   id_camera_dim        number,
   id_serviciu_dim      number,
   id_eveniment_dim     number,
   id_data_start        date,
   id_data_final        date,
   id_metoda_plata_dim  number,
   suma_totala          number(10,2),
   foreign key ( id_client_dim )
      references dim_client ( id_client_dim ),
   foreign key ( id_camera_dim )
      references dim_camera ( id_camera_dim ),
   foreign key ( id_serviciu_dim )
      references dim_serviciu ( id_serviciu_dim ),
   foreign key ( id_eveniment_dim )
      references dim_eveniment ( id_eveniment_dim ),
   foreign key ( id_data_start )
      references dim_timp ( data_completa ),
   foreign key ( id_data_final )
      references dim_timp ( data_completa ),
   foreign key ( id_metoda_plata_dim )
      references dim_metoda_plata ( id_metoda_plata_dim )
);

-- Ajustare cheie primara pentru FACT_REZERVARI, deoarece granularitatea tabelului de fapte este
-- REZERVARE – CAMERA, o rezervare poate aparea de mai multe ori in fact table.
-- Cheia primara este definita ca fiind compusa din id-ul rezervarii din OLTP si cheia camerei,
-- asigurand unicitatea fiecarui rand.
alter table fact_rezervari drop primary key;

alter table fact_rezervari
add constraint pk_fact_rezervari
primary key (id_rezervare_oltp, id_camera_dim);

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
          categorie_camera,
          clasa_confort,
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
INSERT INTO dim_timp
SELECT
    data_completa,
    extract(day from data_completa)     AS zi,
    EXTRACT(MONTH FROM data_completa)   AS luna,
    EXTRACT(YEAR FROM data_completa)    AS an,
    TO_CHAR(data_completa, 'YYYYMM')    AS luna_an
FROM (
    SELECT data_start as data_completa
      FROM rezervare
    UNION
    SELECT data_final as data_completa
      FROM rezervare
);

insert into dim_metoda_plata
   select dense_rank()
          over(
       order by metoda_plata
          ) as id_metoda_plata_dim,
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

-- Populare tabel de fapte FACT_REZERVARI
-- Granularitate: o linie pentru fiecare combinatie: REZERVARE – CAMERA.
-- Pentru fiecare rezervare se insereaza cate un rand pentru fiecare camera asociata rezervarii.
-- Aceasta abordare permite analiza veniturilor in functie de camera, tip camera si perioada de timp.
insert into fact_rezervari (
   id_rezervare,
   id_rezervare_oltp,
   id_client_dim,
   id_camera_dim,
   id_data_start,
   id_data_final,
   id_metoda_plata_dim,
   suma_totala
)
select
   r.id_rezervare,
   r.id_rezervare,
   dc.id_client_dim,
   dcam.id_camera_dim,
   dt_start.data_completa,
   dt_final.data_completa,
   dmp.id_metoda_plata_dim,
   rc.pret_rezervare
from rezervare r
join dim_client dc
   on dc.id_client_oltp = r.id_client
join rezervare_camera rc
   on rc.id_rezervare = r.id_rezervare
join dim_camera dcam
   on dcam.id_camera_oltp = rc.id_camera
join dim_timp dt_start
   on dt_start.data_completa = r.data_start
join dim_timp dt_final
   on dt_final.data_completa = r.data_final
join plata p
   on p.id_rezervare = r.id_rezervare
join dim_metoda_plata dmp
   on dmp.metoda_plata = p.metoda_plata;


BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => USER,
        tabname => 'FACT_REZERVARI',
        cascade => TRUE,
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
    );
    DBMS_STATS.GATHER_TABLE_STATS(ownname => USER, tabname => 'DIM_TIMP', cascade => TRUE);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => USER, tabname => 'DIM_CAMERA', cascade => TRUE);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => USER, tabname => 'DIM_METODA_PLATA', cascade => TRUE);
    DBMS_STATS.GATHER_TABLE_STATS(ownname => USER, tabname => 'DIM_CLIENT', cascade => TRUE);
END;
/

-- =====================================================
-- Creare constrangeri suplimentare si indexuri
-- =====================================================

--5. Definirea constrângerilor
-- DIM CLIENT
alter table dim_client modify
   nume not null;
alter table dim_client modify
   prenume not null;

-- Un client OLTP nu poate aparea de mai multe ori in dim_client
alter table dim_client
add constraint uq_dim_client_oltp
unique (id_client_oltp);

-- DIM CAMERA
alter table dim_camera modify
   tip_camera not null;
alter table dim_camera modify
   pret check ( pret > 0 );

-- O camera OLTP nu poate aparea de mai multe ori in dim_camera
alter table dim_camera
add constraint uq_dim_camera_oltp
unique (id_camera_oltp);

-- DIM SERVICIU
alter table dim_serviciu modify
   pret_serviciu check ( pret_serviciu >= 0 );

alter table dim_serviciu
add constraint uq_dim_serviciu_oltp
unique (id_serviciu_oltp);

-- DIM EVENIMENT
alter table dim_eveniment modify
   nume_eveniment not null;

alter table dim_eveniment
add constraint uq_dim_eveniment_oltp
unique (id_eveniment_oltp);

-- Doua evenimente nu pot avea acelasi nume si aceeasi data
alter table dim_eveniment
add constraint uq_dim_eveniment_nume_data
unique (nume_eveniment, data_eveniment);

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

-- O metoda de plata apare o singura data in dim_metoda_plata
alter table dim_metoda_plata
add constraint uq_dim_metoda_plata
unique (metoda_plata);

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

-- EXERCITII REFACUTE:

-- 6.
-- Indecsi BITMAP pe cheile externe din tabela de fapte:
ALTER SESSION SET STAR_TRANSFORMATION_ENABLED = TRUE;

CREATE BITMAP INDEX bmp_fk_rezervari_clienti
ON fact_rezervari(id_client_dim);
ANALYZE INDEX bmp_fk_rezervari_clienti
COMPUTE STATISTICS;

-- cost fara index = 115
-- cost cu index = 33
EXPLAIN PLAN
SET STATEMENT_ID = 'ex_6'
FOR
SELECT
    dcl.nume  || ' ' || dcl.prenume as client,
    DECODE(GROUPING(dc.clasa_confort), 1, 'Toate clasele de confort', dc.clasa_confort) AS clasa_confort,
    DECODE(GROUPING(dc.categorie_camera), 1, 'Toate categoriile de camera', dc.categorie_camera) AS categorie_camera,
    TO_CHAR(SUM(fr.suma_totala) / NULLIF(SUM(fr.id_data_final - fr.id_data_start), 0), 'FM999G999G990D00') AS venit_mediu_pe_noapte,
    SUM(fr.suma_totala) AS total_incasari,
    SUM(fr.id_data_final - fr.id_data_start) AS total_nopti_ocupate
FROM
    fact_rezervari fr
JOIN dim_camera dc ON fr.id_camera_dim = dc.id_camera_dim
JOIN dim_client dcl ON fr.id_client_dim = dcl.id_client_dim
WHERE
      dcl.id_client_dim = 15
GROUP BY
    ROLLUP (dc.clasa_confort, dc.categorie_camera), dcl.nume, dcl.prenume;

-- afisare plan executie
SELECT *
FROM
table(dbms_xplan.display('plan_table', 'ex_6','serial'));

-- 7.
GRANT CREATE DIMENSION, CREATE MATERIALIZED VIEW, QUERY REWRITE TO DIANA;

-- clasa confort "Luxury" are categoriile de camere: "Deluxe", "Royal"
-- clasa confort "Standard" are categoriile de camere: "Basic", "Economy", "Family"
CREATE DIMENSION dim_camera_obj
   LEVEL camera             IS dim_camera.id_camera_dim
   LEVEL categorie          IS dim_camera.categorie_camera
   LEVEL clasa_confort      IS dim_camera.clasa_confort

   ATTRIBUTE camera        DETERMINES (dim_camera.id_camera_oltp, dim_camera.nr_camera, dim_camera.tip_camera, dim_camera.pret)
   ATTRIBUTE categorie     DETERMINES (dim_camera.categorie_camera)
   ATTRIBUTE clasa_confort DETERMINES (dim_camera.clasa_confort)

   HIERARCHY camera_rollup (
      camera        CHILD OF
      categorie     CHILD OF
      clasa_confort
   );

-- validare obiect dimensiune camera
CALL DBMS_DIMENSION.VALIDATE_DIMENSION(UPPER('dim_camera_obj'), FALSE, TRUE, 'st_dim_camera_obj');
SELECT * FROM DIMENSION_EXCEPTIONS WHERE STATEMENT_ID = 'st_dim_camera_obj'; -- zero exceptii == e valid

CREATE DIMENSION dim_timp_obj
   LEVEL zi    IS dim_timp.data_completa
   LEVEL luna  IS dim_timp.luna_an
   LEVEL an    IS dim_timp.an

   ATTRIBUTE zi DETERMINES (dim_timp.zi, dim_timp.data_completa)
   ATTRIBUTE luna DETERMINES (dim_timp.luna)
   ATTRIBUTE an DETERMINES (dim_timp.an)

   HIERARCHY timp_rollup (
      zi    CHILD OF
      luna  CHILD OF
      an
   );

-- validare obiect dimensiune timp
CALL DBMS_DIMENSION.VALIDATE_DIMENSION(UPPER('dim_timp_obj'), FALSE, TRUE, 'st_dim_timp_obj');
SELECT * FROM DIMENSION_EXCEPTIONS WHERE STATEMENT_ID = 'st_dim_timp_obj'; -- zero exceptii == e valid

-- toate obiectele dimensiune definite
SELECT dimension_name FROM user_dimensions;


-- 8.
CREATE TABLE fact_rezervari_part (
   id_rezervare         NUMBER PRIMARY KEY,
   id_rezervare_oltp    NUMBER,
   id_client_dim        NUMBER,
   id_camera_dim        NUMBER,
   id_serviciu_dim      NUMBER,
   id_eveniment_dim     NUMBER,
   id_data_start        DATE NOT NULL,
   id_data_final        DATE NOT NULL,
   id_metoda_plata_dim  NUMBER,
   suma_totala          NUMBER(10,2),

   CONSTRAINT fk_dim_client FOREIGN KEY (id_client_dim)
      REFERENCES dim_client (id_client_dim),
   CONSTRAINT fk_dim_camera FOREIGN KEY (id_camera_dim)
      REFERENCES dim_camera (id_camera_dim),
   CONSTRAINT fk_dim_serviciu FOREIGN KEY (id_serviciu_dim)
      REFERENCES dim_serviciu (id_serviciu_dim),
   CONSTRAINT fk_dim_eveniment FOREIGN KEY (id_eveniment_dim)
      REFERENCES dim_eveniment (id_eveniment_dim),
   CONSTRAINT fk_dim_data_start FOREIGN KEY (id_data_start)
      REFERENCES dim_timp (data_completa),
   CONSTRAINT fk_dim_data_final FOREIGN KEY (id_data_final)
      REFERENCES dim_timp (data_completa),
   CONSTRAINT fk_dim_metoda_plata FOREIGN KEY (id_metoda_plata_dim)
      REFERENCES dim_metoda_plata (id_metoda_plata_dim)
)
PARTITION BY RANGE (id_data_start) (
   PARTITION p_timp_ani_anteriori VALUES LESS THAN (date '2023-01-01'),
   PARTITION p_timp_2023 VALUES LESS THAN (date '2024-01-01'),
   PARTITION p_timp_2024 VALUES LESS THAN (date '2025-01-01'),
   PARTITION p_timp_2025 VALUES LESS THAN (date '2026-01-01')
);
insert into fact_rezervari_part  (select * from fact_rezervari);

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
    ownname => USER,
    tabname => 'FACT_REZERVARI_PART',
    cascade => TRUE
  );
  DBMS_STATS.SET_TABLE_STATS(
    ownname => USER,
    tabname => 'FACT_REZERVARI_PART',
    numrows => 10000000,
    numblks => 150000,
    avgrlen => 100
  );
  DBMS_STATS.SET_TABLE_STATS(
    ownname => USER,
    tabname => 'FACT_REZERVARI',
    numrows => 10000000,
    numblks => 150000,
    avgrlen => 100
  );
END;
/

EXPLAIN PLAN SET STATEMENT_ID = 'ex_8_part' FOR
WITH Rezervari AS (
    SELECT
        dc.id_client_dim,
        dc.nume || ' ' || dc.prenume AS nume_client,
        fr.id_data_start AS data_checkin,
        SUM(fr.suma_totala) AS total_sejur
    FROM fact_rezervari_part fr
    JOIN dim_client dc ON fr.id_client_dim = dc.id_client_dim
    WHERE id_data_start BETWEEN date '2025-01-01' AND date '2025-12-31'
    GROUP BY fr.id_rezervare_oltp, dc.id_client_dim, dc.nume, dc.prenume, fr.id_data_start
)
SELECT
    nume_client,
    data_checkin,
    total_sejur,
    NVL(LAG(data_checkin, 1) OVER (
        PARTITION BY id_client_dim
        ORDER BY data_checkin
    ), data_checkin) AS data_vizita_anterioara,
    data_checkin - NVL(LAG(data_checkin, 1) OVER (
        PARTITION BY id_client_dim
        ORDER BY data_checkin
    ), data_checkin) AS zile_de_la_ultima_vizita
FROM Rezervari
ORDER BY nume_client, data_checkin;

-- afiare plan executie
SELECT * FROM table(dbms_xplan.display('plan_table', 'ex_8_part','serial'));

-- 9
-- cerere de optimizat:
-- pentru fiecare client care a rezervat camera 1001 sa se afle:
--      - venitul lunar generat pentru acea camera
--      - clasamentul sau in cadrul lunii in functie de venitul lunar generat
-- vom clasifica clientii ca fiind:
--      -"VIP luna" daca sunt pe locul 1,
--      - "Top 3" daca sunt pe primele 3 locuri
--      - "Standard" altfel
EXPLAIN PLAN SET STATEMENT_ID = 'ex_9' FOR
WITH
vanzari_per_client AS (
    SELECT
        t.an,
        t.luna,
        cl.nume,
        SUM(f.suma_totala) AS venit_generat
    FROM fact_rezervari f
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    JOIN dim_client cl ON f.id_client_dim = cl.id_client_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE c.nr_camera = 1001
    GROUP BY t.an, t.luna, cl.nume
),
clasamente AS (
    SELECT
        an,
        luna,
        nume,
        venit_generat,
        DENSE_RANK() OVER (
            PARTITION BY an, luna
            ORDER BY venit_generat DESC
        ) AS rang_lunar
    FROM vanzari_per_client
)
SELECT
    an,
    luna,
    nume,
    venit_generat,
    rang_lunar,
    CASE
        WHEN rang_lunar = 1 THEN 'VIP Luna'
        WHEN rang_lunar <= 3 THEN 'Top 3'
        ELSE 'Standard'
    END AS status_client
FROM clasamente
ORDER BY an, luna, rang_lunar;
SELECT * FROM table(dbms_xplan.display('plan_table', 'ex_9','serial'));

-- optimizare 1: Bitmap join index pe numar camera => Cost = 13
CREATE BITMAP INDEX bji_rezervari_camera
ON fact_rezervari(c.nr_camera)
FROM fact_rezervari f, dim_camera c
WHERE f.id_camera_dim = c.id_camera_dim;

-- optimizare 2: materialized view
GRANT QUERY REWRITE TO DIANA;
ALTER SESSION SET QUERY_REWRITE_ENABLED = TRUE;

CREATE MATERIALIZED VIEW materialized_view_client_1001
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE -- foloseste automat vizualizarea materializata
AS
SELECT
    c.nr_camera,
    cl.nume,
    t.an,
    t.luna,
    SUM(f.suma_totala) AS venit_total
FROM fact_rezervari f
JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
JOIN dim_client cl ON f.id_client_dim = cl.id_client_dim
JOIN dim_timp t ON f.id_data_start = t.data_completa
WHERE c.nr_camera = 1001
GROUP BY c.nr_camera, cl.nume, t.an, t.luna;

-- actualizare view manual
BEGIN
    DBMS_MVIEW.REFRESH('materialized_view_client_1001');
END;
/

-- 10.
-- cerere 1:
WITH venituri_lunare AS (
    SELECT
        t.luna,
        SUM(CASE WHEN t.an = 2024 THEN f.suma_totala ELSE 0 END) as venit_lunar_2024,
        SUM(CASE WHEN t.an = 2025 THEN f.suma_totala ELSE 0 END) as venit_lunar_2025
    FROM fact_rezervari f
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an IN (2024, 2025)
    GROUP BY t.luna
)
SELECT
    luna,
    SUM(venit_lunar_2024) OVER (
        ORDER BY luna
        ROWS UNBOUNDED PRECEDING
    ) as cumulat_2024,
    SUM(venit_lunar_2025) OVER (
        ORDER BY luna
        ROWS UNBOUNDED PRECEDING
    ) as cumulat_2025
FROM venituri_lunare
ORDER BY luna;


-- cerere 2:
SELECT f.id_camera_dim,
       dm.metoda_plata,
       dm.tip_tranzactie,
       dt.an,
       dt.luna,
       SUM(f.suma_totala)                                                          AS venit_metoda_plata,
       ROUND(
               (SUM(f.suma_totala) /
                SUM(SUM(f.suma_totala)) OVER (PARTITION BY f.id_camera_dim, dt.an, dt.luna)) * 100,
               2)                                                                  AS procent_din_venit_total,
       SUM(f.suma_totala) -
       AVG(SUM(f.suma_totala)) OVER (PARTITION BY f.id_camera_dim, dt.an, dt.luna) AS deviata_fata_de_media_camerei
FROM fact_rezervari f
         JOIN dim_metoda_plata dm ON f.id_metoda_plata_dim = dm.id_metoda_plata_dim
         JOIN dim_timp dt ON f.id_data_start = dt.data_completa
WHERE f.id_metoda_plata_dim IN (2, 3)
  AND dt.an = 2024
GROUP BY f.id_camera_dim, dm.metoda_plata, dm.tip_tranzactie, dt.an, dt.luna
ORDER BY f.id_camera_dim, dt.an, dt.luna, venit_metoda_plata DESC;

-- cerere 3:
WITH clienti_vip AS (
    SELECT id_client_dim
    FROM (
        SELECT
            id_client_dim,
            SUM(suma_totala) as total_cheltuit,
            NTILE(20) OVER (ORDER BY SUM(suma_totala) DESC) as tile -- impartim in grupuri de 5%
        FROM fact_rezervari
        GROUP BY id_client_dim
    )
    WHERE tile = 1 -- primii 5%
),
numar_rezervari_per_categorie AS (
    SELECT
        c.categorie_camera,
        COUNT(*) as numar_rezervari
    FROM clienti_vip tc
    JOIN fact_rezervari f ON f.id_client_dim = tc.id_client_dim
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    GROUP BY c.categorie_camera
)
SELECT
    categorie_camera,
    numar_rezervari,
    ROUND(RATIO_TO_REPORT(numar_rezervari) OVER () * 100, 2) as procent
FROM numar_rezervari_per_categorie;

-- cerere 4:
WITH venituri_anuale AS (
    SELECT 
        c.categorie_camera,
        AVG(f.suma_totala) as venit_mediu_anual
    FROM fact_rezervari f
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an = 2024
    GROUP BY c.categorie_camera
),
venituri_trimestriale AS (
    SELECT 
        c.categorie_camera,
        CEIL(t.luna / 3.0) as trimestru,
        COUNT(*) as numar_rezervari,
        AVG(f.suma_totala) as venit_mediu_rezervare
    FROM fact_rezervari f
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an = 2024
    GROUP BY c.categorie_camera, CEIL(t.luna / 3.0)
)
SELECT 
    vt.categorie_camera,
    vt.trimestru,
    vt.numar_rezervari,
    ROUND(vt.venit_mediu_rezervare, 2) as venit_mediu_rezervare,
    ROUND(
        ((vt.venit_mediu_rezervare - va.venit_mediu_anual) / va.venit_mediu_anual) * 100, 
        2
    ) as diferenta_procentuala_fata_de_medie_anuala
FROM venituri_trimestriale vt
JOIN venituri_anuale va ON vt.categorie_camera = va.categorie_camera
ORDER BY vt.categorie_camera, vt.trimestru;

-- cerere 5:
WITH camere_count AS (
    SELECT 
        f.id_metoda_plata_dim,
        f.id_camera_dim,
        COUNT(*) AS numar_rezervari,
        SUM(f.suma_totala) AS venit_total
    FROM fact_rezervari f
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an = 2024
    GROUP BY f.id_metoda_plata_dim, f.id_camera_dim
),

top_camere AS (
    SELECT 
        id_metoda_plata_dim,
        id_camera_dim,
        numar_rezervari,
        venit_total,
        ROW_NUMBER() OVER (
            PARTITION BY id_metoda_plata_dim
            ORDER BY numar_rezervari DESC
        ) AS rank_camera
    FROM camere_count
),

venituri_lunare AS (
    SELECT 
        tc.id_metoda_plata_dim,
        tc.id_camera_dim,
        t.luna,
        SUM(f.suma_totala) AS venit_lunar
    FROM top_camere tc
    JOIN fact_rezervari f 
        ON tc.id_camera_dim = f.id_camera_dim 
       AND tc.id_metoda_plata_dim = f.id_metoda_plata_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE tc.rank_camera <= 3 AND t.an = 2024
    GROUP BY tc.id_metoda_plata_dim, tc.id_camera_dim, t.luna
),

rate_crestere AS (
    SELECT 
        id_metoda_plata_dim,
        id_camera_dim,
        AVG(
            CASE 
                WHEN prev_venit > 0 THEN ((venit_lunar - prev_venit)/prev_venit)*100
                ELSE 0
            END
        ) AS rata_crestere_medie
    FROM (
        SELECT 
            id_metoda_plata_dim,
            id_camera_dim,
            luna,
            venit_lunar,
            LAG(venit_lunar) OVER (
                PARTITION BY id_metoda_plata_dim, id_camera_dim 
                ORDER BY luna
            ) AS prev_venit
        FROM venituri_lunare
    )
    GROUP BY id_metoda_plata_dim, id_camera_dim
),

procent_contributie AS (
    SELECT 
        id_metoda_plata_dim,
        id_camera_dim,
        venit_total,
        (venit_total / SUM(venit_total) OVER (PARTITION BY id_metoda_plata_dim)) * 100 AS contributie_procentuala
    FROM top_camere
    WHERE rank_camera <= 3
)

SELECT 
    mp.metoda_plata,
    c.categorie_camera,
    c.nr_camera,
    tc.numar_rezervari,
    ROUND(pc.venit_total, 2) AS valoare_totala,
    ROUND(pc.contributie_procentuala, 2) AS contributie_procentuala,
    ROUND(rc.rata_crestere_medie, 2) AS rata_crestere_lunara_medie
FROM top_camere tc
JOIN procent_contributie pc 
    ON tc.id_metoda_plata_dim = pc.id_metoda_plata_dim 
   AND tc.id_camera_dim = pc.id_camera_dim
JOIN rate_crestere rc 
    ON tc.id_metoda_plata_dim = rc.id_metoda_plata_dim 
   AND tc.id_camera_dim = rc.id_camera_dim
JOIN dim_camera c ON tc.id_camera_dim = c.id_camera_dim
JOIN dim_metoda_plata mp ON tc.id_metoda_plata_dim = mp.id_metoda_plata_dim
WHERE tc.rank_camera <= 3
ORDER BY mp.metoda_plata, tc.numar_rezervari DESC;
