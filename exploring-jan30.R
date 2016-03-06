setwd("~/git/qs-survey")
source("~/git/R-projects/data-portal-analysis/functions.r")

library(ggplot2)
theme_set(theme_minimal(base_family = "Helvetica Neue"))

# Careful takes long to run
source("data-2014-01-30/survey_526437_R_syntax_file.R")

# Removed 1 speeder online
# Remove incomplete
qs <- data[!is.na(data$submitdate), ]

# Recognise time formats
qs$datestamp <- as.POSIXct(qs$datestamp, format = "%d-%m-%Y %H:%M:%S")
qs$submitdate <- as.POSIXct(qs$submitdate, format = "%d-%m-%Y %H:%M:%S")

# Variable names
attr(qs, "variable.labels")[648]
attr(qs, "variable.labels")[649]
qs$sex <- NA
qs[which(qs[, 648] == "Yes"), "sex"] <- 1
qs[which(qs[, 649] == "Yes"), "sex"] <- 0
qs$sexfactor <- factor(qs$sex, levels = c(0, 1), labels = c("male", "female"))


# save.image("qs-data-2014-02-28.RData")

#----------------------------------------------
# Function that plots a variable and its label with exact matching
plot.label <- function(var, flip = FALSE){
  ggplot(data = qs) + geom_bar(aes_string(x = var), fill = "azure3") +  xlab("") +
    ggtitle(attr(qs, "variable.labels")[grep(paste0("^", var, "$"), names(qs))]) +
    if (flip) coord_flip()
}

# Let's have a look at opening up data
plot.label("G74_Q0005b")
plot.label(names(qs)[635])
ggsave("graphics/open-data.png", width = 9, height = 4, dpi = 100)

table(qs$G74_Q0005b, useNA = "ifany")

# Gender
table(qs[, 648], qs[, 649])

# Weight tools
write.csv(qs[!is.na(qs$G24_Q0002_SQ001), "G24_Q0002_SQ001"], "weight-tools.csv")

# Location
table(qs[, "G74_Q0014"])

# Qual analysis
write.csv(qs[!is.na(qs$G74_Q0003), "G74_Q0003"], "G74_Q0003.csv")
write.csv(qs[!is.na(qs$G74_Q0008b), "G74_Q0008b"], "G74_Q0008b.csv")


