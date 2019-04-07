FROM debian:stretch-slim

LABEL maintainer="Jonathan Goldfarb <jgoldfar@my.fit.edu>"

# Make sure we don't get notifications we can't answer during building.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq -y update && \
    apt-get -qq -y --no-install-recommends install \
      build-essential \
      libfftw3-dev \
      libblas-dev \
      liblapack-dev \
      gfortran \
      libgsl-dev \
      autoconf \
      automake \
      curl \
      ca-certificates \
      libtool

# Stage "Build"
#TODO: Build PFFT & FFTW3 with MPI to enable support in octopus
#TODO: Enable LibISF to complete support for Poisson solver
RUN mkdir /build-libxc && cd build-libxc && \
    curl -o /build-libxc/libxc-4.3.4.tar.gz -L http://www.tddft.org/programs/octopus/down.php?file=libxc/4.3.4/libxc-4.3.4.tar.gz && \
    tar xzf libxc-4.3.4.tar.gz && \
    cd libxc-4.3.4 && \
    autoreconf -fvi && \
    ./configure --prefix=/usr && \
    make && \
    make install

ADD . /build

RUN cd /build && \
    autoreconf -fvi && \
    ./configure && \
    make && \
    make install
