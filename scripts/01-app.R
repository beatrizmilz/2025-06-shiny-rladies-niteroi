library(shiny)

# interface do usuário
# controla o que veremos na página da internet!
ui <- fluidPage(
  h1("Olá, mundo!")
)

# o que será executado no servidor
server <- function(input, output, session) {
  
}

# executa o app
shinyApp(ui, server)