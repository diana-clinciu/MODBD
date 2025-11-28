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
    metoda: str = Form(...),
    suma: float = Form(...),
    db: Session = Depends(get_db)
):
    plata = PlataCreate(metoda=metoda, suma=suma)
    return crud.create_plata(db, plata)

@router.post("/{id}", response_model=Plata)
def update_plata(
    id: int,
    metoda: str = Form(...),
    suma: float = Form(...),
    db: Session = Depends(get_db)
):
    plata = PlataCreate(metoda=metoda, suma=suma)
    return crud.update_plata(db, id, plata)

@router.post("/delete/{id}")
def delete_plata(id: int, db: Session = Depends(get_db)):
    crud.delete_plata(db, id)
    return {"success": True}
