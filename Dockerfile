FROM alpine:3.4

MAINTAINER Azavea <systems@azavea.com>

ENV STATSITE_VERSION 0.8.0
ENV STATSITE_HOME /var/lib/statsite
ENV STATSITE_SRC_DIR /usr/local/src
ENV STATSITE_SBIN_DIR /usr/sbin
ENV STATSITE_CONF_DIR /etc/statsite
ENV STATSITE_SINK_DIR /usr/libexec/statsite

RUN \
      addgroup -S statsite \
      && adduser -D -S -h ${STATSITE_HOME} -s /sbin/nologin -G statsite statsite \
      && apk add --no-cache bash \
      && ln -sf /bin/bash /bin/sh \
      && apk add --no-cache --virtual .build-deps \
         autoconf \
         automake \
         ca-certificates \
         gcc \
         g++ \
         libtool \
         make \
         py-pip \
         wget \
         linux-headers \
      && pip install --egg SCons \
      && mkdir -p ${STATSITE_SRC_DIR} \
      && wget -qO- https://github.com/armon/statsite/archive/v${STATSITE_VERSION}.tar.gz | tar -xzC ${STATSITE_SRC_DIR} \
      && cd ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION} \
      && ./bootstrap.sh \
      && ./configure \
      && make \
      && mkdir -p ${STATSITE_CONF_DIR} ${STATSITE_SINK_DIR} \
      && mv ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION}/src/statsite ${STATSITE_SBIN_DIR} \
      && mv ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION}/sinks/* ${STATSITE_SINK_DIR} \
      && apk del .build-deps \
      && rm -rf ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION}

COPY etc/statsite.cfg ${STATSITE_CONF_DIR}/statsite.cfg

USER statsite
WORKDIR ${STATSITE_HOME}

ENTRYPOINT ["/usr/sbin/statsite", "-f", "/etc/statsite/statsite.cfg"]
