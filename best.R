best <- function(state, outcome){

  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Check that state and outcome are vaild
  if(state %in% data[,"State"]){ 
    # setting data
    data <- subset(data, State == state)
    data <- na.omit(data)
  } else {
    stop("invalid state")
  }
  
  if(outcome %in% c("heart attack", "heart failure", "pneumonia")){
    # setting type of disease
    type <- ifelse(outcome == "heart attack", 11, ifelse(outcome == "heart failure", 17, 23))
    data[,type] <- suppressWarnings(as.numeric(data[,type]))
  } else {
    stop("invalid outcome")
  }

  ## Return hospital name in that state with lowest 30-day death rate
  data <- data[order(data[,type], data[,2], na.last=TRUE), 2]
  data[1]
}