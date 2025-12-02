from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Dict, List
from session import get_db
from sqlalchemy import text

router = APIRouter(prefix="/dw", tags=["DW"])

def run_query(db: Session, query: str) -> List[Dict]:
    result = db.execute(text(query))
    columns = result.keys()
    return [dict(zip(columns, row)) for row in result.fetchall()]

# --- RAPORT 1 ---
@router.get("/raport1")
def raport1(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    select dc.tip_camera as tip_camera,
           sum(fr.suma_totala) as suma_totala_platita_dec_2025
    from fact_rezervari fr
             join dim_camera dc on fr.camera_key = dc.camera_key
             join dim_timp dt on fr.timp_key = dt.timp_key
    where dt.an = 2025 and dt.luna = 12
    group by dc.tip_camera
    """
    return run_query(db, query)

# --- RAPORT 2 ---
@router.get("/raport2")
def raport2(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    select dc.nume || ' ' || dc.prenume as client,
           count(fr.rezervare_key) as numar_rezervari,
           sum(fr.suma_totala) as suma_platita
    from fact_rezervari fr
             join dim_client dc on fr.client_key = dc.client_key
             join dim_eveniment de on fr.eveniment_key = de.eveniment_key
             join dim_timp dt on fr.timp_key = dt.timp_key
    where dt.an = 2025 and dt.luna = 12
    group by dc.client_key, dc.nume, dc.prenume
    """
    return run_query(db, query)

# --- RAPORT 3 ---
@router.get("/raport3")
def raport3(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    select to_char(dt.data_completa, 'WW') as saptamana,
           sum(ds.pret_serviciu) as venit_servicii
    from fact_rezervari fr
             join dim_timp dt on fr.timp_key = dt.timp_key
             join dim_serviciu ds on fr.serviciu_key = ds.serviciu_key
    where dt.an = 2025 and dt.luna = 12
    group by to_char(dt.data_completa, 'WW')
    order by saptamana
    """
    return run_query(db, query)

# --- RAPORT 4 ---
@router.get("/raport4")
def raport4(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    select dc.tip_camera as tip_camera,
           dmp.metoda_plata as metoda_plata,
           sum(fr.suma_totala) as suma_totala_rezervari
    from fact_rezervari fr
             join dim_camera dc on fr.camera_key = dc.camera_key
             join dim_metoda_plata dmp on fr.metoda_plata_key = dmp.metoda_plata_key
    where fr.eveniment_key is not null
    group by dc.tip_camera, dmp.metoda_plata_key, dmp.metoda_plata
    order by dc.tip_camera
    """
    return run_query(db, query)

# --- RAPORT 5 ---
@router.get("/raport5")
def raport5(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    select dc.nume || ' ' || dc.prenume as client,
           count(fr.rezervare_key) as numar_rezervari,
           sum(fr.suma_totala) as suma_platita
    from fact_rezervari fr
             join dim_client dc on fr.client_key = dc.client_key
             join dim_eveniment de on fr.eveniment_key = de.eveniment_key
             join dim_timp dt on fr.timp_key = dt.timp_key
    where dt.an = 2025 and dt.luna = 12
    group by dc.client_key, dc.nume, dc.prenume
    order by suma_platita desc
    fetch first 5 rows only
    """
    return run_query(db, query)
