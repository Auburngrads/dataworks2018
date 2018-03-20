ui = fluidPage(theme = shinythemes::shinytheme('flatly'),
               
sidebarLayout(
 sidebarPanel(width = 4,
              sliderInput('start', 
                          label = 'Start Values',
                          min = 6,
                          max = 10,
                          value = 6),
              hr(),
              actionButton('sample','Add Sample', width = '100%')),
 
 mainPanel(plotOutput('plotout', height = '650px'), width = 8)))
