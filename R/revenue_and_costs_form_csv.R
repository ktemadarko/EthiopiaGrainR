#Append to CSV----
#Connect to EpiCollect5 API https://five.epicollect.net/


#' Download Revenue and Costs form entries using EpiCollect5 API
#'
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom httr POST
#' @importFrom tibble tibble
#' @importFrom readr write_csv
#' @importFrom httr add_headers
#' @rdname revenue_costs_form_csv
#'
#' @return The dataset is written as a csv file in the IKEA_Ethopian_grain_mill_data folder on local storage
#' @export
#'
#' @examples
#' #Download and store the Revenue and Costs form of the IKEA Ethiopia grain mill project in CSV
#' \dontrun{
#' Revenue_costs_form <- revenue_costs_form_csv()
#' }

revenue_costs_form_csv<-function(){

  authorization_details <- tibble::tibble(
    ClientID = "3211",
    Client_secret = "G657WQAQs6sM1rEACzLoO97yjwdwuhDf5LTpzaTu",
    project_slug = "ikea-data-collection-pilot",
    form_name =c("Grain Mill Operator","Revenue","Revenue and Cost Data","Costs"),

    form_reference =c("39162b0fea2a47939a8ce0e4c3b61d3b_61014d51ad844",
                      "39162b0fea2a47939a8ce0e4c3b61d3b_61016a5f77597",
                      "39162b0fea2a47939a8ce0e4c3b61d3b_61014a493a8ad",
                      "39162b0fea2a47939a8ce0e4c3b61d3b_610150fcad85a" ))

  #POST: is used to send the data to the server to create/update the resource
  create_resource<- httr::POST("https://five.epicollect.net/api/oauth/token",
                               body = list(grant_type = "client_credentials",
                                           client_id = authorization_details$ClientID[1],
                                           client_secret = authorization_details$Client_secret[1]))
  #access token
  token <- httr::content(create_resource)$access_token

  survey_base_url <- "https://five.epicollect.net/api/export/entries/"
  survey_project_id <- authorization_details$project_slug[1]

  #Create the url
  url_json <- function(form_reference){
    paste0(survey_base_url,
           survey_project_id,
           "?map_index=0&form_ref=",
           form_reference,
           "&format=json&page=",
           "&per_page=1000")
  }



  form_links<-function(form_reference){
    form_urls<-url_json(form_reference)
    return(form_urls)
  }

  form_api_links <-purrr::map_chr(authorization_details$form_reference,form_links)


  #Create vector of get responses
  get_survey_responses<-function(form_api_links){
    survey_content<-httr::GET(form_api_links, add_headers("Authorization" = paste("Bearer", token)))
    return(survey_content)
  }

  survey_responses<-purrr::map(form_api_links,get_survey_responses)

  get_form_count<-function(form){
    form_count <-jsonlite::fromJSON(rawToChar(survey_responses[[form]][["content"]]))
    return(form_count$meta)
  }

  count_form_entries<-purrr::map_df(c(1:4),get_form_count)

  get_form<-function(form){
    form <-jsonlite::fromJSON(rawToChar(survey_responses[[form]][["content"]]))
    return(form$data$entries)
  }

  revenue_costs_form <-purrr::map_df(3,get_form)
  #paste0("The Revenue and Costs data frame has ", nrow(revenue_costs_form), " rows and ", ncol(revenue_costs_form)," columns")

  readr::write_csv(revenue_costs_form,"Revenue_and_Costs_form.csv")
  return(revenue_costs_form)

}



