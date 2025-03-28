% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw_client.R
\name{.RawClient}
\alias{.RawClient}
\title{Raw Client}
\description{
Raw Client

Raw Client
}
\section{Super class}{
\code{\link[datalabSDK:ProvenanceCache]{datalabSDK::ProvenanceCache}} -> \code{RawClient}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{environment}}{Env -- The environment.}
}
\if{html}{\out{</div>}}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{environment}}{Env -- The environment.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{.RawClient$new()}}
\item \href{#method-post}{\code{.RawClient$post()}}
\item \href{#method-get}{\code{.RawClient$get()}}
\item \href{#method-put}{\code{.RawClient$put()}}
\item \href{#method-delete}{\code{.RawClient$delete()}}
\item \href{#method-clone}{\code{.RawClient$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="datalabSDK" data-topic="ProvenanceCache" data-id=".cache_response">}\href{../../datalabSDK/html/ProvenanceCache.html#method-.cache_response}{\code{datalabSDK::ProvenanceCache$.cache_response()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="datalabSDK" data-topic="ProvenanceCache" data-id="get_provenance_session_id">}\href{../../datalabSDK/html/ProvenanceCache.html#method-get_provenance_session_id}{\code{datalabSDK::ProvenanceCache$get_provenance_session_id()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Get error type for status code


Raise error on failure
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$new(environment)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{environment}}{}

\item{\code{status_code}}{int -- The status code.}

\item{\code{response}}{Request response.}

\item{\code{request_verb}}{str -- The request verb: GET, PUT, POST or DELETE.}

\item{\code{url}}{str -- The URL.}

\item{\code{token}}{str -- The access token.}

\item{\code{parse_json}}{bool -- Whether to parse the result as json.}

\item{\code{body}}{list -- Request body.}

\item{\code{encode}}{str -- Encoding method for body; "form", json", "multipart" or "raw".}

\item{\code{additional_headers}}{named vector -- any additional headers.}

\item{\code{stream}}{bool -- Whether the response should be streamed}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
The error type.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-post"></a>}}
\if{latex}{\out{\hypertarget{method-post}{}}}
\subsection{Method \code{post()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$post(
  url,
  token = "",
  body = FALSE,
  parse_response = TRUE,
  encode = "json"
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{url}}{str -- The full request URL}

\item{\code{token}}{str -- The auth token to use for the API call}

\item{\code{body}}{JSON data for the request}

\item{\code{parse_response}}{bool -- Whether the response should be parsed as JSON}

\item{\code{encode}}{str -- Encoding method for body; "form", json", "multipart" or "raw". Use "multipart" for file upload.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
JSON response data or APIError
Make a GET request to the User Apps API
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-get"></a>}}
\if{latex}{\out{\hypertarget{method-get}{}}}
\subsection{Method \code{get()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$get(url, token = "", parse_response = TRUE, stream = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{url}}{str -- The full request URL, including any request parameters}

\item{\code{token}}{str -- The auth token to use for the API call}

\item{\code{parse_response}}{bool -- Whether the response should be parsed as JSON}

\item{\code{stream}}{bool -- Whether the response should be streamed}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
JSON response data or APIError
Make a PUT request to the User Apps API
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-put"></a>}}
\if{latex}{\out{\hypertarget{method-put}{}}}
\subsection{Method \code{put()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$put(
  url,
  token = "",
  body = FALSE,
  parse_response = TRUE,
  encode = "json"
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{url}}{str -- The full request URL}

\item{\code{token}}{str -- The auth token to use for the API call.}

\item{\code{body}}{JSON data for the request}

\item{\code{parse_response}}{bool -- Whether the response should be parsed as JSON}

\item{\code{encode}}{str -- Encoding method for body; "form", json", "multipart" or "raw". Use "multipart" for file upload.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
JSON response data or APIError
Make a DELETE request to the User Apps API
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-delete"></a>}}
\if{latex}{\out{\hypertarget{method-delete}{}}}
\subsection{Method \code{delete()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$delete(url, token = "", parse_response = TRUE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{url}}{str -- The full request URL}

\item{\code{token}}{str -- The auth token to use for the API call}

\item{\code{parse_response}}{bool -- Whether the response should be parsed as JSON}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
No response body; APIError if failed
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{.RawClient$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
