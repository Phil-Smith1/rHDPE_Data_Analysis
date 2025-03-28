% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/access_data_gateway_by_dataset_id.R
\name{access_data_gateway_by_dataset_id}
\alias{access_data_gateway_by_dataset_id}
\title{Function which retrieves the contents of a dataset from the data access gateway given a dataset id}
\usage{
access_data_gateway_by_dataset_id(dataset_id, session,
  dataset_descriptor = dataset_id, repo_page = 1, dataset_page = 1)
}
\arguments{
\item{dataset_id}{\itemize{
\item the id of the dataset to retrieve
}}

\item{session}{\itemize{
\item the R Shiny session argument
}}

\item{dataset_descriptor}{\itemize{
\item variable to make any errors more understandable at higher levels
}}

\item{repo_page}{\itemize{
\item the request uses pagination to show 100 repos (i.e. data files) contained in this dataset per page.
Use this argument to choose which page to return
}}

\item{dataset_page}{\itemize{
\item the request uses pagination to show 100 child datasets per page.
Use this argument to choose which page to return
}}
}
\value{
the JSON output of the response or the function throws an error if unsuccessful. An example JSON: \cr
\code{{"DatasetID": "aa136c7b-13a3-4e29-b713-529726a5c750", \cr
"Name": "DS name", \cr
"Description": "DS", \cr
"Tags": ["myTAG"], \cr
"KeyValueFields": [], \cr
"AccessGroups": ["BD4BS-PROD-Internal"], \cr
"Children": { \cr
 "Repos": { \cr
   "items": [ \cr
     { \cr
       "RepoID": "02044a2c-f9d1-4ae4-8a86-8312d2d8313b", \cr
       "Name": "file.png", \cr
       "Description": "052_upload", \cr
       "Tags": ["pentest", "upload data"], \cr
       "KeyValueFields": [], \cr
       "AccessGroups": ["BD4BS-PROD-Internal"] \cr
     } \cr
     ], \cr
   "next": false \cr
 },\cr
 "Datasets": {\cr
   "items": [],\cr
   "next": false\cr
  }\cr
}}
}
}
\description{
Function which retrieves the contents of a dataset from the data access gateway given a dataset id
}
