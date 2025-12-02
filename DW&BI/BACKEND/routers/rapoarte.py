from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Dict, List
from session import get_db 

router = APIRouter(prefix="/dw", tags=["DW - Rapoarte"])

def run_query(db: Session, query: str) -> List[Dict]:
    try:
        result = db.execute(text(query))
        
        columns = result.keys()
        rows = result.fetchall()

        dict_rows = [dict(zip(columns, row)) for row in rows]
        
        return dict_rows

    except Exception as e:
        print(f"EROARE SQL: {e}")
        raise HTTPException(status_code=400, detail=f"Eroare executie raport: {str(e)}")

@router.get("/raport1_camere_decembrie")
def raport1(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT dc.tip_camera as tip_camera,
           sum(fr.suma_totala) as suma_totala_platita_dec_2025
      FROM fact_rezervari fr
      JOIN dim_camera dc ON fr.camera_key = dc.camera_key
      JOIN dim_timp dt   ON fr.timp_key = dt.timp_key
     WHERE dt.an = 2025
       AND dt.luna = 12
     GROUP BY dc.tip_camera
    """
    return run_query(db, query)

@router.get("/raport2_clienti_evenimente")
def raport2(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT dc.nume || ' ' || dc.prenume as client,
           count(fr.rezervare_key) as numar_rezervari,
           sum(fr.suma_totala) as suma_platita
      FROM fact_rezervari fr
      JOIN dim_client dc    ON fr.client_key = dc.client_key
      JOIN dim_eveniment de ON fr.eveniment_key = de.eveniment_key
      JOIN dim_timp dt      ON fr.timp_key = dt.timp_key
     WHERE dt.an = 2025
       AND dt.luna = 12
     GROUP BY dc.client_key,
              dc.nume,
              dc.prenume
    """
    return run_query(db, query)

@router.get("/raport3_evolutie_servicii")
def raport3(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT to_char(dt.data_completa, 'WW') as saptamana,
           sum(ds.pret_serviciu) as venit_servicii
      FROM fact_rezervari fr
      JOIN dim_timp dt      ON fr.timp_key = dt.timp_key
      JOIN dim_serviciu ds  ON fr.serviciu_key = ds.serviciu_key
     WHERE dt.an = 2025
       AND dt.luna = 12
     GROUP BY to_char(dt.data_completa, 'WW')
     ORDER BY saptamana
    """
    return run_query(db, query)

@router.get("/raport4_metode_plata")
def raport4(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT dc.tip_camera as tip_camera,
           dmp.metoda_plata as metoda_plata,
           sum(fr.suma_totala) as suma_totala_rezervari
      FROM fact_rezervari fr
      JOIN dim_camera dc        ON fr.camera_key = dc.camera_key
      JOIN dim_metoda_plata dmp ON fr.metoda_plata_key = dmp.metoda_plata_key
     WHERE fr.eveniment_key is not null
     GROUP BY dc.tip_camera,
              dmp.metoda_plata_key,
              dmp.metoda_plata
     ORDER BY dc.tip_camera
    """
    return run_query(db, query)

@router.get("/raport5_top_clienti")
def raport5(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT dc.nume || ' ' || dc.prenume as client,
           count(fr.rezervare_key) as numar_rezervari,
           sum(fr.suma_totala) as suma_platita
      FROM fact_rezervari fr
      JOIN dim_client dc    ON fr.client_key = dc.client_key
      JOIN dim_eveniment de ON fr.eveniment_key = de.eveniment_key
      JOIN dim_timp dt      ON fr.timp_key = dt.timp_key
     WHERE dt.an = 2025
       AND dt.luna = 12
     GROUP BY dc.client_key,
              dc.nume,
              dc.prenume
     ORDER BY suma_platita desc
     FETCH FIRST 5 ROWS ONLY
    """
    return run_query(db, query)