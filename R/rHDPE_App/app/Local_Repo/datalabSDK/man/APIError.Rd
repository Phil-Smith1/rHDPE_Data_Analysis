% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exceptions.R
\name{APIError}
\alias{APIError}
\title{API error}
\usage{
APIError(
  .subclass,
  message = "",
  call = sys.call(-1),
  correlation_id = NULL,
  status_code = NULL
)
}
\arguments{
\item{.subclass}{The subclass}

\item{message}{The message}

\item{call}{The call}

\item{correlation_id}{The correlation ID}

\item{status_code}{The status code}
}
\description{
Base class for exceptions
}
