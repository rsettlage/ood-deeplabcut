## this will ultimately be a singularity container
FROM ubuntu:20.04
MAINTAINER Robert Settlage

ENV LANG en_US.UTF-8
ENV TZ=America/New_York

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl gcc-9 wget gnupg software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt-get install -y ubuntu-drivers-common

RUN wget --progress=dot:mega https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb && \ 
    rm cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb

RUN apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libxxf86vm-dev libcanberra-gtk-module libcanberra-gtk3-module && \
    DEBIAN_FRONTEND=noninteractive apt-get clean -y

# Intall Anaconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    /bin/bash /miniconda.sh -b -p /miniconda3 && \
    rm miniconda.sh

ENV PATH=/miniconda3/bin:$PATH
ENV PATH=/miniconda3/envs/DEEPLABCUT/bin:$PATH

##### Install Deeplabcut and its dependencies #####
##### fix inconsistency between Anaconda glib and Ubuntu version
# Install DeepLabCut

## install at runtime

#COPY ./OOD-DEEPLABCUT.yaml ./
#COPY ./OOD-install.sh ./
#RUN conda env create -f DEEPLABCUT.yaml
#SHELL ["conda", "run", "-n", "DEEPLABCUT", "/bin/bash", "-c"]
#RUN conda install tensorflow-gpu==1.15.0
#RUN conda install -c conda-forge wxpython
#RUN pip install deeplabcut && \
#    bash /anaconda3/envs/DEEPLABCUT/lib/python3.7/site-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained/download.sh
RUN echo "#!/bin/bash" > run.sh && \
    echo "source activate OOD-DEEPLABCUT" >> run.sh && \
    echo "python -m deeplabcut" >> /run.sh 


