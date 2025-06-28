FROM perl:5.38.0
LABEL maintainer="dave@perlhacks.org"

EXPOSE 5000
CMD [ "starman",  "bin/app.psgi" ]

COPY . /klortho
RUN cd /klortho && cpanm Starman && cpanm --installdeps .
WORKDIR /klortho
