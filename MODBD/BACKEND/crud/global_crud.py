"""
CRUD helpers pentru vederile globale (bdd_global).

Toate operatiile merg prin singura conexiune bdd_global@oracle-bucuresti.
Triggerele INSTEAD OF ruteaza DML catre fragmentul corect (hotel1/hotel2 etc.).
Verificarea propagarii (Req 4) interogheaza vederea globala si determina
fragmentul din coloana oras (hotel/camera) sau prin JOIN cu hotel_global (angajat).
"""

from sqlalchemy.orm import Session
from sqlalchemy import text


# ─── HOTEL GLOBAL ─────────────────────────────────────────────────────────────

def get_hoteluri_global(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate FROM hotel_global"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def create_hotel_global(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO hotel_global (id_hotel, nume_hotel, oras, nr_stele, capacitate) "
        "VALUES (:id, :nume, :oras, :stele, :cap)"
    ), {"id": data["id_hotel"], "nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate")})
    db.commit()
    return data


def update_hotel_global(db: Session, id_hotel: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE hotel_global SET nume_hotel=:nume, oras=:oras, "
        "nr_stele=:stele, capacitate=:cap WHERE id_hotel=:id"
    ), {"nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate"), "id": id_hotel})
    db.commit()
    return {**data, "id_hotel": id_hotel}


def delete_hotel_global(db: Session, id_hotel: int) -> bool:
    db.execute(text("DELETE FROM hotel_global WHERE id_hotel=:id"), {"id": id_hotel})
    db.commit()
    return True


# ─── ANGAJAT GLOBAL ───────────────────────────────────────────────────────────

def get_angajati_global(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_angajat, nume, prenume, functie, salariu, "
        "id_departament, id_serviciu, id_hotel, cnp, data_angajare "
        "FROM angajat_global"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def create_angajat_global(db: Session, data: dict) -> dict:
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


def update_angajat_global(db: Session, id_angajat: int, data: dict) -> dict:
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


def delete_angajat_global(db: Session, id_angajat: int) -> bool:
    db.execute(text("DELETE FROM angajat_global WHERE id_angajat=:id"), {"id": id_angajat})
    db.commit()
    return True


# ─── CAMERA GLOBAL ────────────────────────────────────────────────────────────

def get_camere_global(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM camera_global"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def create_camera_global(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO camera_global (id_camera, nr_camera, id_tip_camera, id_hotel) "
        "VALUES (:id, :nr, :tip, :hotel)"
    ), {"id": data["id_camera"], "nr": data["nr_camera"],
        "tip": data["id_tip_camera"], "hotel": data["id_hotel"]})
    db.commit()
    return data


def update_camera_global(db: Session, id_camera: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE camera_global SET nr_camera=:nr, id_tip_camera=:tip, id_hotel=:hotel "
        "WHERE id_camera=:id"
    ), {"nr": data["nr_camera"], "tip": data["id_tip_camera"],
        "hotel": data["id_hotel"], "id": id_camera})
    db.commit()
    return {**data, "id_camera": id_camera}


def delete_camera_global(db: Session, id_camera: int) -> bool:
    db.execute(text("DELETE FROM camera_global WHERE id_camera=:id"), {"id": id_camera})
    db.commit()
    return True


# ─── TABELE CENTRALIZATE (read-only via sinonime) ─────────────────────────────

def get_rezervari(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_rezervare, id_client, data_start, data_final FROM rezervare"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def get_plati(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_plata, id_rezervare, suma, data_plata, metoda_plata FROM plata"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


def get_clienti_global(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_client, nume, prenume, email FROM client"
    )).fetchall()
    return [dict(r._mapping) for r in rows]


# ─── VERIFICARE PROPAGARE (Req 4) ─────────────────────────────────────────────
#
# Cu o singura conexiune bdd_global, verificarea se face prin vederea globala.
# Coloana oras indica in ce fragment fizic se afla inregistrarea:
#   oras='Bucuresti' → hotel1 / angajat1 / camera1
#   oras='Constanta' → hotel2 / angajat2 / camera2

def verifica_hotel(db: Session, id_hotel: int) -> dict:
    row = db.execute(text(
        "SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate "
        "FROM hotel_global WHERE id_hotel = :id"
    ), {"id": id_hotel}).fetchone()
    data = dict(row._mapping) if row else None
    oras = (data or {}).get("oras")
    return {
        "entitate": "hotel",
        "id": id_hotel,
        "fragment_bucuresti": data if oras == "Bucuresti" else None,
        "fragment_constanta": data if oras == "Constanta" else None,
    }


def verifica_angajat(db: Session, id_angajat: int) -> dict:
    row = db.execute(text(
        "SELECT ag.id_angajat, ag.nume, ag.prenume, ag.functie, ag.salariu, "
        "ag.id_departament, ag.id_serviciu, ag.id_hotel, ag.cnp, ag.data_angajare, "
        "h.oras "
        "FROM angajat_global ag "
        "JOIN hotel_global h ON ag.id_hotel = h.id_hotel "
        "WHERE ag.id_angajat = :id"
    ), {"id": id_angajat}).fetchone()
    if row:
        d = dict(row._mapping)
        oras = d.pop("oras", None)
        data = d
    else:
        oras, data = None, None
    return {
        "entitate": "angajat",
        "id": id_angajat,
        "fragment_bucuresti": data if oras == "Bucuresti" else None,
        "fragment_constanta": data if oras == "Constanta" else None,
    }


def verifica_camera(db: Session, id_camera: int) -> dict:
    row = db.execute(text(
        "SELECT cg.id_camera, cg.nr_camera, cg.id_tip_camera, cg.id_hotel, h.oras "
        "FROM camera_global cg "
        "JOIN hotel_global h ON cg.id_hotel = h.id_hotel "
        "WHERE cg.id_camera = :id"
    ), {"id": id_camera}).fetchone()
    if row:
        d = dict(row._mapping)
        oras = d.pop("oras", None)
        data = d
    else:
        oras, data = None, None
    return {
        "entitate": "camera",
        "id": id_camera,
        "fragment_bucuresti": data if oras == "Bucuresti" else None,
        "fragment_constanta": data if oras == "Constanta" else None,
    }


# ─── STATISTICI DISTRIBUTIE ───────────────────────────────────────────────────

def get_distributie(db: Session) -> list[dict]:
    result = []
    # Hotel: group by oras directly
    rows = db.execute(text(
        "SELECT oras AS fragment, COUNT(*) AS cnt FROM hotel_global GROUP BY oras"
    )).fetchall()
    for r in rows:
        result.append({"entitate": "hotel", "fragment": r[0], "count": r[1]})

    # Angajat: join cu hotel_global pentru oras
    rows = db.execute(text(
        "SELECT h.oras AS fragment, COUNT(*) AS cnt "
        "FROM angajat_global ag JOIN hotel_global h ON ag.id_hotel = h.id_hotel "
        "GROUP BY h.oras"
    )).fetchall()
    for r in rows:
        result.append({"entitate": "angajat", "fragment": r[0], "count": r[1]})

    # Camera: join cu hotel_global pentru oras
    rows = db.execute(text(
        "SELECT h.oras AS fragment, COUNT(*) AS cnt "
        "FROM camera_global cg JOIN hotel_global h ON cg.id_hotel = h.id_hotel "
        "GROUP BY h.oras"
    )).fetchall()
    for r in rows:
        result.append({"entitate": "camera", "fragment": r[0], "count": r[1]})

    return result
