## this will ultimately be a singularity container
FROM ubuntu:18.04
MAINTAINER Robert Settlage

ENV LANG en_US.UTF-8

RUN apt-get -y update --fix-missing && apt-get -y upgrade && \
    apt-get install -y sudo wget bzip2 git vim cmake xserver-xorg-dev libgl1-mesa-dev unzip \
            ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git && \
    apt-get install -y x11-apps libgtk2.0-dev libgtk-3-dev libjpeg-dev libtiff-dev libsdl1.2-dev \
            libgstreamer-plugins-base1.0-dev libnotify-dev freeglut3 freeglut3-dev libsm-dev \
            libwebkitgtk-dev libwebkitgtk-3.0-dev python-dev libpng-dev libtiff-dev libsdl2-dev libsdl2-2.0-0 \
            libnotify-dev libsm-dev make gcc libgstreamer-gl1.0-0 python-gst-1.0 python3-gst-1.0 libglib2.0-dev

# Intall Anaconda
RUN echo 'export PATH=/anaconda3/bin:$PATH' > /etc/profile.d/anaconda.sh && \
    wget https://repo.continuum.io/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /anaconda.sh && \
    /bin/bash /anaconda.sh -b -p /anaconda3 && \
    rm anaconda.sh

ENV PATH /anaconda3/bin:$PATH

##### Install Deeplabcut and its dependencies #####
##### fix inconsistency between Anaconda glib and Ubuntu version
# Install DeepLabCut
COPY ./DLC-CPU.yaml ./
RUN conda env create -f DLC-CPU.yaml
SHELL ["conda", "run", "-n", "DLC-CPU", "/bin/bash", "-c"]
RUN conda install -c anaconda glib=2.56.1 && \
    pip install tensorflow==1.15.5 && \
    wget https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-18.04/wxPython-4.0.7-cp37-cp37m-linux_x86_64.whl && \
    pip3 install wxPython-4.0.7-cp37-cp37m-linux_x86_64.whl && \
    pip3 install deeplabcut[gui] && \
    rm wxPython-4.0.7-cp37-cp37m-linux_x86_64.whl
##COPY ./run.sh /run.sh
RUN echo "#!/bin/bash \n source activate DLC-CPU \n python -m deeplabcut"> /run.sh 
