#importing 7 sensor csv files

#X0869----
X0869 <- readr::read_csv("data-raw/Sensor Data/0869.csv",
col_types = readr::cols(Timestamp = col_character())) |>
 dplyr::mutate(sensor_id="X0869", .before=Timestamp) #adding sensor-id column
#removing excess characters that were imported
X0869$Timestamp <-stringr::str_sub(X0869$Timestamp,3,21)

#Parsing the date column`time_recorded` for the seven devices.
X0869$Timestamp <-readr::parse_datetime(X0869$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
#Parse date time to get individual dates
X0869$single_date=lubridate::floor_date(X0869$Timestamp , unit= "day")

#X0868----
X0868 <- read_csv("data-raw/Sensor Data/0868.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X0868", .before=Timestamp)
X0868$Timestamp <-stringr::str_sub(X0868$Timestamp,3,21)
X0868$Timestamp <-readr::parse_datetime(X0868$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X0868$single_date=lubridate::floor_date(X0868$Timestamp , unit= "day")

#X0862----
X0862 <- read_csv("data-raw/Sensor Data/0862.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X0862", .before=Timestamp)
X0862$Timestamp <-stringr::str_sub(X0862$Timestamp,3,21)
X0862$Timestamp <-readr::parse_datetime(X0862$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X0862$single_date=lubridate::floor_date(X0862$Timestamp , unit= "day")

#X0861----
X0861 <- read_csv("data-raw/Sensor Data/0861.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X0861", .before=Timestamp)
X0861$Timestamp <-stringr::str_sub(X0861$Timestamp,3,21)
X0861$Timestamp <-readr::parse_datetime(X0861$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X0861$single_date=lubridate::floor_date(X0861$Timestamp , unit= "day")

#X085c----
X085c <- read_csv("data-raw/Sensor Data/085c.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X085c", .before=Timestamp)
X085c$Timestamp <-stringr::str_sub(X085c$Timestamp,3,21)
X085c$Timestamp <-readr::parse_datetime(X085c$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X085c$single_date=lubridate::floor_date(X085c$Timestamp , unit= "day")

#X0885e----
X085e <- read_csv("data-raw/Sensor Data/085e.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X085e", .before=Timestamp)
X085e$Timestamp <-stringr::str_sub(X085e$Timestamp,3,21)
X085e$Timestamp <-readr::parse_datetime(X085e$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X085e$single_date=lubridate::floor_date(X085e$Timestamp , unit= "day")


#X085f----
X085f <- read_csv("data-raw/Sensor Data/085f.csv",
                  col_types = readr::cols(Timestamp = col_character())) |>
  dplyr::mutate(sensor_id="X085f", .before=Timestamp)
X085f$Timestamp <-stringr::str_sub(X085f$Timestamp,3,21)
X085f$Timestamp <-readr::parse_datetime(X085f$Timestamp ,locale=locale(tz="Africa/Addis_Ababa"))
X085f$single_date=lubridate::floor_date(X085f$Timestamp , unit= "day")


#' Rename_dates_kwh
#'
#' @author Ama Owusu-Darko
#'
#' @description
#' A function to for initial data cleaning of sensor files
#'
#' @param df one of the sensor files above eg. X085c
#'
#' @importFrom stringr str_sub
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr add_count
#' @importFrom hms as_hms
#' @importFrom lubridate floor_date
#' @importFrom lubridate hour
#' @importFrom lubridate year
#' @importFrom labelled set_variable_labels
#'
#' @rdname dates_n_labels
#'
#' @return add columns year_created
#'
#' @export
#'
#' @examples
#' dates_n_labels(XO869)
dates_n_labels <- function(df){
  df|> tibble::as_tibble()|>

    dplyr::rename(rpm_value= Value, #value is number of rotations divided by 10
                  time_recorded= Timestamp)|>

    # number of rotations in 10 minutes in recorded from sensors
    dplyr::mutate(number_of_rotations = rpm_value*10,

                year_created=lubridate::year(time_recorded),
                month_created = lubridate::month(time_recorded,#month factor
                                                 label = TRUE, abbr = FALSE),
                daily=as.character(single_date),

                time_of_day=hms::as_hms(format(as.POSIXct(time_recorded),format="%T")),

                hour_of_day = lubridate::floor_date(time_recorded,unit="hour"),
                hr_of_day=lubridate::hour(time_recorded)) |>

    dplyr::add_count(month_created, name="records_per_month")|>#count records per month

    labelled::set_variable_labels(
                                  sensor_id = "sensor device ids",
                                  time_recorded = "sensor records every 10 minutes",
                                  number_of_rotations= "number of rotations in 10 minutes",
                                  rpm_value = "rotations per minute",

                                  daily="single date as a character",
                                  single_date="single date as a date object",

                                  daily="single date as a character",
                                  month_created = "month the record was created",
                                  hour_of_day= "hour entry was made (time)",
                                  hr_of_day= "hour as integer")
}



#X0869<-dates_n_labels(X0869)
#X0868<-dates_n_labels(X0868)
#X085f<-dates_n_labels(X085f)
