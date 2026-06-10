# Logger Package Quick Reference Guide

## Installation & Setup

First, ensure the logger package is installed:

```r
install.packages("logger")
```

Then source the logging setup in your script:

```r
source("R/setup_logging.R")
init_logging(log_level = "INFO", verbose = TRUE)
```

## Basic Logging Functions

### 1. Initialize Logging
```r
init_logging(log_level = "INFO", log_dir = "output", verbose = TRUE)
```
- Creates log files in the output directory with timestamp
- Sets up both console and file logging
- `verbose = TRUE` prints logs to console

### 2. Script Execution Tracking
```r
# At the start of your script
exec_info <- log_script_start("My Script Name")

# ... your code here ...

# At the end of your script
log_script_end(exec_info)
```

### 3. Log Different Severity Levels

```r
log_debug("Detailed debugging information")
log_info("General information about program execution")
log_warn("Warning about something that might be problematic")
log_error("An error occurred but execution continues")
log_fatal("Critical error - execution should stop")
log_success("Operation completed successfully")
```

## Common Usage Patterns

### Pattern 1: Data Processing with Logging
```r
source("R/setup_logging.R")
init_logging(verbose = TRUE)
exec_info <- log_script_start("Data Processing")

tryCatch({
  log_info("Reading raw data")
  raw_data <- read.csv("data/raw.csv")
  log_info("Rows: {nrow(raw_data)}, Columns: {ncol(raw_data)}")
  
  log_info("Cleaning data")
  cleaned_data <- raw_data[complete.cases(raw_data), ]
  log_info("Removed {nrow(raw_data) - nrow(cleaned_data)} rows with missing values")
  
  log_success("Data processing complete!")
}, error = function(e) {
  log_error("Processing failed: {e$message}")
  stop(e)
})

log_script_end(exec_info)
```

### Pattern 2: Loop Processing
```r
log_info("Processing {length(items)} items")
for (i in seq_along(items)) {
  tryCatch({
    log_debug("Processing item {i}/{length(items)}")
    # Process item
  }, error = function(e) {
    log_warn("Item {i} failed: {e$message}")
  })
}
log_info("All items processed")
```

### Pattern 3: Function Logging
```r
my_analysis_function <- function(data, threshold = 0.05) {
  log_info("Starting analysis with threshold = {threshold}")
  
  # Validate input
  if (nrow(data) == 0) {
    log_error("Empty dataset provided")
    return(NULL)
  }
  log_debug("Dataset has {nrow(data)} rows")
  
  # Process
  result <- data[data$value > threshold, ]
  log_info("Found {nrow(result)} rows above threshold")
  
  return(result)
}
```

## Log File Location

Log files are automatically saved to: `output/project_log_YYYYMMDD_HHMMSS.log`

Each time you run `init_logging()`, a new log file is created with the current timestamp.

## Viewing Logs

You can view log files with:
```r
# In the console
file.show("output/project_log_20240115_143022.log")

# Or in a terminal
# tail -f output/project_log_*.log
```

## String Interpolation in Logs

The logger package uses glue-style string interpolation. Use `{}` to embed R expressions:

```r
n_rows <- nrow(my_data)
threshold <- 0.05
log_info("Processed {n_rows} rows with threshold {threshold}")
# Output: Processed 1000 rows with threshold 0.05
```

## Best Practices

1. **Always initialize at the top** of your main scripts
2. **Log key decision points** - what variables were used, what happened
3. **Use appropriate log levels** - don't log everything at INFO level
4. **Include context** - log not just "Error" but "Error reading file X: message"
5. **Use try-catch with logging** - log both successes and failures
6. **Save raw data counts** - log nrow/ncol after loading to track data quality
7. **Time-track long operations** - use log_script_start/end for performance monitoring

## Disable File Logging (Console Only)

If you only want console output without files:

```r
library(logger)
log_formatter(formatter_glue)
# No file appender = console only
```

## Change Log Level After Initialization

```r
# Set to see only warnings and errors
log_threshold("WARN")

# Set to debug everything
log_threshold("DEBUG")
```
