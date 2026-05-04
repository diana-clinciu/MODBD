"""Rute CRUD pentru fragmentul LOCAL CONSTANTA (filtrat din vederi globale bdd_global)."""

from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
from crud import local_crud as crud

router = APIRouter(prefix="/local/con", tags=["Local – Constanta"])

_ORAS = "Constanta"


# ─── HOTEL2 ───────────────────────────────────────────────────────────────────

@router.get("/hoteluri")
def list_hoteluri(db: Session = Depends(get_db)):
    return crud.get_hoteluri(db, _ORAS)


@router.post("/hoteluri")
def add_hotel(
    id_hotel: int    = Form(...),
    nume_hotel: str  = Form(...),
    oras: str        = Form(...),
    nr_stele: int    = Form(None),
    capacitate: int  = Form(None),
    db: Session      = Depends(get_db),
):
    return crud.create_hotel(db, {
        "id_hotel": id_hotel, "nume_hotel": nume_hotel, "oras": oras,
        "nr_stele": nr_stele, "capacitate": capacitate,
    })


@router.put("/hoteluri/{id_hotel}")
def edit_hotel(
    id_hotel: int,
    nume_hotel: str = Form(...),
    oras: str       = Form(...),
    nr_stele: int   = Form(None),
    capacitate: int = Form(None),
    db: Session     = Depends(get_db),
):
    return crud.update_hotel(db, id_hotel, {
        "nume_hotel": nume_hotel, "oras": oras,
        "nr_stele": nr_stele, "capacitate": capacitate,
    })


@router.delete("/hoteluri/{id_hotel}")
def remove_hotel(id_hotel: int, db: Session = Depends(get_db)):
    crud.delete_hotel(db, id_hotel)
    return {"success": True}


# ─── ANGAJAT2 ─────────────────────────────────────────────────────────────────

@router.get("/angajati")
def list_angajati(db: Session = Depends(get_db)):
    return crud.get_angajati(db, _ORAS)


@router.post("/angajati")
def add_angajat(
    id_angajat: int     = Form(...),
    nume: str           = Form(...),
    prenume: str        = Form(...),
    functie: str        = Form(None),
    salariu: float      = Form(None),
    id_departament: int = Form(...),
    id_serviciu: int    = Form(None),
    id_hotel: int       = Form(...),
    cnp: str            = Form(None),
    data_angajare: str  = Form(None),
    db: Session         = Depends(get_db),
):
    return crud.create_angajat(db, {
        "id_angajat": id_angajat, "nume": nume, "prenume": prenume,
        "functie": functie, "salariu": salariu,
        "id_departament": id_departament, "id_serviciu": id_serviciu,
        "id_hotel": id_hotel, "cnp": cnp, "data_angajare": data_angajare,
    })


@router.put("/angajati/{id_angajat}")
def edit_angajat(
    id_angajat: int,
    nume: str           = Form(...),
    prenume: str        = Form(...),
    functie: str        = Form(None),
    salariu: float      = Form(None),
    id_departament: int = Form(...),
    id_serviciu: int    = Form(None),
    id_hotel: int       = Form(...),
    cnp: str            = Form(None),
    data_angajare: str  = Form(None),
    db: Session         = Depends(get_db),
):
    return crud.update_angajat(db, id_angajat, {
        "nume": nume, "prenume": prenume, "functie": functie, "salariu": salariu,
        "id_departament": id_departament, "id_serviciu": id_serviciu,
        "id_hotel": id_hotel, "cnp": cnp, "data_angajare": data_angajare,
    })


@router.delete("/angajati/{id_angajat}")
def remove_angajat(id_angajat: int, db: Session = Depends(get_db)):
    crud.delete_angajat(db, id_angajat)
    return {"success": True}


# ─── CAMERA2 ──────────────────────────────────────────────────────────────────

@router.get("/camere")
def list_camere(db: Session = Depends(get_db)):
    return crud.get_camere(db, _ORAS)


@router.post("/camere")
def add_camera(
    id_camera: int     = Form(...),
    nr_camera: int     = Form(...),
    id_tip_camera: int = Form(...),
    id_hotel: int      = Form(...),
    db: Session        = Depends(get_db),
):
    return crud.create_camera(db, {
        "id_camera": id_camera, "nr_camera": nr_camera,
        "id_tip_camera": id_tip_camera, "id_hotel": id_hotel,
    })


@router.put("/camere/{id_camera}")
def edit_camera(
    id_camera: int,
    nr_camera: int     = Form(...),
    id_tip_camera: int = Form(...),
    id_hotel: int      = Form(...),
    db: Session        = Depends(get_db),
):
    return crud.update_camera(db, id_camera, {
        "nr_camera": nr_camera, "id_tip_camera": id_tip_camera, "id_hotel": id_hotel,
    })


@router.delete("/camere/{id_camera}")
def remove_camera(id_camera: int, db: Session = Depends(get_db)):
    crud.delete_camera(db, id_camera)
    return {"success": True}


# ─── TABELE REPLICATE ─────────────────────────────────────────────────────────

@router.get("/clienti")
def list_clienti(db: Session = Depends(get_db)):
    return crud.get_clienti(db)


@router.get("/servicii")
def list_servicii(db: Session = Depends(get_db)):
    return crud.get_servicii(db)


# ─── REFERINTA ────────────────────────────────────────────────────────────────

@router.get("/referinta/tipuri_camera")
def ref_tip_camere(db: Session = Depends(get_db)):
    return crud.get_tip_camere(db)


@router.get("/referinta/departamente")
def ref_departamente(db: Session = Depends(get_db)):
    return crud.get_departamente(db)
