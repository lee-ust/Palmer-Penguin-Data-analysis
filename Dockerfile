## Palmer Penguins Analysis Dockerfile 
FROM jupyter/r-notebook:latest

LABEL maintainer="LEE Yui<yleebi@connect.ust.hk>"
LABEL description="Palmer Penguins Data Analysis"

# ============================================================
# STEP 1: System dependencies
# ============================================================
USER root

# Use Tsinghua mirror for apt 
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list || true

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# STEP 2: Switch to jovyan user
# ============================================================
USER jovyan

# ============================================================
# STEP 3: Install R packages 
# ============================================================
RUN R -e "install.packages(c('tidyverse', 'ggplot2', 'dplyr', 'tidyr', 'corrr', 'psych', 'knitr', 'rmarkdown', 'gridExtra', 'ggrain'), repos='https://cloud.r-project.org/', dependencies=TRUE)"

# ============================================================
# STEP 4: Install Python packages 
# ============================================================
# ============================================================
# PYTHON PACKAGES INSTALLATION (COMPLETE)
# ============================================================

# Use Tsinghua mirror
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Install all Python packages
RUN pip install --no-cache-dir \
    pandas \
    numpy \
    scipy \
    matplotlib \
    seaborn \
    scikit-learn \
    statsmodels \
    pingouin \
    scikit-posthocs \
    jupyter \
    nbconvert\
    openpyxl \
    plotly

# ============================================================
# STEP 5: Copy the code
# ============================================================
COPY --chown=jovyan:jovyan data/ /home/jovyan/work/data/
COPY --chown=jovyan:jovyan scripts/ /home/jovyan/work/scripts/
COPY --chown=jovyan:jovyan output/ /home/jovyan/work/output/
COPY --chown=jovyan:jovyan README.ipynb /home/jovyan/work/

WORKDIR /home/jovyan/work
EXPOSE 8888

CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.default_url=/lab"]kApp.default_url=/lab"]