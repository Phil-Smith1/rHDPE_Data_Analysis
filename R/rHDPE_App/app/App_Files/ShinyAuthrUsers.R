#===============
# Database for logins.

#===============
# Code

# user_base is a tibble containing login details.

user_base <- tibble::tibble(
  
  user = c( "psmith", "admin", "tmcdonald", "standard" ),
  password = sapply( c( "pass1", "pass2", "pass3", "pass4" ), sodium::password_store ),
  permissions = c( "admin", "admin", "admin", "standard" ),
  name = c( "Phil", "Admin", "Tom", "User1" )
  
)