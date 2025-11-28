from typing import Optional
from pydantic import BaseModel, Field
from datetime import date, datetime

# Client
class ClientBase(BaseModel):
    nume: str
    prenume: str
    email: str

class ClientCreate(ClientBase):
    pass

class Client(ClientBase):
    id: int = Field(..., alias="id_client")
    class Config:
        orm_mode = True

# Rezervare
class RezervareBase(BaseModel):
    data: datetime

class RezervareCreate(RezervareBase):
    id_client: int

class RezervareResponse(BaseModel):
    id_rezervare: int
    clientName: str
    data: datetime

    class Config:
        orm_mode = True

# Camera
class CameraBase(BaseModel):
    nr_camera: int
    tip_camera: str
    pret: float

class CameraCreate(CameraBase):
    pass

class Camera(CameraBase):
    id: int = Field(..., alias="id_camera")
    class Config:
        orm_mode = True

# Serviciu
class ServiciuBase(BaseModel):
    denumire: str
    pret: float
    data_achizitionare: Optional[date] = None
    cantitate: Optional[int] = None

class ServiciuCreate(ServiciuBase):
    pass

class ServiciuUpdate(ServiciuBase):
    pass

class Serviciu(ServiciuBase):
    id: int

    class Config:
        orm_mode = True

# Plata
class PlataBase(BaseModel):
    id_rezervare: int
    suma: float
    data_plata: date
    metoda_plata: str

class PlataCreate(PlataBase):
    pass

class Plata(PlataBase):
    id_plata: int = Field(..., alias="id_plata")
    class Config:
        orm_mode = True

# Angajat
class AngajatBase(BaseModel):
    nume: str
    prenume: str
    functie: str
    salariu: float
    id_serviciu: int

class AngajatCreate(AngajatBase):
    pass

class Angajat(AngajatBase):
    id: int = Field(..., alias="id_angajat")
    class Config:
        orm_mode = True

# Eveniment
class EvenimentBase(BaseModel):
    nume_eveniment: str = Field(..., alias="nume_eveniment")
    data_eveniment: datetime = Field(..., alias="data_eveniment")
    descriere: str = ""

    class Config:
        orm_mode = True

class EvenimentCreate(EvenimentBase):
    pass

class Eveniment(EvenimentBase):
    id_eveniment: int
