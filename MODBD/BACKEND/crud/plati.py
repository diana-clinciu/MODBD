from sqlalchemy.orm import Session
from models import Plata
from schemas import PlataCreate

def get_plati(db: Session):
    return db.query(Plata).all()

def create_plata(db: Session, plata: PlataCreate):
    db_plata = Plata(**plata.dict())
    db.add(db_plata)
    db.commit()
    db.refresh(db_plata)
    return db_plata

def update_plata(db: Session, id: int, plata: PlataCreate):
    db_plata = db.query(Plata).filter(Plata.id_plata == id).first()
    if db_plata:
        for key, value in plata.dict().items():
            setattr(db_plata, key, value)
        db.commit()
        db.refresh(db_plata)
        return db_plata

def delete_plata(db: Session, id: int):
    db_plata = db.query(Plata).filter(Plata.id_plata == id).first()
    if db_plata:
        db.delete(db_plata)
        db.commit()
