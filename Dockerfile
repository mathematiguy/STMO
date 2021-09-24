FROM julia:1.7.0-rc1-buster

# Use New Zealand mirrors
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list

RUN apt update

# Set timezone to Auckland
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales tzdata git
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

# Create user 'kaimahi' to create a home directory
RUN useradd kaimahi
RUN mkdir -p /kaimahi/
RUN chown -R kaimahi:kaimahi /kaimahi
ENV HOME /kaimahi

# Install python + other things
RUN apt update

# Install python + other things
RUN apt update
RUN apt install -y python3-dev python3-pip

# Install julia packages
USER kaimahi
RUN julia -e 'using Pkg; Pkg.add("IJulia")'
RUN julia -e 'using Pkg; Pkg.add("Weave")'
RUN julia -e 'using Pkg; Pkg.add(url="https://github.com/MichielStock/STMO.git")'
RUN julia -e 'using Pkg; Pkg.add("Pluto")'
