### Build a database of TN House/Senate members by scraping the Legislature website

library(tidyverse)
library(rvest)

################################################################################

house_112 <- 
  "https://www.capitol.tn.gov/house/members/" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 112,
         Chamber = "House")


senate_112 <- 
  "https://www.capitol.tn.gov/senate/members/" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 112,
         Chamber = "Senate")

################################################################################

house_111 <- 
  "https://www.capitol.tn.gov/house/archives/111GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 111,
         Chamber = "House")


senate_111 <- 
  "https://www.capitol.tn.gov/senate/archives/111GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 111,
         Chamber = "Senate")


################################################################################

house_110 <- 
  "https://www.capitol.tn.gov/house/archives/110GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 110,
         Chamber = "House")


senate_110 <- 
  "https://www.capitol.tn.gov/senate/archives/110GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 110,
         Chamber = "Senate") 

# Manually add Doug Overbey since he's not there for some reason
#  %>% add_rows("Overbey, Doug", "R", "2", "110", "Senate",)



################################################################################

house_109 <- 
  "https://www.capitol.tn.gov/house/archives/109GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 109,
         Chamber = "House")


senate_109 <- 
  "https://www.capitol.tn.gov/senate/archives/109GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 109,
         Chamber = "Senate")

################################################################################

house_108 <- 
  "https://www.capitol.tn.gov/house/archives/108GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 108,
         Chamber = "House")


senate_108 <- 
  "https://www.capitol.tn.gov/senate/archives/108GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 108,
         Chamber = "Senate")

################################################################################

house_107 <- 
  "https://www.capitol.tn.gov/house/archives/107GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 107,
         Chamber = "House")


senate_107 <- 
  "https://www.capitol.tn.gov/senate/archives/107GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 107,
         Chamber = "Senate")


################################################################################

house_107 <- 
  "https://www.capitol.tn.gov/house/archives/107GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 107,
         Chamber = "House")


senate_107 <- 
  "https://www.capitol.tn.gov/senate/archives/107GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 107,
         Chamber = "Senate")


################################################################################

house_106 <- 
  "https://www.capitol.tn.gov/house/archives/106GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Representative, Party, `District Map`) %>%
  rename(Name = Representative,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 106,
         Chamber = "House")


senate_106 <- 
  "https://www.capitol.tn.gov/senate/archives/106GA/members/index.html" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  select(Senator, Party, `District Map`) %>%
  rename(Name = Senator,
         District = `District Map`) %>%
  mutate(District = gsub("District ", "", District),
         District = as.numeric(District)) %>%
  mutate(Session = 106,
         Chamber = "Senate")


################################################################################

house_105 <- 
  "https://www.capitol.tn.gov/house/archives/105GA/Members/HMembers.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office) %>%
  separate(party_district, c("Party", "District"), sep = " - ") %>%
  rename(Name = representative) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 105,
         Chamber = "House") %>%
  mutate(Name = gsub(",", ", ", Name)) %>% 
  mutate(Name = gsub("  ", " ", Name)) %>% 
  mutate(Name = gsub(" , ", ", ", Name))


senate_105 <- 
  "https://www.capitol.tn.gov/senate/archives/105GA/Members/sMembers105a.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office, -sponsor_list) %>%
  separate(party_district, c("Party", "District"), sep = " - ") %>%
  rename(Name = senator) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 105,
         Chamber = "Senate")


################################################################################

house_104 <- 
  "https://www.capitol.tn.gov/house/archives/104GA/Members/HMembers.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office) %>%
  separate(party_district, c("Party", "District"), sep = " - ") %>%
  rename(Name = representative) %>%
  mutate(Name = gsub("\\r", "", Name)) %>%
  mutate(Name = gsub("\\n", "", Name)) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 104,
         Chamber = "House")

################################################################################

house_103 <- 
  "https://www.capitol.tn.gov/house/archives/103GA/Members/HMembers.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office) %>%
  separate(party_district, c("Party", "District"), sep = "-") %>%
  rename(Name = representative) %>%
  mutate(Name = gsub("\\r", "", Name)) %>%
  mutate(Name = gsub("\\n", "", Name)) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 103,
         Chamber = "House")

################################################################################

house_102 <- 
  "https://www.capitol.tn.gov/house/archives/102GA/Members/Members.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office) %>%
  separate(party_district, c("Party", "District"), sep = "-") %>%
  rename(Name = member) %>%
  mutate(Name = gsub("\\r", "", Name)) %>%
  mutate(Name = gsub("\\n", "", Name)) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 102,
         Chamber = "House")

################################################################################

house_101 <- 
  "https://www.capitol.tn.gov/house/archives/101GA/Members.htm" %>%
  read_html() %>%
  html_nodes("table") %>%
  .[[1]] %>%
  html_table() %>%
  as_tibble(.name_repair = "minimal") %>%
  janitor::clean_names() %>%
  select(-office) %>%
  separate(party_district, c("Party", "District"), sep = "-") %>%
  rename(Name = member) %>%
  mutate(Name = gsub("\\r", "", Name)) %>%
  mutate(Name = gsub("\\n", "", Name)) %>%
  mutate(District = as.numeric(District)) %>%
  mutate(Session = 101,
         Chamber = "House")


all_house <-
  house_112 %>%
  bind_rows(house_111) %>%
  bind_rows(house_110) %>%
  bind_rows(house_109) %>%
  bind_rows(house_108) %>%
  bind_rows(house_107) %>%
  bind_rows(house_106) %>%
  bind_rows(house_105) %>%
  bind_rows(house_104) %>%
  bind_rows(house_103) %>%
  bind_rows(house_102) %>%
  bind_rows(house_101) %>%
  mutate(Name = if_else(grepl("Hargett", Name),
                        "Hargett, Tre", Name)) %>%
  mutate(
    Party = if_else(Party == "CCR",   "R", Party),
    Party = if_else(Party == "D\r\n", "D", Party),
    Party = if_else(Party == "R\r\n", "R", Party)
    ) 

all_senate <-
  senate_112 %>%
  bind_rows(senate_111) %>%
  bind_rows(senate_110) %>%
  bind_rows(senate_109) %>%
  bind_rows(senate_108) %>%
  bind_rows(senate_107) %>%
  bind_rows(senate_106) %>%
  bind_rows(senate_105) %>%
  mutate(Name = if_else(grepl("Hargett", Name),
                        "Harget, Tre", Name))

all_legislature <-
  all_house %>%
  bind_rows(all_senate) %>%
  mutate(Name = gsub("Speaker Emeritus ", "", Name)) %>%
  mutate(
    Speaker = if_else(grepl("Speaker|Lt. Gov.", Name), TRUE, FALSE),
    Name = gsub(" Speaker", "", Name),
    Name = gsub(" Lt. Gov.", "", Name),
    ) %>%
  filter(Name != "Vacant") %>%
  filter(Name != "") %>%
  mutate(Name = ifelse(Name == "Towns, Joe , Jr.",      "Towns, Joe, Jr.",          Name)) %>%
  mutate(Name = ifelse(Name == "Kyle, James F., Jr.",   "Kyle, Jim",                Name)) %>%
  mutate(Name = ifelse(Name == "Love, Jr., Harold M.",  "Love, Harold M., Jr.",     Name)) %>%
  mutate(Name = ifelse(Name == "Kumar, Sabi 'Doc'",     "Kumar, Sabi",              Name)) %>%
  mutate(Name = ifelse(Name == "Lynn, Susan",           "Lynn, Susan M.",           Name)) %>%
  mutate(Name = ifelse(Name == "Lynn,Susan M.",         "Lynn, Susan M.",           Name)) %>%
  mutate(Name = ifelse(Name == "McMillan, Kim",         "McMillan, Kim A.",         Name)) %>%
  mutate(Name = ifelse(Name == "Kelsey, Brian",         "Kelsey, Brian K.",         Name)) %>%
  mutate(Name = ifelse(Name == "Sargent, Charles",      "Sargent, Charles Michael", Name)) %>%
  mutate(Name = ifelse(Name == "Favors, Joanne",        "Favors, JoAnne",           Name)) %>%
  mutate(Name = ifelse(Name == "Deberry, John J., Jr.", "DeBerry, John J., Jr.",    Name)) %>%
  mutate(Name = ifelse(Name == "Hargrove, Jere",        "Hargrove, Jere L.",        Name)) %>%
  mutate(Name = ifelse(Name == "Jones, Ulysses , Jr.",  "Jones, Ulysses, Jr.",      Name)) %>%
  mutate(Name = ifelse(Name == "Harwell,  Beth",        "Harwell, Beth",            Name)) %>%
  mutate(Name = ifelse(Name == "Halteman Harwell, Beth","Harwell, Beth",            Name)) 

# A patch for missing entries due to resignation or special election. 
# The person listed spent the majority of the Session in that seat.  The only
# challenging decision was deciding House 83 when Kelsey won for Senate since
# it occurred close to the midpoint of the term.
patch <- tribble(
  ~Name,            ~Party, ~District,  ~Session,  ~Chamber, ~Speaker,
  "Ketron, Bill",      "R",        13,       110,  "Senate",    FALSE,
  "Harris, Lee",       "D",        29,       110,  "Senate",    FALSE,
  "Kyle, Jim",         "D",        30,       108,  "Senate",    FALSE,
  "Godsey, Steve",     "R",         1,       104,   "House",    FALSE,
  "Armstrong, Joe E.", "D",        15,       109,   "House",    FALSE,
  "Durham, Jeremy",    "R",        65,       109,   "House",    FALSE,
  "Kelsey, Brian K.",  "R",        83,       106,   "House",    FALSE,
)

all_legislature <-
  all_legislature %>%
  bind_rows(patch) %>%
  unique() %>%
  arrange(desc(Session)

write_csv(all_legislature, "tn_legislature_directory_101-112.csv")
