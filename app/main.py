from fastapi import FastAPI
from pydantic import BaseModel
import random

app = FastAPI(title="MathsWallah", version="1.0.0")

class NumberResponse(BaseModel):
    number: int

@app.get("/", summary="Welcome", tags=["meta"])
def root():
    return {"app": "MathsWallah", "message": "Call /random to get a random number between 1 and 1000"}

@app.get("/random", response_model=NumberResponse, summary="Random number", tags=["api"])
def random_number():
    """Return a random integer between 1 and 1000 (inclusive)."""
    return {"number": random.randint(1, 1000)}
