from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
import crud.plati as crud
from schemas import Plata, PlataCreate
from typing import List

router = APIRouter(prefix="/plati", tags=["Plati"])

@router.get("/", response_model=List[Plata])
def fetch_plati(db: Session = Depends(get_db)):
    return crud.get_plati(db)

@router.post("/add", response_model=Plata)
def add_plata(
    id_rezervare: int = Form(...),
    suma: float = Form(...),
    data_plata: str = Form(...),
    metoda_plata: str = Form(...),
    db: Session = Depends(get_db)
):
    plata = PlataCreate(
        id_rezervare=id_rezervare,
        suma=suma,
        data_plata=data_plata,
        metoda_plata=metoda_plata
    )
    return crud.create_plata(db, plata)

@router.post("/{id}", response_model=Plata)
def update_plata(
    id: int,
    id_rezervare: int = Form(...),
    suma: float = Form(...),
    data_plata: str = Form(...),
    metoda_plata: str = Form(...),
    db: Session = Depends(get_db)
):
    plata = PlataCreate(
        id_rezervare=id_rezervare,
        suma=suma,
        data_plata=data_plata,
        metoda_plata=metoda_plata
    )
    return crud.update_plata(db, id, plata)

@router.post("/delete/{id}")
def delete_plata(id: int, db: Session = Depends(get_db)):
    crud.delete_plata(db, id)
    return {"success": True}
