#' Function which retrieves the contents of a dataset from the data access gateway given a dataset id
#'@param dataset_id - the id of the dataset to retrieve
#'@param session - the R Shiny session argument
#'@param dataset_descriptor - variable to make any errors more understandable at higher levels
#'@param repo_page - the request uses pagination to show 100 repos (i.e. data files) contained in this dataset per page.
#'Use this argument to choose which page to return
#'@param dataset_page - the request uses pagination to show 100 child datasets per page.
#'Use this argument to choose which page to return
#'@return the JSON output of the response or the function throws an error if unsuccessful. An example JSON: \cr
#'\code{{"DatasetID": "aa136c7b-13a3-4e29-b713-529726a5c750", \cr
#'"Name": "DS name", \cr
#'"Description": "DS", \cr
#'"Tags": ["myTAG"], \cr
#'"KeyValueFields": [], \cr
#'"AccessGroups": ["BD4BS-PROD-Internal"], \cr
#'"Children": { \cr
#'  "Repos": { \cr
#'    "items": [ \cr
#'      { \cr
#'        "RepoID": "02044a2c-f9d1-4ae4-8a86-8312d2d8313b", \cr
#'        "Name": "file.png", \cr
#'        "Description": "052_upload", \cr
#'        "Tags": ["pentest", "upload data"], \cr
#'        "KeyValueFields": [], \cr
#'        "AccessGroups": ["BD4BS-PROD-Internal"] \cr
#'      } \cr
#'      ], \cr
#'    "next": false \cr
#'  },\cr
#'  "Datasets": {\cr
#'    "items": [],\cr
#'    "next": false\cr
#'   }\cr
#'}}
#'}
#'@export
access_data_gateway_by_dataset_id <- function(dataset_id, session, dataset_descriptor=dataset_id, repo_page=1, dataset_page=1){

  if(!"ShinySession" %in% class(session) && !"session_proxy" %in% class(session)){
    stop("The R Shiny session or session_proxy object should be passed into the access_data_gateway_by_dataset_id function")
  }
  if(is.null(dataset_descriptor)){
    stop(paste("dataset_descriptor argument cannot be NULL",
               "it should be a description of the dataset being extracted so that meaningful error messages can be given to users"))
  }

  path <- paste0("/dataset/",dataset_id,"?repoPage=",repo_page,"&datasetPage=", dataset_page)

  url <- paste0(getConfigValue("DATA_ACCESS_GATEWAY"), path)

  #inject the required security headers when running request
  r <- call_request_with_auth_headers(url, session, request_type="GET")

  if(httr::status_code(r) != 200 && httr::status_code(r) != 201){
    stop(paste("Cannot retrieve", dataset_descriptor, "dataset:", httr::http_status(r)$message))
  }

  #return the JSON string
  return(httr::content(r, "text", encoding = "UTF-8"))
}

