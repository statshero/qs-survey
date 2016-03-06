setwd("~/git/qs-survey")
library(plyr)
library(reshape2)
library(RGoogleDocs)

options(stringsAsFactors = FALSE)

# This loads the Google password
source('~/git/R-playground/sensitive-data-never-commit.R')
# source('~/git/R-projects/data-portal-analysis/functions.r')

# Get the data directly
sheets.con <- getGoogleDocsConnection(getGoogleAuth("ulrich.atz@theodi.org", gmailpw, service = "wise"))
spreadsheets <- getDocs(sheets.con)

#--- G74_Q0008b
G74_Q0008b <- getWorksheets(spreadsheets[["G74_Q0008b – Any specific reasons why you don't do analysis on your data?"]], sheets.con)

G74_Q0008b.ch <- sheetAsMatrix(G74_Q0008b[["Colin"]], header = TRUE)
G74_Q0008b.al <- sheetAsMatrix(G74_Q0008b[["Adriana"]], header = TRUE)
G74_Q0008b.fd <- sheetAsMatrix(G74_Q0008b[["Farzana"]], header = TRUE)

#--- G74_Q0003
G74_Q0003 <- getWorksheets(spreadsheets[["G74_Q0003 - Any specific challenges with data collection?"]], sheets.con)

G74_Q0003.ch <- sheetAsMatrix(G74_Q0003[["Colin"]], header = TRUE)
G74_Q0003.al <- sheetAsMatrix(G74_Q0003[["Adriana"]], header = TRUE)
G74_Q0003.fd  <- sheetAsMatrix(G74_Q0003[["Farzana"]], header = TRUE)
G74_Q0003.rp  <- sheetAsMatrix(G74_Q0003[["Rasmus"]], header = TRUE)

#--- G74_Q00010
G74_Q00010 <- getWorksheets(spreadsheets[["G74_Q0010 – How could the QS community help you more?"]], sheets.con)

G74_Q00010.rp <- sheetAsMatrix(G74_Q00010[["Rasmus"]], header = TRUE)
G74_Q00010.al <- sheetAsMatrix(G74_Q00010[["Adriana"]], header = TRUE)
G74_Q00010.nb  <- sheetAsMatrix(G74_Q00010[["Neil"]], header = TRUE)

#--- G74_Q0009
G74_Q0009 <- getWorksheets(spreadsheets[["G74_Q0009 – In terms of personal data, is there anything you're trying to achieve that you can't yet do?"]], sheets.con)

G74_Q0009.rp <- sheetAsMatrix(G74_Q0009[["Rasmus"]], header = TRUE)
G74_Q0009.ua <- sheetAsMatrix(G74_Q0009[["Ulrich"]], header = TRUE)

#--- G74_Q0008
G74_Q0008 <- getWorksheets(spreadsheets[["G74_Q0008 – What kind(s) of analysis do you do?"]], sheets.con)

G74_Q0008.nb  <- sheetAsMatrix(G74_Q0008[["Neil"]], header = TRUE)
G74_Q0008.rp <- sheetAsMatrix(G74_Q0008[["Rasmus"]], header = TRUE)


#--- G74_Q0006b
G74_Q0006b <- getWorksheets(spreadsheets[["G74_Q0006b – Please describe these concerns"]], sheets.con)

G74_Q0006b.al  <- sheetAsMatrix(G74_Q0006b[["Adriana"]], header = TRUE)
G74_Q0006b.ch <- sheetAsMatrix(G74_Q0006b[["Colin"]], header = TRUE)

codes <- c("code1", "code2", "code3")

# Write tables to file
sink("qual-analysis.txt", append = TRUE, type = "output")
source("qual-analysis-tables.R", echo = TRUE, max.deparse.length = 1e3)
sink()
