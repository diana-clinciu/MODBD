"""Pydantic schemas pentru schema distribuita (BD_MODBD)."""

from datetime import date
from typing import Optional
from pydantic import BaseModel

class HotelBase(BaseModel):
    nume_hotel: str
    oras: str
    nr_stele: Optional[int] = None
    capacitate: Optional[int] = None

class HotelCreate(HotelBase):
    id_hotel: int

class HotelResponse(HotelBase):
    id_hotel: int
    class Config:
        from_attributes = True

class TipCameraResponse(BaseModel):
    id_tip_camera: int
    tip_camera: str
    clasa_confort: str
    categorie_camera: str
    pret: float
    class Config:
        from_attributes = True

class CameraBase(BaseModel):
    nr_camera: int
    id_tip_camera: int
    id_hotel: int

class CameraCreate(CameraBase):
    id_camera: int

class CameraResponse(CameraBase):
    id_camera: int
    class Config:
        from_attributes = True

class DepartamentResponse(BaseModel):
    id_departament: int
    nume_departament: str
    class Config:
        from_attributes = True

class ServiciuBase(BaseModel):
    denumire: str
    pret_serviciu: float

class ServiciuCreate(ServiciuBase):
    id_serviciu: int

class ServiciuResponse(ServiciuBase):
    id_serviciu: int
    class Config:
        from_attributes = True

class AngajatLocalBase(BaseModel):
    nume: str
    prenume: str
    functie: Optional[str] = None
    salariu: Optional[float] = None
    id_departament: int
    id_serviciu: Optional[int] = None
    id_hotel: int

class AngajatLocalCreate(AngajatLocalBase):
    id_angajat: int

class AngajatLocalResponse(AngajatLocalBase):
    id_angajat: int
    class Config:
        from_attributes = True

class AngajatGlobalBase(BaseModel):
    nume: str
    prenume: str
    functie: Optional[str] = None
    salariu: Optional[float] = None
    id_departament: int
    id_serviciu: Optional[int] = None
    id_hotel: int
    cnp: str
    data_angajare: date

class AngajatGlobalCreate(AngajatGlobalBase):
    id_angajat: int

class AngajatGlobalResponse(AngajatGlobalBase):
    id_angajat: int
    class Config:
        from_attributes = True

class ClientBase(BaseModel):
    nume: str
    prenume: str
    email: Optional[str] = None

class ClientCreate(ClientBase):
    id_client: int

class ClientResponse(ClientBase):
    id_client: int
    class Config:
        from_attributes = True

class RezervareBase(BaseModel):
    id_client: int
    data_start: date
    data_final: date

class RezervareCreate(RezervareBase):
    id_rezervare: int

class RezervareResponse(RezervareBase):
    id_rezervare: int
    class Config:
        from_attributes = True

class PlataBase(BaseModel):
    id_rezervare: int
    suma: Optional[float] = None
    data_plata: date
    metoda_plata: Optional[str] = None

class PlataCreate(PlataBase):
    id_plata: int

class PlataResponse(PlataBase):
    id_plata: int
    class Config:
        from_attributes = True

class VerificareHotelResponse(BaseModel):
    entitate: str
    id: int
    fragment_bucuresti: Optional[dict] = None
    fragment_constanta: Optional[dict] = None

class VerificareAngajatResponse(BaseModel):
    entitate: str
    id: int
    fragment_bucuresti: Optional[dict] = None
    fragment_constanta: Optional[dict] = None
    date_personale: Optional[dict] = None

class VerificareCameraResponse(BaseModel):
    entitate: str
    id: int
    fragment_bucuresti: Optional[dict] = None
    fragment_constanta: Optional[dict] = None

class DistributieEntry(BaseModel):
    entitate: str
    fragment: str
    count: int

class StatisticiResponse(BaseModel):
    distributie: list[DistributieEntry]
