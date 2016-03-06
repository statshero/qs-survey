setwd("~/git/qs-survey")
load("qs-data-2014-02-28.RData")
library(sdcMicro)
library(sdcMicroGUI)
library(ggplot2)
theme_set(theme_minimal(base_family = "Helvetica Neue"))

qs.anon <- qs

# Remove identifiers
qs.anon$G74_Q0014 <- NULL # location


sdcGUI()

