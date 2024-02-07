FROM debian:12 AS dependencies
WORKDIR /app
# install python deps
RUN apt-get update && apt-get install -y python3-pip python3-venv \
    python3-pandas python3-requests python3-zeep python3-tabulate python3-sklearn python3-yaml
RUN pip install --break-system-packages pubchempy
RUN python3 -c 'import yaml; print(yaml.__version__)'
# install R + R deps
RUN apt-get update && apt-get install -y r-base r-base-dev \
    libcurl4-openssl-dev libssl-dev default-jdk libgit2-dev
COPY renv.lock renv.lock
COPY renv renv
COPY .Rprofile .Rprofile
RUN R CMD javareconf
RUN R -e "renv::restore()"
RUN R -e "renv::snapshot()"     # maybe

# FROM dependencies AS data
# COPY scripts scripts
# COPY example example
# COPY resources resources
# COPY processed_data processed_data
# COPY raw_data raw_data

# FROM data AS standardization
# RUN Rscript scripts/R_ci/compounds_standardize.R "0001"
# FROM standardization AS classyfire
# RUN Rscript scripts/R_ci/compounds_classyfire.R "0001"
# FROM classyfire AS descriptors
# RUN Rscript scripts/R_ci/compounds_descriptors.R "0001"
# FROM descriptors AS fingerprints
# RUN Rscript scripts/R_ci/compounds_fingerprints.R "0001"
# FROM fingerprints AS metadata
# RUN Rscript scripts/R_ci/metadata_standardize.R "0001"
# FROM metadata AS overview
# RUN Rscript scripts/R_ci/compounds_overview.R "0001"
# RUN Rscript scripts/R_ci/files_complete.R "0001"
# RUN python3 scripts/Python/datasets_overview.py
# FROM overview AS validation
# RUN python3 scripts/Python/validation_qspr.py
# RUN python3 scripts/Python/validation_order.py --mode same_condition
# RUN python3 scripts/Python/validation_order.py --mode systematic
# TODO: copy output to dir
