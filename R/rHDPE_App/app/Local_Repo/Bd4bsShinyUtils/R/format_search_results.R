#take the list containing the converted JSON content
#returned from access_data_gateway functions
#and converts it to form for the search_platform module
format_search_results <- function(request_content_from_JSON){

  convert_key_value <- function(value, type){
    if(type!="DATE") return(value)
    #in Date case have value as a string (number of milliseconds since 1/1/1970)
    #convert to number of seconds then into time Date, then just Date then character
    as.character(as.Date(as.POSIXct(as.numeric(value)/1000, origin="1970-01-01", tz="GMT")))
  }

  if(!"results" %in% names(request_content_from_JSON)) stop("Malformed response")

  #No results -> [] in JSON gets converted to list() whereas [{...},{...}] get converted to data frame
  if(is.list(request_content_from_JSON$results) && length(request_content_from_JSON$results) == 0){
    empty_data_frame <- data.frame(Name=character(0),Description=character(0),Tags=character(0), Id=character(0), RepoID=character(0),
                      "Key-Values"=character(0))
    colnames(empty_data_frame)[6] <- "Key-Values"
    return(empty_data_frame)
  }

  data <- tryCatch({
    ans <- request_content_from_JSON$results[, c("Name", "Description")]
    ans[, "Tags"] <- vapply(request_content_from_JSON$results$Tags, function(x)paste(x, collapse=", "), FUN.VALUE = character(1))
    ans[, "Id"] <- request_content_from_JSON$results[,"DataID"]
    ans[, "RepoId"] <- request_content_from_JSON$results[,"RepoID"]
    ans[, "Key-Values"] <- vapply(request_content_from_JSON$results$KeyValueFields, function(x){
      if(class(x)=="data.frame"){
        paste(as.character(by(x, seq_len(nrow(x)), function(x) paste(c(x["Key"], convert_key_value(x["Value"], x["Type"])),collapse=":"))), collapse="<br/>")
      }
      else{
        ""
      }
    }, FUN.VALUE=character(1))
    ans
  },error=function(cond){ #if no results
    stop(paste("Malformed response", cond$message))
  })
  data
}
