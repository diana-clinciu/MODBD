from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
import crud.angajati as crud
from schemas import Angajat, AngajatCreate
from typing import List

router = APIRouter(prefix="/angajati", tags=["Angajati"])

@router.get("/", response_model=List[Angajat])
def fetch_angajati(db: Session = Depends(get_db)):
    return crud.get_angajati(db)

@router.post("/add", response_model=Angajat)
def add_angajat(
    nume: str = Form(...),
    functie: str = Form(...),
    db: Session = Depends(get_db)
):
    angajat = AngajatCreate(nume=nume, functie=functie)
    return crud.create_angajat(db, angajat)

@router.post("/{id}", response_model=Angajat)
def update_angajat(
    id: int,
    nume: str = Form(...),
    functie: str = Form(...),
    db: Session = Depends(get_db)
):
    angajat = AngajatCreate(nume=nume, functie=functie)
    return crud.update_angajat(db, id, angajat)

@router.post("/delete/{id}")
def delete_angajat(id: int, db: Session = Depends(get_db)):
    crud.delete_angajat(db, id)
    return {"success": True}
