from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base

# date de conexiune Oracle
USERNAME = "alexia"
PASSWORD = "mypassword1"
HOST = "localhost"
PORT = "1521"
SERVICE_NAME = "orclpdb1" 

# URL-ul pentru SQLAlchemy
DATABASE_URL = f"oracle+oracledb://{USERNAME}:{PASSWORD}@{HOST}:{PORT}/?service_name={SERVICE_NAME}"

engine = create_engine(DATABASE_URL, echo=True)

# session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
