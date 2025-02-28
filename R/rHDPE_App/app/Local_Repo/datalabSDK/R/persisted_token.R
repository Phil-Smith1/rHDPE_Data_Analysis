
#' Simple file-based token persistence
#'
#' OK for scripts, not for web applications. Uses SyncAuth flow.
.SimplePersistedToken <- R6::R6Class(
  classname = "SimplePersistedToken",
  public = list(

    #' @description
    #' Get an access token.
    #'
    #' @param environment Env -- The environment.
    #' @param file_path str -- The file path for storing the access token.
    #'
    #' @return An access token if available.
    get_token = function(environment, file_path) {
      auth <- SyncAuth(environment)
      tryCatch({
        token <- ""

        if (file.exists(file_path)) {
          auth_file <- file(file_path, "r")
          if (isOpen(auth_file, "r")) {
            token <- readLines(auth_file)
            close(auth_file)
          }

          if (auth$is_valid(token)) {
            return(token)
          }
        }

        return(private$.renew_token(auth, file_path))
      },
      error = function(e) {
        private$.renew_token(auth, file_path)
      })
    }
  ),
  private = list(
    #' @description
    #' Renew token
    #'
    #' @param auth Auth -- an Auth object.
    #' @param file_path -- str - The file path for storing the access token.
    #'
    #' @return An access token if available.
    .renew_token = function(auth, file_path) {
      token <- auth$get_token()
      message("Acquired new token")
      auth_file <- file(file_path)
      writeLines(token, auth_file)
      close(auth_file)
      return(token)
    }
  )
)

#' Initialise an instance of SimplePersistedToken
#'
#' @return A SimplePersistedToken instance.
#' @export
SimplePersistedToken <- function() {
  return(.SimplePersistedToken$new())
}
