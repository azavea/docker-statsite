FROM python:2.7-slim

MAINTAINER Azavea <systems@azavea.com>

ENV STATSITE_VERSION 0.7.1
ENV STATSITE_SRC_DIR /usr/local/src
ENV STATSITE_SBIN_DIR /usr/sbin
ENV STATSITE_CONF_DIR /etc/statsite
ENV STATSITE_SINK_DIR /usr/libexec/statsite

RUN apt-get update && apt-get install -y \
  build-essential \
  python-pip \
  ca-certificates \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools \
  && pip install SCons

RUN wget -qO- https://github.com/armon/statsite/archive/v${STATSITE_VERSION}.tar.gz \
    | tar -xzC ${STATSITE_SRC_DIR} \
    && cd ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION} \
    && make

RUN mkdir -p ${STATSITE_CONF_DIR} ${STATSITE_SINK_DIR} \
  && mv ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION}/statsite ${STATSITE_SBIN_DIR} \
  && mv ${STATSITE_SRC_DIR}/statsite-${STATSITE_VERSION}/sinks/* ${STATSITE_SINK_DIR}

COPY etc/statsite.cfg ${STATSITE_CONF_DIR}/statsite.cfg

ENTRYPOINT ["/usr/sbin/statsite", "-f", "/etc/statsite/statsite.cfg"]
