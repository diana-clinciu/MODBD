from datetime import datetime
from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
import crud.evenimente as crud
from schemas import Eveniment, EvenimentCreate
from typing import List

router = APIRouter(prefix="/evenimente", tags=["Evenimente"])

@router.get("/", response_model=List[Eveniment])
def fetch_evenimente(db: Session = Depends(get_db)):
    return crud.get_evenimente(db)

@router.post("/add", response_model=Eveniment)
def add_eveniment(
    nume_eveniment: str = Form(...),
    data_eveniment: datetime = Form(...),
    descriere: str = Form(""),
    db: Session = Depends(get_db)
):
    eveniment = EvenimentCreate(
        nume_eveniment=nume_eveniment,
        data_eveniment=data_eveniment,
        descriere=descriere
    )
    return crud.create_eveniment(db, eveniment)

@router.post("/{id}", response_model=Eveniment)
def update_eveniment(
    id: int,
    nume_eveniment: str = Form(...),
    data_eveniment: datetime = Form(...),
    descriere: str = Form(""),
    db: Session = Depends(get_db)
):
    eveniment = EvenimentCreate(nume_eveniment=nume_eveniment, data_eveniment=data_eveniment, descriere=descriere)
    return crud.update_eveniment(db, id, eveniment)

@router.post("/delete/{id}")
def delete_eveniment(id: int, db: Session = Depends(get_db)):
    crud.delete_eveniment(db, id)
    return {"success": True}
