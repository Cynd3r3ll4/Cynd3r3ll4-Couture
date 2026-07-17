# kleines, sicheres Nginx-Image, das die statischen Dateien aus dem aktuellen Verzeichnis bereitstellt
FROM nginx:alpine
# kopiert die statischen Dateien in das Nginx-Standardverzeichnis und setzt die Berechtigungen auf schreibgeschützt
COPY . /usr/share/nginx/html:ro