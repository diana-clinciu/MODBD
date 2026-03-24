from sqlalchemy.orm import Session
from sqlalchemy import text

def propagate_dw(db: Session):
    results = {}

    # DIM_CLIENT
    db.execute(text("ALTER TABLE dim_client ENABLE CONSTRAINT UQ_DIM_CLIENT_OLTP"))
    res = db.execute(text("""
        INSERT INTO dim_client (id_client_dim, id_client_oltp, nume, prenume, email)
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
    db.execute(text("ALTER TABLE dim_camera ENABLE CONSTRAINT UQ_DIM_CAMERA_OLTP"))
    res = db.execute(text("""
        INSERT INTO dim_camera (id_camera_dim, id_camera_oltp, nr_camera, tip_camera, categorie_camera, clasa_confort, pret)
        SELECT CAMERA_SEQ.NEXTVAL, c.id_camera, c.nr_camera, c.tip_camera, c.categorie_camera, c.clasa_confort, c.pret
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
    db.execute(text("ALTER TABLE dim_serviciu ENABLE CONSTRAINT UQ_DIM_SERVICIU_OLTP"))
    res = db.execute(text("""
        INSERT INTO dim_serviciu (id_serviciu_dim, id_serviciu_oltp, denumire, pret_serviciu)
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
    db.execute(text("ALTER TABLE dim_eveniment ENABLE CONSTRAINT UQ_DIM_EVENIMENT_OLTP"))
    db.execute(text("ALTER TABLE dim_eveniment ENABLE CONSTRAINT UQ_DIM_EVENIMENT_NUME_DATA"))
    res = db.execute(text("""
        INSERT INTO dim_eveniment (id_eveniment_dim, id_eveniment_oltp, nume_eveniment, data_eveniment)
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
        INSERT INTO dim_timp (data_completa, zi, luna, an, luna_an)
        SELECT
            dt,
            EXTRACT(DAY FROM dt),
            EXTRACT(MONTH FROM dt),
            EXTRACT(YEAR FROM dt),
            TO_CHAR(dt, 'YYYYMM')
        FROM (
            SELECT DISTINCT r.data_start + LEVEL - 1 AS dt
            FROM rezervare r
            CONNECT BY LEVEL <= (r.data_final - r.data_start + 1)
            AND PRIOR r.id_rezervare = r.id_rezervare
            AND PRIOR SYS_GUID() IS NOT NULL
        )
        WHERE NOT EXISTS (
            SELECT 1
            FROM dim_timp d
            WHERE d.data_completa = dt
        )
    """))
    results['dim_timp_inserted'] = res.rowcount
    results['dim_timp'] = db.execute(text("SELECT COUNT(*) FROM dim_timp")).scalar()

    # DIM_METODA_PLATA
    db.execute(text("ALTER TABLE dim_metoda_plata ENABLE CONSTRAINT UQ_DIM_METODA_PLATA"))
    res = db.execute(text("""
        INSERT INTO dim_metoda_plata (id_metoda_plata_dim, metoda_plata, tip_tranzactie)
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
