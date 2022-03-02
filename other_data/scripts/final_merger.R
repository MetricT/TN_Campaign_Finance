### Combine all the contribution and expenditure files for all years into one
### file, making the following changes:
###
### * Change "Amount" from a char to a numeric
### * Change "Date" from a char to a date

Path <- getwd()

tn_data_load <- function(file, Report.Year) {
  val <- 
    read.csv(file) %>%
    mutate(Report.Year = Report.Year) %>%
    as_tibble() %>%
    select(-X) %>%
    mutate(
      Amount = gsub("\\$", "", Amount),
      Amount = gsub(",", "", Amount),
      Amount = as.numeric(Amount),
      Date = as.Date(Date, format = "%m/%d/%Y")
    )
  
    return(val)
}

contrib_list <- 
  list.files(path = Path, full.names = TRUE) %>% 
  as_tibble() %>% 
  filter(grepl("Contributions_", value)) %>% 
  rename(file = value) %>%
  mutate(
    Report.Year = gsub(paste(getwd(), "/Contributions_", sep = ""), "", file), 
    Report.Year = gsub(".csv", "", Report.Year), 
    Report.Year = as.integer(Report.Year))

expend_list <- 
  list.files(path = Path, full.names = TRUE) %>% 
  as_tibble() %>% 
  filter(grepl("Expenditures_", value)) %>% 
  rename(file = value) %>%
  mutate(
    Report.Year = gsub(paste(getwd(), "/Expenditures_", sep = ""), "", file), 
    Report.Year = gsub(".csv", "", Report.Year), 
    Report.Year = as.integer(Report.Year))

tn_data_contrib <- purrr::pmap_dfr(.l = contrib_list, .f = tn_data_load)
tn_data_expend  <- purrr::pmap_dfr(.l = expend_list,  .f = tn_data_load)

write_csv(tn_data_contrib, "Contributions_allyears_pristine.csv")
write_csv(tn_data_expend,  "Expenditures_allyears_pristine.csv")