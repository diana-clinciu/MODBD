from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import local_buc, local_con, global_db, statistici

app = FastAPI(title="MODBD – Baza de Date Distribuita", version="2.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(local_buc.router)
app.include_router(local_con.router)
app.include_router(global_db.router)
app.include_router(statistici.router)

@app.get("/")
def root():
    return {
        "message": "Backend MODBD merge!",
        "docs": "/docs",
        "endpoints": {
            "local_bucuresti": "/local/buc/...",
            "local_constanta": "/local/con/...",
            "global": "/global/...",
            "statistici": "/statistici/distributie",
        },
    }
