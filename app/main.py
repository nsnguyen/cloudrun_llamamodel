from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from llama_cpp import Llama



app = FastAPI()

MODEL = None

@app.on_event("startup")
async def startup():
  global MODEL
  if not MODEL:
    MODEL = Llama(model_path="models/llama-2-7b-chat.Q5_K_M.gguf")
  
 
class InferenceRequest(BaseModel):
  prompt: str
  
@app.get("/")
async def root():
    return {"message": "hello world"}
  
@app.post("/process_message")
async def process_message(request: InferenceRequest):
  # breakpoint()
  output = MODEL(request.prompt, max_tokens=48, echo=True)
  return {'data': output}
