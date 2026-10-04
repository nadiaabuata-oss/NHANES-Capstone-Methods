# NHANES Capstone Methods Review

This repository contains the preliminary NHANES analysis used to generate Table 1 for my MPH capstone.

## Purpose

I am using NHANES 200-2006 through 2017-2018 to examine dietary factors and depressive symptoms among women ages 20–44.

I prepared this repository for methodological review of my NHANES survey-weighting approach.

## Questions for review

1. Am I using the appropriate survey weight (`WTDRD1`) given that the current analysis requires a reliable Day 1 dietary recall?
2. Am I correctly pooling seven 2-year NHANES cycles by dividing `WTDRD1` by 7?
3. Am I correctly defining the survey-design base before restricting to my analytic population?
4. Am I correctly specifying strata (`SDMVSTRA`) and PSU (`SDMVPSU`) in `svydesign()`?
5. Am I correctly defining and subsetting the analytic population within the survey design?

## Analytic population

The preliminary analytic population includes women ages 20–44 with:

- a reliable Day 1 dietary recall
- complete PHQ-9 data
- known current pregnancy status

The current unweighted analytic sample is **N = 6,954**, including:

- **617 pregnant participants**
- **6,337 non-pregnant participants**

## Repository contents

- `NHANES_table1_weights_question.R` - R code used to construct the survey design and generate the preliminary survey-weighted Table 1
- `Data/` - NHANES data files used during preliminary analyses

The NHANES data used in this repository are publicly available from the National Center for Health Statistics.
