BF <- function(sd, obtained, dfdata = 1, likelihood = c("normal", "t"), modeloftheory= c("normal","t","cauchy", "uniform") ,lower =0, upper=1, modeoftheory = 0, scaleoftheory = 1, dftheory = 1, tail = 2) {

if(likelihood=="normal"){

dfdata=10^10

}

if(modeloftheory=="normal"){

dftheory = 10^10

} else if(modeloftheory=="cauchy"){

dftheory = 1

}

area <- 0

normarea <- 0

if(modeloftheory=="uniform"){

theta <- lower

range <- upper - lower

incr <- range / 2000

for (A in -1000:1000){

theta <- theta + incr

dist_theta <- 1 / range

height <- dist_theta * dt((obtained-theta)/sd, df=dfdata)

area <- area + height * incr

}

LikelihoodTheory <- area

}else{

theta <- modeoftheory - 8 * scaleoftheory

incr <- scaleoftheory/200

for (A in -1600:1600){

theta <- theta + incr

dist_theta <- dt((theta-modeoftheory)/scaleoftheory, df=dftheory)

if(identical(tail, 1)){

if (theta <= modeoftheory){

dist_theta <- 0

} else {

dist_theta <- dist_theta * 2

}

}

height <- dist_theta * dt((obtained-theta)/sd, df = dfdata)

area <- area + height * incr

normarea <- normarea + dist_theta*incr

}

LikelihoodTheory <- area/normarea

}

Likelihoodnull <- dt(obtained/sd, df = dfdata)

BayesFactor <- LikelihoodTheory/Likelihoodnull

BayesFactor

}

BF_range <- function(sd, obtained, dfdata = 1, likelihood = c("normal", "t"),
modeloftheory= c("normal","t","cauchy") , meanoftheory = 0,
modeoftheory = 0, sdtheoryrange, dftheory = 1, tail = 1) {
x = c(0)
y = c(0)
# loop through all the values in given range and compute the BF
for(sdi in sdtheoryrange)
{
B = as.numeric(BF(sd = sd, obtained = obtained, dfdata = dfdata,
likelihood = likelihood,
modeloftheory = modeloftheory,
modeoftheory=modeoftheory,
scaleoftheory=sdi,
dftheory = dftheory, tail = tail))
if (sdi ==0 ) {B=1} # calculator returns NaN when sdtheory=0; change that return BF=1
x= append(x,sdi)
y= append(y,B)
output = cbind(x,y)
}
output = output[-1,]
colnames(output) = c("sdtheory", "BF")
return(output)
}
