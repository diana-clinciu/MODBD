from sqlalchemy.orm import Session
from models import Client
from schemas import ClientCreate

def get_clients(db: Session):
    return db.query(Client).all()

def create_client(db: Session, client: ClientCreate):
    db_client = Client(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_client(db: Session, id_client: int, client: ClientCreate):
    db_client = db.query(Client).filter(Client.id_client == id_client).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_client(db: Session, id_client: int):
    db_client = db.query(Client).filter(Client.id_client == id_client).first()
    if db_client:
        db.delete(db_client)
        db.commit()
        return True
    return False
