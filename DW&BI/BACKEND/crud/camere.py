from sqlalchemy.orm import Session
from models import Camera
from schemas import CameraCreate

def get_camere(db: Session):
    return db.query(Camera).all()

def create_camera(db: Session, client: CameraCreate):
    db_client = Camera(**client.dict())
    db.add(db_client)
    db.commit()
    db.refresh(db_client)
    return db_client

def update_camera(db: Session, id: int, client: CameraCreate):
    db_client = db.query(Camera).filter(Camera.id == id).first()
    if db_client:
        for key, value in client.dict().items():
            setattr(db_client, key, value)
        db.commit()
        db.refresh(db_client)
        return db_client

def delete_camera(db: Session, id: int):
    db_client = db.query(Camera).filter(Camera.id == id).first()
    if db_client:
        db.delete(db_client)
        db.commit()
