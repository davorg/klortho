# Dancer2 on Google Cloud Run (EU/UK - europe-west2)
FROM perl:5.40-slim

# Minimal build deps
RUN apt-get update && apt-get install -y --no-install-recommends     build-essential ca-certificates   && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Carton & Starman first for layer caching
RUN cpanm --notest Carton Starman Plack

# Dependencies (optional cpanfile*)
COPY cpanfile* /app/
RUN carton install --deployment || true

# App source
COPY . /app

# Cloud Run listens on $PORT; default 8080
ENV PLACK_ENV=production PORT=8080
EXPOSE 8080

# Honour proxy headers (HTTPS, host) behind Cloud Run's proxy
CMD ["sh","-lc","carton exec -- starman -Ilib -e 'enable q(ReverseProxy);' -p ${PORT:-8080} bin/app.psgi"]
