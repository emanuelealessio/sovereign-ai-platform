from fastapi import FastAPI

app = FastAPI()
VERSION = "1.0.0"

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/version")
def version():
    return {"version": VERSION}
