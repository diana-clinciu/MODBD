"""Rute pentru BD globala (vederi bdd_global). Req 2 + Req 4."""

from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db
from crud import global_crud as crud

router = APIRouter(prefix="/global", tags=["Global"])


# ─── HOTEL GLOBAL ─────────────────────────────────────────────────────────────

@router.get("/hoteluri")
def list_hoteluri(db: Session = Depends(get_db)):
    return crud.get_hoteluri_global(db)


@router.post("/hoteluri")
def add_hotel(
    id_hotel: int    = Form(...),
    nume_hotel: str  = Form(...),
    oras: str        = Form(...),
    nr_stele: int    = Form(None),
    capacitate: int  = Form(None),
    db: Session      = Depends(get_db),
):
    return crud.create_hotel_global(db, {
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
    return crud.update_hotel_global(db, id_hotel, {
        "nume_hotel": nume_hotel, "oras": oras,
        "nr_stele": nr_stele, "capacitate": capacitate,
    })


@router.delete("/hoteluri/{id_hotel}")
def remove_hotel(id_hotel: int, db: Session = Depends(get_db)):
    crud.delete_hotel_global(db, id_hotel)
    return {"success": True}


# ─── ANGAJAT GLOBAL ───────────────────────────────────────────────────────────

@router.get("/angajati")
def list_angajati(db: Session = Depends(get_db)):
    return crud.get_angajati_global(db)


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
    return crud.create_angajat_global(db, {
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
    return crud.update_angajat_global(db, id_angajat, {
        "nume": nume, "prenume": prenume, "functie": functie, "salariu": salariu,
        "id_departament": id_departament, "id_serviciu": id_serviciu,
        "id_hotel": id_hotel, "cnp": cnp, "data_angajare": data_angajare,
    })


@router.delete("/angajati/{id_angajat}")
def remove_angajat(id_angajat: int, db: Session = Depends(get_db)):
    crud.delete_angajat_global(db, id_angajat)
    return {"success": True}


# ─── CAMERA GLOBAL ────────────────────────────────────────────────────────────

@router.get("/camere")
def list_camere(db: Session = Depends(get_db)):
    return crud.get_camere_global(db)


@router.post("/camere")
def add_camera(
    id_camera: int     = Form(...),
    nr_camera: int     = Form(...),
    id_tip_camera: int = Form(...),
    id_hotel: int      = Form(...),
    db: Session        = Depends(get_db),
):
    return crud.create_camera_global(db, {
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
    return crud.update_camera_global(db, id_camera, {
        "nr_camera": nr_camera, "id_tip_camera": id_tip_camera, "id_hotel": id_hotel,
    })


@router.delete("/camere/{id_camera}")
def remove_camera(id_camera: int, db: Session = Depends(get_db)):
    crud.delete_camera_global(db, id_camera)
    return {"success": True}


# ─── TABELE CENTRALIZATE (read-only) ──────────────────────────────────────────

@router.get("/rezervari")
def list_rezervari(db: Session = Depends(get_db)):
    return crud.get_rezervari(db)


@router.get("/plati")
def list_plati(db: Session = Depends(get_db)):
    return crud.get_plati(db)


@router.get("/clienti")
def list_clienti(db: Session = Depends(get_db)):
    return crud.get_clienti_global(db)


# ─── VERIFICARE PROPAGARE (Req 4) ─────────────────────────────────────────────

@router.get("/verificare/hoteluri/{id_hotel}")
def verificare_hotel(id_hotel: int, db: Session = Depends(get_db)):
    return crud.verifica_hotel(db, id_hotel)


@router.get("/verificare/angajati/{id_angajat}")
def verificare_angajat(id_angajat: int, db: Session = Depends(get_db)):
    return crud.verifica_angajat(db, id_angajat)


@router.get("/verificare/camere/{id_camera}")
def verificare_camera(id_camera: int, db: Session = Depends(get_db)):
    return crud.verifica_camera(db, id_camera)
