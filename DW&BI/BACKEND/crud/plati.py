from sqlalchemy.orm import Session
from models import Plata
from schemas import PlataCreate

def get_plati(db: Session):
    return db.query(Plata).all()

def create_plata(db: Session, client: PlataCreate):
    db_client = Plata(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_plata(db: Session, id: int, client: PlataCreate):
    db_client = db.query(Plata).filter(Plata.id == id).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_plata(db: Session, id: int):
    db_client = db.query(Plata).filter(Plata.id == id).first()
    if db_client:
        db.delete(db_client)
        db.commit()
