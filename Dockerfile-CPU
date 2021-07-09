## this will ultimately be a singularity container
FROM ubuntu:18.04
MAINTAINER Robert Settlage

ENV LANG en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update --fix-missing && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y sudo wget bzip2 git vim cmake xserver-xorg-dev libgl1-mesa-dev unzip \
            ca-certificates libxext6 libsm6 libxrender1 make gcc make build-essential libgtk-3-dev libwebkitgtk-3.0-dev

# Intall Anaconda
RUN echo 'export PATH=/anaconda3/bin:$PATH' > /etc/profile.d/anaconda.sh && \
    wget https://repo.continuum.io/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /anaconda.sh && \
    /bin/bash /anaconda.sh -b -p /anaconda3 && \
    rm anaconda.sh

ENV PATH=/anaconda3/bin:$PATH
ENV PATH=/anaconda3/envs/DLC-CPU/bin:$PATH

##### Install Deeplabcut and its dependencies #####
##### fix inconsistency between Anaconda glib and Ubuntu version
# Install DeepLabCut
COPY ./DLC-CPU.yaml ./
RUN conda env create -f DLC-CPU.yaml
#SHELL ["/anaconda3/bin/activate", "DLC-CPU", "/bin/bash", "-c"]
##RUN . /anaconda3/bin/activate DLC-CPU

RUN pip install tensorflow==1.15.5 six wheel setuptools && \
    pip install https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-18.04/wxPython-4.0.3-cp36-cp36m-linux_x86_64.whl
RUN pip3 install deeplabcut[gui] 
COPY ./run.sh /run.sh
RUN echo "#!/bin/bash \n source activate DLC-CPU \n python -m deeplabcut"> /run.sh 
