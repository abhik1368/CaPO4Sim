#' @title CaPO4 user info UI module
#'
#' @description Create a CaPO4 user info card
#'
#' @param id module id.
#'
#' @export
userInfoUi <- function(id) {

  ns <- NS(id)

  tagAppendAttributes(
    shinydashboardPlus::userOutput(ns("user")),
    style = "margin-left: 100px; border:none;"
  )
}




#' @title CaPO4 user info server module
#'
#' @description Create a CaPO4 user info card
#'
#' @param input Shiny inputs
#' @param output Shiny Outputs
#' @param session Session object.
#' @param diseases Shiny input disease selector. See \link{diseaseSelect}.
#' @param sliderDisease Shiny input disease severity selector. See \link{plotBox}.
#' @param help Help input.
#'
#' @export
userInfo <- function(input, output, session, diseases, sliderDisease, help) {

  # generate a patient profile
  output$user <- shinydashboardPlus::renderUser({

    ns <- session$ns

    req(!is.null(diseases$php1()) | !is.null(diseases$hypopara()) | !is.null(diseases$hypoD3()))

    shinydashboardPlus::dashboardUser(
      name = "Rat State",
      src = if (diseases$php1() | diseases$hypopara() | diseases$hypoD3()) {
        generate_userFields(diseases, sliderDisease)$image
      } else {
        "images_patient_info/happy.png"
      },
      title = if (diseases$php1() | diseases$hypopara() | diseases$hypoD3()) {
        generate_userFields(diseases, sliderDisease)$description
      } else {
        "healthy"
      },
      subtitle = if (diseases$php1()) {
        "Rat has primary-hyperparathyroidism"
      } else if (diseases$hypopara()) {
        "Rat suffers from hypoparathyroidism"
      } else if (diseases$hypoD3()) {
        "Rat has vitamin D3 defficiency"
      } else {
        "nothing to declare!"
      },
      if (diseases$php1() | diseases$hypopara() | diseases$hypoD3()) {
        shinydashboardPlus::dashboardUserItem(width = 6, generate_userFields(diseases, sliderDisease)$stat1)
      } else {
        shinydashboardPlus::dashboardUserItem(
          width = 6,
          HTML(paste(withMathJax(p("$$[Ca^{2+}]_p$$ 1.21 mM")), "<br/>", "(1.1-1.4 mM)"))
        )
      },
      if (diseases$php1() | diseases$hypopara() | diseases$hypoD3()) {
        shinydashboardPlus::dashboardUserItem(width = 6, generate_userFields(diseases, sliderDisease)$stat2)
      } else {
        shinydashboardPlus::dashboardUserItem(
          width = 6,
          HTML(paste(withMathJax(p("$$[P_i]_p$$ 2.96 mM")), "<br/>", "(2.1-3.4 mM)"))
        )
      },
      if (diseases$php1() | diseases$hypopara() | diseases$hypoD3()) {
        shinydashboardPlus::dashboardUserItem(width = 12, generate_userFields(diseases, sliderDisease)$stat3)
      } else {
        shinydashboardPlus::dashboardUserItem(
          width = 12,
          HTML(paste(withMathJax(p("$$[PTH]_p$$ 6.87 pM")), "<br/>", "(3-16 pM)"))
        )
      },
      br()
    )
  })


  # Open the userInfo menu. Useless since rintrojs does not work with modules
  #observeEvent(help(), {
  #  shinyjs::toggleClass(
  #    id = "user",
  #    class = "user-menu open",
  #    condition = help()
  #  )
  #})

}
