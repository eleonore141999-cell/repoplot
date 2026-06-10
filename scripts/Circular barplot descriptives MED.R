source("R/setup_logging.R")
source("R/generate_simulated_data.R")
source("R/create_medication_plot.R")

init_logging(log_level = "INFO", log_dir = "output", verbose = TRUE)

# Log script start
exec_info <- log_script_start("Circular barplot descriptives MED")

tryCatch({
  log_info("Generating simulated dataset")
  dta <- generate_simulated_data(n = 10000, seed = 42)
  log_info("Dataset generated: {nrow(dta)} rows, {ncol(dta)} columns")

  log_info("Building circular medication plot")
  plot_final3 <- create_medication_plot(dta)
  log_info("Plot object created successfully")

  log_info("Saving plot to output/medication_circular_barplot.png")
  ggplot2::ggsave("output/medication_circular_barplot.png", plot_final3, width = 9, height = 12.6)
  log_success("Circular barplot created and saved successfully!")

}, error = function(e) {
  log_error("Error during visualization: {e$message}")
  stop(e)
})

# Log script end
log_script_end(exec_info)
