ui = fluidPage(theme = shinythemes::shinytheme('flatly'),
               
sidebarLayout(
 sidebarPanel(width = 4,
              sliderInput('start', 
                          label = h2('Number of Initial Observations'),
                          min = 6,
                          max = 16,
                          value = 6),
              hr(),
              actionButton('sample',h2('Add Sample'), width = '100%'),
              hr(),
              actionButton('reset',h2('Reset Simulation'), width = '100%')),
 
 mainPanel(plotOutput('plotout', height = '800px'), width = 8)))
