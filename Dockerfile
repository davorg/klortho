# Dancer2 on Google Cloud Run (EU/UK - europe-west2)
FROM perl:5.40-slim

# Build tools for CPAN modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates gcc libexpat1-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Tools + server
RUN cpanm --notest App::cpanminus Module::CPANfile Starman Plack Plack::Middleware::ReverseProxy

# Cache layer for deps
COPY cpanfile* /app/
RUN cpanm --notest --quiet --no-man-pages --installdeps /app

# App source
COPY . /app

ENV PLACK_ENV=production PORT=8080
EXPOSE 8080

# Honour proxy headers and Cloud Run's $PORT
CMD ["sh","-lc","starman -Ilib -e 'enable q(ReverseProxy);' -p ${PORT:-8080} bin/app.psgi"]

