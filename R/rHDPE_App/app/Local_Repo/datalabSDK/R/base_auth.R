
#' Base authentication
.BaseAuth <- R6::R6Class(
  classname = "BaseAuth",
  private = list(

    #' @field env Env -- The environment.
    .env = NULL

  ),
  public = list(

    #' @description
    #' Initialise an instance of BaseAuth
    #' @param environment Env -- The environment.
    #' @return A new BaseAuth object.
    initialize = function(environment) {
      private$.env <- environment
    },

    #' @description
    #' Check if token is valid.
    #' @param token The access token.
    #' @return TRUE if token is valid.
    is_valid = function(token) {
      tryCatch(
        {
          claims <- .decode_jwt(token)
          # Check if the returned claims list has required elements
          if (!(all(c("appid", "aud") %in% names(claims)))) return(FALSE)

          correct_app <- claims$appid == get_appid(private$.env)
          correct_audience <- claims$aud == get_aud(private$.env)
          in_time <- self$.is_in_time(claims)

          if (!correct_app) message("Token issued to another app")
          if (!correct_audience) message("Token issued for another audience")
          if (!in_time) message("Token expired")

          return(correct_app & correct_audience & in_time)
        },
        error = function(e) {
          warning(e)
          return(FALSE)
        }
      )
    },

    #' @description
    #' Check if token has expired.
    #' @param claims The claims
    #' @return TRUE if token has not expired.
    #' @keywords internal
    .is_in_time = function(claims) {
      # Check for required elements
      if (!all(c("nbf", "exp") %in% names(claims))) return(FALSE)
      tryCatch(
        {
          nbf <- as.POSIXct(claims$nbf, origin = "1970-01-01", tz = "UTC")
          exp <- as.POSIXct(claims$exp, origin = "1970-01-01", tz = "UTC")
          now <- as.POSIXct(Sys.time(), tz = "UTC")
          return(now >= nbf & now < exp)
        },
        error = function(e) {
          warning(e)
          return(FALSE)
        }
      )
    }
  )
)

#' Initialise a new instance of BaseAuth
#'
#' @param environment Env -- the environment.
#'
#' @return An instance of BaseAuth.
#' @export
BaseAuth <- function(environment) {
  return(.BaseAuth$new(environment))
}

