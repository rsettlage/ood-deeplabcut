## this will ultimately be a singularity container
FROM ubuntu:20.04
MAINTAINER Robert Settlage

ENV LANG en_US.UTF-8
ENV TZ=America/New_York

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install gcc-9 wget gnupg software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt-get install -y ubuntu-drivers-common

RUN wget --progress=dot:mega https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb && \ 
    rm cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb

RUN apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cuda && \
    apt install -y nvidia-cuda-toolkit gcc-9

# Intall Anaconda
RUN echo 'export PATH=/anaconda3/bin:$PATH' > /etc/profile.d/anaconda.sh && \
    wget https://repo.continuum.io/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /anaconda.sh && \
    /bin/bash /anaconda.sh -b -p /anaconda3 && \
    rm anaconda.sh

ENV PATH=/anaconda3/bin:$PATH
ENV PATH=/anaconda3/envs/DEEPLABCUT/bin:$PATH

##### Install Deeplabcut and its dependencies #####
##### fix inconsistency between Anaconda glib and Ubuntu version
# Install DeepLabCut
RUN apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module

COPY ./DEEPLABCUT.yaml ./
RUN conda env create -f DEEPLABCUT.yaml
SHELL ["conda", "run", "-n", "DEEPLABCUT", "/bin/bash", "-c"]
RUN conda install tensorflow-gpu==1.15.0
#RUN conda install -c conda-forge wxpython
RUN pip install deeplabcut && \
    bash /anaconda3/envs/DEEPLABCUT/lib/python3.7/site-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained/download.sh
RUN echo "#!/bin/bash" > run.sh && \
    echo "source activate DEEPLABCUT" >> run.sh && \
    echo "python -m deeplabcut" >> /run.sh 


