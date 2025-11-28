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
    metoda: str
    suma: float

class PlataCreate(PlataBase):
    pass

class Plata(PlataBase):
    id: int
    class Config:
        orm_mode = True


# Angajat
class AngajatBase(BaseModel):
    nume: str
    functie: str

class AngajatCreate(AngajatBase):
    pass

class Angajat(AngajatBase):
    id: int
    class Config:
        orm_mode = True


# Eveniment
class EvenimentBase(BaseModel):
    nume: str
    data: datetime

class EvenimentCreate(EvenimentBase):
    pass

class Eveniment(EvenimentBase):
    id: int
    class Config:
        orm_mode = True
