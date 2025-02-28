
#' Auth implementation for user apps API use only
.PlatformAuth <- R6::R6Class(
  classname = "PlatformAuth",
  inherit = .BaseAuth,
  public = list(

    #' @description
    #' Initialise an instance of PlatformAuth
    #' @return A new PlatformAuth object.
    initialize = function() {
      super$initialize(Environment$ON_PLATFORM)
    },

    #' @description
    #' Get token from current call context
    #' @param session The current Shiny session, if using in a Shiny app, otherwise leave empty.
    #' @return A token if available.
    get_token = function(session = NULL) {
      if (!is.null(session$request$HEADERS[["x-auth-jwt"]])) {
        # Check for token if in a shiny app
        return(as.character(session$request$HEADERS[["x-auth-jwt"]]))
      } else if (.in_rstudio()) {
        # If running in RStudio, no token necessary.
        return("")
      }

      return(AuthNotValid("Unable to find current token"))
    },

    #' @description
    #' Check if access token is valid.
    #' @param token The access token.
    #' @return TRUE if the access token is valid.
    is_valid = function(token) {
      # In the platform context can't access the app without token
      # So just need to check that it is a JWT
      tryCatch(
        {
          claims <- .decode_jwt(token)

          return((length(claims) > 0) & super$.is_in_time(claims))
        },
        error = function(e) {
          warning(e)
          return(FALSE)
        }
      )
    }
  )
)

#' Initialise a new instance of PlatformAuth
#'
#' @return An instance of PlatformAuth
#' @export
#'
#' @examples
#'
#' # On platform - RStudio
#' env <- Environment$ON_PLATFORM
#' auth <- PlatformAuth()
#' token <- auth$get_token()
#'
#' # On platform - Shiny app
#' env <- Environment$ON_PLATFORM
#' auth <- PlatformAuth()
#' token <- auth$get_token(session) # provide the shiny session
#'
PlatformAuth <- function() {
  return(.PlatformAuth$new())
}
