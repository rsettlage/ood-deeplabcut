FROM ubuntu:20.04
MAINTAINER Robert Settlage

ENV LANG en_US.UTF-8
ENV TZ=America/New_York
ARG DEBIAN_FRONTEND=noninteractive

#Install prereqs
RUN apt-get update && apt-get install --no-install-recommends -y locales ca-certificates python3.8 python3.8-dev tzdata wget curl gpg

#Set locales and timezone info
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg-reconfigure tzdata && \
    locale-gen en_US en_US.UTF-8 en_GB en_GB.UTF-8 && \
    dpkg-reconfigure locales

#Install conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    /bin/bash /miniconda.sh -b -p /miniconda3 && \
    rm miniconda.sh

ENV PATH=/miniconda3/bin:$PATH
ENV PATH=/miniconda3/envs/DEEPLABCUT/bin:$PATH

#Install wxpython prereqs
RUN apt-get update && apt-get install -y libxxf86vm1 python3-wxgtk4.0 adwaita-icon-theme-full gnome-icon-theme libatk-adaptor libcanberra-gtk-module

#Get deeplabcut conda env
RUN mkdir /apps && cd /apps
RUN wget https://raw.githubusercontent.com/DeepLabCut/DeepLabCut/master/conda-environments/DEEPLABCUT.yaml

#Create deeplabcut conda env, install wxpython before pip gets to it due to compilation issues
#RUN conda create python=3.8 --prefix /miniconda3/envs/DEEPLABCUT
#RUN conda install -c conda-forge -n DEEPLABCUT wxpython=4.0.7
#RUN conda env update -n DEEPLABCUT -f DEEPLABCUT.yaml
#RUN conda clean --all


#Cleanup env to reduce system image size

RUN apt-get -qy autoremove && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/

