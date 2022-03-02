################################################################################
### Some examples of how to use the Campaign Finance DB in R
################################################################################
library(plyr)
library(tidyverse)
library(lubridate)
library(gt)
library(cowplot)

### Load the Campaign Finance data
contrib <- read_csv("../../Contributions_cleaned.csv")
expend  <- read_csv("../../Expenditures_cleaned.csv")
pacs    <- read_csv("../../PACS_cleaned.csv") %>% select(-Salutation, -First.Name)

### Load a file containing lists of various industry PACs, Business, and Individuals
source("pac_business_individuals.R")

################################################################################
### Example 1:  Graph contributions by Individuals, Candidates, Busineses, 
###             and PACs to Candidates by Year/Month
################################################################################

data <- 
  contrib %>% 
  filter(Dest == "Candidate") %>%
  select(Date, Amount, Source) %>% 
  mutate(Year = year(Date), Month = month(Date)) %>% 
  select(-Date) %>% 
  group_by(Year, Month, Source) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup %>% 
  mutate(Date = as.Date(paste(Year, "-", Month, "-01", sep = ""))) %>% 
  select(Date, Amount, Source) %>% 
  filter(!is.na(Date))

# Optional:  Normalize Amount using the max value for each source.   This helps
#            prevent a flood of contributions by PACs from making patterns in
#            contributions from Individuals too faint to see.
#
#data <-
#  data %>% 
#  left_join((data %>% 
#       select(Source, Amount) %>% 
#       group_by(Source) %>%  
#       summarize(MaxAmount = max(Amount)) %>% 
#       ungroup()), by = "Source") %>% 
#  mutate(Amount = Amount / MaxAmount)

# Graph the result
g_campaign_contributions <-
  
  ggplot(data = data, aes(x = year(Date), y = month(Date), fill = Amount)) +

  theme_minimal() +
  theme(
      legend.position = "none",
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      plot.caption = element_text(hjust = 0.5)) +

  geom_tile(color = "white") + 
  
  labs(title = "Contributions to TN Legislators by Year, Month", x = "", y = "") +
  
  scale_fill_gradient(low = "white", high = "darkred") +
  
  scale_y_continuous(trans = "reverse",
     breaks = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
     labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) + 
  
  scale_x_continuous(
    breaks = c(2000, 2001, 2003, 2005, 2007, 2009, 
               2011, 2013, 2015, 2017, 2019, 2021), 
     limits = c(2003, 2021),
     labels = c("101st\n2000", "102nd\n2001", "103rd\n2003", "104th\n2005", 
                "105th\n2007", "106th\n2009", "107th\n2011", "108th\n2013",
                "109th\n2015", "110th\n2017", "111st\n2019", "112nd\n2021")) +
  
  facet_wrap(~ Source, nrow = 2, ncol = 2, scales = "free")

print(g_campaign_contributions)

################################################################################
### Example 2:  Find the top 20 Individual donors to Candidates since 2018
################################################################################

contrib %>%
  filter(Source == "Individual") %>%
  filter(Dest   == "Candidate") %>% 
  filter(Report.Year >= 2018) %>%
  select(Amount, Contributor.Name) %>% 
  group_by(Contributor.Name) %>% 
  summarize(Amount = sum(Amount)) %>% ungroup() %>% 
  arrange(desc(Amount)) %>% 
  print(n = 20)

################################################################################
### Example 3:  Find the top 20 PACS outside TN donating to Candidates
################################################################################

outside_tn_pacs <- pacs %>% filter(State != "TN") %>% pull(Last.Name)

contrib %>% 
  filter(Source == "PAC" & Dest == "Candidate") %>% 
  filter(Contributor.Name %in% outside_tn_pacs) %>%
  select(Contributor.Name, Amount) %>%
  group_by(Contributor.Name) %>%
  summarize(Amount = sum(Amount)) %>%
  ungroup() %>%
  arrange(desc(Amount)) %>%
  print(n = 20)

################################################################################
### Example 4:  Top 20 Candidates receiving donations from other legislators 
###             since 2016
################################################################################  

contrib %>% 
  filter(Source == "Candidate" & Dest == "Candidate") %>% 
  filter(Report.Year >= 2016) %>%
  filter(!is.na(Amount)) %>% 
  select(Amount, Recipient.Name) %>% 
  group_by(Recipient.Name) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(desc(Amount)) %>% 
  
  # Optional:  Filter out gubernatorial candidates so we can just look at the legislature
  filter(!grepl("BOYD, RANDY|BLACK, DIANE|DEAN, KARL|LEE, BILL|HASLAM, BILL|GOVERNOR", Recipient.Name)) %>%

  print(n = 20)

################################################################################
### Example 5:  What was the effect of "Citizens United" on the number of PACs
###             and dollar volume of PAC contributions?
################################################################################

# NOTE:  This is broken because PAC data is split across two databases.

### Graph the number of PACs using the info in the PAC database
g_number_pacs <-
  pacs %>% 
  select(Created) %>% 
  mutate(Year = year(Created)) %>% 
  select(Year) %>% 
  filter(Year != 1990) %>% 
  filter(Year <= 2020) %>% 
  filter(Year >= 2004) %>% # Because data before 2004 is buggy and unreliable
  
  mutate(Session = case_when(
    Year == 2004   ~ 103,
    Year == 2005   ~ 104,
    Year == 2006   ~ 104,
    Year == 2007   ~ 105,
    Year == 2008   ~ 105,
    Year == 2009   ~ 106,
    Year == 2010   ~ 106,
    Year == 2011   ~ 107,
    Year == 2012   ~ 107,
    Year == 2013   ~ 108,
    Year == 2014   ~ 108,
    Year == 2015   ~ 109,
    Year == 2016   ~ 109,
    Year == 2017   ~ 110,
    Year == 2018   ~ 110,
    Year == 2019   ~ 111,
    Year == 2020   ~ 111,
    Year == 2021   ~ 112,
  )) %>%
  
  group_by(Session) %>% 
  summarize(n = n()) %>% 
  ungroup() %>% 
  
  mutate(Year = case_when(
    Session == 103  ~ 2003,
    Session == 104  ~ 2005,
    Session == 105  ~ 2007,
    Session == 106  ~ 2009,
    Session == 107  ~ 2011,
    Session == 108  ~ 2013,
    Session == 109  ~ 2015,
    Session == 110  ~ 2017,
    Session == 111  ~ 2019,
    Session == 112  ~ 2021,
  )) %>%
  
  arrange(Year) %>% 
  ggplot() + 
  theme_bw() +
  geom_bar(stat = "identity", aes(x = Year, y = n), fill = "darkseagreen4") +
  geom_vline(xintercept = decimal_date(as.Date("2010-01-21")), linetype = "dashed") +
  scale_x_continuous(
    breaks = c(2000, 2001, 2003, 2005, 2007, 2009, 
               2011, 2013, 2015, 2017, 2019, 2021), 
    labels = c("101st\n2000", "102nd\n2001", "103rd\n2003", "104th\n2005", 
               "105th\n2007", "106th\n2009", "107th\n2011", "108th\n2013",
               "109th\n2015", "110th\n2017", "111st\n2019", "112nd\n2021")) +
  labs(x = "", y = "",
       title = "Number of New PACs in TN by year created",
       subtitle = "Dashed line shows date of US Supreme Court Decision \"Citizens United v FEC\"")

g_dollar_pacs <- 
  contrib %>% 
  filter(Source == "PAC") %>% 
  filter(Report.Year >= 2004) %>% 
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  mutate(Session = case_when(
    Report.Year == 2004   ~ 103,
    Report.Year == 2005   ~ 104,
    Report.Year == 2006   ~ 104,
    Report.Year == 2007   ~ 105,
    Report.Year == 2008   ~ 105,
    Report.Year == 2009   ~ 106,
    Report.Year == 2010   ~ 106,
    Report.Year == 2011   ~ 107,
    Report.Year == 2012   ~ 107,
    Report.Year == 2013   ~ 108,
    Report.Year == 2014   ~ 108,
    Report.Year == 2015   ~ 109,
    Report.Year == 2016   ~ 109,
    Report.Year == 2017   ~ 110,
    Report.Year == 2018   ~ 110,
    Report.Year == 2019   ~ 111,
    Report.Year == 2020   ~ 111,
    Report.Year == 2021   ~ 112,
  )) %>%
  group_by(Session) %>%
  summarize(Amount = sum(Amount)) %>%
  ungroup() %>%
  mutate(Report.Year = case_when(
    Session == 103  ~ 2003,
    Session == 104  ~ 2005,
    Session == 105  ~ 2007,
    Session == 106  ~ 2009,
    Session == 107  ~ 2011,
    Session == 108  ~ 2013,
    Session == 109  ~ 2015,
    Session == 110  ~ 2017,
    Session == 111  ~ 2019,
    Session == 112  ~ 2021,
  )) %>%
  ggplot() + 
  theme_bw() + 
  geom_bar(stat = "identity", aes(x = Report.Year, y = Amount), fill = "darkred") +
  scale_y_continuous(labels = scales::dollar) +
  geom_vline(xintercept = decimal_date(as.Date("2010-01-21")), linetype = "dashed") +
  scale_x_continuous(
    breaks = c(2000, 2001, 2003, 2005, 2007, 2009, 
               2011, 2013, 2015, 2017, 2019, 2021), 
    labels = c("101st\n2000", "102nd\n2001", "103rd\n2003", "104th\n2005", 
               "105th\n2007", "106th\n2009", "107th\n2011", "108th\n2013",
               "109th\n2015", "110th\n2017", "111st\n2019", "112nd\n2021")) +
  labs(x = "", y = "", 
       title = "Dollars Donated in PACs by Legislative Session",
       subtitle = "Dashed line shows date of US Supreme Court Decision \"Citizens United v FEC\"")

print(plot_grid(g_number_pacs, g_dollar_pacs, nrow = 1, ncol = 2, align = "hv"))


################################################################################
### Example 6:  How did Citizens United affect PAC contributions from various
###             industries?
################################################################################

### Large ISP's (AT&T/Bellsouth, Verizon, Charter, Comcast)
g_isp <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_isp) %>% 
  filter(Report.Year >= 2004) %>% 
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ggplot() + 
  theme_bw() + 
  geom_bar(stat = "identity", fill = "darkseagreen4",
           aes(x = Report.Year, y = Amount)) + 
  scale_y_continuous(labels = scales::dollar) + 
  geom_vline(xintercept = 2010, linetype = "dashed", color = "steelblue2") + 
  labs(x = "", 
       title = "Contributions from ISP's (AT&T/Verizon/Comcast/Charter) to TN Candidates", 
       subtitle = "Dashed line represents date US Supreme Court decided Citizens United v F.E.C.")
#print(g_isp)


# Alcohol manufacturers, wholesalers, distributors, and shops
g_alcohol <- 
contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_alcohol) %>% 
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  filter(Report.Year >= 2004) %>%
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  ggplot() + 
  theme_bw() + 
  geom_bar(stat = "identity", fill = "darkseagreen4",
           aes(x = Report.Year, y = Amount)) + 
  scale_y_continuous(labels = scales::dollar) + 
  geom_vline(xintercept = 2010, linetype = "dashed", color = "steelblue2") + 
  labs(x = "", title = "Contributions from Alcohol Industry to TN Candidates", 
       subtitle = "Dashed line represents date US Supreme Court decided Citizens United v F.E.C.")
#print(g_alcohol)

print(plot_grid(g_isp, g_alcohol, nrow = 1, ncol = 2, align = "hv"))


################################################################################
### Example 7:  Compare contributions from cannabis and several antagonistic 
###             businesses and organizations
################################################################################

data_alcohol <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_alcohol) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(Alcohol = Amount)

data_private_prisons <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_private_prisons) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(`Private Prisons` = Amount)

data_pharma <-
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_pharma_sales) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(`Pharma`= Amount)

data_cannabis <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% c(pac_cannabis, business_cannabis)) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(Cannabis = Amount)

data <-
  data_alcohol %>%
  full_join(data_private_prisons, by = "Report.Year") %>% 
  full_join(data_cannabis,        by = "Report.Year") %>%
  full_join(data_pharma,          by = "Report.Year") %>%
  pivot_longer(-Report.Year,
               names_to = "Industry",
               values_to = "Amount") %>% 
  mutate(Industry = fct_relevel(Industry,
                                c("Alcohol", 
                                  "Private Prisons",
                                  "Pharma", 
                                  "Cannabis")))

g_mmj_and_foes <-
  ggplot(data = data) + 
  theme_bw() + 
  geom_bar(stat = "identity", fill = "darkseagreen4",
           aes(x = Report.Year, y = Amount)) + 
  scale_y_continuous(labels = scales::dollar) + 
  labs(x = "", title = "Contributions from Cannabis and Opponents to TN Candidates") +
  facet_wrap(~ Industry, nrow = 2, ncol = 2)

print(g_mmj_and_foes)


################################################################################
### Example 8:  Where do Alcohol industry contributions come from?
################################################################################

# Top PAC contributors
contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pacs_alcohol) %>% 
  filter(Report.Year >= 2004) %>%
  select(Contributor.Name, Amount) %>% 
  group_by(Contributor.Name) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(desc(Amount)) %>% 
  print(n = 20)

# Top business contributors
contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% business_alcohol) %>% 
  filter(Report.Year >= 2004) %>%
  select(Contributor.Name, Amount) %>% 
  group_by(Contributor.Name) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(desc(Amount)) %>% 
  print(n = 20)

# Top Individual contributors
contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% individual_alcohol) %>% 
  filter(Report.Year >= 2004) %>%
  select(Contributor.Name, Amount) %>% 
  group_by(Contributor.Name) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(desc(Amount)) %>% 
  print(n = 20)

################################################################################
### Example 9:  How much do Alcohol Producers, Distributors, and Retailers donate?
################################################################################

data_alcohol_producer <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_alcohol_producer) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(Producer = Amount)

data_alcohol_wholesaler <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_alcohol_wholesaler) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(Wholesaler = Amount)

data_alcohol_retailer <- 
  contrib %>% 
  filter(Dest == "Candidate") %>% 
  filter(Contributor.Name %in% pac_alcohol_retailer) %>% 
  filter(Report.Year >= 2004) %>%
  select(Report.Year, Amount) %>% 
  group_by(Report.Year) %>% 
  summarize(Amount = sum(Amount)) %>% 
  ungroup() %>% 
  arrange(Report.Year) %>%
  rename(Retailer = Amount)

data_alcohol_tiers <-
  data_alcohol_producer %>%
  full_join(data_alcohol_wholesaler, by = "Report.Year") %>% 
  full_join(data_alcohol_retailer,   by = "Report.Year") %>%
  arrange(Report.Year) %>%
  mutate_if(is.numeric, ~ (replace_na(., 0))) %>%
  pivot_longer(-Report.Year, names_to = "Tier", values_to = "Amount") %>%
  mutate(Tier = fct_relevel(Tier, c("Producer", "Wholesaler", "Retailer")))

g_alcohol_tiers <-
  ggplot(data = data_alcohol_tiers) +
  theme_bw() +
  geom_line(aes(x = Report.Year, y = Amount, color = Tier), size = 1.3) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_continuous(
    breaks = c(2000, 2001, 2003, 2005, 2007, 2009, 
               2011, 2013, 2015, 2017, 2019, 2021), 
    labels = c("101st\n2000", "102nd\n2001", "103rd\n2003", "104th\n2005", 
               "105th\n2007", "106th\n2009", "107th\n2011", "108th\n2013",
               "109th\n2015", "110th\n2017", "111st\n2019", "112nd\n2021")) +
  labs(title = "Campaign Contributions by Alcohol companies to TN Legislators by Tier", x = "", y = "")
print(g_alcohol_tiers)
