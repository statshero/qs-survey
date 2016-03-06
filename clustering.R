setwd("~/git/qs-survey")
load("qs-data-2014-03-31.RData")

require(Hmisc)
require(descr)
require(foreign)
require(plyr)

require(clusterCons)
source("/Users/Ulrich/git/R-projects/consensusclustering/cluscomp_pb_mach.r")
source("/Users/Ulrich/git/R-projects/consensusclustering/cc_robustness.R")
set.seed(4994)

# Make respid the rowlabels for CC, input data for allocation algorithm
rmclus <- data.frame(sapply(personas, as.numeric))
rmclus$respid <- 1:105
rownames(rmclus) <- rmclus$respid
rmclus[,1] <- NULL

# Recommended are 1000 replications; time-consuming.
system.time(  
  dataseg <- cluscomp_mach(rmclus, diss = FALSE, algorithms = list("kmeans"), 
                           alparams = list(iter.max = 50), clmin = 3, clmax = 6, prop = 0.8, 
                           reps = 1000) 
)

# Calculate robustness of each segment solution via the clusterCons package.
# Result is called 'clustrobexp'
cc_robust_package(3, 6, dataseg)

# Alternative way with highest and number of re-allocated segment membership
# Takes some time to calculate individual membership robustness 'memrob'
# Not the ideal way because 'clusterallocation' gets overwritten
# To save the result specify: segmentX <- clusterallocation
#
# 'cc_robust_cust' gives you the alternative robustness statistic AND 
# the number of respondents which are allocated into different segments.

cc_robust_cust(3, dataseg$e1_kmeans_k3)
segment3 <- clusterallocation
cc_robust_cust(4, dataseg$e1_kmeans_k4)
segment4 <- clusterallocation
cc_robust_cust(5, dataseg$e1_kmeans_k5)
segment5 <- clusterallocation
cc_robust_cust(6, dataseg$e1_kmeans_k6)
segment6 <- clusterallocation

all_clusters <- data.frame(rmclus$respid, segment3, segment4, segment5, segment6)
write.csv(all_clusters, "Segments allocation 3-6.csv")

# Optional: Compare segmentation solution.
colours <-  c(odi_dBlue, odi_dPink, odi_purple, odi_orange)
crosstab(all_clusters[, 3], all_clusters[, 2], xlab = "4 segments", ylab = "3 segments", color = colours)
crosstab(all_clusters[, 4], all_clusters[, 3], xlab = "5 segments", ylab = "4 segments", color = colours)
crosstab(all_clusters[, 5], all_clusters[, 3], xlab = "6 segments", ylab = "4 segments", color = colours)


# heatmaps - takes very long to run
jpeg("graphics/heatmap 3 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k3@cm, labRow="", labCol=""))
dev.off()
jpeg("graphics/heatmap 4 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k4@cm, labRow="", labCol=""))
dev.off()
jpeg("graphics/heatmap 5 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k5@cm, labRow="", labCol=""))
dev.off()
jpeg("graphics/heatmap 6 seg.jpg", width = 800, height = 800)
system.time(heatmap(dataseg$e1_kmeans_k6@cm, labRow="", labCol=""))
dev.off()

#------------------------------
# Add cluster allocation to data
personas.cluster <- cbind(all_clusters[, -1], personas)
names(personas.cluster)[names(personas.cluster)=="max.col.mrm."] <- "seg3"
names(personas.cluster)[names(personas.cluster)=="max.col.mrm..1"] <- "seg4"
names(personas.cluster)[names(personas.cluster)=="max.col.mrm..2"] <- "seg5"
names(personas.cluster)[names(personas.cluster)=="max.col.mrm..3"] <- "seg6"

# Select factors
is.fact <- sapply(personas.cluster, is.factor)
str(personas.cluster[, is.fact])
is.not.fact <- !sapply(personas.cluster, is.factor)

ddply(personas.cluster[, is.not.fact], ~ seg4, summarise, mean)                                                                             
                                           
library(psych)
groups <- describeBy(personas.cluster, personas.cluster$seg4, mat = TRUE)
write.csv(as.data.frame(groups), "groups-by-seg4.csv")

groups <- describeBy(personas.cluster, personas.cluster$seg3, mat = TRUE)
write.csv(as.data.frame(groups), "groups-by-seg3.csv")
