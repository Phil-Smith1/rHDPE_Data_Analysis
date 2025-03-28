% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw_client.R
\name{RawClient}
\alias{RawClient}
\title{Initialise a new instance of RawClient.}
\usage{
RawClient(environment = Environment$ON_PLATFORM)
}
\arguments{
\item{environment}{Env -- The environment.}
}
\value{
An instance of RawClient.
}
\description{
Initialise a new instance of RawClient.
}
\examples{
# Search

# If on platform
env <- Environment$ON_PLATFORM
auth <- PlatformAuth()
token <- auth$get_token()
# If off platform
#env <- Environment$DEV
#token <- SimplePersistedToken()$get_token(env, "temp.auth")

client <- RawClient(env)
url <- get_public_api_url(env, "search")

body <- list(SearchTerm = "data", Page = 1)

r <- client$post(url=url, token=token, body=body)


# File upload

env <- Environment$DEV

# If on platform
token <- ""
# If off platform
#token <- SimplePersistedToken()$get_token(env, "temp.auth")

client <- RawClient(env)
url <- get_public_api_url(env, "")

metadata <- list(Name=jsonlite::unbox("Test file"),
                 Description=jsonlite::unbox("A test file"),
                 Tags=c("test-file"),
                 KeyValueFields = list(),
                 AccessGroups=c("BD4BS-DEV-Public"))

data <- tempfile()
writeLines("Test file", data)

body <- list(file = httr::upload_file(data, type="text/plain"),
             metadata = jsonlite::toJSON(metadata))

r <- client$post(url=url, token=token, body=body, encode="multipart")

}
