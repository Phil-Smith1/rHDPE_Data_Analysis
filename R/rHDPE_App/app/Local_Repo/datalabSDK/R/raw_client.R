
.pkg_env$prov_corr_id_header <- "x-prov-corr-id"
.pkg_env$prov_corr_id_jwt_field <- "ProvenanceId"

#' Provenance cache
#'
#' Encapsulate caching logic of provenance correlation ids
#' Designed to be inherited by clients
.ProvenanceCache <- R6::R6Class(
  classname = "ProvenanceCache",
  private = list(

    #' @field .cached_prov_corr_id The cached provenance correlation ID.
    .cached_prov_corr_id = NULL

  ),
  public = list(

    #' @description
    #' Initialise a new instance of ProvenanceCache
    initialize = function() {
      .cached_prov_corr_id = NULL
    },

    #' @description
    #' Cache response
    #'
    #' @param headers Request headers
    #'
    #' @keywords internal
    .cache_response = function(headers) {
      if (.pkg_env$prov_corr_id_header %in% names(headers)) {
        private$.cached_prov_corr_id <- headers[[.pkg_env$prov_corr_id_header]]
      }
    },

    #' @description
    #' Return the Provenance Correlation Id of this session
    #'
    #' @param token str -- The auth token of the current session
    #'
    #' @return str -- the current Provenance Correlation Id, or NULL if there is
    #' none present on the token and none has been cached yet
    get_provenance_session_id = function(token) {
      # A provenance correlation Id in the JWT takes precedence
      # If that's not present we fall back on any Id cached from previous responses
      parsed_token <- .decode_jwt(token)
      if (.pkg_env$prov_corr_id_jwt_field %in% names(parsed_token)) {
        return(parsed_token[[.pkg_env$prov_corr_id_jwt_field]])
      } else if (!is.null(private$.cached_prov_corr_id)) {
        return(private$.cached_prov_corr_id)
      } else {
        return(NULL)
      }
    }
  )
)

#' Initialise an instance of ProvenanceCache
#'
#' @return A new instance of ProvenanceCache
#' @export
ProvenanceCache <- function() {
  return(.ProvenanceCache$new())
}

#' Raw Client
.RawClient <- R6::R6Class(
  classname = "RawClient",
  inherit = .ProvenanceCache,
  private = list(

    #' @field environment Env -- The environment.
    .environment = NULL,

    #' @description
    #' Get error type for status code
    #'
    #' @param status_code int -- The status code.
    #' @return The error type.
    .get_error_type_for_status_code = function(status_code) {
      if (status_code >= 502 & status_code <= 504) {
        return(TemporaryError)
      } else if (status_code >= 500) {
        return(InternalError)
      } else if (status_code == 404) {
        return(ResourceNotFound)
      } else if (status_code == 401) {
        return(AuthNotValid)
      } else if (status_code >= 400) {
        return(InputNotValid)
      } else {
        return(APIChanged)
      }
    },

    #' @description
    #' Raise error on failure
    #'
    #' @param response Request response.
    #'
    #' @return Error if failed.
    .raise_error_on_failure = function(response) {
      if (httr::status_code(response) > 300) {
        content <- jsonlite::fromJSON(rawToChar(response$content))
        correlation_id <- NULL
        error_message <- httr::http_status(response)[["message"]]
        try(
          {
            if ("correlationId" %in% names(content)) {
              # capture correlation if present
              correlation_id <- content[["correlationId"]]
            }
            if ("message" %in% names(content)) {
              # capture message if present
              error_message <- paste(error_message, content[["message"]])
            }
            if ("errors" %in% names(content)) {
              # capture list of errors if present
              error_message <- paste(error_message, "-", paste(content[["errors"]], collapse = ", "))
            }
          },
          silent = TRUE
        )

        error_type <- private$.get_error_type_for_status_code(httr::status_code(response))
        stop(error_type(error_message, correlation_id, httr::status_code(response)))
      }
    },

    #' Make request sequence
    #'
    #' Generic sequence of operations for any request type.
    #'
    #' @param request_verb str -- The request verb: GET, PUT, POST or DELETE.
    #' @param url str -- The URL.
    #' @param token str -- The access token.
    #' @param parse_json bool -- Whether to parse the result as json.
    #' @param body list -- Request body.
    #' @param encode str -- Encoding method for body; "form", json", "multipart" or "raw".
    #' @param additional_headers named vector -- any additional headers.
    #' @param stream bool -- Whether the response should be streamed
    #'
    #' @return
    .make_request_sequence = function(request_verb, url, token, parse_json, body = FALSE,
                                      encode = "json", additional_headers = NULL, stream = FALSE) {
      headers <- get_headers(private$.environment, token)
      if (!is.null(additional_headers)) {
        headers <- c(headers, additional_headers)
      }

      config <- httr::add_headers(headers)

      message(paste(request_verb, "to", url))

      if (stream == TRUE) {
        #httr::write_stream(function(x){ })
        message("Stream not yet implemented.")
      }

      r <- httr::VERB(verb = request_verb,
                      url = url,
                      config = config,
                      body = body,
                      encode = encode)

      message(paste("Response:", httr::status_code(r)))
      super$.cache_response(r[["headers"]])
      private$.raise_error_on_failure(r)

      if (parse_json == TRUE) {
        tryCatch(return(httr::content(r, as = "parsed")),
                 error = function(e) {
                   intro <- "Received OK status code but could not parse response."
                   desc <- paste("Received body: ", httr::content(r, as = "text"))
                   return(APIChanged(paste(intro, "\n", desc), status_code = 500))
                 })
      } else {
        return(r)
      }
    }
  ),
  public = list(

    #' Initialise a .RawClient instance
    #'
    #' @param environment
    #'
    #' @return A new instance of .RawClient
    initialize = function(environment) {
      private$.environment <- environment
    },

    #' Make a POST request to the User Apps API
    #'
    #' @param url str -- The full request URL
    #' @param token str -- The auth token to use for the API call
    #' @param body JSON data for the request
    #' @param parse_response bool -- Whether the response should be parsed as JSON
    #' @param encode str -- Encoding method for body; "form", json", "multipart" or "raw". Use "multipart" for file upload.
    #'
    #' @return JSON response data or APIError
    post = function(url, token = "", body = FALSE, parse_response = TRUE, encode="json") {
      private$.make_request_sequence("POST", url, token, parse_response, body = body, encode=encode)
    },

    #' Make a GET request to the User Apps API
    #'
    #' @param url str -- The full request URL, including any request parameters
    #' @param token str -- The auth token to use for the API call
    #' @param parse_response bool -- Whether the response should be parsed as JSON
    #' @param stream bool -- Whether the response should be streamed
    #'
    #' @return JSON response data or APIError
    get = function(url, token = "", parse_response = TRUE, stream = FALSE) {
      private$.make_request_sequence("GET", url, token, parse_response, stream = stream)
    },

    #' Make a PUT request to the User Apps API
    #'
    #' @param url str -- The full request URL
    #' @param token str -- The auth token to use for the API call.
    #' @param body JSON data for the request
    #' @param parse_response bool -- Whether the response should be parsed as JSON
    #' @param encode str -- Encoding method for body; "form", json", "multipart" or "raw". Use "multipart" for file upload.
    #'
    #' @return JSON response data or APIError
    put = function(url, token = "", body = FALSE, parse_response = TRUE, encode="json") {
      private$.make_request_sequence("PUT", url, token, parse_response, body = body, encode=encode)
    },

    #' Make a DELETE request to the User Apps API
    #'
    #' @param url str -- The full request URL
    #' @param token str -- The auth token to use for the API call
    #' @param parse_response bool -- Whether the response should be parsed as JSON
    #'
    #' @return No response body; APIError if failed
    delete = function(url, token = "", parse_response = TRUE) {
      private$.make_request_sequence("DELETE", url, token, parse_response, NULL)
    }
  )
)

#' Initialise a new instance of RawClient.
#'
#' @param environment Env -- The environment.
#'
#' @return An instance of RawClient.
#'
#' @examples
#' # Search
#'
#' # If on platform
#' env <- Environment$ON_PLATFORM
#' auth <- PlatformAuth()
#' token <- auth$get_token()
#' # If off platform
#' #env <- Environment$DEV
#' #token <- SimplePersistedToken()$get_token(env, "temp.auth")
#'
#' client <- RawClient(env)
#' url <- get_public_api_url(env, "search")
#'
#' body <- list(SearchTerm = "data", Page = 1)
#'
#' r <- client$post(url=url, token=token, body=body)
#'
#'
#' # File upload
#'
#' env <- Environment$DEV
#'
#' # If on platform
#' token <- ""
#' # If off platform
#' #token <- SimplePersistedToken()$get_token(env, "temp.auth")
#'
#' client <- RawClient(env)
#' url <- get_public_api_url(env, "")
#'
#' metadata <- list(Name=jsonlite::unbox("Test file"),
#'                  Description=jsonlite::unbox("A test file"),
#'                  Tags=c("test-file"),
#'                  KeyValueFields = list(),
#'                  AccessGroups=c("BD4BS-DEV-Public"))
#'
#' data <- tempfile()
#' writeLines("Test file", data)
#'
#' body <- list(file = httr::upload_file(data, type="text/plain"),
#'              metadata = jsonlite::toJSON(metadata))
#'
#' r <- client$post(url=url, token=token, body=body, encode="multipart")
#'
RawClient <- function(environment = Environment$ON_PLATFORM) {
  return(.RawClient$new(environment))
}

