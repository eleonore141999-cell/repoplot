library(logger)
# Source the logging setup
source("R/setup_logging.R")
# Initialize logging
init_logging(log_level = "INFO", log_dir = "output", verbose = TRUE)
# Log the start of the script
exec_info <- log_script_start("Simulated dataset for barplot example")

tryCatch({
  
  # Set seed for consistency
  log_info("Setting seed for reproducibility")
  set.seed(42)
  n <- 10000
  log_info("Sample size: {n}")
   
  # 1. Population Description Variables (Table 1)
  log_info("Generating population description variables")
  dta <- data.frame(
    DBIRTH  = as.Date(sample(seq(as.Date("1940/01/01"), as.Date("2000/01/01"), by = "day"), n, replace = TRUE)),
    SEX     = sample(c(0, 1), n, replace = TRUE),
    MAL     = sample(c(0, 1), n, replace = TRUE),
    DATD    = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    AGED    = round(runif(n, 18, 85)),
    SYCH    = sample(c(0, 1), n, replace = TRUE),
    CHA     = rep("L01DB", n),
    CHT     = sample(1:6, n, replace = TRUE),
    CHDA    = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    CHH     = sample(1001:1050, n, replace = TRUE),
    SUR     = sample(c(0, 1), n, replace = TRUE),
    SURDA   = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    RAD     = sample(c(0, 1), n, replace = TRUE),
    RADDA   = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    RADTA   = sample(c(0, 1), n, replace = TRUE),
    RADTADA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    REC     = sample(c(0, 1), n, replace = TRUE)
  )
  log_info("Population variables created successfully")
  
  # 2. Outcome Variables: Mortality (Table 2)
  log_info("Generating mortality outcome variables")
  dta$MO <- sample(2015:2026, n, replace = TRUE)
  dta$MOCOM <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
  
  # ICD-10 codes for CVD (Table 3)
  icd_codes <- c("I20", "I21", "I25", "I30", "I42", "I48", "I50", "I61", "I64")
  dta$MOICD <- sample(icd_codes, n, replace = TRUE)
  dta$MOCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.85, 0.15))
  log_info("Mortality variables created successfully")
  
  # 3. Outcome Variables: Hospitalization (Table 2)
  log_info("Generating hospitalization outcome variables")
  dta$HOSICD <- sample(icd_codes, n, replace = TRUE)
  dta$HOSMAIND <- sample(c(0, 1), n, replace = TRUE)
  dta$HOSCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.7, 0.3))
  dta$HOSDA <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
  log_info("Hospitalization variables created successfully")
  
  # 4. Determinant Variables (Table 4 & 5)
  log_info("Generating determinant variables")
  cardiac_atc <- c("C07", "C03", "C09", "C08", "C07E", "C02", "C10", "A10BK", "B01")
  med_probs <- c(0.20, 0.15, 0.20, 0.10, 0.05, 0.05, 0.15, 0.05, 0.05)
  dta$MED <- sample(cardiac_atc, n, replace = TRUE, prob = med_probs)
  log_info("Determinant variables created successfully")
  
  # Save the dataset
  log_info("Saving dataset to output/simulated_data.RData")
  save(dta, file = "output/simulated_data.RData")
  log_success("Dataset created and saved successfully!")
  
}, error = function(e) {
  log_error("Error during data generation: {e$message}")
  stop(e)
})
dir.create(c("output"), recursive = TRUE, showWarnings = FALSE)
# Log the end of the script
log_script_end(exec_info)
