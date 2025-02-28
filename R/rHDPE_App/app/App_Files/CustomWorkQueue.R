# Custom work queue for use by future_promise.

cores_available <- 0

if (nbrOfWorkers() > 1) {
  
  cores_available <- 1
  
}

more_than_one_core_free <- function() {
  
  nbrOfFreeWorkers() > cores_available
  
}

custom_work_queue <- WorkQueue$new( can_proceed = more_than_one_core_free )