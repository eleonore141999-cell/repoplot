#' Generate a simulated dataset for barplot examples
#'
#' @param n Integer number of rows to generate. Default 10000.
#' @param seed Integer seed for reproducible sampling. Default 42.
#' @return A data.frame with simulated clinical and medication variables.
#' @export
generate_simulated_data <- function(n = 10000, seed = 42) {
  if (!is.numeric(n) || length(n) != 1 || n <= 0) {
    stop("n must be a positive integer")
  }
  if (!is.numeric(seed) || length(seed) != 1) {
    stop("seed must be numeric")
  }

  set.seed(seed)

  dta <- data.frame(
    DBIRTH = as.Date(sample(seq(as.Date("1940/01/01"), as.Date("2000/01/01"), by = "day"), n, replace = TRUE)),
    SEX = sample(c(0, 1), n, replace = TRUE),
    MAL = sample(c(0, 1), n, replace = TRUE),
    DATD = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    AGED = round(runif(n, 18, 85)),
    SYCH = sample(c(0, 1), n, replace = TRUE),
    CHA = rep("L01DB", n),
    CHT = sample(1:6, n, replace = TRUE),
    CHDA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    CHH = sample(1001:1050, n, replace = TRUE),
    SUR = sample(c(0, 1), n, replace = TRUE),
    SURDA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    RAD = sample(c(0, 1), n, replace = TRUE),
    RADDA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    RADTA = sample(c(0, 1), n, replace = TRUE),
    RADTADA = as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2023/01/01"), by = "day"), n, replace = TRUE)),
    REC = sample(c(0, 1), n, replace = TRUE)
  )

  icd_codes <- c("I20", "I21", "I25", "I30", "I42", "I48", "I50", "I61", "I64")

  dta$MO <- sample(2015:2026, n, replace = TRUE)
  dta$MOCOM <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
  dta$MOICD <- sample(icd_codes, n, replace = TRUE)
  dta$MOCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.85, 0.15))

  dta$HOSICD <- sample(icd_codes, n, replace = TRUE)
  dta$HOSMAIND <- sample(c(0, 1), n, replace = TRUE)
  dta$HOSCVD <- sample(c(0, 1), n, replace = TRUE, prob = c(0.7, 0.3))
  dta$HOSDA <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))

  cardiac_atc <- c("C07", "C03", "C09", "C08", "C07E", "C02", "C10", "A10BK", "B01")
  med_probs <- c(0.20, 0.15, 0.20, 0.10, 0.05, 0.05, 0.15, 0.05, 0.05)

  dta$MED <- sample(cardiac_atc, n, replace = TRUE, prob = med_probs)
  dta$DMED <- as.Date(sample(seq(as.Date("2015/01/01"), as.Date("2026/01/01"), by = "day"), n, replace = TRUE))
  dta$STARTMED <- sample(c(0, 1, 2), n, replace = TRUE)

  dta
}
