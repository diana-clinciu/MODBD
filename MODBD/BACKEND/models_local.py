

from sqlalchemy import Column, Integer, String, Float
from database import Base

class Hotel1(Base):
    __tablename__ = "hotel1"
    id_hotel   = Column("ID_HOTEL",   Integer, primary_key=True)
    nume_hotel = Column("nume_hotel", String(50), nullable=False)
    oras       = Column("ORAS",       String(30), nullable=False)
    nr_stele   = Column("NR_STELE",   Integer)
    capacitate = Column("CAPACITATE", Integer)

class Hotel2(Base):
    __tablename__ = "hotel2"
    id_hotel   = Column("ID_HOTEL",   Integer, primary_key=True)
    nume_hotel = Column("nume_hotel", String(50), nullable=False)
    oras       = Column("ORAS",       String(30), nullable=False)
    nr_stele   = Column("NR_STELE",   Integer)
    capacitate = Column("CAPACITATE", Integer)

class Angajat1(Base):
    __tablename__ = "angajat1"
    id_angajat     = Column("ID_ANGAJAT",     Integer, primary_key=True)
    nume           = Column("NUME",           String(30), nullable=False)
    prenume        = Column("PRENUME",        String(30), nullable=False)
    functie        = Column("FUNCTIE",        String(30))
    salariu        = Column("SALARIU",        Float)
    id_departament = Column("ID_DEPARTAMENT", Integer, nullable=False)
    id_serviciu    = Column("ID_SERVICIU",    Integer)
    id_hotel       = Column("ID_HOTEL",       Integer, nullable=False)

class Angajat2(Base):
    __tablename__ = "angajat2"
    id_angajat     = Column("ID_ANGAJAT",     Integer, primary_key=True)
    nume           = Column("NUME",           String(30), nullable=False)
    prenume        = Column("PRENUME",        String(30), nullable=False)
    functie        = Column("FUNCTIE",        String(30))
    salariu        = Column("SALARIU",        Float)
    id_departament = Column("ID_DEPARTAMENT", Integer, nullable=False)
    id_serviciu    = Column("ID_SERVICIU",    Integer)
    id_hotel       = Column("ID_HOTEL",       Integer, nullable=False)

class Camera1(Base):
    __tablename__ = "camera1"
    id_camera     = Column("ID_CAMERA",     Integer, primary_key=True)
    nr_camera     = Column("NR_CAMERA",     Integer, nullable=False)
    id_tip_camera = Column("ID_TIP_CAMERA", Integer, nullable=False)
    id_hotel      = Column("ID_HOTEL",      Integer, nullable=False)

class Camera2(Base):
    __tablename__ = "camera2"
    id_camera     = Column("ID_CAMERA",     Integer, primary_key=True)
    nr_camera     = Column("NR_CAMERA",     Integer, nullable=False)
    id_tip_camera = Column("ID_TIP_CAMERA", Integer, nullable=False)
    id_hotel      = Column("ID_HOTEL",      Integer, nullable=False)

class TipCameraReplica(Base):
    __tablename__ = "tip_camera"
    id_tip_camera    = Column("ID_TIP_CAMERA",    Integer, primary_key=True)
    tip_camera       = Column("TIP_CAMERA",       String(20), nullable=False)
    clasa_confort    = Column("CLASA_CONFORT",     String(20), nullable=False)
    categorie_camera = Column("CATEGORIE_CAMERA", String(30), nullable=False)
    pret             = Column("PRET",             Float, nullable=False)

class ServiciuReplica(Base):
    __tablename__ = "serviciu"
    id_serviciu   = Column("ID_SERVICIU",   Integer, primary_key=True)
    denumire      = Column("DENUMIRE",      String(50), nullable=False)
    pret_serviciu = Column("PRET_SERVICIU", Float, nullable=False)

class DepartamentReplica(Base):
    __tablename__ = "departament"
    id_departament   = Column("ID_DEPARTAMENT",   Integer, primary_key=True)
    nume_departament = Column("NUME_DEPARTAMENT", String(50), nullable=False)

class ClientReplica(Base):
    __tablename__ = "client"
    id_client = Column("ID_CLIENT", Integer, primary_key=True)
    nume      = Column("NUME",      String(30), nullable=False)
    prenume   = Column("PRENUME",   String(30), nullable=False)
    email     = Column("EMAIL",     String(50))
