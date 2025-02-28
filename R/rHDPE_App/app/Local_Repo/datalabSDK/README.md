# DataLab R SDK

This R library contains the DataLab R SDK. This SDK simplifies the use of the 
DataLab User Apps API functionality, and provides helper functions to support 
common use cases when working with models and data.

This release provides Raw access to the User Apps API. 

## Setting up your local R development environment

* Package build processes are managed with [devtools](https://github.com/r-lib/devtools)
* Documentation is handled by [roxygen2](https://github.com/r-lib/roxygen2)
* Dependencies are managed with [packrat](https://rstudio.github.io/packrat)
* Tests are written using [testthat](https://testthat.r-lib.org/)

These all work well with [RStudio](https://rstudio.com/).

This library was developed in R version 3.6.1.


### Build environment

To start local development:

````R
install.packages("packrat")
packrat::restore()
````


### Build the package

To build this package, including documentation:

````R
install.packages("devtools")
devtools::document()
devtools::build(vignettes = FALSE)
````

This will produce the file `datalabSDK_X.Y.Z.tar.gz`, where `X.Y.Z` is the package version number. 
This is the distributable package for all platforms.

The setting `vignettes = FALSE` means that the vignettes (long form documentation) for the package
will not be built. This is because the vignette requires the authentication process. This can be set 
to TRUE if persisted token has recently been acquired and therefore a `temp.auth` file contains a 
valid token.


### Testing the package

To run the tests for this package run:

````R
devtools::test()
````


### Installing the package

To install this package from downloaded source: 

````R
install.packages("path/to/source", repos = NULL, type = "source")
````

### Downloading the package

The SDK is published to [this Azure DevOps artifact feed](https://dev.azure.com/bnlwe-d-57280-bigdata-01-unilevercom-vsts/bnlwe-d-57280-bigdata-vstsp/_packaging?_a=feed&feed=datalab-R).

It can be obtained by following these steps:

1. Install the [Azure CLI](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli). 
2. Open PowerShell and install the Azure DevOps extension for the CLI 

````
az extension add --name azure-devops
````

3. Download the artifact using PowerShell 
(check for the latest versin number)

````
az artifacts universal download \
  --organization "https://dev.azure.com/bnlwe-d-57280-bigdata-01-unilevercom-vsts/" \
  --project "04693593-241c-49f8-adb1-c94569593ab3" \
  --scope project \
  --feed "datalab-R" \
  --name "datalab-r-sdk" \
  --version "0.1.4" \
  --path .
````

4. Open RStudio and install the package using the console

````R
install.packages("<path>/datalabSDK_X.Y.Z.tar.gz", repos = NULL, type = "source")
````


### Publishing the package

The package can be published using the Azure CLI tool from the section above, 
using the command:

```
az artifacts universal publish    
  --organization https://dev.azure.com/bnlwe-d-57280-bigdata-01-unilevercom-vsts/ \
  --project="bnlwe-d-57280-bigdata-vstsp" \
  --scope project \
  --feed datalab-R \
  --name datalab-r-sdk \
  --version 0.1.4 \
  --description "datalab R SDK" \
  --path .
```

**Ensure that the version number is correctly incremented.**

### Using the package

A basic workflow would look like:

````R
library("datalabSDK")

env <- Environment$QA

# Interactive login process
token <- SimplePersistedToken()$get_token(env, "temp.auth")

client <- RawClient(env)

search_url <- get_public_api_url(env, "search")
search_term <- "data"
page <- 1

search_body <- list("SearchTerm" = search_term, "Page" = page)

# Searching returns a json object
search_results <- client$post(search_url, token, search_body)

print(search_results[["results"]][[1]])
````

For more examples, see the `example-usage` vignette, or these
[Example Scripts](https://github.com/Unilever-Datalab/examples/tree/main/Scripts/R).


### Uninstalling the package

To uninstall the package, run:

````R
remove.packages("datalabSDK")
````


