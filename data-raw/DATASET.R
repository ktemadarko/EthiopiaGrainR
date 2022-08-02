## code to prepare `DATASET` dataset goes here



load("C:/Users/Korantema/Documents/RMI/EthiopiaGrainR/data-raw/edited_survey_forms.RData")
usethis::use_data(grain_operator_df, overwrite = TRUE)
usethis::use_data(revenue_costs_df, overwrite = TRUE)
usethis::use_data(revenue_df, overwrite = TRUE)
usethis::use_data(costs_df, overwrite = TRUE)
usethis::use_data(survey_list, overwrite = TRUE)
