library(plyr)
library(reshape2)
library(RGoogleDocs)

options(stringsAsFactors = FALSE)
source('~/git/R-playground/sensitive-data-never-commit.R')
source('~/git/R-projects/data-portal-analysis/functions.r')

# Get data directly

sheets.con <- getGoogleDocsConnection(getGoogleAuth("ulrich.atz@theodi.org", gmailpw, service = "wise"))
spreadsheets <- getDocs(sheets.con)

#--- G74_Q0008
G74_Q0008b <- getWorksheets(spreadsheets[["G74_Q0008b"]], sheets.con)
G74_Q0008b.fd <- getWorksheets(spreadsheets[["FD Coding for G74_Q0008b - Why not analyse"]], sheets.con)

G74_Q0008b.ch <- sheetAsMatrix(G74_Q0008b[["Colin"]], header = TRUE)
G74_Q0008b.al <- sheetAsMatrix(G74_Q0008b[["Adriana"]], header = TRUE)
G74_Q0008b.fd <- sheetAsMatrix(G74_Q0008b.fd[["Sheet 1"]], header = TRUE)

#--- G74_Q0003
G74_Q0003 <- getWorksheets(spreadsheets[["G74_Q0003"]], sheets.con)
G74_Q0003.fd <- getWorksheets(spreadsheets[["FD Coding for G74_Q0003 - challenges with data collection"]], sheets.con)

G74_Q0003.ch <- sheetAsMatrix(G74_Q0003[["Colin"]], header = TRUE)
G74_Q0003.al <- sheetAsMatrix(G74_Q0003[["Adriana"]], header = TRUE)
G74_Q0003.fd  <- sheetAsMatrix(G74_Q0003.fd[["Sheet 1"]], header = TRUE)
  
  
codes <- c("code1", "code2", "code3")

# This function creates an ordered frequency table of the codes used
# Option for length 
fre.table <- function(dta, id = "Response", list = 30) {
  all.codes <- melt(dta[, c(id, codes)], id, na.rm = TRUE)
  as.data.frame(sort(table(all.codes$value), TRUE)[1:min(list, length(unique(all.codes$value)))])
}

fre.table(G74_Q0008b.ch)
fre.table(G74_Q0008b.al)
fre.table(G74_Q0008b.fd, id = "no")

fre.table(G74_Q0003.ch, id = "Response number")
fre.table(G74_Q0003.al, id = "Response number")
fre.table(G74_Q0003.fd)
