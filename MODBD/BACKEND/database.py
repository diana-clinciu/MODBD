import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

Base = declarative_base()

DB_PORT  = os.getenv("DB_PORT", "1521")
SERVICE  = os.getenv("DB_SERVICE", "FREEPDB1")
HOST_BUC = os.getenv("DB_BUC_HOST", "oracle-bucuresti")
HOST_CON = os.getenv("DB_CON_HOST", "oracle-constanta")

URL_GLOBAL = f"oracle+oracledb://bdd_global:password@{HOST_BUC}:{DB_PORT}/?service_name={SERVICE}"
URL_BUC    = f"oracle+oracledb://bdd:password@{HOST_BUC}:{DB_PORT}/?service_name={SERVICE}"
URL_CON    = f"oracle+oracledb://bdd:password@{HOST_CON}:{DB_PORT}/?service_name={SERVICE}"

engine_global = create_engine(URL_GLOBAL, echo=False)
engine_buc    = create_engine(URL_BUC,    echo=False)
engine_con    = create_engine(URL_CON,    echo=False)

SessionGlobal = sessionmaker(bind=engine_global, autocommit=False, autoflush=False)
SessionBuc    = sessionmaker(bind=engine_buc,    autocommit=False, autoflush=False)
SessionCon    = sessionmaker(bind=engine_con,    autocommit=False, autoflush=False)

SessionLocal = SessionGlobal
engine = engine_global
