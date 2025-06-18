# app.R

# Carregando pacotes necessários
library(shiny)
library(shinyWidgets)
library(bslib)
library(tidyverse)
library(reactable)
library(leaflet)
library(plotly)

# Carregando os dados
dados_etec <- read_csv("https://raw.githubusercontent.com/beatrizmilz/etec/refs/heads/main/shinyapps/dados-etec.csv")

# UI
ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty"),
  
  titlePanel("Demanda dos Cursos da ETEC - SP"),
  
  sidebarLayout(
    sidebarPanel(
      pickerInput(
        inputId = "filtro_muni",
        label = "Município",
        choices = sort(unique(dados_etec$name_muni)),
        selected = unique(dados_etec$name_muni),
        options = list(`actions-box` = TRUE, `live-search` = TRUE),
        multiple = TRUE
      ),
      
      pickerInput(
        inputId = "filtro_unidade",
        label = "Unidade",
        choices = sort(unique(dados_etec$unidade_pad)),
        selected = unique(dados_etec$unidade_pad),
        options = list(`actions-box` = TRUE, `live-search` = TRUE),
        multiple = TRUE
      ),
      
      pickerInput(
        inputId = "filtro_curso",
        label = "Curso",
        choices = sort(unique(dados_etec$curso_resumido)),
        selected = unique(dados_etec$curso_resumido),
        options = list(`actions-box` = TRUE, `live-search` = TRUE),
        multiple = TRUE
      ),
      
      pickerInput(
        inputId = "filtro_periodo",
        label = "Período",
        choices = sort(unique(dados_etec$periodo)),
        selected = unique(dados_etec$periodo),
        options = list(`actions-box` = TRUE),
        multiple = TRUE
      ),
      
      prettyCheckbox(
        inputId = "filtro_ensino_medio",
        label = "Mostrar apenas cursos do Ensino Médio",
        value = FALSE,
        shape = "curve",
        outline = TRUE,
        status = "primary"
      ),
      
      downloadButton("baixar_dados", "Download CSV", class = "btn-primary mt-3")
    ),
    
    mainPanel(
      fluidRow(
        column(
          width = 4,
          uiOutput("valuebox_unidades")
        ),
        column(
          width = 4,
          uiOutput("valuebox_cursos")
        ),
        column(
          width = 4,
          uiOutput("valuebox_vagas")
        )
      ),
      
      tabsetPanel(
        tabPanel("Tabela", reactableOutput("tabela")),
        tabPanel("Mapa", leafletOutput("mapa", height = 500)),
        tabPanel("Gráfico", plotlyOutput("grafico"))
      )
    )
  )
)

# SERVER
server <- function(input, output, session) {
  
  # Dados reativos filtrados
  dados_filtrados <- reactive({
    dados_etec |>
      filter(
        name_muni %in% input$filtro_muni,
        unidade_pad %in% input$filtro_unidade,
        curso_resumido %in% input$filtro_curso,
        periodo %in% input$filtro_periodo
      ) |>
      filter(
        if (input$filtro_ensino_medio) str_starts(curso, "Ensino Médio com") else TRUE
      )
  })
  
  # Value Boxes
  output$valuebox_unidades <- renderUI({
    unidades <- dados_filtrados() |> distinct(unidade_pad) |> nrow()
    bs4Dash::valueBox(value = unidades, subtitle = "Unidades", icon = icon("school"))
  })
  
  output$valuebox_cursos <- renderUI({
    cursos <- dados_filtrados() |> distinct(curso_resumido) |> nrow()
    bs4Dash::valueBox(value = cursos, subtitle = "Cursos", icon = icon("book"))
  })
  
  output$valuebox_vagas <- renderUI({
    vagas <- sum(dados_filtrados()$vagas, na.rm = TRUE)
    bs4Dash::valueBox(value = vagas, subtitle = "Total de Vagas", icon = icon("users"))
  })
  
  # Tabela
  output$tabela <- renderReactable({
    reactable(dados_filtrados(), searchable = TRUE, pagination = TRUE)
  })
  
  # Mapa
  output$mapa <- renderLeaflet({
    dados_mapa <- dados_filtrados() |>
      group_by(unidade_pad, lat, lon) |>
      summarise(vagas = sum(vagas), .groups = "drop")
    
    leaflet(dados_mapa) |>
      addTiles() |>
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        popup = ~paste0("<strong>", unidade_pad, "</strong><br>Vagas: ", vagas),
        radius = ~sqrt(vagas), fillColor = "blue", fillOpacity = 0.7, color = "white"
      )
  })
  
  # Gráfico interativo
  output$grafico <- renderPlotly({
    dados_grafico <- dados_filtrados() |>
      group_by(curso_resumido) |>
      summarise(media_demanda = mean(demanda, na.rm = TRUE), .groups = "drop") |>
      slice_max(media_demanda, n = 10)
    
    p <- ggplot(dados_grafico, aes(x = reorder(curso_resumido, media_demanda), y = media_demanda)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(
        x = "Curso",
        y = "Média de Demanda",
        title = "Top 10 Cursos com Maior Demanda"
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Download dos dados filtrados
  output$baixar_dados <- downloadHandler(
    filename = function() {
      paste0("dados_etec_filtrados_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(dados_filtrados(), file)
    }
  )
}

# Executa o app
shinyApp(ui, server)
