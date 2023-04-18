#ARG IMAGE="ubuntu"

#---
# Place anything that is common to both the build and execution environment in base 
#
FROM ubuntu:latest AS base

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    clang \
    cmake \
    curl \
    git \
    python3 \
    libffi-dev \
    libreadline-dev \
    tcl-dev \
    graphviz \
    wget \
    xdot \
    libboost-system-dev \
    libboost-python-dev \
    libboost-filesystem-dev \
    zlib1g-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists

ENV INSTALL_DIR="/opt/symbiflow/eos-s3"
ENV PATH="$INSTALL_DIR/install/bin:$INSTALL_DIR/install/bin/python:$PATH"
ENV YOSYS=${INSTALL_DIR}/install/bin/yosys

#---

FROM base AS build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    bison \
    build-essential \
    flex \
    gawk \
    git \
    iverilog \
    pkg-config

#Checkout *yosys* repository (https://github.com/QuickLogic-Corp/yosys.git), branch: **quicklogic-rebased**. 
RUN git clone https://github.com/YosysHQ/yosys.git quicklogic-yosys
RUN cd quicklogic-yosys
WORKDIR /quicklogic-yosys
RUN make config-gcc
RUN make install PREFIX=${INSTALL_DIR}/install
RUN cd -

RUN apt-get install pip -y
RUN apt-get install default-jre -y
RUN pip3 install orderedmultidict

WORKDIR /
RUN git clone https://github.com/chipsalliance/Surelog.git --recurse-submodules
RUN cd Surelog
WORKDIR /Surelog
# export PATH='specify Yosys installation path as specified in PREFIX in previous step':$PATH
RUN make
RUN make install
RUN cd -

#Checkout *yosys-f4pga-plugins* (https://github.com/QuickLogic-Corp/yosys-f4pga-plugins.git).
WORKDIR /
RUN git clone https://github.com/chipsalliance/yosys-f4pga-plugins.git # -b v1.0.0_7_g59ff1e6_23_g3a95697_17_g00b887b
RUN cd yosys-f4pga-plugins 
WORKDIR /yosys-f4pga-plugins
# export PATH='specify Yosys installation path as specified in PREFIX in previous step':$PATH
RUN make
RUN make install
RUN cd -

#RUN apt-get install catch2 -y

#Checkout *vpr* repository (https://github.com/QuickLogic-Corp/vtr-verilog-to-routing.git).
WORKDIR /
RUN git clone https://github.com/verilog-to-routing/vtr-verilog-to-routing.git
RUN cd vtr-verilog-to-routing
WORKDIR /vtr-verilog-to-routing
RUN make

#Checkout *symbiflow-arch-defs* repository (https://github.com/QuickLogic-Corp/symbiflow-arch-defs.git), branch: **quicklogic-upstream-rebase**. 
WORKDIR /
RUN git clone https://github.com/f4pga/f4pga-arch-defs.git
RUN cd f4pga-arch-defs
WORKDIR /f4pga-arch-defs

RUN make env
# RUN cd build
# RUN make all_conda
# RUN cd -
# RUN make

# #---

FROM base AS release-candidate

COPY --from=build /opt/symbiflow/eos-s3 /opt/symbiflow/eos-s3/
COPY --from=build /f4pga-arch-defs /f4pga-arch-defs/
COPY --from=build /yosys-f4pga-plugins /yosys-f4pga-plugins/
COPY --from=build /vtr-verilog-to-routing /vtr-verilog-to-routing/

# FROM release-candidate AS all_quick_tests

# WORKDIR /f4pga-arch-defs/quicklogic/pp3/tests
# RUN make all_quick_tests

# FROM release-candidate AS all_ql_tests

# WORKDIR /symbiflow-arch-defs/quicklogic/pp3/tests
# RUN make all_ql_tests


# FROM release-candidate AS release


# Build the container with something like:
# docker build . -t symbiflow-ql-slim-buster

# Run bash in the container interactively with something like:
# docker run -it symbiflow-ql-slim-buster bash

# Run any test case in the container running bash interactively.  For example, follow these steps to run a test case:
# cd /symbiflow-arch-defs/build/quicklogic/pp3/tests/quicklogic_testsuite/bin2seven
# make bin2seven-ql-chandalar_fasm


