from fastapi import APIRouter, Depends, Form, HTTPException
from sqlalchemy.orm import Session
from session import get_db
import crud.clients as crud
from schemas import ClientCreate, Client
from typing import List

router = APIRouter(prefix="", tags=["Clients"])

@router.get("/clients", response_model=List[Client])
def fetch_clients(db: Session = Depends(get_db)):
    return crud.get_clients(db)

@router.post("/clients/add", response_model=Client)
def add_client(
    nume: str = Form(...),
    prenume: str = Form(...),
    email: str = Form(...),
    db: Session = Depends(get_db)
):
    client = ClientCreate(nume=nume, prenume=prenume, email=email)
    return crud.create_client(db, client)

@router.post("/clients/{id_client}", response_model=Client)
def update_client(
    id_client: int,
    nume: str = Form(...),
    prenume: str = Form(...),
    email: str = Form(...),
    db: Session = Depends(get_db)
):
    client = ClientCreate(nume=nume, prenume=prenume, email=email)
    updated = crud.update_client(db, id_client, client)
    if not updated:
        raise HTTPException(status_code=404, detail="Client not found")
    return updated

@router.post("/clients/delete/{id_client}")
def delete_client(id_client: int, db: Session = Depends(get_db)):
    deleted = crud.delete_client(db, id_client)
    if not deleted:
        raise HTTPException(status_code=404, detail="Client not found")
    return {"success": True}
