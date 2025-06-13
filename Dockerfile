# Base Image
FROM ubuntu:22.04

# Code Composer Studio Version Variables
# <Major Version> . <Minor Version> . <Patch Version> . <Build Version>
# Updated to use CCS 20.2.0.00012
ENV MAJOR_VER=20
ENV MINOR_VER=2
ENV PATCH_VER=0
ENV BUILD_VER=00012

# Installable Product families Variables - WCONN for CC1310 wireless MCU
ENV COMPONENTS=PF_WCONN

# Adding support for i386 architecture
RUN dpkg --add-architecture i386

# Update package lists, upgrade, and install essential packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        libc6:i386 \
        libusb-0.1-4:i386 \
        libgconf-2-4:i386 \
        libncurses5:i386 \
        libtinfo5:i386 \
        libpython2.7 \
        build-essential \
        wget \
        unzip \
        git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory for CCS installation
WORKDIR /ccs_install

RUN wget https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-J1VdearkvK/20.2.0/CCS_20.2.0.00012_linux.zip
RUN unzip CCS_20.2.0.00012_linux.zip && \
    chmod +x CCS_20.2.0.00012_linux/ccs_setup_20.2.0.00012.run

RUN ./CCS_20.2.0.00012_linux/ccs_setup_20.2.0.00012.run --mode unattended --enable-components ${COMPONENTS} --prefix /opt/ti

# Clean up installation directory
RUN rm -r /ccs_install

# Set working directory to home
WORKDIR /home

# Update PATH environment variable
ENV PATH="/opt/ti/ccs/eclipse/:${PATH}"