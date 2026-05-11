

from sqlalchemy import Column, Integer, String, Date
from database import Base

class AngajatDatePersonale(Base):
    """
    Fragment vertical al tabelei ANGAJAT.
    Stocat exclusiv in bdd_global pe oracle-bucuresti.
    """
    __tablename__ = "angajat_date_personale"
    id_angajat    = Column("ID_ANGAJAT",    Integer, primary_key=True)
    cnp           = Column("CNP",           String(30), nullable=False)
    data_angajare = Column("DATA_ANGAJARE", Date, nullable=False)
