from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
import crud.camere as crud
from schemas import Camera, CameraCreate
from typing import List

router = APIRouter(prefix="/camere", tags=["Camere"])

@router.get("/", response_model=List[Camera])
def fetch_camere(db: Session = Depends(get_db)):
    return crud.get_camere(db)

@router.post("/add", response_model=Camera)
def add_camera(
    nr_camera: int = Form(...),
    tip_camera: str = Form(...),
    pret: float = Form(...),
    db: Session = Depends(get_db)
):
    camera = CameraCreate(nr_camera=nr_camera, tip_camera=tip_camera, pret=pret)
    return crud.create_camera(db, camera)

@router.post("/{id}", response_model=Camera)
def update_camera(
    id: int,
    nr_camera: int = Form(...),
    tip_camera: str = Form(...),
    pret: float = Form(...),
    db: Session = Depends(get_db)
):
    camera = CameraCreate(nr_camera=nr_camera, tip_camera=tip_camera, pret=pret)
    return crud.update_camera(db, id, camera)

@router.post("/delete/{id}")
def delete_camera(id: int, db: Session = Depends(get_db)):
    crud.delete_camera(db, id)
    return {"success": True}
