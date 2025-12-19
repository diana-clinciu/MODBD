from sqlalchemy.orm import Session
from sqlalchemy import text

def propagate_dw(db: Session):
    results = {}

    # DIM_CLIENT
    res = db.execute(text("""
        INSERT INTO dim_client (client_key, id_client_oltp, nume, prenume, email)
        SELECT CLIENT_SEQ.NEXTVAL, c.id_client, c.nume, c.prenume, c.email
        FROM client c
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_client d
            WHERE d.id_client_oltp = c.id_client
        )
    """))
    results['dim_client_inserted'] = res.rowcount
    results['dim_client'] = db.execute(text("SELECT COUNT(*) FROM dim_client")).scalar()

    # DIM_CAMERA
    res = db.execute(text("""
        INSERT INTO dim_camera (camera_key, id_camera_oltp, nr_camera, tip_camera, pret)
        SELECT CAMERA_SEQ.NEXTVAL, c.id_camera, c.nr_camera, c.tip_camera, c.pret
        FROM camera c
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_camera d
            WHERE d.id_camera_oltp = c.id_camera
        )
    """))
    results['dim_camera_inserted'] = res.rowcount
    results['dim_camera'] = db.execute(text("SELECT COUNT(*) FROM dim_camera")).scalar()

    # DIM_SERVICIU
    res = db.execute(text("""
        INSERT INTO dim_serviciu (serviciu_key, id_serviciu_oltp, denumire, pret_serviciu)
        SELECT SERVICIU_SEQ.NEXTVAL, s.id_serviciu, s.denumire, s.pret_serviciu
        FROM serviciu s
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_serviciu d
            WHERE d.id_serviciu_oltp = s.id_serviciu
        )
    """))
    results['dim_serviciu_inserted'] = res.rowcount
    results['dim_serviciu'] = db.execute(text("SELECT COUNT(*) FROM dim_serviciu")).scalar()

    # DIM_EVENIMENT
    res = db.execute(text("""
        INSERT INTO dim_eveniment (eveniment_key, id_eveniment_oltp, nume_eveniment, data_eveniment)
        SELECT EVENIMENT_SEQ.NEXTVAL, e.id_eveniment, e.nume_eveniment, e.data_eveniment
        FROM eveniment e
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_eveniment d
            WHERE d.id_eveniment_oltp = e.id_eveniment
        )
    """))
    results['dim_eveniment_inserted'] = res.rowcount
    results['dim_eveniment'] = db.execute(text("SELECT COUNT(*) FROM dim_eveniment")).scalar()

    # DIM_TIMP
    res = db.execute(text("""
        INSERT INTO dim_timp (timp_key, data_completa, zi, luna, an)
        SELECT TIMP_SEQ.NEXTVAL,
               r.data_rezervare,
               EXTRACT(DAY FROM r.data_rezervare),
               EXTRACT(MONTH FROM r.data_rezervare),
               EXTRACT(YEAR FROM r.data_rezervare)
        FROM rezervare r
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_timp dt
            WHERE dt.data_completa = r.data_rezervare
        )
    """))
    results['dim_timp_inserted'] = res.rowcount
    results['dim_timp'] = db.execute(text("SELECT COUNT(*) FROM dim_timp")).scalar()

    # DIM_METODA_PLATA
    res = db.execute(text("""
        INSERT INTO dim_metoda_plata (metoda_plata_key, metoda_plata, tip_tranzactie)
        SELECT METODA_PLATA_SEQ.NEXTVAL,
               p.metoda_plata,
               CASE
                   WHEN p.metoda_plata IN ('Card', 'Transfer') THEN 'Electronic'
                   ELSE 'Numerar'
               END
        FROM plata p
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_metoda_plata d
            WHERE d.metoda_plata = p.metoda_plata
        )
    """))
    results['dim_metoda_plata_inserted'] = res.rowcount
    results['dim_metoda_plata'] = db.execute(text("SELECT COUNT(*) FROM dim_metoda_plata")).scalar()

    db.commit()
    return results
