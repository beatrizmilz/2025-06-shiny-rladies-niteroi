**Prompt para criação de Shiny App em R:**

## Objetivo

Quero criar um aplicativo interativo usando Shiny em R. O objetivo principal do app é [descreva o objetivo principal do app, ex: visualizar dados de vendas, explorar dados demográficos,  etc.].


## Dados
Os dados que serão utilizados são:

[descreva os dados, ex: um arquivo CSV com dados de vendas, uma base de dados SQL, etc.]

Eles podem ser importados com o seguinte caminho:
[...]

Esse é o resultado do `glimpse()` dos dados (copie e cole a saída aqui para melhor geração do código):
[...]




## Funcionalidades

Os dados devem ser filtrados e salvos em um objeto reativo, para que possam ser utilizados em diferentes partes do aplicativo (gráficos, tabelas, etc.). Esses filtros devem operar sobre os dados carregados inicialmente.


O aplicativo deve ter as seguintes funcionalidades:

> * Filtros para: [ex: selecionar intervalo de datas, categorias específicas, regiões, etc.]
> * Visualização dos dados em [ex: tabela interativa, gráficos, mapas, etc.]
> * Outputs adicionais como [ex: resumo estatístico, download de resultados, etc.]

Os filtros do tipo seleção de opções devem ter a opção de *select all/deselect all*, e campo de busca. 

## Estrutura do App

A estrutura pode ter uma sidebar com os inputs e um painel principal com os outputs. 

Muito importante: O app **deve utilizar  explificamente a biblioteca `bslib` para o layout** e ser responsivo. 
O `bslib` deve usar o tema ["minty"](https://rstudio.github.io/bslib/articles/theming/)


## Sobre o desenvolvimento

O aplicativo deve ser criado em um único arquivo `app.R`.

Por favor, escreva o código em R para este aplicativo utilizando o pacote `shiny`, adicionando comentários explicativos e seguindo as melhores práticas de desenvolvimento.

Utilize esses pacotes, de preferência:
- shinyWidgets: para botões e inputs personalizados
- reactable: para tabelas interativas
- leaflet: para mapas interativos
- ggplot2 + plotly: para visualização de dados
- tidyverse: para manipulação de dados. Obs: use o pipe nativo do R (`|>`)
