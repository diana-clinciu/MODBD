from datetime import datetime
from sqlalchemy.orm import Session
from models import Rezervare as RezervareModel
from schemas import RezervareCreate, RezervareResponse

def get_rezervari(db: Session):
    rezervari = db.query(RezervareModel).all()
    result = []
    for r in rezervari:
        client_name = f"{r.client.nume} {r.client.prenume}"
        result.append(
            RezervareResponse(
                id_rezervare=r.id_rezervare,
                clientName=client_name,
                data=r.data
            )
        )
    return result

def create_rezervare(db: Session, rezervare: RezervareCreate):
    db_rez = RezervareModel(
        id_client=rezervare.id_client,
        data=rezervare.data
    )
    db.add(db_rez)
    db.commit()
    db.refresh(db_rez)
    client_name = f"{db_rez.client.nume} {db_rez.client.prenume}"
    return RezervareResponse(
        id_rezervare=db_rez.id_rezervare,
        clientName=client_name,
        data=db_rez.data
    )

def update_rezervare(db: Session, id: int, rezervare_data: RezervareCreate):
    rezervare = db.query(RezervareModel).filter(RezervareModel.id_rezervare == id).first()
    if not rezervare:
        return None
    rezervare.id_client = rezervare_data.id_client
    rezervare.data = rezervare_data.data
    db.commit()
    db.refresh(rezervare)
    
    return RezervareResponse(
        id_rezervare=rezervare.id_rezervare,
        clientName=rezervare.client.nume + " " + rezervare.client.prenume,
        data=rezervare.data
    )

def delete_rezervare(db: Session, id: int):
    db_rez = db.query(RezervareModel).filter(RezervareModel.id_rezervare == id).first()
    if db_rez:
        db.delete(db_rez)
        db.commit()
        return True
    return False
