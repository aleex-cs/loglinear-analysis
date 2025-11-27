# loglinear_analysis

This repository contains the analysis of three-way contingency tables from the Spanish National Health Survey 2017 (ENSE 2017) using loglinear models. The goal is to study the relationships between BMI, Sex, and Age or Autonomous Community (CCAA).

## Project Structure

loglinear_analysis/

│

├─ README.md                   # Project description

├─ data/

│   ├─ CCAA_SEX_BMI.csv        # Contingency table: CCAA x SEX x BMI

│   └─ AGE_SEX_BMI.csv         # Contingency table: AGE x SEX x BMI

├─ scripts/

│   └─ loglinear_models.R      # Main R script for analysis

├─ results/

│   ├─ models_by_ccaa/         # Loglinear model results by CCAA

│   └─ models_by_age/          # Loglinear model results by Age group

└─ LICENSE                     # License file

## Data Description

- CCAA_SEX_BMI.csv: Counts of individuals by Autonomous Community (CCAA), Sex, and BMI category.
- AGE_SEX_BMI.csv: Counts of individuals by Age group, Sex, and BMI category.

All data comes from the Encuesta Nacional de Salud 2017 (Spanish National Health Survey 2017).

## Analysis Goals

1. Study the association between BMI and Sex conditional on Autonomous Community (CCAA)
    - Fit multiple loglinear models (Null, Saturated, No Association, Uniform, Symmetry, Quasi-Symmetry, and others).
    - Compare models using AIC and deviance p-values.
    - Test marginal homogeneity between Symmetry and Quasi-Symmetry models.
    - Confirm findings using Cochran-Mantel-Haenszel (CMH) test.

2. Study the association between BMI and Sex conditional on Age group
    - Same modeling and testing procedure as above.
    - CMH test to confirm conditional independence.

## Usage Instructions

1. Clone this repository:
```
git clone https://github.com/yourusername/loglinear_analysis.git
cd loglinear_analysis
```
2. Place the data files inside the data/ folder.
3. Open R or RStudio and run the main script:
```
source("scripts/loglinear_models.R")
```
4. The script will:
  - Fit all loglinear models by CCAA and Age.
  - Save results in the results/ folder (you can customize output saving).
  - Perform CMH tests for conditional independence.

## Results

- results_ccaa contains loglinear model summaries and best model selection by CCAA.
- results_age contains loglinear model summaries and best model selection by Age group.
- CMH tests confirm whether Sex and BMI are independent conditional on CCAA or Age.

## License

This project is licensed under the MIT License. See LICENSE file for details.



















