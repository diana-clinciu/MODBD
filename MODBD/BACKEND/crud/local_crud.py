"""
CRUD helpers pentru fragmentele locale prin vederile globale (bdd_global).

Operatiile "locale" sunt filtrate dupa oras (hotel/camera) sau dupa id_hotel
din fragmentul corespunzator orasului (angajat).
Triggerele INSTEAD OF pe vederi rutateaza DML catre fragmentul corect.
"""

from sqlalchemy.orm import Session
from sqlalchemy import text


# ─── HOTEL ────────────────────────────────────────────────────────────────────

def get_hoteluri(db: Session, oras: str) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate "
        "FROM hotel_global WHERE oras = :oras"
    ), {"oras": oras}).fetchall()
    return [dict(r._mapping) for r in rows]


def create_hotel(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO hotel_global (id_hotel, nume_hotel, oras, nr_stele, capacitate) "
        "VALUES (:id, :nume, :oras, :stele, :cap)"
    ), {"id": data["id_hotel"], "nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate")})
    db.commit()
    return data


def update_hotel(db: Session, id_hotel: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE hotel_global SET nume_hotel=:nume, oras=:oras, "
        "nr_stele=:stele, capacitate=:cap WHERE id_hotel=:id"
    ), {"nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate"), "id": id_hotel})
    db.commit()
    return {**data, "id_hotel": id_hotel}


def delete_hotel(db: Session, id_hotel: int) -> bool:
    db.execute(text("DELETE FROM hotel_global WHERE id_hotel=:id"), {"id": id_hotel})
    db.commit()
    return True


# ─── ANGAJAT ──────────────────────────────────────────────────────────────────

def get_angajati(db: Session, oras: str) -> list[dict]:
    rows = db.execute(text(
        "SELECT ag.id_angajat, ag.nume, ag.prenume, ag.functie, ag.salariu, "
        "ag.id_departament, ag.id_serviciu, ag.id_hotel, ag.cnp, ag.data_angajare "
        "FROM angajat_global ag "
        "JOIN hotel_global h ON ag.id_hotel = h.id_hotel "
        "WHERE h.oras = :oras"
    ), {"oras": oras}).fetchall()
    return [dict(r._mapping) for r in rows]


def create_angajat(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO angajat_global "
        "(id_angajat, nume, prenume, functie, salariu, "
        "id_departament, id_serviciu, id_hotel, cnp, data_angajare) "
        "VALUES (:id, :n, :p, :f, :s, :dep, :serv, :hotel, :cnp, :da)"
    ), {"id": data["id_angajat"], "n": data["nume"], "p": data["prenume"],
        "f": data.get("functie"), "s": data.get("salariu"),
        "dep": data["id_departament"], "serv": data.get("id_serviciu"),
        "hotel": data["id_hotel"], "cnp": data.get("cnp"),
        "da": data.get("data_angajare")})
    db.commit()
    return data


def update_angajat(db: Session, id_angajat: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE angajat_global SET nume=:n, prenume=:p, functie=:f, salariu=:s, "
        "id_departament=:dep, id_serviciu=:serv, id_hotel=:hotel, "
        "cnp=:cnp, data_angajare=:da "
        "WHERE id_angajat=:id"
    ), {"n": data["nume"], "p": data["prenume"], "f": data.get("functie"),
        "s": data.get("salariu"), "dep": data["id_departament"],
        "serv": data.get("id_serviciu"), "hotel": data["id_hotel"],
        "cnp": data.get("cnp"), "da": data.get("data_angajare"), "id": id_angajat})
    db.commit()
    return {**data, "id_angajat": id_angajat}


def delete_angajat(db: Session, id_angajat: int) -> bool:
    db.execute(text("DELETE FROM angajat_global WHERE id_angajat=:id"), {"id": id_angajat})
    db.commit()
    return True


# ─── CAMERA ───────────────────────────────────────────────────────────────────

def get_camere(db: Session, oras: str) -> list[dict]:
    rows = db.execute(text(
        "SELECT cg.id_camera, cg.nr_camera, cg.id_tip_camera, cg.id_hotel "
        "FROM camera_global cg "
        "JOIN hotel_global h ON cg.id_hotel = h.id_hotel "
        "WHERE h.oras = :oras"
    ), {"oras": oras}).fetchall()
    return [dict(r._mapping) for r in rows]


def create_camera(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO camera_global (id_camera, nr_camera, id_tip_camera, id_hotel) "
        "VALUES (:id, :nr, :tip, :hotel)"
    ), {"id": data["id_camera"], "nr": data["nr_camera"],
        "tip": data["id_tip_camera"], "hotel": data["id_hotel"]})
    db.commit()
    return data


def update_camera(db: Session, id_camera: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE camera_global SET nr_camera=:nr, id_tip_camera=:tip, id_hotel=:hotel "
        "WHERE id_camera=:id"
    ), {"nr": data["nr_camera"], "tip": data["id_tip_camera"],
        "hotel": data["id_hotel"], "id": id_camera})
    db.commit()
    return {**data, "id_camera": id_camera}


def delete_camera(db: Session, id_camera: int) -> bool:
    db.execute(text("DELETE FROM camera_global WHERE id_camera=:id"), {"id": id_camera})
    db.commit()
    return True


# ─── TABELE REFERINTA (accesibile prin sinonime in bdd_global) ────────────────

def get_clienti(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_client, nume, prenume, email FROM client"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def get_servicii(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_serviciu, denumire, pret_serviciu FROM serviciu"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def get_tip_camere(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_tip_camera, tip_camera, clasa_confort, categorie_camera, pret "
        "FROM tip_camera"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def get_departamente(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_departament, nume_departament FROM departament"
    )).fetchall()
    return [dict(r._mapping) for r in rows]
