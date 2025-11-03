#' COVID-19 Quarantine Breach Dataset
#'
#' Simulated outcomes of quarantine breach events under different scenarios of
#' basic reproductive ratio (R0) and vaccine efficacy (VE). Used to explore how
#' the relative force of infection changes with R0 and VE.
#'
#' @format A data frame with 100 rows and 3 columns:
#' \describe{
#'   \item{R0}{integer, basic reproductive ratio: the average number of secondary infections produced by an infected person in a completely susceptible population.}
#'   \item{VE}{numeric, vaccine efficacy, representing reduction in susceptibility to infection.}
#'   \item{Value}{numeric, relative force of infection produced by quarantine breaches.}
#' }
#'
#' @source
#' Zachreson, C., Shearer, F. M., Price, D. J., Lydeamore, M. J., McVernon, J., McCaw, J., & Geard, N. (2022).
#' COVID‑19 in low-tolerance border quarantine systems: Impact of the Delta variant of SARS‑CoV‑2.
#' *Science Advances, 8*(14), eabm3624. https://doi.org/10.1126/sciadv.abm3624
"covid19"
