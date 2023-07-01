#' Create a new open science R package
#'
#' This function creates a new open science R package with a standardized structure and setup.
#' It also prompts the user to enter some basic information about the package and the author.
#'
#' @param package_name The name of the package to create.
#' @param path The directory in which to create the package. Defaults to the current working directory.
#'
#' @return A message indicating the package was created.
#' @export create_openscipkg
#' @examples
#' \dontrun{
#' create_openscipkg("myPackage", path = "/myPath")
#' }
create_openscipkg <- function(package_name, path = NULL) {

  # Create the new package
  usethis::create_package(path = file.path(path, package_name))

  # Change the working directory to the new package
  setwd(file.path(path, package_name))
  wd <- getwd()

  # Prompt user for information
  author_name <- readline(prompt = "Please enter the author's first name(s), followed by a space, and then the author's surname or family name: ")
  author_email <- readline(prompt = "Enter the author's email: ")
  author_orcid <- readline(prompt = "Enter the author's ORCID (if any): ")
  description_input <- readline(prompt = "Please enter an initial description of your package, including its primary purpose and intended audience: ")

  # Split the author name into first and last names
  name_parts <- strsplit(author_name, " ")[[1]]
  first_name <- paste(name_parts[-length(name_parts)], collapse = " ")
  last_name <- name_parts[length(name_parts)]

  # Add DESCRIPTION entries
  usethis::use_description(fields = list(
    'Title' = 'Open Science Template Package',
    'Author' = author_name,
    'Maintainer' = paste(author_name, '<', author_email, '>', sep = ''),
    'Description' = description_input,
    'License' = 'MIT',
    'Imports' = 'learnr',
    'Encoding' = 'UTF-8',
    'LazyData' = 'true',
    'Authors@R' = paste0("person(given = \"", first_name,
                         "\", family = \"", last_name,
                         "\", role = c(\"aut\", \"cre\"), ",
                         "email = \"", author_email, "\", ",
                         ifelse(author_orcid != "", paste0("comment = c(ORCID = \"", author_orcid, "\")"), ""),
                         ")")
  ))

  # Create core R scripts
  file.create("R/data_preparation.R")
  file.create("R/data_analysis.R")

  # Add content to R scripts
  writeLines(c("#' Data preparation function",
               "#' @export",
               "data_preparation <- function() {",
               "  # Add data preparation code here",
               "}"),
             "R/data_preparation.R")

  writeLines(c("#' Data analysis function",
               "#' @export",
               "data_analysis <- function() {",
               "  # Add data analysis code here",
               "}"),
             "R/data_analysis.R")

  # Use roxygen2 for documentation
  usethis::use_roxygen_md()

  # Add a README
  usethis::use_readme_md()

  # Prompt user for license choice
  cat("Common licenses:\n",
      "1: MIT (A permissive license that is short and to the point)\n",
      "2: GPL-3 (A widely-used license that requires derivatives be open source)\n",
      "3: Apache-2 (A permissive license that also provides an express grant of patent rights)\n",
      "4: CC0 (Dedicates code into the public domain, or otherwise grants permission to use it for any purpose)\n")
  license_choice <- as.integer(readline(prompt = "Enter the number for your license choice: "))

  # Add the chosen license
  if (license_choice == 1) {
    usethis::use_mit_license()
  } else if (license_choice == 2) {
    usethis::use_gpl3_license()
  } else if (license_choice == 3){
    usethis::use_apache_license()
  } else if (license_choice == 4) {
    usethis::use_cc0_license()
  } else {
    cat("Invalid choice. Defaulting to MIT license.\n")
    usethis::use_mit_license()
  }

  # Create custom directories
  dir.create("data")
  dir.create("data-raw")
  dir.create("inst")
  dir.create("inst/sandbox")
  dir.create("tests")

  # Install required packages
  usethis::use_package("learnr")

  # Upload raw data
  data_path <- paste0(wd, "/data-raw", collapse = NULL)
  upload_data(path = data_path)

  # Return a message indicating the package was created
  return("Open Science Template Package created successfully")
}
