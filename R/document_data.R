#' Document the processed dataset
#'
#' This function appends Roxygen2 documentation for the processed dataset to the existing documentation for the raw dataset.
#'
#' @param data_name The name of the processed dataset.
#' @param data_desc The description of the processed dataset.
#' @param path The path to the R directory of the package.
#' @param data_format The format of the processed data.
#' @param data_source The source of the processed data.
#' @param variables A list of variables in the processed dataset with their descriptions.
#' @param column_headers Indicates whether the processed data has column headers (TRUE or FALSE).
#'
#' @keywords internal
document_data <- function(data_name, data_desc, path, data_format, data_source, variables = NULL, column_headers = FALSE) {

  # The file path of the documentation file
  doc_file <- file.path(path, "R", paste0("data", ".R", collapse = NULL))
  file.create(doc_file)

  if (!file.exists(doc_file)){
    stop("Documentation file not found. Please check your package structure.")
  }

  # Start of the Roxygen2 tags for the documentation
  roxygen_tags <- c(
    "",
    paste0("#' ", data_name, "data"),
    paste0("#' "),
    paste0("#' ", data_desc),
    "#' ",
    paste0("#' @format ", data_format, ":"),
    "#' \\describe{"
  )

  # Variable names and descriptions
  if (column_headers && is.null(variables)) {
    # Extract variable names from the first row of the dataset
    csv_path <- file.path(path, "data-raw", paste0(data_name, ".csv", collapse = NULL))
    dataset <- utils::read.csv(csv_path)  # Assuming the raw data is in a CSV file
    variable_names <- colnames(dataset)
    variables <- stats::setNames(variable_names, variable_names)  # Automatically generate descriptions based on variable names
  }

  # Add each variable to the Roxygen2 tags
  for(var_name in names(variables)) {
    roxygen_tags <- c(roxygen_tags, paste0("#'   \\item{", var_name, "}{", variables[[var_name]], "}"))
  }

  # End of the Roxygen2 tags for the documentation
  roxygen_tags <- c(roxygen_tags, "#' }", sprintf("#' @source %s", data_source), sprintf("'%s'", data_name))

  # Append the Roxygen2 tags to the file
  writeLines(c(roxygen_tags), doc_file)

  # Return a message indicating the documentation was updated
  return(paste0("Documentation for the processed '", data_name, "' dataset updated successfully in ", doc_file))
}
