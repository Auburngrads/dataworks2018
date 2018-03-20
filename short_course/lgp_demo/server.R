server <- function(input, output, session) {
  
  rv <- reactiveValues(start = 0)

  observeEvent(input$reset,{rv[["start"]] <- 0})
  
  observeEvent(input$sample, {
    
    rv[["start"]] <- rv[["start"]] + 1
    rv[["X"]] <- rbind(rv[["X"]], rv[["Xnew"]])
    rv[["Z"]] <- c(rv[["Z"]], rv[["Znew"]])
    rv[["XX"]] <- matrix(rv[["XX"]][-rv[["m"]],], ncol=ncol(rv[["X"]]))
    
    updateGP(rv[["gpi"]], rv[["Xnew"]], rv[["Znew"]], verb = 1)
    
    rv[["outp"]] <- predGP(rv[["gpi"]], rv[["XX"]])  ## lite = TRUE is faster but can't use rmvt below
    rv[["tmat"]] <- data.frame(m=rv[["outp"]]$mean, sd=sqrt(diag(rv[["outp"]]$Sigma)), df=rv[["outp"]]$df)
    rv[["eis"]] <- calc.eis(rv[["tmat"]], min(rv[["Z"]]))
    
    ## calculate next point
    rv[["m"]] <- which.max(rv[["eis"]])
    rv[["Xnew"]] <- matrix(rv[["XX"]][rv[["m"]],], ncol=ncol(rv[["X"]]))
    rv[["Znew"]] <- sin(rv[["Xnew"]])
    
    rv[["sd"]] <- sqrt(diag(rv[["outp"]]$Sigma))
    
  }) 
    
  observe({
    
  if(rv[["start"]] == 0) {
    
  rv[["start"]] <- input$start  
  rv[["X"]] <- matrix(seq(0,2*pi,length=rv[["start"]]), ncol=1)
  rv[["Z"]] <- sin(rv[["X"]])
  
  ## deliberately small d=1 value to make for a better illustration
  rv[["gpi"]] <- newGP(rv[["X"]], rv[["Z"]], 1, 0.00001, dK=TRUE)
  ## add mleGP after updateGP below to speed convergenves
  
  ## testing prediction code
  rv[["XX"]] <- matrix(seq(-1,2*pi+1, length=499), ncol=ncol(rv[["X"]]))
  
  rv[["outp"]] <- predGP(rv[["gpi"]], rv[["XX"]])  ## lite = TRUE is faster but can't use rmvt below
  rv[["tmat"]] <- data.frame(m=rv[["outp"]]$mean, sd=sqrt(diag(rv[["outp"]]$Sigma)), df=rv[["outp"]]$df)
  rv[["eis"]] <- calc.eis(rv[["tmat"]], min(rv[["Z"]]))
  
  ## calculate next point
  rv[["m"]] <- which.max(rv[["eis"]])
  rv[["Xnew"]] <- matrix(rv[["XX"]][rv[["m"]],], ncol=ncol(rv[["X"]]))
  rv[["Znew"]] <- sin(rv[["Xnew"]])
  
  rv[["sd"]] <- sqrt(diag(rv[["outp"]]$Sigma))
  }
  })
  
 
  
  output$plotout <- renderPlot({
    
    par(mfrow=c(2,1), mar=c(4,4,0.5,1))
    N <- 100
    rv[["ZZ"]] <- rmvt(N, rv[["outp"]]$Sigma, rv[["outp"]]$df) + t(matrix(rep(rv[["outp"]]$mean, N), ncol=N))
    matplot(rv[["XX"]], t(rv[["ZZ"]]), col="gray", lwd=0.5, lty=1, type="l",
            ylab="Y", xlab="", ylim=c(-1.3,1.5))
    points(rv[["X"]], rv[["Z"]], pch=19, cex=1.5)
    lines(rv[["XX"]][,1], rv[["outp"]]$mean, lwd=2)
    # sd <- sqrt(diag(rv[["outp$Sigma"]]))
    lines(rv[["XX"]][,1], rv[["outp"]]$mean + qt(0.95, rv[["outp"]]$df)*rv[["sd"]], col=2, lty=2, lwd=2)
    lines(rv[["XX"]][,1], rv[["outp"]]$mean + qt(0.05, rv[["outp"]]$df)*rv[["sd"]], col=2, lty=2, lwd=2)
    points(rv[["Xnew"]], rv[["Znew"]], col=3, pch=18, cex=2)
    plot(rv[["XX"]], rv[["eis"]], type="l", ylab="EI", xlab="X", ylim=c(0,0.25), lwd=2, col="blue")
    
    
  })
  
  
}