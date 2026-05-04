import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

Base = declarative_base()

DB_HOST = os.getenv("DB_HOST", "oracle-bucuresti")
DB_PORT = os.getenv("DB_PORT", "1521")

# Singura conexiune: bdd_global@oracle-bucuresti
# Vederile globale (hotel_global, angajat_global, camera_global) + sinonimele
# din schema bdd_global acopera toate fragmentele prin DB link.
URL = f"oracle+oracledb://bdd_global:password@{DB_HOST}:{DB_PORT}/?service_name=FREEPDB1"

engine = create_engine(URL, echo=False)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
