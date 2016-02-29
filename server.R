library(shiny)

# Load return data:
# Total US market returns:
VTSMX <- c(16.70,-18.24,-27.32,38.46,26.48,-4.36,7.32,22.79,32.47,-3.86,20.59,21.79,4.32,31.98,15.90,1.53,17.80,28.68,-6.16,34.47,9.61,10.43,-0.17,35.79,20.96,30.99,23.26,23.81,-10.57,-10.97,-20.96,31.35,12.52,5.98,15.51,5.49,-37.04,28.70,17.09,0.96,16.25,33.35,12.43,0.29)
VTSMX <- .01*VTSMX
# Total international stock market returns:
VGTSX <- c(38.08,-14.92,-23.68,36.42,2.99,22.71,35.45,4.24,22.96,-0.38,-1.15,25.52,8.02,56.98,68.45,26.54,30.08,18.67,-21.48,19.35,-8.52,38.88,5.56,9.70,7.58,-0.99,15.60,29.92,-15.61,-20.15,-15.08,40.34,20.84,15.57,26.64,15.52,-44.10,36.73,11.12,-14.56,18.14,15.04,-4.24,-4.37)
VGTSX <- .01*VGTSX
# 5 Yr T-Bill returns:
VFITX <- c(3.07,3.74,4.84,7.00,10.77,2.84,2.09,2.57,3.31,5.47,33.05,5.61,13.01,20.35,18.02,0.84,5.42,12.89,9.42,13.97,7.56,11.43,-4.33,20.44,1.92,8.96,10.61,-3.52,14.03,7.55,14.15,2.37,3.40,2.32,3.14,9.98,13.32,-1.69,7.35,9.80,2.67,-3.09,4.32,1.50)
VFITX <- .01*VFITX
# REIT returns:
VGSIX <- c(7.72,-15.72,-21.60,18.99,47.22,22.08,10.01,35.55,24.08,5.73,21.28,30.26,20.59,18.79,18.89,-3.85,13.21,8.52,-15.62,35.35,14.30,19.39,2.93,15.00,34.95,18.46,-16.32,-4.04,26.35,12.35,3.75,35.65,30.76,11.89,35.07,-16.46,-37.05,29.58,28.30,8.47,17.53,2.31,30.13,2.22)
VGSIX <- .01*VGSIX
# Commodities returns:
PCRIX <- c(38.69,68.40,4.10,5.11,-5.55,3.05,26.37,34.26,6.12,-22.52,3.84,12.24,-3.51,13.03,-6.19,17.91,18.50,27.72,25.13,3.77,6.59,6.42,5.89,24.29,18.35,-1.00,-25.30,19.66,35.83,-15.25,39.93,29.82,16.36,20.50,-3.04,23.80,-43.33,39.92,24.13,-7.56,5.31,-14.81,-18.06,-25.70)
PCRIX <- .01*PCRIX

shinyServer(function(input, output) {
  
  output$text1 <- renderUI({ 
    
    # Create combined return vector:
    comb_ret <- VTSMX*input$us_stocks + VGTSX*input$foreign_stocks + VFITX*input$bonds + VGSIX*input$real_estate + PCRIX*input$commodities
    # Start with $1000:
    curr_val <- 1000
    acct_val <- c(curr_val)
    year <- 1971:2015
    for (ret in comb_ret) {
      curr_val <- (1+.01*ret)*curr_val
      acct_val <- c(acct_val,curr_val)
    }
    
    CAGR <- 100*((acct_val[44]/acct_val[1])^(1/44)-1)
    
    # Check that inputs are valid:
    tot_in <- input$us_stocks + input$foreign_stocks + input$bonds + input$real_estate + input$commodities
    
    if (tot_in != 100){
      "ERROR: Allocations must total to 100%, please fix inputs on left side."
    }
    else {
      HTML(paste(
      "Starting Year: 1971",
      "Ending Year: 2015",
      "Initial Investment: $1000.00",
      paste("Final Value: $", round(acct_val[44],2), sep=""),
      paste("CAGR: ", round(CAGR,2), "%", sep=""),
      paste("Standard Deviation: ", round(sd(comb_ret),2), sep=""),
      paste("Sharpe Ratio: ", round(CAGR/sd(comb_ret),2), sep=""),
      sep="<br/>"))
    }
  })
  
   
  output$return_chart <- renderPlot({
    
    # Create combined return vector:
    comb_ret <- VTSMX*input$us_stocks + VGTSX*input$foreign_stocks + VFITX*input$bonds + VGSIX*input$real_estate + PCRIX*input$commodities
    # Start with $1000:
    curr_val <- 1000
    acct_val <- c(curr_val)
    year <- 1971:2015
    for (ret in comb_ret) {
      curr_val <- (1+.01*ret)*curr_val
      acct_val <- c(acct_val,curr_val)
    }
    
    # Error check:
    tot_in <- input$us_stocks + input$foreign_stocks + input$bonds + input$real_estate + input$commodities
    
    if (tot_in == 100){
    plot(year,acct_val,type="b", main="Growth of $1000", xlab="Year", ylab="Value ($)")
    }
  })  
  

  
})

