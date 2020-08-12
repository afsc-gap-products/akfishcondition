#' A function to compute length-weight residuals
#'
#' This function makes a log-log regression of length and weight for individual fish
#' and then calculates a residual.
#' @param length Set of individual fish lengths
#' @param weight Corresponding set of individual fish weights
#' @param outlier.rm Should outliers be removed using Bonferoni test (cutoff = 0.7)
#' @keywords length, weight, groundfish condition
#' @export
#' @examples
#' lw.resids()

lw.resids<-function(length,weight,outlier.rm=FALSE){
# For testing
# length<-tempdata$LENGTH
# weight<-tempdata$WEIGHT
# outlier.rm<-TRUE
  
  require(car)
  loglength<-log(length)
  logwt<-log(weight)
    lw.res<-lm(logwt~loglength)
  #Assessing Outliers using Bonferoni Outlier Test
  #Identify if there are any outliers in your data that exceed cutoff = 0.05 (default)
  if(outlier.rm==TRUE){
  #outlierTest(lw.res,n.max=Inf)
    #QQ residual plot with SD's 
 # qqPlot(lw.res, main="QQ Plot") #qq plot for studentized resid
  #Produce a bonferoni value for each point in your data
  test1<-outlierTest(lw.res,n.max=Inf,cutoff=Inf,order=FALSE)$bonf.p 
  remove<-which(test1<.7,)
	print("Outlier rows removed")
	print(unname(remove))
  logwt[remove]<-NA
  lw.res<-lm(logwt~loglength,na.action=na.exclude)
  lw.res<-residuals(lw.res) 
  }
    
 if(outlier.rm==FALSE){ lw.res<-residuals(lw.res)}
  return(lw.res)}

#' A function to weight length-weight residuals by catch
#'
#' This function weights length-weight residuals by a catch column. This
#' catch can be CPUE from the tow where the fish was caught (most common) or
#' stratum CPUE or biomass. 
#' @param year Year of sample must be the same length as the residuals
#' @param residual Residual that will be weighted by catch
#' @param catch Catch for weighting residual (default = 1) must be the same length as residuals
#' @keywords length, weight, groundfish condition
#' @export
#' @examples
#' weighted_resids()

weighted_resids<-function(year, residuals, catch=1){
wtlw.res<-residuals
if(length(catch)==1){catch<-rep(1,length(residuals))}
years1<-unique(year)
for(i in 1:length(years1)){
d0<-which(year==years1[i])
d1<-residuals[d0]
d2<-catch[d0]
 var1<-d1*d2
 var2<-sum(d2)
 var3<-var1/var2*length(d2)
wtlw.res[d0]<-var3}
return(wtlw.res)}





