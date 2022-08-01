library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "EthiopiaGrainR")

#Set your name
my_desc$set("Authors@R", "person('Ama', 'Owusu-Darko', email = 'aowusuda@asu.edu', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Ethiopia Grain Mill Data analysis")
# The description of your package
my_desc$set(Description = "Functions to analyze data from the Ethiopian Grain Mill project.")
my_desc$set("URL", "https://eap-ethiopia-mill-data.netlify.app/")
my_desc$set("BugReports", "http://that")
# Save everything
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(copyright_holder = "Ama Owusu-Darko")
use_code_of_conduct("aowusuda@asu.edu")
use_lifecycle_badge("Experimental")
use_news_md()

# Get the dependencies
use_package("httr")
use_package("jsonlite")
use_package("readr")
use_package("tibble")
use_package("purrr")

# Clean your description
use_tidy_description()
