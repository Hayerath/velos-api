# velos-api

API HTTP en Python (Flask) exposant l'état des stations de vélos en libre-service d'une communauté de communes.

## Routes

| Route | Description |
| --- | --- |
| `/sante` | État de santé de l'application, destiné aux systèmes de supervision |
| `/stations` | Liste des stations, quartier et vélos disponibles |
| `/disponibilite` | Taux d'occupation moyen du parc |
| `/alertes` | Stations dont le nombre de vélos disponibles est ≤ 2 |

## Configuration

L'application lit sa configuration via des variables d'environnement :

- `DATABASE_URL` : si définie, l'application lit les données depuis PostgreSQL. Sinon, elle utilise un jeu de données en mémoire.
- `PORT` : port d'écoute (par défaut `8000`).
