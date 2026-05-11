from database import SessionGlobal, SessionBuc, SessionCon


def get_db_global():
    db = SessionGlobal()
    try:
        yield db
    finally:
        db.close()


def get_db_buc():
    db = SessionBuc()
    try:
        yield db
    finally:
        db.close()


def get_db_con():
    db = SessionCon()
    try:
        yield db
    finally:
        db.close()


get_db = get_db_global
