
#' API error
#'
#' Base class for exceptions
#'
#' @param .subclass The subclass
#' @param message The message
#' @param call The call
#' @param correlation_id The correlation ID
#' @param status_code The status code
#'
#' @export
APIError <- function(.subclass, message = "", call = sys.call(-1), correlation_id = NULL, status_code = NULL) {
  structure(
    class = c(.subclass, "APIError", "condition"),
    list(
      message = message,
      call = call,
      correlation_id = correlation_id,
      status_code = status_code
    )
  )
}


#' Auth not valid
#'
#' Raised when the provided auth token was not valid
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code, default 401
#'
#' @export
AuthNotValid <- function(message, correlation_id = NULL, status_code = 401) {
  return(APIError(c("AuthNotValid", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

#' Input not valid
#'
#' Raised when the input data was not valid for the API call
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code, default 400
#'
#' @export
InputNotValid <- function(message, correlation_id = NULL, status_code = 400) {
  return(APIError(c("InputNotValid", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

#' Resource not found
#'
#' Raised when a requested resource is missing
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code, default 404
#'
#' @export
ResourceNotFound <- function(message, correlation_id = NULL, status_code = 404) {
  return(APIError(c("ResourceNotFound", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

#' Internal error
#'
#' Raised when the API expected to process the request but failed to do so
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code 500
#'
#' @export
InternalError <- function(message, correlation_id = NULL, status_code = 500) {
  return(APIError(c("InternalError", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

#' Temporary error
#'
#' Raised when the API had a temporary issue in processing the request
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code, default 502
#'
#' @export
TemporaryError <- function(message, correlation_id = NULL, status_code = 502) {
  return(APIError(c("TemporaryError", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

#' API changed
#'
#' Raised when the API is not as expected
#'
#' @param message The message
#' @param correlation_id The correlation ID
#' @param status_code The status code, default 500
#'
#' @export
APIChanged <- function(message, correlation_id = NULL, status_code = 500) {
  return(APIError(c("APIChanged", "error"),
                  message = message,
                  correlation_id = correlation_id,
                  status_code = status_code))
}

