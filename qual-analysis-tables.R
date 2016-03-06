# This function creates an ordered frequency table of the codes used
# Option for length 
fre.table <- function(dta, id = "Response", list = 30) {
  all.codes <- melt(dta[, c(id, codes)], id, na.rm = TRUE)
  x <- as.data.frame(sort(table(all.codes$value), TRUE)[1:min(list, length(unique(all.codes$value)))])
  names(x)  <- 'count'
  return(x)
}

# G74_Q0008b – Any specific reasons why you don't do analysis on your data?
fre.table(G74_Q0008b.ch)
fre.table(G74_Q0008b.al)
fre.table(G74_Q0008b.fd)

# G74_Q0003 - Any specific challenges with data collection?
fre.table(G74_Q0003.ch)
fre.table(G74_Q0003.al)
fre.table(G74_Q0003.fd)

# G74_Q0010 – How could the QS community help you more?
fre.table(G74_Q00010.rp)
fre.table(G74_Q00010.al)
fre.table(G74_Q00010.nb)

# G74_Q0009 – In terms of personal data, is there anything you're trying to achieve that you can't yet do?
fre.table(G74_Q0009.rp)
fre.table(G74_Q0009.ua)

# G74_Q0008 – What kind(s) of analysis do you do?
fre.table(G74_Q0008.nb)
fre.table(G74_Q0008.rp)

# G74_Q0006b – Please describe these concerns
fre.table(G74_Q0006b.al)
fre.table(G74_Q0006b.ch)
