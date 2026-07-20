# kleines, sicheres Nginx-Image, das die statischen Dateien aus dem aktuellen Verzeichnis bereitstellt
FROM nginx:alpine
# kopiert die statischen Dateien in das Nginx-Standardverzeichnis
COPY ./Webseite /usr/share/nginx/html
# Berechtigung auf schreibgeschützt
RUN chmod -R a-w /usr/share/nginx/html