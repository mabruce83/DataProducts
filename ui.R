library(shiny)
shinyUI(fluidPage(
  titlePanel("Investment Portfolio Backtester"),
  sidebarLayout(
    # Side bar:
    sidebarPanel( 
      # Title:
      h3("Allocation Percentage:"),     
      
      # Inputs:
      numericInput("us_stocks", 
                   label = h5("Enter Allocation to US Stocks (%):"), 
                   value = 60, min = 1, max = 100),
      numericInput("foreign_stocks", 
                   label = h5("Enter Allocation to Foreign Stocks (%):"), 
                   value = 0, min = 1, max = 100),
      numericInput("bonds", 
                   label = h5("Enter Allocation to US Government Bonds (%):"), 
                   value = 40, min = 1, max = 100),
      numericInput("real_estate", 
                   label = h5("Enter Allocation to Real Estate (%):"), 
                   value = 0, min = 1, max = 100),
      numericInput("commodities", 
                   label = h5("Enter Allocation to Commodities (%):"), 
                   value = 0, min = 1, max = 100),
      h3("Instructions:"),
      "To calculate portfolio returns of a simulated $1000 investment starting 
      in 1971, enter allocations to each asset class in the appropriate box above.  All 
      allocations should total to 100%.  Results are based on yearly rebalancing.
      Simulation based on historical performance of the following mutual funds:
      VTSMX, VGTSX, VFITX, VGSIX, PCRIX."
    ),
    
    # Main panel:
    mainPanel(
      h3("Backtest Results:"),
        plotOutput("return_chart"),
        htmlOutput("text1")
    )
 
  )
))
