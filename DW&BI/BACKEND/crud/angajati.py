from sqlalchemy.orm import Session
from models import Angajat
from schemas import AngajatCreate

def get_angajati(db: Session):
    return db.query(Angajat).all()

def create_angajat(db: Session, angajat: AngajatCreate):
    db_angajat = Angajat(**angajat.dict())
    db.add(db_angajat)
    db.commit()
    db.refresh(db_angajat)
    return db_angajat

def update_angajat(db: Session, id: int, angajat: AngajatCreate):
    db_angajat = db.query(Angajat).filter(Angajat.id_angajat == id).first()
    if db_angajat:
        for key, value in angajat.dict().items():
            setattr(db_angajat, key, value)
        db.commit()
        db.refresh(db_angajat)
        return db_angajat

def delete_angajat(db: Session, id: int):
    db_angajat = db.query(Angajat).filter(Angajat.id_angajat == id).first()
    if db_angajat:
        db.delete(db_angajat)
        db.commit()
