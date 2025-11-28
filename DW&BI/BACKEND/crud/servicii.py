from sqlalchemy.orm import Session
from models import Serviciu
from schemas import ServiciuCreate

def get_servicii(db: Session):
    return db.query(Serviciu).all()

def create_serviciu(db: Session, client: ServiciuCreate):
    db_client = Serviciu(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_serviciu(db: Session, id: int, client: ServiciuCreate):
    db_client = db.query(Serviciu).filter(Serviciu.id == id).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_serviciu(db: Session, id: int):
    db_client = db.query(Serviciu).filter(Serviciu.id == id).first()
    if db_client:
        db.delete(db_client)
        db.commit()
