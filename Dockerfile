# --- Étage 1 : construction des dépendances ---
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Étage 2 : image finale, allégée ---
FROM python:3.12-slim

WORKDIR /app

# Utilisateur non privilégié
RUN useradd --create-home --shell /bin/bash appuser

# Récupère uniquement les paquets installés depuis l'étage précédent
COPY --from=builder /root/.local /home/appuser/.local

# Copie le code applicatif en dernier (change souvent, cache préservé pour ce qui précède)
COPY app.py .

ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONPATH=/home/appuser/.local/lib/python3.12/site-packages

USER appuser

EXPOSE 8000

CMD ["python", "app.py"]