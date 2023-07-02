#' Upload and rename a dataset
#'
#' This function allows users to upload a dataset from various formats (csv, xlsx, xls, dat, sav, dta, RData, rda) and convert it to csv.
#' The user is also prompted to give the dataset a new name, following guidelines for good naming conventions.
#'
#' @return A message indicating the data was uploaded successfully and its new location in the 'data-raw' directory.
#'
#' @param path The directory in which to save the raw data.
#'
#' @export
upload_data <- function(path = NULL) {

  # Save the path
  path <- gsub("/data-raw", "", path)

  # Ask user to upload a file
  message("Including raw data in your templated opensci package promotes reproducibility, transparency, and collaboration. It allows others to validate your results, explore the data further, and ensures long-term data preservation.")

  # Ask user whether the raw data contains column / variable headers
  cat("Does the raw data file that you want to provide in the open sci package already include column / variable headers?\n",
      "1: Yes.\n",
      "2: No.\n")
  column_headers <- as.integer(readline(prompt = "Enter the number for your choice: "))

  # Add the chosen license
  if (column_headers == 1) {
    column_headers <- TRUE
  } else {
    column_headers <- FALSE
  }

  # Ask user to upload a file
  message("Please upload the raw dataset that you would like to share through your opensci package.")

  # Allow user to choose a file
  file_path <- file.choose()

  # Get file extension
  file_ext <- tools::file_ext(file_path)

  # Ask user to provide a new name for the dataset
  cat("Please provide a new name for this dataset. The name should be descriptive, concise, and should not contain spaces or special characters.\n")
  new_data_name <- readline(prompt = "New dataset name (no spaces / special characters!): ")

  if (file_ext == "csv") {
    # Read the chosen CSV file
    data <- utils::read.csv(file_path, stringsAsFactors = FALSE)

    # File name is provided by the user
    file_name <- paste0(new_data_name, ".csv")
  } else if (file_ext == "xlsx" || file_ext == "xls") {
    # Read the chosen Excel file
    data <- readxl::read_excel(file_path)

    # File name is provided by the user
    file_name <- paste0(new_data_name, ".csv")
  } else if (file_ext == "dat" || file_ext == "sav") {
    # Read the chosen SPSS file
    data <- haven::read_spss(file_path)

    # File name is provided by the user
    file_name <- paste0(new_data_name, ".csv")
  } else if (file_ext == "dta") {
    # Read the chosen Stata file
    data <- haven::read_dta(file_path)

    # File name is provided by the user
    file_name <- paste0(new_data_name, ".csv")
  } else if (file_ext == "RData" || file_ext == "rda") {
    # Load the chosen RData file
    load(file_path)

    # Note: This will load the variables in the RData file into the global environment.
    # If there are multiple variables, you'll need to handle this appropriately.
    # For simplicity, we assume the RData file contains a single variable.
    data <- get(ls())

    # File name is provided by the user
    file_name <- paste0(new_data_name, ".csv")
  } else {
    return("Selected file is not a .csv, .xlsx, .xls, .dat, .sav, .dta, .RData, or .rda file.")
  }

  # Create the "data-raw" directory if it doesn't exist
  if (!dir.exists("data-raw")) {
    dir.create("data-raw")
  }

  # Create new file path within the "data-raw" directory
  new_file_path <- file.path("data-raw", file_name)

  # Write the data to the new CSV file
  readr::write_csv(data, new_file_path)

  # Create a corresponding R script for data preparation used to create the "/data/.rda" version of the raw data in the "data-raw" directory
  data_prep_script_path <- file.path("data-raw/", paste0(new_data_name, ".R", collapse = NULL))

  # Create and write to the R script
  file.create(data_prep_script_path)

  writeLines(c(
    paste0("#' Prepare ", new_data_name, " data"),
    "#'",
    paste0("#' This script processes the raw ", new_data_name, " data, which won't be available for users, into the processed data that will be available for the users of the templated open sci package."),
    "#'",
    "#' Load the raw data",
    paste0(new_data_name, " <- readr::read_csv('", new_file_path, "')"),
    "#'",
    "#' Add your preprocessing steps for the data below, for example:",
    "#' data <- data %>% na.omit() # remove rows with NA values",
    "#' NOTE: Replace this with the actual preprocessing steps",
    "#'",
    "#' Save the processed data in the /data directory, which is the data that will be available for users of the templated open sci package",
    paste0("usethis::use_data(", new_data_name, ", overwrite = TRUE)")
    ), data_prep_script_path)

  # Let the user enter a description of his / her dataset
  data_desc <- readline(prompt = "Please enter an initial description of your raw data, such as its type and purpose: ")
  data_source <- readline(prompt = "Please enter the source of your raw data, e.g. a URL: ")
  data_format <- readline(prompt = "Please enter an short description of your raw data, such as the number of rows and variables: ")

  # Create the documentation of the raw dataset
  document_rawdata(data_name = new_data_name, data_desc = data_desc, data_source = data_source, data_format = data_format, path = path, column_headers = column_headers)
  document_data(data_name = new_data_name, data_desc = data_desc, data_source = data_source, data_format = data_format, path = path, column_headers = column_headers)

  # Create the processed dataset
  source(paste0(path, "/data-raw/", paste0(new_data_name, ".R", collapse = NULL)))

  # Update the core R scripts prepare_data and analyze_data
  writeLines(c("#' prepare_data()",
               "#' ",
               "#' @description The basic data preparation function. It is used for cleaning and preprocessing the data and returning it cleaned.",
               "#' ",
               "#' @param data a [tibble][tibble::tibble-package]",
               "#' ",
               "#' @return the prepared data as a [tibble]",
               "#' ",
               "#' @examples",
               paste0("#' ", new_data_name, " %>%"),
               "#' prepare_data()",
               "#' ",
               "#' @export",
               "prepare_data <- function(data) {",
               "  #",
               "  # Add data preparation code here, for example:",
               "  #",
               "  # Get the data",
               "data <- data",
               "  #",
               "  # Prepare the data",
               "  # 1. Handle Missing Data",
               "data %>%",
               "tidyr::drop_na()",
               "  #",
               "  # 2. Convert Data Types if Necessary",
               "data %>%",
               "dplyr::select(tidyselect::where(is.numeric)) %>%",
               "dplyr::select(tidyselect::last_col()) %>%",
               "dplyr::mutate(factor_var = dplyr::across(.cols = dplyr::last_col(), .fns = ~ factor(.)))",
               "  #",
               "  # 3. Mean-Center/Normalize/Scale Data if Necessary",
               "data %>%",
               "dplyr::select(tidyselect::where(is.numeric)) %>%",
               "dplyr::select(tidyselect::last_col()) %>%",
               "dplyr::mutate(z_var = dplyr::across(.cols = dplyr::last_col(), .fns = ~ . - mean(.)))",
               "  #",
               "  # Return the prepared data",
               "return(data)",
               "}"),
             "R/prepare_data.R")

  writeLines(c("#' analyze_data()",
               "#' ",
               "#' @description The basic data analysis function. It is used for conducting statistical analysis and visualization of the cleaned data. It reads the cleaned dataset, computes descriptive statistics, creates visualizations, and returns the results.",
               "#' @param data a [tibble][tibble::tibble-package]",
               "#' ",
               "#' @examples",
               paste0("#' ", new_data_name, " %>%"),
               "#' prepare_data() %>%",
               "#' analyze_data()",
               "#' ",
               "#' @export",
               "analyze_data <- function(data) {",
               "  #",
               "  # Add data analysis code here, for example:",
               "  #",
               "  # Get the data",
               "data <- data",
               "  #",
               "  # Analyze the data",
               "  # 1. Summary Statistics",
               "data %>%",
               "tidycomm::describe()",
               "  #",
               "  # 2. Data Visualization",
               "data %>%",
               "dplyr::select(tidyselect::where(is.numeric)) %>%",
               "dplyr::select(tidyselect::last_col()) %>%",
               "tidycomm::describe() %>%",
               "tidycomm::visualize()",
               "  #",
               "  # 3. Apply Statistical Tests if Needed",
               "  # For example, you might want to run a correlation",
               "data %>%",
               "dplyr::select(tidyselect::where(is.numeric)) %>%",
               "dplyr::select(tidyselect::last_col(1):tidyselect::last_col()) %>%",
               "tidycomm::correlate()",
               "}"),
             "R/analyze_data.R")

  # Return a message indicating the data was uploaded
  return(paste0("Data '", new_data_name, "' uploaded successfully to ", new_file_path))
}
