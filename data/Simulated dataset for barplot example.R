source("R/setup_logging.R")
source("R/generate_simulated_data.R")

init_logging(log_level = "INFO", log_dir = "output", verbose = TRUE)

# Log script start
exec_info <- log_script_start("Simulated dataset for barplot example")

tryCatch({
  log_info("Generating simulated dataset")
  dta <- generate_simulated_data(n = 10000, seed = 42)
  log_info("Generated simulated dataset: {nrow(dta)} rows, {ncol(dta)} columns")
  log_success("Simulated dataset created successfully")
}, error = function(e) {
  log_error("Error generating dataset: {e$message}")
  stop(e)
})

# Log script end
log_script_end(exec_info)
