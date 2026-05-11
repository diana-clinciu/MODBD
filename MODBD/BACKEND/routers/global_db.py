"""Rute pentru BD globala (vederi bdd_global). Req 2 + Req 4."""

from fastapi import APIRouter, Depends, Form
from sqlalchemy.orm import Session
from session import get_db_global as get_db
from crud import global_crud as crud

router = APIRouter(prefix="/global", tags=["Global"])

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

@router.get("/clienti")
def list_clienti(db: Session = Depends(get_db)):
    return crud.get_clienti_global(db)

@router.post("/clienti")
def add_client(
    id_client: int = Form(...),
    nume: str      = Form(...),
    prenume: str   = Form(...),
    email: str     = Form(None),
    db: Session    = Depends(get_db),
):
    return crud.create_client_global(db, {
        "id_client": id_client, "nume": nume, "prenume": prenume, "email": email,
    })

@router.put("/clienti/{id_client}")
def edit_client(
    id_client: int,
    nume: str    = Form(...),
    prenume: str = Form(...),
    email: str   = Form(None),
    db: Session  = Depends(get_db),
):
    return crud.update_client_global(db, id_client, {
        "nume": nume, "prenume": prenume, "email": email,
    })

@router.delete("/clienti/{id_client}")
def remove_client(id_client: int, db: Session = Depends(get_db)):
    crud.delete_client_global(db, id_client)
    return {"success": True}

@router.get("/rezervari")
def list_rezervari(db: Session = Depends(get_db)):
    return crud.get_rezervari(db)

@router.post("/rezervari")
def add_rezervare(
    id_rezervare: int = Form(...),
    id_client: int    = Form(...),
    data_start: str   = Form(...),
    data_final: str   = Form(...),
    db: Session       = Depends(get_db),
):
    return crud.create_rezervare_global(db, {
        "id_rezervare": id_rezervare, "id_client": id_client,
        "data_start": data_start, "data_final": data_final,
    })

@router.put("/rezervari/{id_rezervare}")
def edit_rezervare(
    id_rezervare: int,
    id_client: int  = Form(...),
    data_start: str = Form(...),
    data_final: str = Form(...),
    db: Session     = Depends(get_db),
):
    return crud.update_rezervare_global(db, id_rezervare, {
        "id_client": id_client, "data_start": data_start, "data_final": data_final,
    })

@router.delete("/rezervari/{id_rezervare}")
def remove_rezervare(id_rezervare: int, db: Session = Depends(get_db)):
    crud.delete_rezervare_global(db, id_rezervare)
    return {"success": True}

@router.get("/plati")
def list_plati(db: Session = Depends(get_db)):
    return crud.get_plati(db)

@router.post("/plati")
def add_plata(
    id_plata: int     = Form(...),
    id_rezervare: int = Form(...),
    suma: float       = Form(...),
    data_plata: str   = Form(...),
    metoda_plata: str = Form(None),
    db: Session       = Depends(get_db),
):
    return crud.create_plata_global(db, {
        "id_plata": id_plata, "id_rezervare": id_rezervare,
        "suma": suma, "data_plata": data_plata, "metoda_plata": metoda_plata,
    })

@router.put("/plati/{id_plata}")
def edit_plata(
    id_plata: int,
    id_rezervare: int = Form(...),
    suma: float       = Form(...),
    data_plata: str   = Form(...),
    metoda_plata: str = Form(None),
    db: Session       = Depends(get_db),
):
    return crud.update_plata_global(db, id_plata, {
        "id_rezervare": id_rezervare, "suma": suma,
        "data_plata": data_plata, "metoda_plata": metoda_plata,
    })

@router.delete("/plati/{id_plata}")
def remove_plata(id_plata: int, db: Session = Depends(get_db)):
    crud.delete_plata_global(db, id_plata)
    return {"success": True}

@router.get("/servicii")
def list_servicii(db: Session = Depends(get_db)):
    return crud.get_servicii_global(db)

@router.post("/servicii")
def add_serviciu(
    id_serviciu: int     = Form(...),
    denumire: str        = Form(...),
    pret_serviciu: float = Form(...),
    db: Session          = Depends(get_db),
):
    return crud.create_serviciu_global(db, {
        "id_serviciu": id_serviciu, "denumire": denumire, "pret_serviciu": pret_serviciu,
    })

@router.put("/servicii/{id_serviciu}")
def edit_serviciu(
    id_serviciu: int,
    denumire: str        = Form(...),
    pret_serviciu: float = Form(...),
    db: Session          = Depends(get_db),
):
    return crud.update_serviciu_global(db, id_serviciu, {
        "denumire": denumire, "pret_serviciu": pret_serviciu,
    })

@router.delete("/servicii/{id_serviciu}")
def remove_serviciu(id_serviciu: int, db: Session = Depends(get_db)):
    crud.delete_serviciu_global(db, id_serviciu)
    return {"success": True}

@router.get("/departamente")
def list_departamente(db: Session = Depends(get_db)):
    return crud.get_departamente_global(db)

@router.post("/departamente")
def add_departament(
    id_departament: int   = Form(...),
    nume_departament: str = Form(...),
    db: Session           = Depends(get_db),
):
    return crud.create_departament_global(db, {
        "id_departament": id_departament, "nume_departament": nume_departament,
    })

@router.put("/departamente/{id_departament}")
def edit_departament(
    id_departament: int,
    nume_departament: str = Form(...),
    db: Session           = Depends(get_db),
):
    return crud.update_departament_global(db, id_departament, {
        "nume_departament": nume_departament,
    })

@router.delete("/departamente/{id_departament}")
def remove_departament(id_departament: int, db: Session = Depends(get_db)):
    crud.delete_departament_global(db, id_departament)
    return {"success": True}

@router.get("/tipuri_camera")
def list_tipuri_camera(db: Session = Depends(get_db)):
    return crud.get_tipuri_camera_global(db)

@router.post("/tipuri_camera")
def add_tip_camera(
    id_tip_camera: int    = Form(...),
    tip_camera: str       = Form(None),
    clasa_confort: str    = Form(None),
    categorie_camera: str = Form(None),
    pret: float           = Form(...),
    db: Session           = Depends(get_db),
):
    return crud.create_tip_camera_global(db, {
        "id_tip_camera": id_tip_camera, "tip_camera": tip_camera,
        "clasa_confort": clasa_confort, "categorie_camera": categorie_camera, "pret": pret,
    })

@router.put("/tipuri_camera/{id_tip_camera}")
def edit_tip_camera(
    id_tip_camera: int,
    tip_camera: str       = Form(None),
    clasa_confort: str    = Form(None),
    categorie_camera: str = Form(None),
    pret: float           = Form(...),
    db: Session           = Depends(get_db),
):
    return crud.update_tip_camera_global(db, id_tip_camera, {
        "tip_camera": tip_camera, "clasa_confort": clasa_confort,
        "categorie_camera": categorie_camera, "pret": pret,
    })

@router.delete("/tipuri_camera/{id_tip_camera}")
def remove_tip_camera(id_tip_camera: int, db: Session = Depends(get_db)):
    crud.delete_tip_camera_global(db, id_tip_camera)
    return {"success": True}

@router.get("/verificare/hoteluri/{id_hotel}")
def verificare_hotel(id_hotel: int, db: Session = Depends(get_db)):
    return crud.verifica_hotel(db, id_hotel)

@router.get("/verificare/angajati/{id_angajat}")
def verificare_angajat(id_angajat: int, db: Session = Depends(get_db)):
    return crud.verifica_angajat(db, id_angajat)

@router.get("/verificare/camere/{id_camera}")
def verificare_camera(id_camera: int, db: Session = Depends(get_db)):
    return crud.verifica_camera(db, id_camera)
