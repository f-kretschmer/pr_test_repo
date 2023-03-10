## ---------------------------
##
## Script name: compounds_standardize.R
##
## Purpose of script: Standardization of structures according to PubChem
##
## Author: Dr. Michael Witting
##
## Date Created: 2020-06-19
##
## Copyright (c) Michael Witting, 2020
## Email: michael.witting@helmholtz-muenchen.de
##
## -----------------------------------------------------------------------------
##
## Notes:
##
## This script performs a PubChem API based standardization of SMILES. Data is
## splitted into substances having isomeric or canonical SMILES.
##
## -----------------------------------------------------------------------------

# ==============================================================================
# load required libraries
# ==============================================================================
library(tidyverse)

# ==============================================================================
# read the data and create tibble for data analysis
# ==============================================================================
# folders from command arguments -----------------------------------------------
data_folders <- file.path('raw_data', commandArgs(trailingOnly=TRUE))

# read data  and perform standardization ----------------------------------------
for(data_folder in data_folders) {

  # ============================================================================
  # read and standardize meta data
  # ============================================================================
  meta_data_file <- list.files(data_folder,
                               pattern = "_metadata.txt$",
                               full.names = TRUE)

  if(length(meta_data_file) > 0 && file.exists(meta_data_file)) {

    meta_data <- read_tsv(meta_data_file)

    # calculate additional parameters
    t0 <- ((0.5 * meta_data$column.length * meta_data$column.id ^ 2) / 1000) / meta_data$column.flowrate

    if(!is.na(t0)) {

      meta_data$column.t0 <- t0

    } else {

      meta_data$column.t0 <- 0

    }

    # ============================================================================
    # write results
    # ============================================================================
    # create new path ------------------------------------------------------------
    result_folder <- paste0("processed_data/", basename(data_folder))

    if(!dir.exists(result_folder)) {
      dir.create(result_folder)
    }

    write_tsv(meta_data,
              paste0(result_folder,
                     "/",
                     basename(data_folder),
                     "_metadata.txt"),
              na = "")
  }

  # ============================================================================
  # read and standardize gradient data
  # ============================================================================
  gradient_data_file <- list.files(data_folder,
                               pattern = "_gradient.txt$",
                               full.names = TRUE)

  if(length(gradient_data_file) > 0 && file.exists(gradient_data_file)) {

    gradient_data <- read_tsv(gradient_data_file)

    # ============================================================================
    # write results
    # ============================================================================
    # create new path ------------------------------------------------------------
    result_folder <- paste0("processed_data/", basename(data_folder))

    if(!dir.exists(result_folder)) {
      dir.create(result_folder)
    }

    write_tsv(gradient_data,
              paste0(result_folder,
                     "/",
                     basename(data_folder),
                     "_gradient.txt"),
              na = "")
  }
}
