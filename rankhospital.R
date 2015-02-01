rankhospital <- function(state, outcome, num = "best") {
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Check that state and outcome are valid
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
  
  ## Return hospital name in that state with the given rank 30-day death rate
  # order data
  data <- data[order(data[,type], data[,2], na.last=TRUE), ]
  data <- na.omit(data)
  data.names <- data[,2]
  
  # check valuable num
  if(num == "best"){
    return(data.names[1])
  }
  if(num == "worst"){
    worst.rate <- data[NROW(data),type]
    worst.hospital.names <- data[data[,type]==worst.rate, 2]
    return(worst.hospital.names[1])
  }
  else {
    return(data.names[num])
  }
  
}