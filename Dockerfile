FROM rocker/r-ver:4.4.2
ENV RENV_CONFIG_REPOS_OVERRIDE https://packagemanager.rstudio.com/cran/latest

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev \
  libicu-dev \
  libsodium-dev \
  libssl-dev \
  libfontconfig1-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libfreetype6-dev \
  libpng-dev \
  libtiff5-dev \
  libjpeg-dev \
  libxml2-dev \
  pandoc \
  make \
  zlib1g-dev \
  pkg-config \
  && apt-get clean

COPY renv.lock renv.lock
RUN Rscript -e "install.packages('renv')"
RUN Rscript -e "renv::restore()"
COPY API.R API.R
COPY data/diabetes.rds /data/diabetes.rds
COPY model/diabetes_rf_final_model.RData /model/diabetes_rf_final_model.RData
COPY model/diabetes_rf_final_fit.RData /model/diabetes_rf_final_fit.RData
EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('API.R'); pr$run(host = '0.0.0.0', port = 8000)"]
