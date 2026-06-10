#' Create a medication frequency circular barplot
#'
#' @param dta A data.frame containing at least the MED column.
#' @return A ggplot object representing the circular medication barplot.
#' @export
create_medication_plot <- function(dta) {
  if (!is.data.frame(dta)) {
    stop("dta must be a data.frame")
  }
  if (!"MED" %in% names(dta)) {
    stop("dta must contain a MED column")
  }

  plot_med <- dplyr::group_by(dta, MED)
  plot_med <- dplyr::summarise(
    plot_med,
    count = dplyr::n(),
    pct_total_pt = (dplyr::n() / nrow(dta)) * 100,
    .groups = "drop"
  )
  plot_med <- dplyr::mutate(
    plot_med,
    MED = as.character(MED),
    med_pct = (count / sum(count)) * 100
  )

  ggplot2::ggplot(plot_med, ggplot2::aes(x = factor(MED), y = count)) +
    ggplot2::labs(
      title = "Frequency of MED types",
      x = "Type of medication",
      y = "Count"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::geom_hline(
      ggplot2::aes(yintercept = y),
      data = data.frame(y = c(0, 500, 1000, 1500, 2000, 2500)),
      color = "lightgrey"
    ) +
    ggplot2::geom_col(
      ggplot2::aes(
        x = reorder(stringr::str_wrap(factor(MED), 5), count),
        y = count,
        fill = count
      ),
      position = "dodge2",
      show.legend = TRUE,
      alpha = 0.9
    ) +
    ggplot2::geom_text(
      ggplot2::aes(
        x = reorder(stringr::str_wrap(as.character(MED), 9), count),
        y = count - 200,
        label = paste0(round(med_pct, 1), "%")
      ),
      size = 3,
      color = "black"
    ) +
    ggplot2::ylim(0, 2500) +
    ggplot2::coord_polar() +
    ggplot2::scale_y_continuous(
      limits = c(-1000, 2500),
      expand = c(0, 0),
      breaks = c(0, 500, 1000, 1500, 2000, 2500),
      position = "left"
    ) +
    ggplot2::scale_fill_gradientn(
      "Amount of Patients",
      colours = c("#6C5B7B", "#C06C84", "#F67280", "#F8B195"),
      limits = c(0, 2500)
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_colorsteps(
        barwidth = 2,
        barheight = 5,
        title.position = "top",
        title.hjust = 0.5
      )
    ) +
    ggplot2::labs(
      title = "Cardiovascular medication use",
      subtitle = "\nCount and percentages of patients using that medication class",
      caption = "By Eleonore Logie \n Dataset simulated by Gemini AI"
    ) +
    ggplot2::theme(
      text = ggplot2::element_text(color = "gray12", family = "sans"),
      plot.title = ggplot2::element_text(face = "bold", size = 25, hjust = 0.05),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.05),
      plot.caption = ggplot2::element_text(size = 10, hjust = 0.5),
      panel.background = ggplot2::element_rect(fill = "white", color = "white"),
      panel.grid = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank()
    )
}
