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
    __tablename__ = "angajati"
    id = Column(Integer, primary_key=True, index=True)
    nume = Column(String(50))
    functie = Column(String(100))

class Eveniment(Base):
    __tablename__ = "evenimente"
    id = Column(Integer, primary_key=True, index=True)
    nume = Column(String(100))
    data = Column(DateTime, default=datetime.utcnow)
