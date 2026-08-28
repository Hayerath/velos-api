# --- Étage 1 : construction des dépendances ---

FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Étage 2 : tests, non conserve dans l'image finale ---
FROM python:3.12-slim AS test
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY requirements-dev.txt .
RUN pip install --no-cache-dir --user -r requirements-dev.txt
COPY app.py test_app.py ./
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local/lib/python3.12/site-packages
RUN python -m pytest test_app.py -v && touch /tests-ok
# --- Étage 3 : image finale, allegee ---
FROM python:3.12-slim
WORKDIR /app
RUN useradd --create-home --shell /bin/bash appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=test /tests-ok /tests-ok
COPY app.py .
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONPATH=/home/appuser/.local/lib/python3.12/site-packages
USER appuser
EXPOSE 8000
CMD ["python", "app.py"]