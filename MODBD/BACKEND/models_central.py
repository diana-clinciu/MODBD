"""
Modele ORM pentru tabelele centralizate (schema bdd_all pe oracle-bucuresti).
Accesibile din sesiunile bdd prin sinonime, si direct din sesiunea bdd_all.
"""

from sqlalchemy import Column, Integer, String, Float, Date, CheckConstraint
from database import Base

class TipCamera(Base):
    __tablename__ = "tip_camera"
    id_tip_camera    = Column("ID_TIP_CAMERA",    Integer, primary_key=True)
    tip_camera       = Column("TIP_CAMERA",       String(20), nullable=False)
    clasa_confort    = Column("CLASA_CONFORT",     String(20), nullable=False)
    categorie_camera = Column("CATEGORIE_CAMERA", String(30), nullable=False)
    pret             = Column("PRET",             Float, nullable=False)

class Hotel(Base):
    __tablename__ = "hotel"
    id_hotel   = Column("ID_HOTEL",   Integer, primary_key=True)
    nume_hotel = Column("nume_hotel", String(50), nullable=False)
    oras       = Column("ORAS",       String(30), nullable=False)
    nr_stele   = Column("NR_STELE",   Integer)
    capacitate = Column("CAPACITATE", Integer)

class Camera(Base):
    __tablename__ = "camera"
    id_camera     = Column("ID_CAMERA",     Integer, primary_key=True)
    nr_camera     = Column("NR_CAMERA",     Integer, nullable=False)
    id_tip_camera = Column("ID_TIP_CAMERA", Integer, nullable=False)
    id_hotel      = Column("ID_HOTEL",      Integer, nullable=False)

class Departament(Base):
    __tablename__ = "departament"
    id_departament   = Column("ID_DEPARTAMENT",   Integer, primary_key=True)
    nume_departament = Column("NUME_DEPARTAMENT", String(50), nullable=False)

class Serviciu(Base):
    __tablename__ = "serviciu"
    id_serviciu   = Column("ID_SERVICIU",   Integer, primary_key=True)
    denumire      = Column("DENUMIRE",      String(50), nullable=False)
    pret_serviciu = Column("PRET_SERVICIU", Float, nullable=False)

class Client(Base):
    __tablename__ = "client"
    id_client = Column("ID_CLIENT", Integer, primary_key=True)
    nume      = Column("NUME",      String(30), nullable=False)
    prenume   = Column("PRENUME",   String(30), nullable=False)
    email     = Column("EMAIL",     String(50))

class Rezervare(Base):
    __tablename__ = "rezervare"
    id_rezervare = Column("ID_REZERVARE", Integer, primary_key=True)
    id_client    = Column("ID_CLIENT",    Integer, nullable=False)
    data_start   = Column("DATA_START",   Date, nullable=False)
    data_final   = Column("DATA_FINAL",   Date, nullable=False)

class RezervareCamera(Base):
    __tablename__ = "rezervare_camera"
    id_rezervare   = Column("ID_REZERVARE",   Integer, primary_key=True)
    id_camera      = Column("ID_CAMERA",      Integer, primary_key=True)
    nr_nopti       = Column("NR_NOPTI",       Integer, nullable=False)
    pret_rezervare = Column("PRET_REZERVARE", Float, nullable=False)

class Plata(Base):
    __tablename__ = "plata"
    id_plata     = Column("ID_PLATA",     Integer, primary_key=True)
    id_rezervare = Column("ID_REZERVARE", Integer, nullable=False)
    suma         = Column("SUMA",         Float)
    data_plata   = Column("DATA_PLATA",   Date, nullable=False)
    metoda_plata = Column("METODA_PLATA", String(20))

class SalaEveniment(Base):
    __tablename__ = "sala_eveniment"
    id_sala_eveniment = Column("ID_SALA_EVENIMENT", Integer, primary_key=True)
    nume_sala         = Column("NUME_SALA",         String(50), nullable=False)
    capacitate_maxima = Column("CAPACITATE_MAXIMA", Integer, nullable=False)
    etaj              = Column("ETAJ",              Integer)

class Eveniment(Base):
    __tablename__ = "eveniment"
    id_eveniment      = Column("ID_EVENIMENT",      Integer, primary_key=True)
    nume_eveniment    = Column("NUME_EVENIMENT",    String(50), nullable=False)
    data_eveniment    = Column("DATA_EVENIMENT",    Date, nullable=False)
    descriere         = Column("DESCRIERE",         String(200))
    id_sala_eveniment = Column("ID_SALA_EVENIMENT", Integer)
