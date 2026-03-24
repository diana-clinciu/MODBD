from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Dict
from session import get_db
from crud.dw_sync import propagate_dw

router = APIRouter(prefix="/dw", tags=["DW"])

@router.post("/sync")
def sync_dw(db: Session = Depends(get_db)) -> Dict[str, int]:
    result = propagate_dw(db)
    return result
