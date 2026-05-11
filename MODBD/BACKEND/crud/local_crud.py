from sqlalchemy.orm import Session
from sqlalchemy import text

_FRAG = {"Bucuresti": "1", "Constanta": "2"}

def _suffix(oras: str) -> str:
    try:
        return _FRAG[oras]
    except KeyError as exc:
        raise ValueError(f"Oras necunoscut pentru fragmentare: {oras!r}") from exc

def get_hoteluri(db: Session, oras: str) -> list[dict]:
    s = _suffix(oras)
    rows = db.execute(text(
        f"SELECT id_hotel, nume_hotel, oras, nr_stele, capacitate FROM hotel{s}"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_hotel(db: Session, data: dict) -> dict:
    s = _suffix(data["oras"])
    db.execute(text(
        f"INSERT INTO hotel{s} (id_hotel, nume_hotel, oras, nr_stele, capacitate) "
        "VALUES (:id, :nume, :oras, :stele, :cap)"
    ), {"id": data["id_hotel"], "nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate")})
    db.commit()
    return data

def update_hotel(db: Session, id_hotel: int, data: dict) -> dict:
    s = _suffix(data["oras"])
    db.execute(text(
        f"UPDATE hotel{s} SET nume_hotel=:nume, oras=:oras, "
        "nr_stele=:stele, capacitate=:cap WHERE id_hotel=:id"
    ), {"nume": data["nume_hotel"], "oras": data["oras"],
        "stele": data.get("nr_stele"), "cap": data.get("capacitate"), "id": id_hotel})
    db.commit()
    return {**data, "id_hotel": id_hotel}

def delete_hotel(db: Session, id_hotel: int, oras: str) -> bool:
    s = _suffix(oras)
    db.execute(text(f"DELETE FROM hotel{s} WHERE id_hotel=:id"), {"id": id_hotel})
    db.commit()
    return True

def get_angajati(db: Session, oras: str) -> list[dict]:
    s = _suffix(oras)
    rows = db.execute(text(
        f"SELECT a.id_angajat, a.nume, a.prenume, a.functie, a.salariu, "
        "a.id_departament, a.id_serviciu, a.id_hotel, dp.cnp, dp.data_angajare "
        f"FROM angajat{s} a "
        "JOIN angajat_date_personale dp ON a.id_angajat = dp.id_angajat"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_angajat(db: Session, data: dict, oras: str) -> dict:
    s = _suffix(oras)
    db.execute(text(
        f"INSERT INTO angajat{s} "
        "(id_angajat, nume, prenume, functie, salariu, id_departament, id_serviciu, id_hotel) "
        "VALUES (:id, :n, :p, :f, :s, :dep, :serv, :hotel)"
    ), {"id": data["id_angajat"], "n": data["nume"], "p": data["prenume"],
        "f": data.get("functie"), "s": data.get("salariu"),
        "dep": data["id_departament"], "serv": data.get("id_serviciu"),
        "hotel": data["id_hotel"]})
    db.execute(text(
        "INSERT INTO angajat_date_personale (id_angajat, cnp, data_angajare) "
        "VALUES (:id, :cnp, TO_DATE(:da, 'YYYY-MM-DD'))"
    ), {"id": data["id_angajat"], "cnp": data.get("cnp"),
        "da": (data.get("data_angajare") or "")[:10] or None})
    db.commit()
    return data

def update_angajat(db: Session, id_angajat: int, data: dict, oras: str) -> dict:
    s = _suffix(oras)
    db.execute(text(
        f"UPDATE angajat{s} SET nume=:n, prenume=:p, functie=:f, salariu=:s, "
        "id_departament=:dep, id_serviciu=:serv, id_hotel=:hotel "
        "WHERE id_angajat=:id"
    ), {"n": data["nume"], "p": data["prenume"], "f": data.get("functie"),
        "s": data.get("salariu"), "dep": data["id_departament"],
        "serv": data.get("id_serviciu"), "hotel": data["id_hotel"], "id": id_angajat})
    db.execute(text(
        "UPDATE angajat_date_personale SET cnp=:cnp, data_angajare=TO_DATE(:da, 'YYYY-MM-DD') "
        "WHERE id_angajat=:id"
    ), {"cnp": data.get("cnp"),
        "da": (data.get("data_angajare") or "")[:10] or None,
        "id": id_angajat})
    db.commit()
    return {**data, "id_angajat": id_angajat}

def delete_angajat(db: Session, id_angajat: int, oras: str) -> bool:
    s = _suffix(oras)
    db.execute(text(f"DELETE FROM angajat{s} WHERE id_angajat=:id"), {"id": id_angajat})
    db.execute(text("DELETE FROM angajat_date_personale WHERE id_angajat=:id"),
               {"id": id_angajat})
    db.commit()
    return True

def get_camere(db: Session, oras: str) -> list[dict]:
    s = _suffix(oras)
    rows = db.execute(text(
        f"SELECT id_camera, nr_camera, id_tip_camera, id_hotel FROM camera{s}"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_camera(db: Session, data: dict, oras: str) -> dict:
    s = _suffix(oras)
    db.execute(text(
        f"INSERT INTO camera{s} (id_camera, nr_camera, id_tip_camera, id_hotel) "
        "VALUES (:id, :nr, :tip, :hotel)"
    ), {"id": data["id_camera"], "nr": data["nr_camera"],
        "tip": data["id_tip_camera"], "hotel": data["id_hotel"]})
    db.commit()
    return data

def update_camera(db: Session, id_camera: int, data: dict, oras: str) -> dict:
    s = _suffix(oras)
    db.execute(text(
        f"UPDATE camera{s} SET nr_camera=:nr, id_tip_camera=:tip, id_hotel=:hotel "
        "WHERE id_camera=:id"
    ), {"nr": data["nr_camera"], "tip": data["id_tip_camera"],
        "hotel": data["id_hotel"], "id": id_camera})
    db.commit()
    return {**data, "id_camera": id_camera}

def delete_camera(db: Session, id_camera: int, oras: str) -> bool:
    s = _suffix(oras)
    db.execute(text(f"DELETE FROM camera{s} WHERE id_camera=:id"), {"id": id_camera})
    db.commit()
    return True

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

def get_rezervari(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_rezervare, id_client, data_start, data_final FROM rezervare"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_client_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO client (id_client, nume, prenume, email) VALUES (:id, :n, :p, :e)"
    ), {"id": data["id_client"], "n": data["nume"], "p": data["prenume"], "e": data.get("email")})
    db.commit()
    return data

def update_client_central(db: Session, id_client: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE client SET nume=:n, prenume=:p, email=:e WHERE id_client=:id"
    ), {"n": data["nume"], "p": data["prenume"], "e": data.get("email"), "id": id_client})
    db.commit()
    return {**data, "id_client": id_client}

def delete_client_central(db: Session, id_client: int) -> bool:
    db.execute(text("DELETE FROM client WHERE id_client=:id"), {"id": id_client})
    db.commit()
    return True

def create_rezervare_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO rezervare (id_rezervare, id_client, data_start, data_final) "
        "VALUES (:id, :c, TO_DATE(:s, 'YYYY-MM-DD'), TO_DATE(:f, 'YYYY-MM-DD'))"
    ), {"id": data["id_rezervare"], "c": data["id_client"],
        "s": data["data_start"][:10], "f": data["data_final"][:10]})
    db.commit()
    return data

def update_rezervare_central(db: Session, id_rezervare: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE rezervare SET id_client=:c, "
        "data_start=TO_DATE(:s, 'YYYY-MM-DD'), data_final=TO_DATE(:f, 'YYYY-MM-DD') "
        "WHERE id_rezervare=:id"
    ), {"c": data["id_client"], "s": data["data_start"][:10],
        "f": data["data_final"][:10], "id": id_rezervare})
    db.commit()
    return {**data, "id_rezervare": id_rezervare}

def delete_rezervare_central(db: Session, id_rezervare: int) -> bool:
    db.execute(text("DELETE FROM rezervare WHERE id_rezervare=:id"), {"id": id_rezervare})
    db.commit()
    return True

def get_plati_central(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_plata, id_rezervare, suma, data_plata, metoda_plata FROM plata"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_plata_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO plata (id_plata, id_rezervare, suma, data_plata, metoda_plata) "
        "VALUES (:id, :r, :s, TO_DATE(:d, 'YYYY-MM-DD'), :m)"
    ), {"id": data["id_plata"], "r": data["id_rezervare"],
        "s": data["suma"], "d": data["data_plata"][:10], "m": data.get("metoda_plata")})
    db.commit()
    return data

def update_plata_central(db: Session, id_plata: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE plata SET id_rezervare=:r, suma=:s, "
        "data_plata=TO_DATE(:d, 'YYYY-MM-DD'), metoda_plata=:m WHERE id_plata=:id"
    ), {"r": data["id_rezervare"], "s": data["suma"],
        "d": data["data_plata"][:10], "m": data.get("metoda_plata"), "id": id_plata})
    db.commit()
    return {**data, "id_plata": id_plata}

def delete_plata_central(db: Session, id_plata: int) -> bool:
    db.execute(text("DELETE FROM plata WHERE id_plata=:id"), {"id": id_plata})
    db.commit()
    return True

def create_serviciu_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO serviciu (id_serviciu, denumire, pret_serviciu) VALUES (:id, :d, :p)"
    ), {"id": data["id_serviciu"], "d": data["denumire"], "p": data["pret_serviciu"]})
    db.commit()
    return data

def update_serviciu_central(db: Session, id_serviciu: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE serviciu SET denumire=:d, pret_serviciu=:p WHERE id_serviciu=:id"
    ), {"d": data["denumire"], "p": data["pret_serviciu"], "id": id_serviciu})
    db.commit()
    return {**data, "id_serviciu": id_serviciu}

def delete_serviciu_central(db: Session, id_serviciu: int) -> bool:
    db.execute(text("DELETE FROM serviciu WHERE id_serviciu=:id"), {"id": id_serviciu})
    db.commit()
    return True

def create_departament_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO departament (id_departament, nume_departament) VALUES (:id, :n)"
    ), {"id": data["id_departament"], "n": data["nume_departament"]})
    db.commit()
    return data

def update_departament_central(db: Session, id_departament: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE departament SET nume_departament=:n WHERE id_departament=:id"
    ), {"n": data["nume_departament"], "id": id_departament})
    db.commit()
    return {**data, "id_departament": id_departament}

def delete_departament_central(db: Session, id_departament: int) -> bool:
    db.execute(text("DELETE FROM departament WHERE id_departament=:id"), {"id": id_departament})
    db.commit()
    return True

def get_tipuri_camera_central(db: Session) -> list[dict]:
    rows = db.execute(text(
        "SELECT id_tip_camera, tip_camera, clasa_confort, categorie_camera, pret FROM tip_camera"
    )).fetchall()
    return [dict(r._mapping) for r in rows]

def create_tip_camera_central(db: Session, data: dict) -> dict:
    db.execute(text(
        "INSERT INTO tip_camera (id_tip_camera, tip_camera, clasa_confort, categorie_camera, pret) "
        "VALUES (:id, :tip, :clasa, :cat, :pret)"
    ), {"id": data["id_tip_camera"], "tip": data.get("tip_camera"),
        "clasa": data.get("clasa_confort"), "cat": data.get("categorie_camera"),
        "pret": data["pret"]})
    db.commit()
    return data

def update_tip_camera_central(db: Session, id_tip_camera: int, data: dict) -> dict:
    db.execute(text(
        "UPDATE tip_camera SET tip_camera=:tip, clasa_confort=:clasa, "
        "categorie_camera=:cat, pret=:pret WHERE id_tip_camera=:id"
    ), {"tip": data.get("tip_camera"), "clasa": data.get("clasa_confort"),
        "cat": data.get("categorie_camera"), "pret": data["pret"], "id": id_tip_camera})
    db.commit()
    return {**data, "id_tip_camera": id_tip_camera}

def delete_tip_camera_central(db: Session, id_tip_camera: int) -> bool:
    db.execute(text("DELETE FROM tip_camera WHERE id_tip_camera=:id"), {"id": id_tip_camera})
    db.commit()
    return True
