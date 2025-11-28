from sqlalchemy.orm import Session
from models import Camera
from schemas import CameraCreate

def get_camere(db: Session):
    return db.query(Camera).all()

def create_camera(db: Session, camera: CameraCreate):
    db_cam = Camera(**camera.dict())
    db.add(db_cam)
    db.commit()
    db.refresh(db_cam)
    return db_cam

def update_camera(db: Session, id: int, camera: CameraCreate):
    db_cam = db.query(Camera).filter(Camera.id_camera == id).first()
    if db_cam:
        for key, value in camera.dict().items():
            setattr(db_cam, key, value)
        db.commit()
        db.refresh(db_cam)
        return db_cam

def delete_camera(db: Session, id: int):
    db_cam = db.query(Camera).filter(Camera.id_camera == id).first()
    if db_cam:
        db.delete(db_cam)
        db.commit()
