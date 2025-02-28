
#' Synchronous form of auth
#'
#' Use when need to suspend execution until auth has succeeded (or timed out)
.SyncAuth <- R6::R6Class(
  classname = "SyncAuth",
  inherit = .AsyncAuth,
  public = list(

    #' @description
    #' Initialise an instance of PlatformAuth
    #' @param environment The environment.
    #' @return A new PlatformAuth object.
    initialize = function(environment) {
      super$initialize(environment)
    },

    #' @description
    #' Synchronous call to get a token by device flow
    #' @return An access token if available.
    get_token = function() {
      flow <- super$start_auth_flow()
      return (super$complete_auth_flow(flow))
    }
  )
)

#' Initialise a new SyncAuth instance
#'
#' @param environment Env -- The environment.
#'
#' @return A SyncAuth instance.
#' @export
SyncAuth <- function(environment) {
  return(.SyncAuth$new(environment))
}
