
#' Asynchronous form of auth
#'
#' Use when need return to complete after user has completed the auth flow.
.AsyncAuth <- R6::R6Class(
  classname = "AsyncAuth",
  inherit = .BaseAuth,
  public = list(
    #' @description
    #' Initialise an instance of AsyncAuth
    #' @param environment The environment.
    #' @return A new AsyncAuth object.
    initialize = function(environment) {
      super$initialize(environment)
    },

    #' @description
    #' Start device flow
    #' @return Response from initiating device flow with elements:
    #' `device_code`: str -- used to verify session between client and authorisation server.
    #' `user_code`: str -- used to identify session on secondary device.
    #' `verification_uri`: URI -- the URI the user should go to with the `user_code` to sign in.
    #' `expires_in`: int -- number of seconds before the `device_code` and `user_code` expire.
    #' `interval`: int - the number of seconds the client should wait between polling requests.
    #' `message`: str -- instructions for the user.
    start_auth_flow = function() {
      # Initiate device flow
      body <- list(
        client_id = get_client_id(private$.env),
        scope = get_scope(private$.env)
      )

      r <- httr::POST(url = get_device_code_url(), body = body)

      flow <- httr::content(r)

      if (is.null(flow[["user_code"]])) {
        stop(AuthNotValid(paste("Failed to create device flow:", paste(flow, collapse = "\n"))))
      }

      message(flow[["message"]])

      return(flow)
    },

    #' @description
    #' Get a token from completed device flow
    #' @param flow The response from `start_auth_flow()`.
    #' @returns Response from polling for access token.
    #' If successful, contains elements:
    #' `token_type`: str -- always "Bearer"
    #' `scope`: space separated strings -- list of scopes the access token is valid for.
    #' `expires_in`: int -- number of seconds the access token is valid for.
    #' `access_token`: str -- the access token.
    complete_auth_flow = function(flow) {
      body <- list(
        client_id = get_client_id(private$.env),
        device_code = flow[["device_code"]],
        grant_type = .pkg_env$grant_type
      )

      if (flow[["interval"]] < 1 || flow[["interval"]] > 60) {
        stop(paste("Access token poll interval of", flow[["interval"]], "seconds was not in the expected range."))
      }

      if (flow[["expires_in"]] < 10) {
        stop(paste("Device code validity period of", flow[["expires_in"]], "was not in the expected range."))
      }

      retry_count <- floor(flow[["expires_in"]] / flow[["interval"]])

      message("Waiting for login...")

      for (i in 1:retry_count) {
        r <- httr::POST(url = get_token_url(), body = body)

        result <- httr::content(r)

        if (!is.null(result[["access_token"]])) {
          message("Authorisation successful")
          return(result[["access_token"]])
        }

        if (!is.null(result[["error"]])) {
          if (result[["error"]] != "authorization_pending") {
            if (result[["error"]] == "authorization_declined") {
              stop(AuthNotValid("User denied the authorisation request"))
            } else if (result[["error"]] == "bad_verification_code") {
              stop(AuthNotValid("Device code not recognised."))
            } else if (result[["error"]] == "expired_token") {
              stop(AuthNotValid("Device code expired."))
            } else {
              stop(AuthNotValid("Unable to retrieve access token"))
            }
          }
        }

        Sys.sleep(flow[["interval"]])
      }
    }
  )
)

#' Initialise an AsyncAuth instance
#'
#' @param environment Env -- The environment.
#'
#' @return An AsyncAuth instance.
#' @export
#'
#' @examples
#' auth <- AsyncAuth(Environment$DEV)
AsyncAuth <- function(environment) {
  return(.AsyncAuth$new(environment))
}
