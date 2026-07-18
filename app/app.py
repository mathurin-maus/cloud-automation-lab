from flask import Flask
import psycopg
import os

app = Flask(__name__)

@app.route("/")
def home():
    return "API Python OK - Docker Compose fonctionne !"

@app.route("/health")
def health():
    try: 
        with psycopg.connect(
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT"),
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD")
        ) as conn:

            with conn.cursor() as cur:
                cur.execute("SELECT 1")
                resultat = cur.fetchone()
                print(resultat, flush=True)

                if  resultat[0] == 1:
                    return "Database OK, Hello from github Actions"
    except psycopg.Error:
        return "Database ERROR", 503
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
