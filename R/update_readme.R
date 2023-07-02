#' Update the README.md file
#'
#' This function updates the README.md file of the resulting package with the most important information.
#'
#' @param path The directory of the package. Defaults to the current working directory.
#' @param description A string that contains the package description provided by user input.
#'
#' @export
#' @examples
#' \dontrun{
#' update_readme(path = "/myPath", description = "A brief description of the package")
#' }
update_readme <- function(path = NULL, description) {

  # If no path is provided, use the current working directory
  if (is.null(path)) {
    path <- getwd()
  }

  # Create the file path to the README.md file
  readme_file_path <- file.path(path, "README.md")

  # Read the README.md file
  readme <- readr::read_lines(readme_file_path)

  # Locate the section
  start <- which(stringr::str_detect(readme, "The goal of"))

  # Check if the section was found
  if (length(start) == 0) {
    stop("The section 'The goal of' was not found in the README.md file.")
  }

  # Create the new text
  new_text <- c(paste0(description, "\n"),
                        "## Installation",
                        "",
                        "You can install the released version of {package_name} from [CRAN](https://CRAN.R-project.org) with:",
                        "",
                        "```r",
                        "install.packages('{package_name}')",
                        "```",
                        "",
                        "And the development version from [GitHub](https://github.com/) with:",
                        "",
                        "```r",
                        "# install.packages('devtools')",
                        "devtools::install_github('{package_name}')",
                        "```",
                        "\n## Usage\n",
                        "This package provides the following main functions:\n",
                        "- `prepare_data()`: The basic data preparation function. It is used for cleaning and preprocessing the data and returning it cleaned.\n",
                        "  Example usage:\n",
                        "  ```r\n",
                        "  data <- data %>% prepare_data()\n",
                        "  ```\n",
                        "- `analyze_data()`: The basic data analysis function. It is used for conducting statistical analysis and visualization of the cleaned data. It reads the cleaned dataset, computes descriptive statistics, creates visualizations, and returns the results.\n",
                        "  Example usage:\n",
                        "  ```r\n",
                        "  result <- data %>% analyze_data()\n",
                        "  ```\n",
                        "\n## Acknowledgments\n",
                        "This package was created using [openscipackR](https://github.com/openscipackR).\n",
                        "\n## License\n",
                        "This project is licensed under the terms of the MIT license.\n")

  # Replace the entire section from the section onward
  readme <- c(readme[1:(start-1)], new_text)

  # Write the updated README.md file
  readr::write_lines(readme, readme_file_path)

  # Return a message indicating the README.md was updated
  return("README.md updated successfully")
}
