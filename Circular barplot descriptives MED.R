# Descriptive statistics barchart from R graphgallery for medication frequencies

library(dplyr)
library(ggplot2)
library(stringr)
library(tidyverse)

med_count <- with(dta, table(MED))
print(med_count)
med_prop <- prop.table(med_count)
med_pct <- med_prop*100
print(med_pct)

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

#Basic radar chart
plot_final <- ggplot(plot_med, aes(x = factor(MED), y = count)) +
  labs(title = "Frequency of MED types",
       x = "Type of medication",
       y = "Count") +
  theme_minimal() +
  # Make custom panel grid
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
    # ADDED: Percentages next to each bar
    geom_text(
      aes(
        x = reorder(str_wrap(as.character(MED), 9), count),
        y = count-200, 
        label = paste0(round(med_pct, 1), "%")
      ),
      size = 3,
      color = "black"
    ) +
    ylim(0, 2500) +
  
  # Make it circular!
    coord_polar()

plot_final2 <- plot_final + 
  # Annotate custom scale inside plot if wanted
  #annotate(
   #x = 9, 
    #y = 250, 
    #label = "250", 
    #geom = "text", 
    #color = "gray12", 
    #family = "sans"
  #) +

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
    colours = c( "#6C5B7B","#C06C84","#F67280","#F8B195"), 
    limits = c(0,2500) 
  )  + 
  # Make the guide for the fill discrete
  guides(
    fill = guide_colorsteps(
      barwidth = 2, barheight = 5, title.position = "top", title.hjust = .5
  ))

plot_final3 <-plot_final2 +

  # Add labels
  labs(
    title = "Cardiovascular medication use",
    subtitle = paste(
      "\nCount and percentages of patients using that medication class"
    ),
    caption = "By Eleonore Logie \n Dataset simulated by Gemini AI") +
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
# Use `ggsave("plot.png", plt,width=9, height=12.6)` to save it as in the output
plot_final3



