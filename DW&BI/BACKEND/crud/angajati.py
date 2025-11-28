from sqlalchemy.orm import Session
from models import Angajat
from schemas import AngajatCreate

def get_angajati(db: Session):
    return db.query(Angajat).all()

def create_angajat(db: Session, client: AngajatCreate):
    db_client = Angajat(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_angajat(db: Session, id: int, client: AngajatCreate):
    db_client = db.query(Angajat).filter(Angajat.id == id).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_angajat(db: Session, id: int):
    db_client = db.query(Angajat).filter(Angajat.id == id).first()
    if db_client:
        db.delete(db_client)
        db.commit()
