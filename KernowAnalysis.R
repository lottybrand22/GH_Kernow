
######################### THESE ARE THE METRIC VERSIONS OF THE MODELS #########################

library(rethinking)

setwd("~/Desktop/Postdoc/CornwallCommunityStudy/results/Kernow/DataFiles")


############################################################
############################################################
######## COMMUNITY INFLUENCE PRESTIGE AND DOMINANCE RATINGS: 
############################################################
############################################################

commRatings <- read.csv("commRatings.csv")
commRatings[,1:7] <- NULL
#write.csv(commRatings, "commRatings.csv")

presComm <- map2stan(
  alist(
    Pprop ~ dnorm(mu, sigma),
    mu <- a,
    a ~ dnorm(0,10),
    sigma ~ dunif(0,10)
  ),
  data=commRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(presComm)


domComm <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a,
    a ~ dnorm(0,10),
    sigma ~ dunif(0,10)
  ),
  data=commRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domComm)

#### Prestige predicted by Dominance?

domPrestComm <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a + b_pres*Pprop,
    a ~ dnorm(0,1),
    b_pres ~ dnorm(0,1),
    sigma ~ dunif(0,10)
  ),
  data=commRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domPrestComm)
# 
# mean   sd  5.5% 94.5% n_eff Rhat
# a       0.82 0.06  0.73  0.92   283    1
# b_pres -0.53 0.08 -0.66 -0.39   281    1
# sigma   0.21 0.01  0.19  0.24   446    1

?gsub
colnames(commRatings)[2] <- "Name"
commRatings$name <- gsub("999", 'na', commRatings$Name)
commRatings$Name <- commRatings$name
commRatings$name <- NULL
write.csv(commRatings, "commRatings.csv")
commRatings <- read.csv("commRatings.csv")

inflNames <- c("The Queen", "Queen", "Queen Elizabeth", "Theresa May", "David Attenborough",
               "Jeremy Corbyn", "Donald Trump", "JK Rowling", "Ozzy Osbourne",
               "Boris Johnson", "Prince Charles")
infLabels <- commRatings[commRatings$Name %in% inflNames,]


namePlot <- ggplot(commRatings, aes(Pprop, Dprop, label=Name)) +
  geom_point(size = 0.5) +
  theme_bw() +
  geom_text(data=infLabels, position = position_jitter(), size = 5)
namePlot

cor.test(commRatings$Dprop, commRatings$Pprop)
cor(commRatings$Dprop, commRatings$Pprop)
#[1] -0.4868556


############################################################
############################################################
######## COMMUNITY LEARN FROM PRESTIGE AND DOMINANCE RATINGS: 
############################################################
############################################################

learnRatings <- read.csv("learnRatings.csv")

presLearn <- map2stan(
  alist(
    Pprop ~ dnorm(mu, sigma),
    mu <- a,
    a ~ dnorm(0,10),
    sigma ~ dunif(0,10)
  ),
  data=learnRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(presLearn)


domLearn <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a,
    a ~ dnorm(0,10),
    sigma ~ dunif(0,10)
  ),
  data=learnRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domLearn)

#### Prestige predicted by Dominance?

domPrestLearn <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a + b_pres*Pprop,
    a ~ dnorm(0,1),
    b_pres ~ dnorm(0,1),
    sigma ~ dunif(0,10)
  ),
  data=learnRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domPrestLearn)

# mean   sd  5.5% 94.5% n_eff Rhat
# a       0.47 0.11  0.31  0.65   374    1
# b_pres -0.18 0.13 -0.40  0.02   381    1
# sigma   0.20 0.01  0.18  0.22   468    1

plot(learnRatings$Dprop ~ learnRatings$Pprop)
cor.test(learnRatings$Dprop, learnRatings$Pprop)
cor(learnRatings$Dprop, learnRatings$Pprop)
#[1] -0.1110871


############################################################
############################################################
######## GROUP PRESTIGE AND DOMINANCE, DO THEY CORRELATE?
############################################################
############################################################


presMod <- map2stan(
  alist(
    Pprop ~ dnorm(mu, sigma),
    mu <- a +  
      a_p[RaterID]*sigma_p + a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    a_p[RaterID] ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_p ~ dcauchy(0,1),
    sigma_g ~ dcauchy(0,1)
  ),
  data=pdRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(presMod)

#### Dominance null model:

domMod <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a +  
      a_p[RaterID]*sigma_p + a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    a_p[RaterID] ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_p ~ dcauchy(0,1),
    sigma_g ~ dcauchy(0,1)
  ),
  data=pdRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domMod)

#### Prestige predicted by Dominance?

domPrest <- map2stan(
  alist(
    Dprop ~ dnorm(mu, sigma),
    mu <- a + b_pres*Pprop + 
      a_p[RaterID]*sigma_p + a_g[GroupID]*sigma_g,
      a ~ dnorm(0,10),
      b_pres ~ dnorm(0,4),
      a_p[RaterID] ~ dnorm(0,1),
      a_g[GroupID] ~ dnorm(0,1),
      sigma ~ dunif(0,10),
      sigma_p ~ dcauchy(0,1),
      sigma_g ~ dcauchy(0,1)
  ),
  data=pdRatings, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(domPrest)
# Mean StdDev lower 0.89 upper 0.89 n_eff Rhat
# a        0.31   0.04       0.24       0.39   569 1.00
# b_pres  -0.04   0.06      -0.12       0.06   572 1.00
# sigma    0.16   0.01       0.16       0.17   520 1.00
# sigma_p  0.06   0.01       0.04       0.08   232 1.00
# sigma_g  0.00   0.04      -0.05       0.05    20 1.01

plot(pdRatings$Dprop ~ pdRatings$Pprop)
cor.test(pdRatings$Dprop, pdRatings$Pprop)
cor(pdRatings$Dprop, pdRatings$Pprop)
#[1] -0.05316162
#p-value = 0.2262

############################################################
############################################################
##################### What predicts group prestige ratings? ###############
############################################################
############################################################

#Full 

PresFull<- map2stan(
  alist(
    aveP ~ dnorm(mu, sigma),
    mu <- a + score*sScore + oConf*o_conf + infR*aveInf + lik*aveLik +
      sex*Sex + age*ageS + initL*initial_learn + initInf*initial_influential + 
      a_g[GroupID]*sigma_g,
      a ~ dnorm(0,10),
      c(score, oConf, infR, lik, sex, age, initL, initInf) ~ dnorm(0,1),
      a_g[GroupID] ~ dnorm(0,1),
      sigma ~ dunif(0,10),
      sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(PresFull)

#A Priori

PresAPriori <- map2stan(
  alist(
    aveP ~ dnorm(mu, sigma),
    mu <- a + score*IndividScore + infR*aveInf + lik*aveLik +
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    c(score, infR, lik) ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(PresAPriori)


#Null 

PresNull <- map2stan(
  alist(
    aveP ~ dnorm(mu, sigma),
    mu <- a +
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(PresNull)

compare(PresNull,PresFull,PresAPriori)

#### (This is 'Nominated' from the OSF 'full model'? 'inital influential?' #####


PresInitial <- map2stan(
  alist(
    aveP ~ dnorm(mu, sigma), 
    mu <- a + infl*initial_influential + infLearn*initial_learn +
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    c(infl, infLearn) ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(PresInitial)

compare(PresFull, PresNull, PresAPriori, PresInitial)


############################################################
############################################################
##################### What predicts group Dominance ratings? ###############
############################################################
############################################################


DomFull <- map2stan(
  alist(
    aveD ~ dnorm(mu, sigma),
    mu <- a + score*sScore + oconf*oConf +  infR*aveInf + lik*aveLik + 
      age*ageS + sex*Sex + 
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    c(score, oconf, infR, lik, age, sex) ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(DomFull)

####compare to predictions
DomAPriori <- map2stan(
  alist(
    aveD ~ dnorm(mu, sigma),
    mu <- a + oconf*oConf + infR*aveInf +
      a_g[GroupID]*sigma_g,
      a ~ dnorm(0,10),
      c(oconf, infR) ~ dnorm(0,1),
      a_g[GroupID] ~ dnorm(0,1),
      sigma ~ dunif(0,10),
      sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(DomAPriori)

####compare to Null
DomNull <- map2stan(
  alist(
    aveD ~ dnorm(mu, sigma),
    mu <- a + 
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(DomNull)

compare(DomFull,DomAPriori, DomNull)

############# Exploratory: Do initial ratings predict Dominance?


DomInit <- map2stan(
  alist(
    aveD ~ dnorm(mu, sigma),
    mu <- a + infl*initial_influential + infLearn*initial_learn +  
      a_g[GroupID]*sigma_g,
    a ~ dnorm(0,10),
    c(infl, infLearn) ~ dnorm(0,1),
    a_g[GroupID] ~ dnorm(0,1),
    sigma ~ dunif(0,10),
    sigma_g ~ dcauchy(0,1)
  ),
  data=kernowResults, constraints=list(sigma_p="lower=0"),
  warmup = 1000, iter=2000, chains = 1, cores = 1)

precis(DomInit)

compare(DomFull, DomNull, DomAPriori, DomInit)


##################################################
##########################################################################
################ NOMINATIONS MODELS ################################################
##########################################################################
##################################################

#####
#### centre and scale aveInf aveLik aveP and aveD too
#####

#kernowResults$aveDcs <- scale(kernowResults$aveD, center = TRUE, scale = TRUE)
#kernowResults$avePcs <- scale(kernowResults$aveP, center = TRUE, scale = TRUE)
#kernowResults$aveInfCS <- scale(kernowResults$aveInf, center = TRUE, scale = TRUE)
#kernowResults$aveLikCS <- scale(kernowResults$aveLik, center = TRUE, scale = TRUE)

#write.csv(kernowResults,"kernowResults.csv", row.names = FALSE)

kernowResults <- read.csv("kernowResults.csv")


##### Full Model: 

nominatedFull <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + score*ScoreCS + conf*OverCS + 
          prestige*avePcs + Dominance*aveDcs + infR*aveInfCS + lik*aveLikCS + 
          infl*initial_influential + inLearn*initial_learn + 
          age*AgeCS + sex*Sex + a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        c(score, conf, prestige, Dominance, infR, lik, infl, inLearn, age, sex) ~ dnorm(0,1)
  ),
  data=kernowResults, 
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nominatedFull)
plot(precis(nominatedFull))
plot(precis(nominatedFull), 
     pars = c("infR","score","sex", "conf", "prestige", "Dominance","lik","infl","inLearn","age"),
     labels = c("Age","Learning model","initially Influential","Likeability","Dominance","Prestige","Confidence","Sex","Score","Influence"), xlab="Parameter Estimate")


#             mean   sd  5.5% 94.5% n_eff Rhat
# a         -1.54 0.40 -2.18 -0.91  1577    1
# sigma_g    0.08 0.06  0.01  0.19  1800    1
# score      0.78 0.32  0.27  1.30  1800    1
# conf       0.24 0.29 -0.23  0.69  1800    1
# prestige  -0.22 0.42 -0.90  0.45  1800    1
# Dominance  0.23 0.31 -0.26  0.72  1800    1
# infR       1.50 0.38  0.94  2.15  1800    1
# lik       -0.13 0.36 -0.70  0.44  1800    1
# infl      -0.27 0.64 -1.30  0.71  1800    1
# inLearn    0.42 0.70 -0.69  1.55  1800    1
# age        0.00 0.29 -0.46  0.47  1800    1
# sex       -1.00 0.49 -1.77 -0.18  1800    1

####### Null Model: 


nominatedNull <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + 
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nominatedNull)


######## Prestige predicts nominations:


nomPres <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + 
          prestige*avePcs +
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        prestige ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomPres)

######### Dominance predicts nominations:


nomDom <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + 
          Dominance*aveDcs +
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        Dominance ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomDom)

########### Likeability predicts nominations: 


nomLik <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + lik*aveLikCS + 
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        lik ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomLik)

######## Influence on the task: 


nomInf <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + infR*aveInf + 
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        infR ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomInf)


########## Previously influential:


nomPrevious <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + infl*initial_influential + inLearn*initial_learn + 
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        c(infl, inLearn) ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomPrevious)

compare(nominatedNull, nominatedFull, nomDom, nomPres, nomInf, nomLik, nomPrevious)

############# EXPLORATORY: Score & Overconf? 


nomSCORE <- map2stan(
  alist(Nominated ~ dbinom(1,p),
        logit(p) <- a + score*ScoreCS + oconf*OverCS + 
          a_g[GroupID]*sigma_g,
        a ~ dnorm(0,1),
        a_g[GroupID] ~ dnorm(0,1),
        sigma_g ~ normal(0,0.1),
        c(score, oconf) ~ dnorm(0,1)
  ),
  data=kernowResults,
  constraints = list(sigma_g = "lower=0"),
  control=list(adapt_delta=0.99, max_treedepth=13),
  chains = 3, cores = 3, iter = 1200)

precis(nomSCORE)
compare(nominatedNull, nominatedFull, nomDom, nomPres, nomInf, nomLik, nomPrevious, nomSCORE)

#               WAIC pWAIC dWAIC weight    SE   dSE
#nominatedFull 108.6   9.2   0.0      1 13.43    NA
#nomSCORE      122.8   2.9  14.3      0 13.22  9.20
#nomInf        130.3   1.3  21.7      0 11.00  9.97
#nomDom        138.6   1.9  30.0      0 12.64 11.92
#nomPrevious   138.9   2.5  30.3      0 12.59 10.99
#nominatedNull 140.6   1.1  32.0      0 12.37 11.44
#nomPres       141.0   2.0  32.4      0 12.68 11.46
#nomLik        142.7   2.3  34.1      0 12.78 11.59


