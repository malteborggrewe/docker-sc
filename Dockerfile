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
    python3-pip \
    libglpk40 \
    libglpk-dev \
    libzmq3-dev \
    libgsl-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libhdf5-dev \
    && apt-get clean

# Install quarto
RUN apt-get update && apt-get install -y \
    curl \
    && curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb \
    && apt-get install -y ./quarto-linux-amd64.deb \
    && rm quarto-linux-amd64.deb

# Install base python packages
RUN pip3 install poetry==1.8.4 ipykernel jupyter

# Set the working directory
WORKDIR /analysis

# Copy the renv.lock and pyproject.toml files from your host into the container
COPY renv.lock /analysis/
COPY pyproject.toml /analysis/

# Install Python packages using poetry (install Python dependencies)
RUN poetry install --without dev

# Install important R packages for jupyter and others
RUN Rscript -e "install.packages(c('IRkernel', 'languageserver', 'rmarkdown'))"
RUN Rscript -e "remotes::install_github('rstudio/renv@v1.1.1')"
# Activate Jupyter R Kernel
RUN Rscript -e "IRkernel::installspec(user = FALSE)"

# Install R packages using renv (restore R environment)
RUN Rscript -e "renv::activate()"
RUN Rscript -e "renv::restore()"

# Keep container running
CMD ["tail", "-f", "/dev/null"]
