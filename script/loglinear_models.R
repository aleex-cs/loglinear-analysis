# Load data
ccaa_sex_bmi <- read.csv("data/CCAA_SEX_BMI.csv", sep=";")
age_sex_bmi  <- read.csv("data/AGE_SEX_BMI.csv", sep=";")

# Function to fit multiple loglinear models for a given contingency table
fit_loglinear_models <- function(df){
  
  # Convert categorical variables to factors
  sex <- as.factor(df$SEXO)
  bmi <- as.factor(df$IMC)
  counts <- df$n
  
  # Fit different loglinear models
  model_null        <- glm(counts ~ 1, family = poisson)            # Null model
  model_saturated   <- glm(counts ~ sex * bmi, family = poisson)    # Saturated model
  model_no_assoc    <- glm(counts ~ sex + bmi, family = poisson)    # No association
  model_uniform     <- glm(counts ~ sex + bmi + as.numeric(sex)*as.numeric(bmi), family = poisson)
  
  # Symmetry models
  sym_interaction <- as.factor(as.numeric(sex) * as.numeric(bmi))
  model_sym        <- glm(counts ~ sym_interaction, family = poisson)
  model_quasi_sym  <- glm(counts ~ sex + bmi + sym_interaction, family = poisson)
  
  # Additional variants
  extra_factor <- factor(c(1,0,0,2))  # Example for special coding
  model_extra1 <- glm(counts ~ sex + bmi + extra_factor, family = poisson)
  
  xf2 <- rep(0,4); xf2[3:4] <- c(1:2)
  model_extra2 <- glm(counts ~ sex + bmi + xf2, family = poisson)
  xc2 <- as.vector(t(matrix(xf2,2,2)))
  model_extra3 <- glm(counts ~ sex + bmi + xc2, family = poisson)
  
  # Collect models
  models <- list(model_null, model_saturated, model_no_assoc, model_uniform,
                 model_sym, model_quasi_sym, model_extra1, model_extra2, model_extra3)
  
  # Calculate p-values and AIC for model comparison
  p_values <- sapply(models, function(m) 1 - pchisq(m$deviance, m$df.residual))
  aic_values <- AIC(model_null, model_saturated, model_no_assoc, model_uniform,
                    model_sym, model_quasi_sym, model_extra1, model_extra2, model_extra3)$AIC
  
  model_summary <- data.frame(
    Model = c("Null", "Saturated", "No Association", "Uniform", "Symmetry", 
              "Quasi-Symmetry", "Extra1", "Extra2", "Extra3"),
    P_Value = round(p_values, 6),
    AIC = aic_values
  )
  
  # Select best model by minimum AIC
  best_model <- models[[which.min(aic_values)]]
  
  # Test of marginal homogeneity: Symmetry vs Quasi-Symmetry
  dev_sym <- deviance(model_sym); df_sym <- df.residual(model_sym)
  dev_qs  <- deviance(model_quasi_sym); df_qs <- df.residual(model_quasi_sym)
  dev_diff <- dev_sym - dev_qs
  df_diff  <- df_sym - df_qs
  pval_homogeneity <- 1 - pchisq(dev_diff, df_diff)
  
  homogeneity_test <- data.frame(dev_sym, df_sym, dev_qs, df_qs, dev_diff, df_diff, pval_homogeneity)
  
  return(list("Model_Summary" = model_summary, 
              "Best_Model" = summary(best_model),
              "Homogeneity_Test" = homogeneity_test))
}

# Apply function by CCAA
results_ccaa <- list()
for (i in unique(ccaa_sex_bmi$CCAA)) {
  tab <- ccaa_sex_bmi[ccaa_sex_bmi$CCAA == i, ]
  results_ccaa[[i]] <- fit_loglinear_models(tab)
}

# Mantel-Haenszel test for conditional independence of SEX and BMI given CCAA
ccaa_xtab <- xtabs(n ~ IMC + SEXO + CCAA, data = ccaa_sex_bmi)
mantelhaen.test(ccaa_xtab)

# Apply function by Age group
results_age <- list()
for (i in unique(age_sex_bmi$EDAD)) {
  tab <- age_sex_bmi[age_sex_bmi$EDAD == i, ]
  results_age[[i]] <- fit_loglinear_models(tab)
}

# Mantel-Haenszel test for conditional independence of SEX and BMI given Age
age_xtab <- xtabs(n ~ IMC + SEXO + EDAD, data = age_sex_bmi)
mantelhaen.test(age_xtab)
