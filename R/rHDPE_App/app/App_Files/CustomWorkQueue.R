#===============
# Custom work queue for use by future_promise.

#===============
# Sources

source( here::here( "App_Files/WorkQueue.R" ) ) # Enables access to WorkQueue which does not seem to be exported as part of the Promises package.

#===============
# Code

# The WorkQueue created allows the next ExtendedTask to be executed only if at least two cores are free (unless there's only one core in total).

# cores_available is 0 unless there's at least two cores in total, in which case it is set to 1.

cores_available <- 0

if (nbrOfWorkers() > 1) cores_available <- 1

# more_than_one_core_free returns true if the number of free cores is greater than cores_available, otherwise it returns false.

more_than_one_core_free <- function() {
  
  nbrOfFreeWorkers() > cores_available
  
}

custom_work_queue <- WorkQueue$new( can_proceed = more_than_one_core_free ) # WorkQueue created with the required properties.