FROM jupyter/datascience-notebook:45b8529a6bfc

# Install tensorflow using pip, according to documenation from TensorFlow
RUN pip install --no-cache-dir \
    git+https://github.com/data-8/nbgitpuller@07f625783fd27b9e95463036dac64955aaa8177e \
    tensorflow==1.13.* \
    keras==2.2.* && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

# We also need to install the R interface
RUN conda install --quiet --yes -c conda-forge \
    'r-keras' \
    'r-directlabels' \
    'r-repr' \
    'r-gridextra' \
    'r-gridbase' \
    'r-latex2exp' \
    'r-ggplot2' \
    'r-abind' \
    && conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y libssl1.0.0 libssl-dev && \
    rm -rf /var/lib/apt/lists/*
USER jovyan
