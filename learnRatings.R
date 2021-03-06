#######################
#######################
######################## learn from ratings script

#learnRatings <- read.delim("learn_from.txt")


### Calculate p&d scores
### Reverse score items 2,6,10,12,17 as according to Cheng et al. 2013 (should really write a function for this..!!)
# 
# learnRatings$R2rev <- ifelse((learnRatings$R2==1),7,
#                             ifelse((learnRatings$R2==2),6,
#                                    ifelse((learnRatings$R2==3),5,
#                                           ifelse((learnRatings$R2==4),4,
#                                                  ifelse((learnRatings$R2==5),3,
#                                                         ifelse((learnRatings$R2==6),2,
#                                                                ifelse((learnRatings$R2==7),1,NA)))))))
# 
# 
# learnRatings$R6rev <- ifelse((learnRatings$R6==1),7,
#                             ifelse((learnRatings$R6==2),6,
#                                    ifelse((learnRatings$R6==3),5,
#                                           ifelse((learnRatings$R6==4),4,
#                                                  ifelse((learnRatings$R6==5),3,
#                                                         ifelse((learnRatings$R6==6),2,
#                                                                ifelse((learnRatings$R6==7),1,NA)))))))
# 
# learnRatings$R10rev <- ifelse((learnRatings$R10==1),7,
#                              ifelse((learnRatings$R10==2),6,
#                                     ifelse((learnRatings$R10==3),5,
#                                            ifelse((learnRatings$R10==4),4,
#                                                   ifelse((learnRatings$R10==5),3,
#                                                          ifelse((learnRatings$R10==6),2,
#                                                                 ifelse((learnRatings$R10==7),1,NA)))))))
# 
# learnRatings$R12rev <- ifelse((learnRatings$R12==1),7,
#                              ifelse((learnRatings$R12==2),6,
#                                     ifelse((learnRatings$R12==3),5,
#                                            ifelse((learnRatings$R12==4),4,
#                                                   ifelse((learnRatings$R12==5),3,
#                                                          ifelse((learnRatings$R12==6),2,
#                                                                 ifelse((learnRatings$R12==7),1,NA)))))))
# 
# learnRatings$R17rev <- ifelse((learnRatings$R17==1),7,
#                              ifelse((learnRatings$R17==2),6,
#                                     ifelse((learnRatings$R17==3),5,
#                                            ifelse((learnRatings$R17==4),4,
#                                                   ifelse((learnRatings$R17==5),3,
#                                                          ifelse((learnRatings$R17==6),2,
#                                                                 ifelse((learnRatings$R17==7),1,NA)))))))
# 
# #learnRatings <- read.csv("learnRatings.csv")
# learnRatings[learnRatings == 999] <- NA
# learnRatings <- na.omit(learnRatings)
# 
# 
# learnRatings$dominanceMean <- rowMeans(learnRatings[,c("R3", "R5", "R7", "R9","R10rev","R11","R12rev","R16")], na.rm = TRUE)
# learnRatings$prestigeMean <- rowMeans(learnRatings[,c("R1", "R2rev", "R4", "R6rev", "R8", "R13", "R14", "R15", "R17rev")], na.rm = TRUE)
# 
# 
# learnRatings$Psum <- rowSums(learnRatings[,c("R1", "R2rev", "R4", "R6rev", "R8", "R13", "R14", "R15", "R17rev")], na.rm = TRUE)
# learnRatings$Pprop <- (learnRatings$Psum - 9)/54
# 
# learnRatings$Dsum <- rowSums(learnRatings[,c("R3", "R5", "R7", "R9","R10rev","R11","R12rev","R16")], na.rm = TRUE)
# learnRatings$Dprop <-(learnRatings$Dsum -8)/48

write.csv(learnRatings, "learnRatings.csv")
learnRatings <- read.csv("learnRatings.csv")
library(psy)

#cronbach test stuff
PrestigeRatings <- subset(learnRatings, select = c(R1, R2rev, R4, R6rev, R8, R13, R14, R15, R17rev))
DominanceRatings <- subset(learnRatings, select = c(R3, R5, R7, R9, R10rev, R11, R12rev, R16))

cronbach(PrestigeRatings)
#[1] 0.677757
cronbach(DominanceRatings)
#[1] 0.8335996

hist(learnRatings$prestigeMean)
hist(learnRatings$dominanceMean)

cor.test(learnRatings$Pprop, learnRatings$Dprop)

##############################
#############################
###### ORDINAL VERSION ######
############################
###########################

learnRatings <- read.csv("learnRatings.csv")

colnames(learnRatings)
learnRatings <- learnRatings[,2:26]
colnames(learnRatings)

## Prestige first:
presLearn <- learnRatings[,c(1,2,3,4,21,7,22,11,16,17,18,25)]


prestige <- c("R1", "R2rev", "R4", "R6rev", "R8", "R13", "R14", "R15", "R17rev")

presLearnLong <- reshape(presLearn, times = prestige,
                        varying = prestige,
                        v.names = c("prestigeRatings"), 
                        direction = "long")

presLearnLong <- presLearnLong[order(presLearnLong$RATER_ID),]
colnames(presLearnLong)[4] <- "presItem"

presLearn <- presLearnLong

#histPlots
presLearnPlot <- simplehist(presLearn$prestigeRatings, xlim = c(1,7), xlab = "response")

pL <- ggplot(data=presLearn) +
  geom_bar(aes(x=prestigeRatings), fill="seagreen") + theme_bw() +
  theme(text = element_text(size=12), axis.title.y=element_text(margin=margin(0,12,0,0))) +
  scale_x_continuous(breaks=1:7, labels=c("1","2","3","4","5","6","7")) +
  scale_y_continuous(limits = c(0,500)) +
  xlab("Prestige Rating") + ylab("Total Count")
pL



###### Now Dominance:
colnames(learnRatings)

domLearn <- learnRatings[,c(1,2,3,6,8,10,12,23,14,24,19)]

dominance <- c("R3", "R5","R7","R9","R10rev","R11","R12rev","R16")


domLearnLong <- reshape(domLearn, times = dominance,
                         varying = dominance,
                         v.names = c("dominanceRatings"), 
                         direction = "long")

domLearnLong <- domLearnLong[order(domLearnLong$RATER_ID),]
colnames(domLearnLong)[4] <- "domItem"

domLearn <- domLearnLong



learnRatings<- read.csv("learnRatings.csv")
#might need to do own indexing the old way:


NItems = length(unique(domLearn$domItem))
OldItems <- domLearn$domItem
ItemID <- array(0,length(domLearn$domItem))
for (index in 1:NItems){
  ItemID[OldItems == unique(OldItems)[index]] = index
}
domLearn$itemID <- ItemID

Nrater = length(unique(domLearn$RATER_ID))
OldRater <- domLearn$RATER_ID
RaterID <- array(0,length(domLearn$RATER_ID))
for (index in 1:Nrater){
  RaterID[OldRater == unique(OldRater)[index]] = index
}
domLearn$raterID <- RaterID

#presComm$itemID <- coerce_index(as.factor(presComm$presItem))
#presComm$raterID <- coerce_index(presComm$Rater_ID)

domLearn$propP <- learnRatings$Pprop[match(domLearn$RATER_ID, learnRatings$RATER_ID)]

learnDomMod <- map2stan(
  alist(
    dominanceRatings ~ dordlogit(phi, cutpoints),
    phi <- bp*propP + aR[raterID]*sigmaR + aItem[itemID]*sigmaItem,
    bp ~ dnorm(0,1),
    aR[raterID] ~ dnorm(0,1),
    aItem[itemID] ~ dnorm(0,1),
    c(sigmaR, sigmaItem) ~ normal(0,0.1),
    cutpoints ~ dnorm(0,10)
  ),
  data=domLearn, 
  constraints = list(sigmaR = "lower=0", sigmaItem = "lower=0"),
  start = list(cutpoints=c(-2,-1,0,1,2,2.5)),
  chains = 1, cores = 1)

precis(learnDomMod)

#           #mean   sd  5.5% 94.5% n_eff Rhat
# bp        -0.84 0.63 -1.88  0.14   427    1
# sigmaR     0.91 0.06  0.82  1.00  1000    1
# sigmaItem  0.49 0.05  0.41  0.57   592    1

#precis(learnDomMod, depth=2)
#cutpoints... (without all varying intercept estimates... aR = 147, aItem = 8... )
# mean   sd  5.5% 94.5% n_eff Rhat
# cutpoints[1] -1.81 0.53 -2.63 -0.99   330 1.01
# cutpoints[2] -0.68 0.53 -1.50  0.15   338 1.01
# cutpoints[3] -0.03 0.53 -0.89  0.82   342 1.01
# cutpoints[4]  0.96 0.53  0.11  1.78   343 1.01
# cutpoints[5]  1.69 0.53  0.82  2.51   344 1.01
# cutpoints[6]  2.97 0.55  2.08  3.83   353 1.00
# bp           -0.89 0.61 -1.90  0.07   381 1.00

#histPlots
domLearnPlot <- simplehist(domLearn$dominanceRatings, xlim = c(1,7), xlab = "response")

dL <- ggplot(data=domLearn) +
  geom_bar(aes(x=dominanceRatings), fill="seagreen") + theme_bw() +
  theme(text = element_text(size=12), axis.title.y=element_text(margin=margin(0,12,0,0))) +
  scale_x_continuous(breaks=1:7, labels=c("1","2","3","4","5","6","7")) +
  scale_y_continuous(limits=c(0,500)) +
  xlab("Dominance Rating") + ylab("Total Count")
dL


# plot posterior predictions? (rethinking p.341)
post2 <- extract.samples(learnDomMod)

kP <- seq(0,1,by = 0.01) # values of propP to calculate over

# distinguish lines using different colors
color_list <- c("violet","blue","green","yellow","orange","red")

# show s=100 samples and add thick line for mean, given there's a lot of uncertainty
#png("learning_plot.png", width = 15, height = 15, units = 'cm', res = 300)

plot(1, 1, type = "n", xlab = "proportion prestige", ylab = "probability", xlim = c(0,1), ylim = c(0,1), xaxp = c(0,1,1), yaxp = c(0,1,2), main = "learning ratings")

pk_means <- matrix(0, nrow = 101, ncol = 6) # values of propP to calculate over

for( s in 1:100) {
  p <- as.data.frame(post)[s,]
  ak <- as.numeric(p[1:6])
  phi <- p$bp*kP
  pk <- pordlogit( 1:6, a=ak, phi=phi)
  pk_means <- pk_means + pk
  for ( i in 1:6)
    lines( kP, pk[,i], col=col.alpha(color_list[i], alpha = 0.05))
}

# add thick lines for means
for (i in 1:6)
  lines( kP, pk_means[,i]/101, col = color_list[i], lwd = 3)

# add labels for numbers
text(0.9, 0.1, labels = "1")
text(0.9, 0.4, labels = "2")
text(0.9, 0.6, labels = "3")
text(0.9, 0.75, labels = "4")
text(0.9, 0.88, labels = "5")
text(0.9, 0.94, labels = "6")
text(0.9, 1, labels = "7")
