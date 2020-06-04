ARG ONEC_VERSION

FROM alpine:latest as downloader
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG VERSION
ENV installer_type=edt

RUN apk --no-cache add bash curl grep \
  && mkdir /edt \
  && cd /edt \
  && curl -O "https://raw.githubusercontent.com/TheDemonCat/onec_downloader/master/download.sh" \
  && chmod +x download.sh \
  && sync; ./download.sh \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz

FROM demoncat/onec-full as base

LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

COPY --from=downloader /edt /edt/

RUN  apt-get update && \
  apt install -y openjdk-11-jdk && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN cd /edt \ 
    && sync; ./1ce-installer-cli install  \
    && cd .. \
    && rm -rf /edt

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/

ENV PATH /opt/1C/1CE/components/1c-enterprise-ring-0.11.8+4-x86_64:$PATH

ENV RING_OPTS="-Duser.country=ru -Duser.language=RU"

USER usr1cv8 
