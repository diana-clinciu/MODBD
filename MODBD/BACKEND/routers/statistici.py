"""Statistici distributie date per fragment (Tab 3 – Statistici)."""

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from session import get_db
from crud import global_crud as crud

router = APIRouter(prefix="/statistici", tags=["Statistici"])


@router.get("/distributie")
def distributie(db: Session = Depends(get_db)):
    return crud.get_distributie(db)
