setwd("~/git/qs-survey")
load("qs-data-2014-02-28.RData")
source('~/git/R-projects/peer-to-peer/functions.R')
       
require(likert)
require(sjPlot)
require(stringr)
require(plyr)
require(ggplot2)
theme_set(theme_minimal(base_family = "Helvetica Neue", base_size = 20))

#-----------------------------
# PHYSICAL
physical <- qs[, substr(names(qs), 1, 9) == "G3_Q0001_"]
var.labels <- attr(qs, "variable.labels")[grep("G3_Q0001_", names(qs))]
names(physical) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)
#EINTIEAN TSINSIEO
physical$count <- apply(physical, 1, function(x) sum(!is.na(physical[1:23])))

# cbind(as.data.frame(sapply(physical, no.missing)), as.data.frame(sapply(physical, no.missing)) / length(physical[, 1]) * 100 )
# 
# physical.likert <- likert(physical)
# summary(physical.likert)
# plot(physical.likert, type = "heat")
# plot(physical.likert, include.histogram = TRUE)

#-----------------------------
# EMOTIONAL
emotional <- qs[, substr(names(qs), 1, 10) == "G26_Q0001_"]
var.labels <- attr(qs, "variable.labels")[grep("G26_Q0001_", names(qs))]
names(emotional) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)


#-----------------------------
# ACTIVITY
activity <- qs[, substr(names(qs), 1, 10) == "G33_Q0001_"]
var.labels <- attr(qs, "variable.labels")[grep("G33_Q0001_", names(qs))]
names(activity) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)

#-----------------------------
# MONEY
money <- qs[, substr(names(qs), 1, 10) == "G58_Q0001_"]
var.labels <- attr(qs, "variable.labels")[grep("G58_Q0001_", names(qs))]
names(money) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)

#-----------------------------
# SOCIAL
social <- qs[, substr(names(qs), 1, 10) == "G63_Q0001_"]
var.labels <- attr(qs, "variable.labels")[grep("G63_Q0001_", names(qs))]
names(social) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)

#-----------------------------
# Attitudes, skills and demographics
attitudes <- qs[, grep("G74", names(qs), value = TRUE)]
drops <- c("G74_Q0003", "G74_Q0004", "G74_Q0005", "G74_Q0006b", "G74_Q0008", "G74_Q0008b", "G74_Q0009", "G74_Q0010", "G74_Q0014", "G74_Q0016", "G74_Q0017")
drops.no <- match(drops, names(attitudes))

# Factors as dummy variables
recode.factors.dum <- function(dta, x) recode(dta[, x], from = c("Yes", "Not selected"), to = c(1, 0))
attitudes[, substr(names(attitudes), 1, 10) == "G74_Q0002_"] <- recode.factors.dum(attitudes, substr(names(attitudes), 1, 10) == "G74_Q0002_")
attitudes[, substr(names(attitudes), 1, 10) == "G74_Q0006_"] <- recode.factors.dum(attitudes, substr(names(attitudes), 1, 10) == "G74_Q0006_")
attitudes[, substr(names(attitudes), 1, 10) == "G74_Q0018_"] <- recode.factors.dum(attitudes, substr(names(attitudes), 1, 10) == "G74_Q0018_")
attitudes[, substr(names(attitudes), 1, 10) == "G74_Q0015_"] <- recode.factors.dum(attitudes, substr(names(attitudes), 1, 10) == "G74_Q0015_")

var.labels <- attr(qs, "variable.labels")[grep("G74", names(qs))]
names(attitudes) <- gsub(".*\\[(.*)\\].*", "\\1", var.labels)

attitudes <- subset(attitudes, select = -drops.no)

names(attitudes)

# Create dataframe PERSONAS with relevant variables
personas <- attitudes

personas$sex <- NA
personas[which(personas[, "Female"] == "Yes"), "sex"] <- 1
personas[which(personas[, "Male"] == "Yes"), "sex"] <- 0

# Impute sex as sample distribution, simple 5 and 2
personas$sex[is.na(personas$sex)]  <- c(0, 1, 0, 0, 0, 1, 0)
personas$sexfactor <- factor(personas$sex, levels = c(0, 1), labels = c("male", "female"))

# Impute age as sample distribution
# Group extreme ages
personas$age <- personas[, 20]
personas$age[is.na(personas$age)] <- c("41 - 50", "25 - 30", "31 - 35", "25 - 30", "36 - 40", "41 - 50", "51 - 60")
personas$age[personas$age == ">70 years"]  <- "61- 70"
personas$age[personas$age == "21 - 24"]  <- "25 - 30"
personas$age <- factor(personas$age)
levels(personas$age)[levels(personas$age) == "61- 70"] <- "> 60"

table(personas$age)
ggplot(data = personas, aes(x = age)) + geom_histogram(fill = odi_lBlue) + geom_hline(yintercept = c(10, 20), color = "white") + theme(axis.ticks = element_blank())
ggsave("graphics/age-histogram.png", height = 4, width = 8, dpi = 100)

# Openness, code missing as "unknown"
personas$open <- as.character(personas[, 10])
personas$open[is.na(personas$open)] <- "unknown"
personas$open <- factor(personas$open)

# Drop all unneeded columns
personas <- personas[, !names(personas) %in% c("Other", "Other.1", "Other.2", "Other.3", "Your Age:", "sex", "Female", "Male", "Do you analyse your data?", "Would you consider making some of your personal data available as open data?")]

# Better names
attr(personas, "variable.labels")  <- capwords(names(personas))
names(personas) <- clean.names(personas)



