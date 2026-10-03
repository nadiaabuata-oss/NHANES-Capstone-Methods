# NHANES TABLE 1 - METHODS / SURVEY WEIGHTING REVIEW
# NHANES 2005-06 through 2017-18
#
# Purpose:
# I am creating a shorter version of my capstone code so that the
# NHANES survey weighting and Table 1 workflow can be reviewed.
#
# My main questions are:
# 1. Am I using the appropriate survey weight (WTDRD1)?
# 2. Am I correctly pooling 7 two-year cycles by dividing WTDRD1 by 7?
# 3. Am I correctly defining the survey-design base before restricting
#    to my analytic population?
# 4. Am I correctly specifying strata and PSU in svydesign()?
# 5. Am I correctly subsetting the analytic population within the
#    survey design?


# SETUP -------------------------------------------------------------------
setwd("C:/Users/Nadia/Desktop/MPH/Year 2/Fall semester/Capstone/Demo data to check preg feasibility")
getwd()
folder <- "C:/Users/Nadia/Desktop/MPH/Year 2/Fall semester/Capstone/Demo data to check preg feasibility"
library(haven)
library(dplyr)
library(survey)
library(gtsummary)

# DEMOGRAPHICS ------------------------------------------------------------
# I am reading the demographic files for all 7 NHANES cycles
demo_2005 <- read_xpt(file.path(folder, "DEMO_D.xpt"))
demo_2007 <- read_xpt(file.path(folder, "DEMO_E.xpt"))
demo_2009 <- read_xpt(file.path(folder, "DEMO_F.xpt"))
demo_2011 <- read_xpt(file.path(folder, "DEMO_G.xpt"))
demo_2013 <- read_xpt(file.path(folder, "DEMO_H.xpt"))
demo_2015 <- read_xpt(file.path(folder, "DEMO_I.xpt"))
demo_2017 <- read_xpt(file.path(folder, "DEMO_J.xpt"))

# I am adding survey-cycle labels
demo_2005$cycle <- "2005-06"
demo_2007$cycle <- "2007-08"
demo_2009$cycle <- "2009-10"
demo_2011$cycle <- "2011-12"
demo_2013$cycle <- "2013-14"
demo_2015$cycle <- "2015-16"
demo_2017$cycle <- "2017-18"

# I am combining all demographic cycles
demo_all <- bind_rows(
  demo_2005,
  demo_2007,
  demo_2009,
  demo_2011,
  demo_2013,
  demo_2015,
  demo_2017)

# I am checking the combined demographic dataset
dim(demo_all)
table(demo_all$cycle)
anyDuplicated(demo_all$SEQN)


# DEPRESSION SCREENER -----------------------------------------------------
# I am reading the PHQ-9 files for all 7 NHANES cycles
dpq_2005 <- read_xpt(file.path(folder, "DPQ_D.xpt"))
dpq_2007 <- read_xpt(file.path(folder, "DPQ_E.xpt"))
dpq_2009 <- read_xpt(file.path(folder, "DPQ_F.xpt"))
dpq_2011 <- read_xpt(file.path(folder, "DPQ_G.xpt"))
dpq_2013 <- read_xpt(file.path(folder, "DPQ_H.xpt"))
dpq_2015 <- read_xpt(file.path(folder, "DPQ_I.xpt"))
dpq_2017 <- read_xpt(file.path(folder, "DPQ_J.xpt"))

# I am adding survey-cycle labels
dpq_2005$cycle <- "2005-06"
dpq_2007$cycle <- "2007-08"
dpq_2009$cycle <- "2009-10"
dpq_2011$cycle <- "2011-12"
dpq_2013$cycle <- "2013-14"
dpq_2015$cycle <- "2015-16"
dpq_2017$cycle <- "2017-18"

# I am combining all PHQ-9 cycles
dpq_all <- bind_rows(
  dpq_2005,
  dpq_2007,
  dpq_2009,
  dpq_2011,
  dpq_2013,
  dpq_2015,
  dpq_2017)

# I am checking the combined PHQ-9 dataset
dim(dpq_all)
table(dpq_all$cycle)
anyDuplicated(dpq_all$SEQN)


# DAY 1 DIETARY RECALL ----------------------------------------------------
# I am reading the Day 1 dietary files for all 7 NHANES cycles
dr1_2005 <- read_xpt(file.path(folder, "DR1TOT_D.xpt"))
dr1_2007 <- read_xpt(file.path(folder, "DR1TOT_E.xpt"))
dr1_2009 <- read_xpt(file.path(folder, "DR1TOT_F.xpt"))
dr1_2011 <- read_xpt(file.path(folder, "DR1TOT_G.xpt"))
dr1_2013 <- read_xpt(file.path(folder, "DR1TOT_H.xpt"))
dr1_2015 <- read_xpt(file.path(folder, "DR1TOT_I.xpt"))
dr1_2017 <- read_xpt(file.path(folder, "DR1TOT_J.xpt"))

# I am adding survey-cycle labels
dr1_2005$cycle <- "2005-06"
dr1_2007$cycle <- "2007-08"
dr1_2009$cycle <- "2009-10"
dr1_2011$cycle <- "2011-12"
dr1_2013$cycle <- "2013-14"
dr1_2015$cycle <- "2015-16"
dr1_2017$cycle <- "2017-18"

# I am combining all Day 1 dietary cycles
dr1_all <- bind_rows(
  dr1_2005,
  dr1_2007,
  dr1_2009,
  dr1_2011,
  dr1_2013,
  dr1_2015,
  dr1_2017)

# I am checking the combined Day 1 dietary dataset
dim(dr1_all)
table(dr1_all$cycle)
anyDuplicated(dr1_all$SEQN)

# I am checking that the variables needed for the dietary analysis are present
c(
  "SEQN",
  "DR1DRSTZ",
  "WTDRD1",
  "DR1TKCAL",
  "DR1TPROT",
  "DR1TFIBE") %in% names(dr1_all)

# BODY MEASURES -----------------------------------------------------------
# I am reading the body-measure files for all 7 NHANES cycles
bmx_2005 <- read_xpt(file.path(folder, "BMX_D.xpt"))
bmx_2007 <- read_xpt(file.path(folder, "BMX_E.xpt"))
bmx_2009 <- read_xpt(file.path(folder, "BMX_F.xpt"))
bmx_2011 <- read_xpt(file.path(folder, "BMX_G.xpt"))
bmx_2013 <- read_xpt(file.path(folder, "BMX_H.xpt"))
bmx_2015 <- read_xpt(file.path(folder, "BMX_I.xpt"))
bmx_2017 <- read_xpt(file.path(folder, "BMX_J.xpt"))

# I am adding survey-cycle labels
bmx_2005$cycle <- "2005-06"
bmx_2007$cycle <- "2007-08"
bmx_2009$cycle <- "2009-10"
bmx_2011$cycle <- "2011-12"
bmx_2013$cycle <- "2013-14"
bmx_2015$cycle <- "2015-16"
bmx_2017$cycle <- "2017-18"

# I am combining all body-measure cycles
bmx_all <- bind_rows(
  bmx_2005,
  bmx_2007,
  bmx_2009,
  bmx_2011,
  bmx_2013,
  bmx_2015,
  bmx_2017)

# I am checking the combined body-measure dataset
dim(bmx_all)
table(bmx_all$cycle)
anyDuplicated(bmx_all$SEQN)

# I am creating a small BMI dataset
bmi_data <- bmx_all %>%
  select(SEQN, BMXBMI)

dim(bmi_data)
anyDuplicated(bmi_data$SEQN)


# BUILDING THE BROAD SURVEY BASE -----------------------------------------
# I am checking that DEMO contains the variables needed for the survey design

c(
  "SEQN",
  "RIAGENDR",
  "RIDAGEYR",
  "RIDEXPRG",
  "SDMVSTRA",
  "SDMVPSU") %in% names(demo_all)

# I am checking that Day 1 diet contains the dietary survey weight
c("SEQN","WTDRD1","DR1DRSTZ") %in% names(dr1_all)

# I am building a broad survey base by merging the participant-level files
survey_base <- demo_all %>%
  left_join(dr1_all, by = "SEQN")

# I am checking the merge
dim(survey_base)
anyDuplicated(survey_base$SEQN)

# I am adding PHQ-9 data to the broad survey base
survey_base <- survey_base %>%
  left_join(dpq_all, by = "SEQN")

# I am checking that the merge preserved participant uniqueness
dim(survey_base)
anyDuplicated(survey_base$SEQN)

# I am adding measured BMI to the broad survey base
survey_base <- survey_base %>%
  left_join(bmi_data, by = "SEQN")

# I am checking that the BMI merge did not change the number of participants
dim(survey_base)
anyDuplicated(survey_base$SEQN)
"BMXBMI" %in% names(survey_base)

# PHQ-9 -------------------------------------------------------------------
# I am listing the 9 PHQ-9 items
phq_items <- c(
  "DPQ010", "DPQ020", "DPQ030",
  "DPQ040", "DPQ050", "DPQ060",
  "DPQ070", "DPQ080", "DPQ090")

# I am checking that all 9 PHQ-9 items are present
phq_items %in% names(survey_base)

# I am defining complete PHQ-9 as a valid response (0-3) on all 9 items
survey_base$complete_phq9 <- apply(survey_base[phq_items],1,function(x) all(x %in% 0:3))

table(survey_base$complete_phq9)

# I am calculating the PHQ-9 total score for participants with
# valid responses on all 9 items
survey_base$phq9_total <- rowSums(survey_base[phq_items])
survey_base$phq9_total[
  survey_base$complete_phq9 == FALSE] <- NA

summary(survey_base$phq9_total)


# POOLED DAY 1 DIETARY WEIGHT --------------------------------------------
# I am using the Day 1 dietary weight because the current analytic sample
# requires a reliable Day 1 dietary recall.
#
# I am pooling 7 two-year NHANES cycles:
# 2005-06, 2007-08, 2009-10, 2011-12, 2013-14, 2015-16, 2017-18.
#
# I am creating the pooled 14-year weight by dividing WTDRD1 by 7.
# This is one of the methodological decisions I would like reviewed.

survey_base$WTDRD1_14YR <- survey_base$WTDRD1 / 7
# I am checking the original and pooled Day 1 dietary weights
summary(survey_base$WTDRD1)
summary(survey_base$WTDRD1_14YR)

table(survey_base$WTDRD1_14YR == 0,useNA = "ifany")

# I am comparing Day 1 recall status with Day 1 dietary weight status
table(
  survey_base$DR1DRSTZ,
  survey_base$WTDRD1_14YR > 0,
  useNA = "ifany")


# SURVEY-DESIGN BASE ------------------------------------------------------
# I am keeping participants with a reliable Day 1 dietary recall.
# I am doing this before creating the survey design because the current
# analysis requires Day 1 dietary data.
#
# I would specifically like feedback on whether this is the appropriate
# survey-design base.

diet_survey_base <- survey_base %>%
  filter(DR1DRSTZ == 1)
dim(diet_survey_base)

# I am checking that all participants in this base have a positive weight
table(diet_survey_base$WTDRD1_14YR > 0,useNA = "ifany")

# NHANES COMPLEX SURVEY DESIGN -------------------------------------------
# I am creating the NHANES survey-design object using:
# WTDRD1_14YR = pooled Day 1 dietary weight
# SDMVSTRA = survey strata
# SDMVPSU = primary sampling unit

nhanes_design <- svydesign(
  ids = ~SDMVPSU,
  strata = ~SDMVSTRA,
  weights = ~WTDRD1_14YR,
  nest = TRUE,
  data = diet_survey_base)


# TABLE 1 ANALYTIC POPULATION --------------------------------------------
# I am defining Table 1 eligibility within the survey design.
#
# Eligibility:
# - Female
# - Age 20-44 years
# - Complete PHQ-9
# - Known current pregnancy status
#
# Reliable Day 1 dietary recall is already required by diet_survey_base.

nhanes_design <- update(
  nhanes_design,
  table1_eligible =
    RIAGENDR == 2 &
    RIDAGEYR >= 20 &
    RIDAGEYR <= 44 &
    complete_phq9 == TRUE &
    RIDEXPRG %in% c(1, 2))

# I am checking the unweighted eligibility counts

table(nhanes_design$variables$table1_eligible)

# I am subsetting the survey design to the Table 1 analytic population
table1_design <- subset(nhanes_design,table1_eligible == TRUE)

# I am checking the final unweighted analytic sample size
nrow(table1_design$variables)

# TABLE 1 VARIABLES -------------------------------------------------------
# I am creating readable variables for the final Table 1
table1_design <- update(
  table1_design,
  
  # Pregnancy status
  pregnancy_group = factor(
    RIDEXPRG,
    levels = c(1, 2),
    labels = c("Pregnant", "Not pregnant")
  ),
  
  # PHQ-9 categories
  phq9_category = factor(
    ifelse(
      phq9_total < 10,
      "<10",
      ifelse(phq9_total <= 15, "10-15", ">15")
    ),
    levels = c("<10", "10-15", ">15")
  ),
  
  # Race/ethnicity
  race_ethnicity = factor(
    RIDRETH1,
    levels = c(1, 2, 3, 4, 5),
    labels = c(
      "Mexican American",
      "Other Hispanic",
      "Non-Hispanic White",
      "Non-Hispanic Black",
      "Other Race/Multiracial"
    )
  ),
  
  # Education
  education = factor(
    ifelse(DMDEDUC2 == 9, NA, DMDEDUC2),
    levels = c(1, 2, 3, 4, 5),
    labels = c(
      "Less than 9th grade",
      "9-11th grade",
      "High school graduate/GED",
      "Some college or AA degree",
      "College graduate or above"
    )
  ),
  
  # Marital status
  marital_status = factor(
    ifelse(DMDMARTL == 77, NA, DMDMARTL),
    levels = c(1, 2, 3, 4, 5, 6),
    labels = c(
      "Married",
      "Widowed",
      "Divorced",
      "Separated",
      "Never married",
      "Living with partner"
    )
  )
)

# I am checking the pregnancy-group counts
table(
  table1_design$variables$pregnancy_group,
  useNA = "ifany"
)

# SURVEY-WEIGHTED TABLE 1 -------------------------------------------------
# I am creating the survey-weighted Table 1.
# Continuous variables are shown as weighted median (25th, 75th percentile).
# Categorical variables are shown as weighted percentages.
table1 <- table1_design %>%
  tbl_svysummary(
    by = pregnancy_group,
    
    include = c(
      RIDAGEYR,
      race_ethnicity,
      education,
      marital_status,
      INDFMPIR,
      phq9_total,
      phq9_category,
      DR1TKCAL,
      DR1TFIBE,
      DR1TPROT,
      BMXBMI
    ),
    
    label = list(
      RIDAGEYR ~ "Age, years",
      race_ethnicity ~ "Race/ethnicity",
      education ~ "Education",
      marital_status ~ "Marital status",
      INDFMPIR ~ "Poverty-income ratio",
      phq9_total ~ "PHQ-9 score",
      phq9_category ~ "PHQ-9 category",
      DR1TKCAL ~ "Energy intake, kcal/day",
      DR1TFIBE ~ "Dietary fiber, g/day",
      DR1TPROT ~ "Protein intake, g/day",
      BMXBMI ~ "Measured BMI, kg/m²"
    ),
    
    statistic = list(
      all_continuous() ~ "{median} ({p25}, {p75})",
      all_categorical() ~ "{p}%"
    ),
    
    digits = list(
      all_continuous() ~ 1,
      all_categorical() ~ 1
    ),
    
    missing = "no"
  ) %>%
  
  add_overall() %>%
  
  modify_header(
    label ~ "**Characteristic**",
    stat_0 ~ "**Overall**  \nN = 6,954",
    stat_1 ~ "**Pregnant**  \nn = 617",
    stat_2 ~ "**Not pregnant**  \nn = 6,337"
  ) %>%
  
  bold_labels()

table1 %>%
  as_gt()


# TABLE 1 QC --------------------------------------------------------------
# I am checking the weighted age quartiles
svyquantile(
  ~RIDAGEYR,
  table1_design,
  quantiles = c(0.25, 0.50, 0.75),
  ci = FALSE)

# I am checking the weighted race/ethnicity proportions
svymean(
  ~race_ethnicity,
  table1_design,
  na.rm = TRUE)

# I am checking the weighted pregnancy-group proportions
svymean(
  ~pregnancy_group,
  table1_design,
  na.rm = TRUE)

# VALID N FOR TABLE 1 -----------------------------------------------------
# I am checking the number of non-missing observations for each Table 1 variable
table1_design$variables %>%
  summarise(
    Age = sum(!is.na(RIDAGEYR)),
    Race_ethnicity = sum(!is.na(race_ethnicity)),
    Education = sum(!is.na(education)),
    Marital_status = sum(!is.na(marital_status)),
    Poverty_income_ratio = sum(!is.na(INDFMPIR)),
    PHQ9_score = sum(!is.na(phq9_total)),
    PHQ9_category = sum(!is.na(phq9_category)),
    Energy = sum(!is.na(DR1TKCAL)),
    Fiber = sum(!is.na(DR1TFIBE)),
    Protein = sum(!is.na(DR1TPROT)),
    BMI = sum(!is.na(BMXBMI)))