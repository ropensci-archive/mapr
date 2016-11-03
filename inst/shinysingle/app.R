library(shiny)
library(leaflet)
library(RColorBrewer)

quakes <- readr::read_csv("dat.csv")

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    top = 10, right = 10,
    sliderInput("range", "Dates", min(quakes$date), max(quakes$date),
                value = range(quakes$date), step = 0.1
    ),
    selectInput("colors", "Color Scheme",
                rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
    ),
    checkboxInput("legend", "Show legend", TRUE)
  )
)

server <- function(input, output, session) {

  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    quakes[quakes$date >= input$range[1] & quakes$date <= input$range[2],]
  })

  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, quakes$date)
  })

  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(quakes) %>% addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })

  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    pal <- colorpal()

    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(
        radius = 3, weight = 3, color = "#777777",
        fillOpacity = 0.7,
        popup = ~ sprintf("<p><strong>Taxon:</strong> <i>%s</i><br><strong>Date:</strong> %s</p>", name, date)
      )
  })

  # Use a separate observer to recreate the legend as needed.
  # observe({
  #   proxy <- leafletProxy("map", data = quakes)
  #
  #   # Remove any existing legend, and only if the legend is
  #   # enabled, create a new one.
  #   proxy %>% clearControls()
  #   if (input$legend) {
  #     pal <- colorpal()
  #     proxy %>% addLegend(position = "bottomright",
  #                         pal = pal, values = ~date
  #     )
  #   }
  # })
}

shinyApp(ui, server)
