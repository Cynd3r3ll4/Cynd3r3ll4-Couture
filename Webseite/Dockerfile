# ---- Stage 1: Lint ----
# Führt die Codequalitätsprüfung (HTMLHint, Stylelint) innerhalb eines Containers aus.
# Schlägt einer der Linter fehl, bricht der gesamte Docker-Build hier bereits ab.
FROM node:20-alpine AS lint

WORKDIR /app

# Stylelint-Konfiguration und Website-Dateien in den Build-Container kopieren
COPY ./Webseite/.stylelintrc.json ./Webseite/.stylelintrc.json
COPY ./Webseite ./Webseite

# Linter installieren (inkl. Stylelint-Standardkonfiguration, die .stylelintrc.json referenziert)
RUN npm install -g htmlhint stylelint stylelint-config-standard

# Linting ausführen – bei Fehlern stoppt der Build hier
RUN htmlhint ./Webseite
RUN stylelint "./Webseite/**/*.css"

# ---- Stage 2: Produktions-Image ----
# Wird nur erreicht, wenn Stage 1 vollständig erfolgreich war
FROM nginx:alpine

# Website-Dateien aus der (bereits geprüften) Lint-Stage übernehmen,
# statt sie erneut aus dem Build-Kontext zu kopieren
COPY --from=lint /app/Webseite /usr/share/nginx/html

# Berechtigung auf schreibgeschützt
RUN chmod -R a-w /usr/share/nginx/html