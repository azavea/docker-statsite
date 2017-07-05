# docker-statsite

This repository contains a templated `Dockerfile` for image variants that contain a Statsite installation.

## Usage

### Template Variables

 - `STATSITE_VERSION` - Statsite version
 - `VARIANT` - Base container image variant

### Testing

An example of how to use cibuild to build and test an image:

```bash
$ CI=1 STATSITE_VERSION=0.8.0 VARIANT=alpine \
  ./scripts/cibuild
```