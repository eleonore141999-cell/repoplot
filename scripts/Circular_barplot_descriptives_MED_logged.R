# Descriptive statistics barplot for medication frequencies

# Setup logging
source("R/setup_logging.R")
init_logging(log_level = "INFO", log_dir = "output", verbose = TRUE)

# Log script start
exec_info <- log_script_start("Circular barplot descriptives MED")

tryCatch({
  
  log_info("Loading data from simulated dataset")
load(file.path("output", "simulated_data.RData"))
  log_info("Data loaded successfully: {nrow(dta)} rows, {ncol(dta)} columns")
  
  log_info("Loading required libraries")
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(tidyverse)
  log_debug("Libraries loaded: dplyr, ggplot2, stringr, tidyverse")
  
  log_info("Computing medication frequencies")
  med_count <- with(dta, table(MED))
  print(med_count)
  log_debug("Medication counts computed")
  
  med_prop <- prop.table(med_count)
  med_pct <- med_prop * 100
  print(med_pct)
  log_debug("Medication proportions and percentages computed")
  
  log_info("Preparing medication summary data")
  plot_med <- dta %>%
    group_by(MED) %>%
    summarise(
      count = n(),
      pct_total_pt = (n() / nrow(dta)) * 100
    ) %>%
    ungroup()
  
  plot_med_clean <- plot_med %>%
    mutate(MED = as.character(MED))
  
  # View the result
  print(plot_med)
  log_info("Medication summary prepared: {nrow(plot_med)} unique medication types")
  
  log_info("Creating circular barplot visualization")
  # Basic radar chart
  plot_final <- ggplot(plot_med, aes(x = factor(MED), y = count)) +
    labs(
      title = "Frequency of MED types",
      x = "Type of medication",
      y = "Count"
    ) +
    theme_minimal() +
    # Make custom panel grid, since coord_polar() doesn't work with the default grid
    geom_hline(
      aes(yintercept = y),
      data.frame(y = c(0, 500, 1000, 1500, 2000, 2500)),
      color = "lightgrey"
    ) +
    # Add bars to represent the amount of patients in each med group
    # str_wrap(region, 5) wraps the text so each line has at most 5 characters
    # (but it doesn't break long words!)
    geom_col(
      aes(
        x = reorder(str_wrap(factor(MED), 5), count),
        y = count,
        fill = count
      ),
      position = "dodge2",
      show.legend = TRUE,
      alpha = .9
    ) +
    # Add percentages next to each bar
    geom_text(
      aes(
        x = reorder(str_wrap(as.character(MED), 9), count),
        y = count - 200,
        label = paste0(round(med_pct, 1), "%")
      ),
      size = 3,
      color = "black"
    ) +
    ylim(0, 2500) +
    
    # Make it circular!
    coord_polar()
  
  log_debug("Base plot created")
  
  plot_final2 <- plot_final +
    # Scale y axis so bars don't start in the center
    scale_y_continuous(
      limits = c(-1000, 2500),
      expand = c(0, 0),
      breaks = c(0, 500, 1000, 1500, 2000, 2500),
      position = "left"
    ) +
    # New fill and legend title for number of tracks per region.
    # To use category counts instead of 0,1000 this is the code: min(plot_med$count), max(plot_med$count)
    scale_fill_gradientn(
      "Amount of Patients",
      colours = c("#6C5B7B", "#C06C84", "#F67280", "#F8B195"),
      limits = c(0, 2500)
    ) +
    # Make the guide for the fill discrete
    guides(
      fill = guide_colorsteps(
        barwidth = 2, barheight = 5, title.position = "top", title.hjust = .5
      )
    )
  
  log_debug("Plot scaling and fill applied")
  
  plot_final3 <- plot_final2 +
    
    # Add labels
    labs(
      title = "Cardiovascular medication use",
      subtitle = paste(
        "\nCount and percentages of patients using that medication class"
      ),
      caption = "By Eleonore Logie \n Dataset simulated for demonstration purposes"
    ) +
    # Customize general theme
    theme(
      # Set default color and font family for the text
      text = element_text(color = "gray12", family = "sans"),
      
      # Customize the text in the title, subtitle, and caption
      plot.title = element_text(face = "bold", size = 25, hjust = 0.05),
      plot.subtitle = element_text(size = 12, hjust = 0.05),
      plot.caption = element_text(size = 10, hjust = .5),
      
      # Make the background white and remove extra grid lines
      panel.background = element_rect(fill = "white", color = "white"),
      panel.grid = element_blank(),
      panel.grid.major.x = element_blank()
    )
  
  log_info("Finalizing visualization with theme and labels")
  
  # Display the plot
  log_info("Displaying final plot")
  print(plot_final3)
  
  # Save the plot
  log_info("Saving plot to output/medication_circular_barplot.png")
  ggsave(file.path("output", "final_plot.png"), plot_final3, width = 9, height = 12.6)
  log_success("Circular barplot created and saved successfully!")
  
}, error = function(e) {
  log_error("Error during visualization: {e$message}")
  log_error("Traceback: {paste(utils::head(traceback(), -1), collapse = '\n')}")
  stop(e)
})

# Log script end
log_script_end(exec_info)
