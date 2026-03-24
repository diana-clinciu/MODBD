from datetime import date
from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
import crud.servicii as crud
from schemas import Serviciu, ServiciuCreate, ServiciuUpdate
from typing import List, Optional

router = APIRouter(prefix="/servicii", tags=["Servicii"])

@router.get("/", response_model=List[Serviciu])
def fetch_servicii(db: Session = Depends(get_db)):
    return crud.get_servicii(db)

@router.post("/add", response_model=Serviciu)
def add_serviciu(
    denumire: str = Form(...),
    pret: float = Form(...),
    data_achizitionare: Optional[date] = Form(None),
    cantitate: Optional[int] = Form(None),
    db: Session = Depends(get_db)
):
    serviciu = ServiciuCreate(
        denumire=denumire,
        pret=pret,
        data_achizitionare=data_achizitionare,
        cantitate=cantitate
    )
    return crud.create_serviciu(db, serviciu)

@router.post("/{id}", response_model=Serviciu)
def update_serviciu(
    id: int,
    denumire: str = Form(...),
    pret: float = Form(...),
    data_achizitionare: Optional[date] = Form(None),
    cantitate: Optional[int] = Form(None),
    db: Session = Depends(get_db)
):
    serviciu = ServiciuUpdate(
        denumire=denumire,
        pret=pret,
        data_achizitionare=data_achizitionare,
        cantitate=cantitate
    )
    return crud.update_serviciu(db, id, serviciu)

@router.post("/delete/{id}")
def delete_serviciu(id: int, db: Session = Depends(get_db)):
    crud.delete_serviciu(db, id)
    return {"success": True}
