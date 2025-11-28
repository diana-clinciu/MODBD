from sqlalchemy import Column, Date, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Client(Base):
    __tablename__ = 'CLIENT'
    __table_args__ = {'schema': 'ALEXIA'} 

    id_client = Column("ID_CLIENT", Integer, primary_key=True, index=True)
    nume = Column("NUME", String(30), nullable=False)
    prenume = Column("PRENUME", String(30), nullable=False)
    email = Column("EMAIL", String(50), unique=True)

    rezervari = relationship("Rezervare", back_populates="client")

class Rezervare(Base):
    __tablename__ = 'REZERVARE'
    __table_args__ = {'schema': 'ALEXIA'}

    id_rezervare = Column("ID_REZERVARE", Integer, primary_key=True, index=True)
    id_client = Column("ID_CLIENT", Integer, ForeignKey("ALEXIA.CLIENT.ID_CLIENT"), nullable=False)
    data = Column("DATA_REZERVARE", DateTime, default=datetime.utcnow)

    client = relationship("Client", back_populates="rezervari")


class Camera(Base):
    __tablename__ = 'CAMERA'
    __table_args__ = {'schema': 'ALEXIA'}

    id_camera = Column("ID_CAMERA", Integer, primary_key=True, index=True)
    nr_camera = Column("NR_CAMERA", Integer, nullable=False)
    tip_camera = Column("TIP_CAMERA", String(50), nullable=False)
    pret = Column("PRET", Float, nullable=False)

class Serviciu(Base):
    __tablename__ = 'SERVICIU'
    __table_args__ = {'schema': 'ALEXIA'}

    id = Column("id_serviciu", Integer, primary_key=True, index=True)
    denumire = Column(String(50), nullable=False)
    pret = Column("pret_serviciu", Float, nullable=False)
    data_achizitionare = Column(Date, nullable=True)
    cantitate = Column(Integer, nullable=True)

class Plata(Base):
    __tablename__ = 'PLATA'
    __table_args__ = {'schema': 'ALEXIA'}

    id_plata = Column("ID_PLATA", Integer, primary_key=True, index=True)
    id_rezervare = Column("ID_REZERVARE", Integer, ForeignKey("ALEXIA.REZERVARE.ID_REZERVARE"), nullable=False)
    suma = Column("SUMA", Float(precision=2))
    data_plata = Column("DATA_PLATA", Date, nullable=False)
    metoda_plata = Column("METODA_PLATA", String(20))

class Angajat(Base):
    __tablename__ = 'ANGAJAT'
    __table_args__ = {'schema': 'ALEXIA'}

    id_angajat = Column("ID_ANGAJAT", Integer, primary_key=True, index=True)
    nume = Column("NUME", String(30), nullable=False)
    prenume = Column("PRENUME", String(30), nullable=False)
    functie = Column("FUNCTIE", String(30))
    salariu = Column("SALARIU", Float(precision=2))
    id_serviciu = Column("id_serviciu", Integer, ForeignKey("ALEXIA.SERVICIU.id_serviciu"), nullable=False)

    serviciu = relationship("Serviciu")

class Eveniment(Base):
    __tablename__ = 'EVENIMENT'
    __table_args__ = {'schema': 'ALEXIA'}

    id_eveniment = Column("ID_EVENIMENT", Integer, primary_key=True, index=True)
    nume_eveniment = Column("NUME_EVENIMENT", String(50), nullable=False)
    data_eveniment = Column("DATA_EVENIMENT", DateTime, nullable=False)
    descriere = Column("DESCRIERE", String(200))
