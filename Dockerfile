FROM ubuntu:20.04

# Copy requirements.txt and main.py into the container
COPY requirements.txt main.py ./

#ADD files/requirements.txt files/main.py ./

RUN apt update && apt install python3-pip libmysqlclient-dev -y && pip install -r requirements.txt

EXPOSE 8000

CMD uvicorn main:server --host 0.0.0.0
