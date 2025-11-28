from sqlalchemy.orm import Session
from models import Eveniment
from schemas import EvenimentCreate

def get_evenimente(db: Session):
    return db.query(Eveniment).all()

def create_eveniment(db: Session, client: EvenimentCreate):
    db_client = Eveniment(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_eveniment(db: Session, id: int, client: EvenimentCreate):
    db_client = db.query(Eveniment).filter(Eveniment.id == id).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_eveniment(db: Session, id: int):
    db_client = db.query(Eveniment).filter(Eveniment.id == id).first()
    if db_client:
        db.delete(db_client)
        db.commit()
