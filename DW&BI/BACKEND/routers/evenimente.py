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
    nume: str = Form(...),
    data: str = Form(...),
    db: Session = Depends(get_db)
):
    eveniment = EvenimentCreate(nume=nume, data=data)
    return crud.create_eveniment(db, eveniment)

@router.post("/{id}", response_model=Eveniment)
def update_eveniment(
    id: int,
    nume: str = Form(...),
    data: str = Form(...),
    db: Session = Depends(get_db)
):
    eveniment = EvenimentCreate(nume=nume, data=data)
    return crud.update_eveniment(db, id, eveniment)

@router.post("/delete/{id}")
def delete_eveniment(id: int, db: Session = Depends(get_db)):
    crud.delete_eveniment(db, id)
    return {"success": True}
