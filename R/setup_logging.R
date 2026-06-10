# Setup logging configuration for the project
# This file initializes the logger package with project-wide settings

# Load the logger package
library(logger)

#' Initialize Project Logging
#'
#' Sets up logger with custom formatters and output paths.
#' Creates a log file in the output/ directory with timestamp.
#'
#' @param log_level Character. Default log level (DEBUG, INFO, WARN, ERROR, FATAL).
#' @param log_dir Character. Directory to store log files. Defaults to 'output/'.
#' @param verbose Logical. If TRUE, logs are also printed to console.
#'
#' @return Invisible NULL. Logging is configured as a side effect.
#'
#' @examples
#' \dontrun{
#'   init_logging(log_level = "INFO", verbose = TRUE)
#'   log_info("Project initialized successfully")
#' }
#'
#' @export
init_logging <- function(log_level = "INFO", 
                          log_dir = "output", 
                          verbose = TRUE) {
  
  # Create output directory if it doesn't exist
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  # Create timestamp for log file
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  log_file <- file.path(log_dir, paste0("project_log_", timestamp, ".log"))
  
  # Set up console layout (if verbose)
  if (verbose) {
    log_formatter(formatter_glue)
  }
  
  # Add file appender for persistent logging
  log_appender(appender_file(log_file))
  
  # Set the default log level
  log_threshold(get(paste0("DEBUG"), mode = "numeric"))
  
  # Log initialization message
  log_info("Logging initialized at {Sys.time()}")
  log_info("Log file: {log_file}")
  log_info("Log level: {log_level}")
  
  invisible(NULL)
}

#' Log Script Execution Start
#'
#' Logs the start of a script with timing information.
#'
#' @param script_name Character. Name of the script being executed.
#'
#' @return Invisible list with execution start time.
#'
#' @export
log_script_start <- function(script_name) {
  log_info("========================================")
  log_info("Starting script: {script_name}")
  log_info("Start time: {Sys.time()}")
  log_info("User: {Sys.info()['user']}")
  log_info("Working directory: {getwd()}")
  log_info("========================================")
  
  invisible(list(start_time = Sys.time(), script_name = script_name))
}

#' Log Script Execution End
#'
#' Logs the completion of a script with execution time.
#'
#' @param script_start List returned from log_script_start().
#'
#' @return Invisible NULL.
#'
#' @export
log_script_end <- function(script_start) {
  elapsed_time <- difftime(Sys.time(), script_start$start_time, units = "secs")
  
  log_info("========================================")
  log_info("Completed script: {script_start$script_name}")
  log_info("End time: {Sys.time()}")
  log_info("Execution time: {round(as.numeric(elapsed_time), 2)} seconds")
  log_info("========================================")
  
  invisible(NULL)
}
