# Use an R-based image (R 4.3.2)
FROM rocker/r-ver:4.3.2

# Environment settings
ENV POETRY_VIRTUALENVS_CREATE=false

# Install Python (3.10.12)
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3

# Install system libraries
RUN apt-get update && apt-get install -y \
    python3-pip=22.0.2+dfsg-1ubuntu0.5 \
    libglpk40=5.0-1 \
    libglpk-dev=5.0-1 \
    libzmq3-dev=4.3.4-2 \
    libgsl-dev=2.7.1+dfsg-3 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu9.2 \
    libbz2-dev=1.0.8-5build1 \
    liblzma-dev=5.2.5-2ubuntu1 \
    libcurl4-openssl-dev=7.81.0-1ubuntu1.19 \
    libssl-dev=3.0.2-0ubuntu1.18 \
    libxml2-dev=2.9.13+dfsg-1ubuntu0.4 \
    libhdf5-dev=1.10.7+repack-4ubuntu2 \
    && apt-get clean

# Install quarto
RUN apt-get update && apt-get install -y \
    curl \
    && curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb \
    && apt-get install -y ./quarto-linux-amd64.deb \
    && rm quarto-linux-amd64.deb

# Install base python packages
RUN pip3 install poetry==1.8.4 ipykernel==6.29.5 jupyter

# Set the working directory
WORKDIR /analysis

# Copy the renv.lock and pyproject.toml files from your host into the container
COPY renv.lock /analysis/
COPY pyproject.toml /analysis/

# Install Python packages using poetry (install Python dependencies)
RUN poetry install --without dev

# Install important R packages for jupyter and others
RUN R -e "install.packages(c('renv', 'IRkernel', 'languageserver', 'rmarkdown'))"
# Activate Jupyter R Kernel
RUN Rscript -e "IRkernel::installspec(user = FALSE)"

# Install R packages using renv (restore R environment)
RUN R -e "renv::restore()"
RUN R -e "renv::activate()"

# Keep container running
CMD ["bash"]
