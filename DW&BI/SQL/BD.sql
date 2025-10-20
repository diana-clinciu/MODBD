--creare user 
alter session set container = orclpdb1;
SHOW CON_NAME;  -- ORCLPDB1

create user alexia identified by oracle
   default tablespace users
   quota unlimited on users;

grant connect,resource to alexia;
alter user alexia
   account unlock;

--craerea bazei de date OLTP
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
   id_rezervare number primary key,
   id_client    number not null,
   data_inceput date not null,
   data_sfarsit date not null,
   foreign key ( id_client )
      references client ( id_client )
);

create table plata (
   id_plata     number primary key,
   id_rezervare number not null,
   suma         number(10,2) not null,
   data_plata   date not null,
   metoda_plata varchar2(20),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare )
);

create table serviciu (
   id_serviciu number primary key,
   denumire    varchar2(50) not null,
   pret        number(10,2) not null
);

create table angajat (
   id_angajat  number primary key,
   nume        varchar2(30) not null,
   prenume     varchar2(30) not null,
   functie     varchar2(30),
   salariu     number(10,2),
   id_serviciu number,
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

create table camera (
   id_camera       number primary key,
   nr_camera       number unique,
   tip_camera      varchar2(20),
   pret_per_noapte number(10,2)
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

create table client_serviciu (
   id_client   number,
   id_serviciu number,
   primary key ( id_client,
                 id_serviciu ),
   foreign key ( id_client )
      references client ( id_client ),
   foreign key ( id_serviciu )
      references serviciu ( id_serviciu )
);

create table rezervare_camera (
   id_rezervare number,
   id_camera    number,
   primary key ( id_rezervare,
                 id_camera ),
   foreign key ( id_rezervare )
      references rezervare ( id_rezervare ),
   foreign key ( id_camera )
      references camera ( id_camera )
);


insert into eveniment values ( 1,
                               'Concert Rock',
                               to_date('2025-11-01','YYYY-MM-DD'),
                               'Concert de rock local' );
insert into eveniment values ( 2,
                               'Festival Jazz',
                               to_date('2025-11-05','YYYY-MM-DD'),
                               'Festival de jazz international' );
insert into eveniment values ( 3,
                               'Gala Hotel',
                               to_date('2025-11-10','YYYY-MM-DD'),
                               'Gala anuală a hotelului' );
insert into eveniment values ( 4,
                               'Team Building',
                               to_date('2025-11-12','YYYY-MM-DD'),
                               'Eveniment corporativ' );
insert into eveniment values ( 5,
                               'Expozitie Arta',
                               to_date('2025-11-15','YYYY-MM-DD'),
                               'Expoziție de artă contemporană' );
insert into eveniment values ( 6,
                               'Petrecere Halloween',
                               to_date('2025-10-31','YYYY-MM-DD'),
                               'Petrecere tematica Halloween' );
insert into eveniment values ( 7,
                               'Seminar Business',
                               to_date('2025-11-18','YYYY-MM-DD'),
                               'Seminar pentru antreprenori' );
insert into eveniment values ( 8,
                               'Concert Clasic',
                               to_date('2025-11-20','YYYY-MM-DD'),
                               'Concert simfonic clasic' );
insert into eveniment values ( 9,
                               'Workshop Gatit',
                               to_date('2025-11-22','YYYY-MM-DD'),
                               'Workshop culinar' );
insert into eveniment values ( 10,
                               'Seara de Film',
                               to_date('2025-11-25','YYYY-MM-DD'),
                               'Proiecție film pentru oaspeți' );


insert into client values ( 1,
                            'Popescu',
                            'Ana',
                            'ana.popescu@mail.com' );
insert into client values ( 2,
                            'Ionescu',
                            'Maria',
                            'maria.ionescu@mail.com' );
insert into client values ( 3,
                            'Georgescu',
                            'Ioana',
                            'ioana.georgescu@mail.com' );
insert into client values ( 4,
                            'Dumitrescu',
                            'Alina',
                            'alina.dumitrescu@mail.com' );
insert into client values ( 5,
                            'Radu',
                            'Cristina',
                            'cristina.radu@mail.com' );
insert into client values ( 6,
                            'Marin',
                            'Elena',
                            'elena.marin@mail.com' );
insert into client values ( 7,
                            'Stan',
                            'Gabriela',
                            'gabriela.stan@mail.com' );
insert into client values ( 8,
                            'Vasilescu',
                            'Laura',
                            'laura.vasilescu@mail.com' );
insert into client values ( 9,
                            'Niculae',
                            'Irina',
                            'irina.niculae@mail.com' );
insert into client values ( 10,
                            'Florea',
                            'Andreea',
                            'andreea.florea@mail.com' );


insert into rezervare values ( 1,
                               1,
                               to_date('2025-11-01','YYYY-MM-DD'),
                               to_date('2025-11-03','YYYY-MM-DD') );
insert into rezervare values ( 2,
                               2,
                               to_date('2025-11-02','YYYY-MM-DD'),
                               to_date('2025-11-04','YYYY-MM-DD') );
insert into rezervare values ( 3,
                               3,
                               to_date('2025-11-05','YYYY-MM-DD'),
                               to_date('2025-11-06','YYYY-MM-DD') );
insert into rezervare values ( 4,
                               4,
                               to_date('2025-11-07','YYYY-MM-DD'),
                               to_date('2025-11-09','YYYY-MM-DD') );
insert into rezervare values ( 5,
                               5,
                               to_date('2025-11-08','YYYY-MM-DD'),
                               to_date('2025-11-10','YYYY-MM-DD') );
insert into rezervare values ( 6,
                               6,
                               to_date('2025-11-11','YYYY-MM-DD'),
                               to_date('2025-11-13','YYYY-MM-DD') );
insert into rezervare values ( 7,
                               7,
                               to_date('2025-11-14','YYYY-MM-DD'),
                               to_date('2025-11-16','YYYY-MM-DD') );
insert into rezervare values ( 8,
                               8,
                               to_date('2025-11-17','YYYY-MM-DD'),
                               to_date('2025-11-19','YYYY-MM-DD') );
insert into rezervare values ( 9,
                               9,
                               to_date('2025-11-20','YYYY-MM-DD'),
                               to_date('2025-11-22','YYYY-MM-DD') );
insert into rezervare values ( 10,
                               10,
                               to_date('2025-11-23','YYYY-MM-DD'),
                               to_date('2025-11-25','YYYY-MM-DD') );


insert into plata values ( 1,
                           1,
                           500,
                           to_date('2025-10-20','YYYY-MM-DD'),
                           'Card' );
insert into plata values ( 2,
                           2,
                           600,
                           to_date('2025-10-21','YYYY-MM-DD'),
                           'Cash' );
insert into plata values ( 3,
                           3,
                           450,
                           to_date('2025-10-22','YYYY-MM-DD'),
                           'Card' );
insert into plata values ( 4,
                           4,
                           700,
                           to_date('2025-10-23','YYYY-MM-DD'),
                           'Transfer' );
insert into plata values ( 5,
                           5,
                           550,
                           to_date('2025-10-24','YYYY-MM-DD'),
                           'Card' );
insert into plata values ( 6,
                           6,
                           400,
                           to_date('2025-10-25','YYYY-MM-DD'),
                           'Cash' );
insert into plata values ( 7,
                           7,
                           650,
                           to_date('2025-10-26','YYYY-MM-DD'),
                           'Card' );
insert into plata values ( 8,
                           8,
                           500,
                           to_date('2025-10-27','YYYY-MM-DD'),
                           'Transfer' );
insert into plata values ( 9,
                           9,
                           450,
                           to_date('2025-10-28','YYYY-MM-DD'),
                           'Cash' );
insert into plata values ( 10,
                           10,
                           600,
                           to_date('2025-10-29','YYYY-MM-DD'),
                           'Card' );


insert into serviciu values ( 1,
                              'Spa',
                              100 );
insert into serviciu values ( 2,
                              'Room Service',
                              50 );
insert into serviciu values ( 3,
                              'Masaj',
                              80 );
insert into serviciu values ( 4,
                              'Piscina',
                              40 );
insert into serviciu values ( 5,
                              'Ghid Turistic',
                              120 );
insert into serviciu values ( 6,
                              'Transport',
                              150 );
insert into serviciu values ( 7,
                              'Curatenie',
                              30 );
insert into serviciu values ( 8,
                              'Laundry',
                              20 );
insert into serviciu values ( 9,
                              'Fitness',
                              60 );
insert into serviciu values ( 10,
                              'Cinema',
                              70 );


insert into angajat values ( 1,
                             'Popa',
                             'Andrei',
                             'Receptionist',
                             3000,
                             2 );
insert into angajat values ( 2,
                             'Ionescu',
                             'Mihai',
                             'Bucatar',
                             3200,
                             2 );
insert into angajat values ( 3,
                             'Marin',
                             'Sorina',
                             'Ospatar',
                             2800,
                             2 );
insert into angajat values ( 4,
                             'Dumitru',
                             'Raluca',
                             'Maseur',
                             3100,
                             3 );
insert into angajat values ( 5,
                             'Stan',
                             'Vlad',
                             'Instructor',
                             2900,
                             9 );
insert into angajat values ( 6,
                             'Vasilescu',
                             'Ioan',
                             'Sofer',
                             3000,
                             6 );
insert into angajat values ( 7,
                             'Niculae',
                             'Elena',
                             'Receptionist',
                             3000,
                             2 );
insert into angajat values ( 8,
                             'Florea',
                             'Cristina',
                             'Cleaner',
                             2500,
                             7 );
insert into angajat values ( 9,
                             'Georgescu',
                             'Alin',
                             'Laundress',
                             2400,
                             8 );
insert into angajat values ( 10,
                             'Radu',
                             'Laura',
                             'Ghid',
                             2800,
                             5 );


insert into camera values ( 1,
                            101,
                            'Single',
                            100 );
insert into camera values ( 2,
                            102,
                            'Double',
                            150 );
insert into camera values ( 3,
                            103,
                            'Suite',
                            300 );
insert into camera values ( 4,
                            104,
                            'Single',
                            100 );
insert into camera values ( 5,
                            105,
                            'Double',
                            150 );
insert into camera values ( 6,
                            106,
                            'Suite',
                            350 );
insert into camera values ( 7,
                            107,
                            'Single',
                            110 );
insert into camera values ( 8,
                            108,
                            'Double',
                            160 );
insert into camera values ( 9,
                            109,
                            'Suite',
                            320 );
insert into camera values ( 10,
                            110,
                            'Double',
                            140 );


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


insert into client_serviciu values ( 1,
                                     1 );
insert into client_serviciu values ( 2,
                                     2 );
insert into client_serviciu values ( 3,
                                     3 );
insert into client_serviciu values ( 4,
                                     4 );
insert into client_serviciu values ( 5,
                                     5 );
insert into client_serviciu values ( 6,
                                     6 );
insert into client_serviciu values ( 7,
                                     7 );
insert into client_serviciu values ( 8,
                                     8 );
insert into client_serviciu values ( 9,
                                     9 );
insert into client_serviciu values ( 10,
                                     10 );


insert into rezervare_camera values ( 1,
                                      1 );
insert into rezervare_camera values ( 2,
                                      2 );
insert into rezervare_camera values ( 3,
                                      3 );
insert into rezervare_camera values ( 4,
                                      4 );
insert into rezervare_camera values ( 5,
                                      5 );
insert into rezervare_camera values ( 6,
                                      6 );
insert into rezervare_camera values ( 7,
                                      7 );
insert into rezervare_camera values ( 8,
                                      8 );
insert into rezervare_camera values ( 9,
                                      9 );
insert into rezervare_camera values ( 10,
                                      10 );

commit;

--Se acordă acces complet userilor asupra tabelelor din schema GirlsPower

grant select,insert,update,delete on eveniment to alexia;
grant select,insert,update,delete on client to alexia;
grant select,insert,update,delete on rezervare to alexia;
grant select,insert,update,delete on plata to alexia;
grant select,insert,update,delete on serviciu to alexia;
grant select,insert,update,delete on angajat to alexia;
grant select,insert,update,delete on camera to alexia;
grant select,insert,update,delete on eveniment_client to alexia;
grant select,insert,update,delete on client_serviciu to alexia;
grant select,insert,update,delete on rezervare_camera to alexia;