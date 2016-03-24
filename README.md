# docker-statsite

[![Docker Repository on Quay.io](https://quay.io/repository/azavea/statsite/status "Docker Repository on Quay.io")](https://quay.io/repository/azavea/statsite)
[![Apache V2 License](http://img.shields.io/badge/license-Apache%20V2-blue.svg)](https://github.com/azavea/docker-statsite/blob/develop/LICENSE)

A `Dockerfile` based off of [`python:2.7-slim`](https://registry.hub.docker.com/_/python/) that installs Statsite.

## Usage

First, build the container with either of the following commands:

```bash
$ docker build -t quay.io/azavea/statsite:latest .
```

Now you can run the container and provide any custom flags to the `statsite` command:

```bash
$ docker run --rm -p 8125:8125 --name statsite
statsite[1]: Starting statsite.
statsite[1]: Starting statsite.
statsite[1]: stdin is disabled
statsite[1]: stdin is disabled
statsite[1]: Listening on tcp ':::8125'
statsite[1]: Listening on tcp ':::8125'
statsite[1]: Listening on udp ':::8125'.
statsite[1]: Listening on udp ':::8125'.
```

From another window, feed metrics to Statstie with `echo` and `nc`. You should see output (by default a rollup of every 10 seconds) in the Statstie log:

```bash
$ echo "foo:1|c" | nc -w0 127.0.0.1 8125
```
