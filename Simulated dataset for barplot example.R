# Set seed for consistency
set.seed(42)
n <- 10000

# 1. Population Description Variables (Table 1)
dta <- data.frame(
  DBIRTH  = as.Date(sample(seq(as.Date("1940/01/01"), as.Date("2000/01/01"), by = "day"), n, replace = TRUE)),
  SEX     = sample(c(0, 1), n, replace = TRUE),
  MAL     = sample(c(0, 1), n, replace = TRUE),
  DATD    = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
  AGED    = round(runif(n, 18, 85)), # Ensuring Age >= 18 as per exclusion criteria
  SYCH    = sample(c(0, 1), n, replace = TRUE),
  CHA     = rep("L01DB", n), # ATC code for anthracyclines
  CHT     = sample(1:6, n, replace = TRUE),
  CHDA    = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
  CHH     = sample(1001:1050, n, replace = TRUE), # Simulated hospital IDs
  SUR     = sample(c(0, 1), n, replace = TRUE),
  SURDA   = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
  RAD     = sample(c(0, 1), n, replace = TRUE),
  RADDA   = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
  RADTA   = sample(c(0, 1), n, replace = TRUE),
  RADTADA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
  REC     = sample(c(0, 1), n, replace = TRUE)
)

# 2. Outcome Variables: Mortality (Table 2)
dta$MO <- sample(2015:2026, n, replace = TRUE)
dta$MOCOM <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
# ICD-10 codes for CVD (Table 3)
icd_codes <- c("I20", "I21", "I25", "I30", "I42", "I48", "I50", "I61", "I64")
dta$MOICD <- sample(icd_codes, n, replace = TRUE)
dta$MOCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.85, 0.15))

# 3. Outcome Variables: Hospitalization (Table 2)
dta$HOSICD <- sample(icd_codes, n, replace = TRUE)
dta$HOSMAIND <- sample(c(0, 1), n, replace = TRUE)
dta$HOSCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.7, 0.3))
dta$HOSDA <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))

# 4. Determinant Variables (Table 4 & 5)
# ATC codes for cardiac medication: C07 (BB), C03 (DIU), C09 (ACE/ARB), C08 (CA),
# C07E (BBV), C02 (CAG), C10 (STAT), A10BK (SGLT2), B01 (ACO)
# 4. Determinant Variables (Table 4 & 5)
cardiac_atc <- c("C07", "C03", "C09", "C08", "C07E", "C02", "C10", "A10BK", "B01")

# Define specific probabilities for each class (must sum to 1)
# Here, C07 (BB) and C09 (ACE/ARB) are set as more common
med_probs <- c(0.20, 0.15, 0.20, 0.10, 0.05, 0.05, 0.15, 0.05, 0.05)

dta$MED <- sample(cardiac_atc, n, replace = TRUE, prob = med_probs)
dta$DMED <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
dta$STARTMED <- sample(c(0, 1, 2), n, replace = TRUE)

# Preview the data
head(dta)
