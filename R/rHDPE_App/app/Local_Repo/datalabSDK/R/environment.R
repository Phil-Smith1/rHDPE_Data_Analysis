
.pkg_env <- new.env()

.pkg_env$tenant_id <- "f66fae02-5d36-495b-bfe0-78a6ff9f8e6e"

.pkg_env$grant_type <- "urn:ietf:params:oauth:grant-type:device_code"

#' Determine whether this is running in an RStudio session on Datalab.
#'
#' @return TRUE if in an RStudio session.
#'
#' @keywords internal
.in_rstudio <- function() {
  tools_rstudio <- "tools:rstudio"
  if (tools_rstudio %in% search()) {
    e <- as.environment(tools_rstudio)

    if(".rs.api.versionInfo" %in% ls(e, all.names = TRUE)) {
      version_info <- e$.rs.api.versionInfo()
      if (version_info$mode == "server")
        return(TRUE)
    }
  }

  return(FALSE)
}

#' Get the on-platform URL.
#'
#' @return The URL for on-platform.
#'
#' @keywords internal
.get_platform_url <- function() {
  if (!is.null(Sys.getenv("DATA_ACCESS_GATEWAY")) & Sys.getenv("DATA_ACCESS_GATEWAY") != "") {
    return(Sys.getenv("DATA_ACCESS_GATEWAY"))
  } else {
    # If the environment variable could not be found fall back to known port
    if (.in_rstudio()) {
      return("http://localhost:8010")
    } else {
      return("http://localhost:8011")
    }
  }
}

#' Defines an environment
#'
#' @keywords internal
.Env <- R6::R6Class(
  classname = "Env",
  private = list(
    .name = NULL,
    .base_url = NULL,
    .client_id = NULL,
    .audience = NULL,
    .scope = NULL
  ),
  active = list(
    #' @field name The name of the environment.
    name = function() return(private$.name),

    #' @field base_url The base URL for the environment.
    base_url = function() return(private$.base_url),

    #' @field client_id The client ID for the environment.
    client_id = function() return(private$.client_id),

    #' @field audience The audience for the environment.
    audience = function() return(private$.audience),

    #' @field scope The scope for the environment.
    scope = function() {
      if (is.null(private$.audience)) {
        return(NULL)
      } else {
        return(paste0(private$.audience, "/mme"))
      }
    }
  ),
  public = list(
    #' @description
    #' Initialise a new instance of the Env class.
    #'
    #' @param name The name of the environment.
    #' @param base_url The base URL.
    #' @param audience The audience.
    #' @param client_id The client ID.
    #'
    #' @return A new Env object.
    initialize = function(name, base_url, audience, client_id) {
      private$.name <- name
      private$.base_url <- base_url
      private$.client_id <- client_id
      private$.audience <- audience
    }
  )
)

#' Environment
#'
#' @description Settings for environments
Environment <- list(
  DEV = .Env$new(
    name = "DEV",
    base_url = "https://datalab-dev.unilever.com/public",
    audience = "a40ed097-7e5f-4920-93ea-c6857838418c",
    client_id = "65efef35-b8a9-403d-a8fb-1d77ece9e284"
  ),
  QA = .Env$new(
    name = "QA",
    base_url = "https://datalab-qa.unilever.com/public",
    audience = "3f155829-4ed6-4cbf-ab5d-62dea96c4025",
    client_id = "0d795fae-b779-4961-99a9-c883538dc5d4"
  ),
  STAGE = .Env$new(
    name = "STAGE",
    base_url = "https://datalab-staging.unilever.com/public",
    audience = "eae6e5ee-afd0-4580-a382-044333baff7f",
    client_id = "bee98f5f-0e72-446b-ad00-5cc767698666"
  ),
  PROD = .Env$new(
    name = "PROD",
    base_url = "https://datalab.unilever.com/public",
    audience = "e8d353be-7211-482b-8408-6df66025c3dd",
    client_id = "450c6432-f4f7-4db4-98ed-5e2ffb672493"
  ),
  ON_PLATFORM = .Env$new(
    name = "ON_PLATFORM",
    base_url = .get_platform_url(),
    audience = "",
    client_id = ""
  )
)

#' Extract the claims from the token
#' @param token
#'
#' @return The claims
#'
#' @keywords internal
.decode_jwt = function(token) {
  if (is.null(token)) return(list())

  strings <- strsplit(token, ".", fixed = TRUE)[[1]]
  if (!is.na(strings[2])) {
    claims <- jsonlite::fromJSON(rawToChar(jose::base64url_decode(strings[2])))
    return(claims)
  } else {
    return(list())
  }

}

#' Clean join
#'
#' @return string

#' @keywords internal
.clean_join <- function(base = "", path = "") {
  stripped_path <- sub('^/', '', path)
  return(sub("/$", "", paste0(base, "/", stripped_path)))
}

#' Get MME API URL
#'
#' @param environment Env -- The selected environment.
#' @param path str -- the path.
#'
#' @return MME API URL.
#' @export
get_mme_api_url <- function(environment, path = "") {
  return(.clean_join(paste0(environment$base_url, "/mme"), path))
}

#' Get chaining API URL
#'
#' @param environment Env -- The selected environment.
#' @param path str -- the path.
#'
#' @return Chaining API URL.
#' @export
get_chaining_api_url <- function(environment, path = "") {
  return(paste0(environment$base_url, "/chaining/", path))
}

#' Get chaining API get URL.
#'
#' @param environment Env -- The selected environment.
#' @param path str -- the path.
#' @param argument str -- The argument.
#'
#' @return Chaining API URL with argument.
#' @export
get_chaining_api_get_url <- function(environment, path = "", argument = "") {
  return(paste0(environment$base_url, "/chaining/", path, "/", argument))
}

#' Get public API URL.
#'
#' @param environment Env -- The selected environment.
#' @param path str -- the path.
#'
#' @return Public API URL.
#' @export
get_public_api_url <- function(environment, path = "") {
  return(.clean_join(environment$base_url, path))
}

#' Get client ID
#'
#' @param environment Env -- The selected environment.
#'
#' @return The client ID for the environment.
#' @export
get_client_id <- function(environment) {
  return(environment$client_id)
}

#' Get the scope
#'
#' @param environment Env -- The selected environment.
#'
#' @return The scope for the environment
#' @export
get_scope <- function(environment) {
  return(environment$scope)
}

#' Get scopes
#'
#' @param environment Env -- The selected environment.
#'
#' @return Scope as list.
#' @export
get_scopes <- function(environment) {
  return(list(environment$scope))
}

#' Get app ID
#'
#' @param environment Env -- The selected environment.
#'
#' @return The app ID
#' @export
get_appid <- function(environment) {
  return(environment$client_id)
}

#' Get audience
#'
#' @param environment Env -- The selected environment.
#'
#' @return The audience
#' @export
get_aud <- function(environment) {
  return(environment$audience)
}

#' Get headers
#'
#' @param environment Env -- The selected environment.
#' @param token str -- The access token.
#'
#' @return The headers.
#' @export
get_headers <- function(environment, token = "") {
  if (environment$name == "ON_PLATFORM") {
    if (.in_rstudio()) {
      return("")
    }

    return(
      c(
        "x-auth-jwt" = token
      ))
  } else {
    return(
      c(
        "Authorization" = paste("Bearer", token)
      )
    )
  }
}

#' Get authority URL
#'
#' @return The authority URL
#' @export
get_authority_url <- function() {
  return(paste0("https://login.microsoftonline.com/", .pkg_env$tenant_id))
}

#' Get device code URL
#'
#' @return The device code URL
#' @export
get_device_code_url <- function() {
  return(paste0("https://login.microsoftonline.com/", .pkg_env$tenant_id, "/oauth2/v2.0/devicecode"))
}

#' Get the URL to retrieve an access token
#'
#' @return The URL to poll for an access token
#' @export
get_token_url <- function() {
  return(paste0("https://login.microsoftonline.com/", .pkg_env$tenant_id, "/oauth2/v2.0/token"))
}


