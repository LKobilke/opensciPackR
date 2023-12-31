% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update_readme.R
\name{update_readme}
\alias{update_readme}
\title{Update the README.md file}
\usage{
update_readme(path = NULL, description)
}
\arguments{
\item{path}{The directory of the package. Defaults to the current working directory.}

\item{description}{A string that contains the package description provided by user input.}
}
\description{
This function updates the README.md file of the resulting package with the most important information.
}
\examples{
\dontrun{
update_readme(path = "/myPath", description = "A brief description of the package")
}
}
