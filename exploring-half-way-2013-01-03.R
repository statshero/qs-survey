setwd("~/git/qs-survey")
source("~/git/R-projects/data-portal-analysis/functions.r")

library(ggplot2)
theme_set(theme_minimal(base_family = "Helvetica Neue"))


# Careful takes long to run
source("data-2013-01-03/survey_526437_R_syntax_file.R")

# Recognise time formats
data$datestamp <- as.POSIXct(data$datestamp, format = "%d-%m-%Y %H:%M:%S")
data$submitdate <- as.POSIXct(data$submitdate, format = "%d-%m-%Y %H:%M:%S")


# Remove incomplete
qs <- data[!is.na(data$submitdate), ]

# Remove speeders if any


# Function that plots a variable and its label with exact matching
plot.label <- function(var, flip = FALSE){
  ggplot(data = qs) + geom_bar(aes_string(x = var), fill = "azure3") + 
    ggtitle(attr(qs, "variable.labels")[grep(paste0("^", var, "$"), names(qs))]) +
    if (flip) coord_flip()
}

# Let's have a look at opening up data
plot.label("G74_Q0005b")
plot.label(names(qs)[635])


# Gender
table(qs[, 648], qs[, 649])



