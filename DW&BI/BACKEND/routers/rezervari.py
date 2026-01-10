from fastapi import APIRouter, Depends, Form, HTTPException
from datetime import datetime
from sqlalchemy.orm import Session
from models import Rezervare
from session import get_db
import crud.rezervari as crud
from schemas import RezervareResponse, RezervareCreate
from typing import List

router = APIRouter(prefix="", tags=["Rezervari"])

@router.get("/rezervari", response_model=List[RezervareResponse])
def fetch_rezervari(db: Session = Depends(get_db)):
    return crud.get_rezervari(db)

@router.post("/rezervari", response_model=RezervareResponse)
def add_rezervare(
    id_client: int = Form(...),
    data_start: datetime = Form(...),
    data_final: datetime = Form(...),
    db: Session = Depends(get_db)
):
    rezervare_data = RezervareCreate(id_client=id_client, data_start=data_start, data_final=data_final)
    return crud.create_rezervare(db, rezervare_data)

@router.post("/rezervari/update/{id}", response_model=RezervareResponse)
def update_rezervare(
    id: int,
    id_client: int = Form(...),
    data_start: str = Form(...),
    data_final: str = Form(...),
    db: Session = Depends(get_db)
):
    from datetime import datetime
    try:
        parsed_data_start = datetime.fromisoformat(data_start)
        parsed_data_final = datetime.fromisoformat(data_final)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format")

    rezervare_data = RezervareCreate(id_client=id_client, data_start=parsed_data_start, data_final=parsed_data_final)
    updated = crud.update_rezervare(db, id, rezervare_data)
    if not updated:
        raise HTTPException(status_code=404, detail="Rezervare not found")
    return updated


@router.post("/rezervari/delete/{id}")
def delete_rezervare(id: int, db: Session = Depends(get_db)):
    deleted = crud.delete_rezervare(db, id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Rezervare not found")
    return {"success": True}