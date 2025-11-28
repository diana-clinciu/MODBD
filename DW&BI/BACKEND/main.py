from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import clients, rezervari, camere, servicii, plati, angajati, evenimente

app = FastAPI()

origins = [
    "http://localhost:5173",  # portul unde ruleaza Flutter Web
    "http://localhost:8000",  # backendul
    "*",  
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(clients.router)
app.include_router(rezervari.router)
app.include_router(camere.router)
app.include_router(servicii.router)
app.include_router(plati.router)
app.include_router(angajati.router)
app.include_router(evenimente.router)

@app.get("/")
def root():
    return {"message": "Backend FastAPI merge!"}
