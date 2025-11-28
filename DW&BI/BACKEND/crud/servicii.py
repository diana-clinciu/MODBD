from sqlalchemy.orm import Session
from models import Serviciu
from schemas import ServiciuCreate, ServiciuUpdate

def get_servicii(db: Session):
    return db.query(Serviciu).all()

def create_serviciu(db: Session, serviciu: ServiciuCreate):
    db_serviciu = Serviciu(**serviciu.dict())
    db.add(db_serviciu)
    db.commit()
    db.refresh(db_serviciu)
    return db_serviciu

def update_serviciu(db: Session, id: int, serviciu: ServiciuUpdate):
    db_serviciu = db.query(Serviciu).filter(Serviciu.id == id).first()
    if db_serviciu:
        for key, value in serviciu.dict().items():
            setattr(db_serviciu, key, value)
        db.commit()
        db.refresh(db_serviciu)
        return db_serviciu

def delete_serviciu(db: Session, id: int):
    db_serviciu = db.query(Serviciu).filter(Serviciu.id == id).first()
    if db_serviciu:
        db.delete(db_serviciu)
        db.commit()