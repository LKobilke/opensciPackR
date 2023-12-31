% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/document_rawdata.R
\name{document_rawdata}
\alias{document_rawdata}
\title{Document the raw dataset}
\usage{
document_rawdata(
  data_name,
  data_desc,
  path,
  data_format,
  data_source,
  variables = NULL,
  column_headers = FALSE
)
}
\arguments{
\item{data_name}{The name of the raw dataset.}

\item{data_desc}{The description of the raw dataset.}

\item{path}{The path to the R directory of the package.}

\item{data_format}{The format of the raw data.}

\item{data_source}{The source of the raw data.}

\item{variables}{A list of variables in the raw dataset with their descriptions.}

\item{column_headers}{Indicates whether the raw data has column headers (TRUE or FALSE).}
}
\description{
This function generates a Roxygen2 documentation for the provided raw dataset.
The documentation is saved in the R directory of the package (in the data.R file).
}
\keyword{internal}
