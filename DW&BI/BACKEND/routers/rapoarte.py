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

        if not rows:
            print("Query-ul nu a returnat rezultate")
            return []

        return [dict(zip(columns, row)) for row in rows]

    except Exception as e:
        print(f"EROARE SQL: {e}\nQuery: {query}")
        return []

def run_query_raport3(db: Session, query: str) -> List[Dict]:
    try:
        with db.connection() as conn:
            result = conn.execute(text(query))
            rows = result.mappings().all()  # fiecare rând devine dict
            if not rows:
                print("Raport 3: Query-ul nu a returnat rezultate")
                return []
            print("Raport 3 ROWS:", rows)
            return [dict(r) for r in rows]

    except Exception as e:
        print(f"EROARE SQL Raport 3: {e}\nQuery: {query}")
        return []

@router.get("/raport1_venituri_lunare")
def raport1(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    WITH venituri_lunare AS (
        SELECT
            t.luna,
            SUM(CASE WHEN t.an = 2024 THEN f.suma_totala ELSE 0 END) as venit_lunar_2024,
            SUM(CASE WHEN t.an = 2025 THEN f.suma_totala ELSE 0 END) as venit_lunar_2025
        FROM fact_rezervari f
        JOIN dim_timp t ON f.id_data_start = t.data_completa
        WHERE t.an IN (2024, 2025)
        GROUP BY t.luna
    )
    SELECT
        luna,
        SUM(venit_lunar_2024) OVER (ORDER BY luna ROWS UNBOUNDED PRECEDING) as cumulat_2024,
        SUM(venit_lunar_2025) OVER (ORDER BY luna ROWS UNBOUNDED PRECEDING) as cumulat_2025
    FROM venituri_lunare
    ORDER BY luna
    """
    return run_query(db, query)

@router.get("/raport2_venit_metoda_plata")
def raport2(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    SELECT f.id_camera_dim,
       dm.metoda_plata,
       dm.tip_tranzactie,
       dt.an,
       dt.luna,
       SUM(f.suma_totala)                                                          AS venit_metoda_plata,
       ROUND(
               (SUM(f.suma_totala) /
                SUM(SUM(f.suma_totala)) OVER (PARTITION BY f.id_camera_dim, dt.an, dt.luna)) * 100,
               2)                                                                  AS procent_din_venit_total,
       SUM(f.suma_totala) -
       AVG(SUM(f.suma_totala)) OVER (PARTITION BY f.id_camera_dim, dt.an, dt.luna) AS deviata_fata_de_media_camerei
    FROM fact_rezervari f
            JOIN dim_metoda_plata dm ON f.id_metoda_plata_dim = dm.id_metoda_plata_dim
            JOIN dim_timp dt ON f.id_data_start = dt.data_completa
    WHERE f.id_metoda_plata_dim IN (2, 3)
      AND dt.an = 2024
    GROUP BY f.id_camera_dim, dm.metoda_plata, dm.tip_tranzactie, dt.an, dt.luna
    ORDER BY f.id_camera_dim, dt.an, dt.luna, venit_metoda_plata DESC
    """
    return run_query(db, query)

@router.get("/raport3_top_clienti_vip")
def raport3(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    WITH clienti_vip AS (
    SELECT id_client_dim
    FROM (
        SELECT
            id_client_dim,
            SUM(suma_totala) as total_cheltuit,
            NTILE(20) OVER (ORDER BY SUM(suma_totala) DESC) as tile 
        FROM fact_rezervari
        GROUP BY id_client_dim
    )
    WHERE tile = 1
    ),
    numar_rezervari_per_categorie AS (
        SELECT
            c.categorie_camera,
            COUNT(*) as numar_rezervari
        FROM clienti_vip tc
        JOIN fact_rezervari f ON f.id_client_dim = tc.id_client_dim
        JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
        GROUP BY c.categorie_camera
    )
    SELECT
        categorie_camera,
        numar_rezervari,
        ROUND(RATIO_TO_REPORT(numar_rezervari) OVER () * 100, 2) as procent
    FROM numar_rezervari_per_categorie
    """
    return run_query_raport3(db, query)

@router.get("/raport4_venituri_anuale")
def raport4(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
    WITH venituri_anuale AS (
    SELECT 
        c.categorie_camera,
        AVG(f.suma_totala) as venit_mediu_anual
    FROM fact_rezervari f
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an = 2024
    GROUP BY c.categorie_camera
    ),
    venituri_trimestriale AS (
    SELECT 
        c.categorie_camera,
        CEIL(t.luna / 3.0) as trimestru,
        COUNT(*) as numar_rezervari,
        AVG(f.suma_totala) as venit_mediu_rezervare
    FROM fact_rezervari f
    JOIN dim_camera c ON f.id_camera_dim = c.id_camera_dim
    JOIN dim_timp t ON f.id_data_start = t.data_completa
    WHERE t.an = 2024
    GROUP BY c.categorie_camera, CEIL(t.luna / 3.0)
    )
    SELECT 
        vt.categorie_camera,
        vt.trimestru,
        vt.numar_rezervari,
        ROUND(vt.venit_mediu_rezervare, 2) as venit_mediu_rezervare,
        ROUND(
            ((vt.venit_mediu_rezervare - va.venit_mediu_anual) / va.venit_mediu_anual) * 100, 
            2
        ) as diferenta_procentuala_fata_de_medie_anuala
    FROM venituri_trimestriale vt
    JOIN venituri_anuale va ON vt.categorie_camera = va.categorie_camera
    ORDER BY vt.categorie_camera, vt.trimestru
    """
    return run_query(db, query)

@router.get("/raport5_top_camere_per_metoda")
def raport5(db: Session = Depends(get_db)) -> List[Dict]:
    query = """
      WITH camere_count AS (
      SELECT 
          f.id_metoda_plata_dim,
          f.id_camera_dim,
          COUNT(*) AS numar_rezervari,
          SUM(f.suma_totala) AS venit_total
      FROM fact_rezervari f
      JOIN dim_timp t ON f.id_data_start = t.data_completa
      WHERE t.an = 2024
      GROUP BY f.id_metoda_plata_dim, f.id_camera_dim
  ),

  top_camere AS (
      SELECT 
          id_metoda_plata_dim,
          id_camera_dim,
          numar_rezervari,
          venit_total,
          ROW_NUMBER() OVER (
              PARTITION BY id_metoda_plata_dim
              ORDER BY numar_rezervari DESC
          ) AS rank_camera
      FROM camere_count
  ),

  venituri_lunare AS (
      SELECT 
          tc.id_metoda_plata_dim,
          tc.id_camera_dim,
          t.luna,
          SUM(f.suma_totala) AS venit_lunar
      FROM top_camere tc
      JOIN fact_rezervari f 
          ON tc.id_camera_dim = f.id_camera_dim 
        AND tc.id_metoda_plata_dim = f.id_metoda_plata_dim
      JOIN dim_timp t ON f.id_data_start = t.data_completa
      WHERE tc.rank_camera <= 3 AND t.an = 2024
      GROUP BY tc.id_metoda_plata_dim, tc.id_camera_dim, t.luna
  ),

  rate_crestere AS (
      SELECT 
          id_metoda_plata_dim,
          id_camera_dim,
          AVG(
              CASE 
                  WHEN prev_venit > 0 THEN ((venit_lunar - prev_venit)/prev_venit)*100
                  ELSE 0
              END
          ) AS rata_crestere_medie
      FROM (
          SELECT 
              id_metoda_plata_dim,
              id_camera_dim,
              luna,
              venit_lunar,
              LAG(venit_lunar) OVER (
                  PARTITION BY id_metoda_plata_dim, id_camera_dim 
                  ORDER BY luna
              ) AS prev_venit
          FROM venituri_lunare
      )
      GROUP BY id_metoda_plata_dim, id_camera_dim
  ),

  procent_contributie AS (
      SELECT 
          id_metoda_plata_dim,
          id_camera_dim,
          venit_total,
          (venit_total / SUM(venit_total) OVER (PARTITION BY id_metoda_plata_dim)) * 100 AS contributie_procentuala
      FROM top_camere
      WHERE rank_camera <= 3
  )

  SELECT 
      mp.metoda_plata,
      c.categorie_camera,
      c.nr_camera,
      tc.numar_rezervari,
      ROUND(pc.venit_total, 2) AS valoare_totala,
      ROUND(pc.contributie_procentuala, 2) AS contributie_procentuala,
      ROUND(rc.rata_crestere_medie, 2) AS rata_crestere_lunara_medie
  FROM top_camere tc
  JOIN procent_contributie pc 
      ON tc.id_metoda_plata_dim = pc.id_metoda_plata_dim 
    AND tc.id_camera_dim = pc.id_camera_dim
  JOIN rate_crestere rc 
      ON tc.id_metoda_plata_dim = rc.id_metoda_plata_dim 
    AND tc.id_camera_dim = rc.id_camera_dim
  JOIN dim_camera c ON tc.id_camera_dim = c.id_camera_dim
  JOIN dim_metoda_plata mp ON tc.id_metoda_plata_dim = mp.id_metoda_plata_dim
  WHERE tc.rank_camera <= 3
  ORDER BY mp.metoda_plata, tc.numar_rezervari DESC
    """
    return run_query(db, query)