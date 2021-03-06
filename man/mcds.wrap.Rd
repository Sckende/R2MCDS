% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcds.wrap.R
\name{mcds.wrap}
\alias{mcds.wrap}
\title{Fit the distance sampling model provided by the Distance software.}
\usage{
mcds.wrap(dataset, path, pathMCDS, SMP_LABEL = "SMP_LABEL",
  SMP_EFFORT = "SMP_EFFORT", DISTANCE = "DISTANCE", SIZE = "SIZE",
  STR_LABEL = "STR_LABEL", STR_AREA = "STR_AREA", Type = c("Line",
  "Point", "Cue"), units = list(Distance = "Perp", Length_units =
  "Kilometer", Distance_units = "Meter", Area_units = "Square kilometer"),
  breaks = c(0, 50, 100, 200, 300), covariates = NULL, factor = NULL,
  lsub = NULL, stratum = NULL, split = TRUE, rare = NULL,
  period = NULL, detection = c("All", "Stratum"),
  monotone = c("Strict", "None", "Weak"), estimator = NULL,
  multiplier = NULL, empty = NULL, verbose = FALSE)
}
\arguments{
\item{dataset}{A \code{\link{data.frame}} with observations.}

\item{path}{The path where to store the input and output files of the MCDS engine.}

\item{pathMCDS}{The path where the MCDS engine is located.}

\item{SMP_LABEL}{Name of the column to use for the transect/watch label.}

\item{SMP_EFFORT}{Length in of the transect or the transect/watch unit.}

\item{DISTANCE}{Distance of the observation.}

\item{SIZE}{Number of individuals in the observation.}

\item{STR_LABEL}{Name of the column to use as a stratum label.}

\item{STR_AREA}{Name of the column to use for the stratum area.}

\item{Type}{Name of the type of transects \code{("Line", "Point", or "Cue")}. Default value is \coce{"Line"}.}

\item{units}{List of the units used for the analysis. Contains the Distance engine to use (\code{"Perp"} or \code{"Radial"}).
depending on the type of transects, the Length units, the Distance units, and the Area_units.
For the possible units of distance and area see Distance 7.0 documentation.}

\item{breaks}{A vector giving the distance intervals in meters to be used in the analysis.}

\item{covariates}{A vector giving the name of covariates.}

\item{factor}{A vector giving the name of factors to be used in the analysis.}

\item{lsub}{A named list giving the subsets to be used in the analysis. The names of the list are the names of columns used to subset the dataset.
Each element of the list is a vector giving the values to keep in the analysis for a given column. When a vector is \code{NULL},
all values are kept for this column. Default value \code{lsub = NULL}. See examples for further details.}

\item{stratum}{When \code{stratum = "STR_LABEL"}, the model will be stratified with the label.
When \code{stratum} is the name of a column in the data, the model will be
post-stratified according to this column (see Thomas et al. 2010). Default value
is \code{NULL}.}

\item{split}{When \code{split = TRUE}, separate models are ran according to the subsets determined by \code{lsub}. Default value \code{FALSE}.}

\item{rare}{This argument is used when a species has few observations to estimate a detection function.
The probability of detection is estimated from a group of similar species and a multiplier. A named list
has to be given, with the column name where species are stored as the name of the list and the name of the species as
an element (ex: \code{list(Species = "HERG")}). Default value \code{NULL}. See details.}

\item{period}{A vector of characters of length 2 containing the extreme dates for which the analysis
should be restricted. Dates have to be in the "yyyy-mm-dd" format.}

\item{detection}{Currently, set to \code{detection = "All"}. Can also be \code{detection = "Stratum"}. Default value is "All".}

\item{monotone}{Currently, set to \code{monotone = "Strict"}. Can also be \code{monotone = "Strict", "None", or "Weak"}. Default value is "Strict".}

\item{estimator}{When set to \code{NULL}, the following key functions and expansion terms will be used: UN-CO, UN-PO, HN-CO, HN-HE, HA-CO and HA-PO.
If the user wants to choose the key functions and the expansion terms used, a list has to be given with each element a vector of
length 2 with the first element the key function and the second element the expansion term (ex: \code{list(c("HN","CO"),c("HA","PO")}).
When \code{rare != NULL}, only one set is used (UN-CO) for the final specific model.}

\item{multiplier}{Value by which the estimates of density or abundance are multiplied. The first value is the multiplier, the second the SE and the third the degree of freedom associated with the multiplier (useful when using the probability of detection as a multiplier in a two-step analyses with the second step). Default value when \code{Type = "Line"} and \code{multiplier = NULL} is set to \code{multiplier = c(2,0,0)} meaning
only one-half of the transect is surveyed and the value is known with certainty with an infinite degree of freedom. When \code{rare != NULL}, the multiplier will be modified to account for the probability of detection. When \code{Type = "Point"} and \code{multiplier = NULL}, the multiplier is set to \code{multiplier = c(2,0,0)}. Values provided by the user will override these default settings.}

\item{empty}{Determine how empty transects are to be selected in the analysis. When \code{empty = NULL}, all
empty transects are included for every element of \code{lsub}. For example, when models are splitted according
to species, empty transects and transects where a species was not detected need to be considered in the analysis for that species.
When \code{lsub} contains geographic or temporal elements, empty transects need to be restricted to the subsets given. In this case,
a vector of character has to be given with the names in \code{lsub} for which the empty transects are to be restricted. When \code{split = TRUE}
and \code{empty != NULL}, empty transects will be splitted according to the names in \code{empty}. In any case, it is assumed that
the \code{dataset} contains at least a line for every transect executed, either with or without an observation. See examples for
further details.}

\item{verbose}{When set to \code{TRUE}, prints the input file given to the MCDS engine. Default value \code{FALSE}.}
}
\value{
An object of class \code{"distanceFit"}, when \code{split = FALSE}. When \code{split = TRUE} and \code{lsub != NULL},
a named list with the different models of class \code{"distanceFit"}.
Each object of class \code{"distanceFit"} is a named list with components \code{model_fitting}, \code{parameter_estimates},
\code{chi_square_test}, \code{density_estimate}, \code{detection} and \code{path}. Elements
of the list are accessible through the \code{$} operator. For each component
except \code{detection} and \code{path}, a \code{\link{list}} of length 2 is given with
component "\code{Global}" and "\code{Stratum}". Depending on the analysis chosen,
one of these component will be empty (\code{NULL}).
}
\description{
This function fits the distance sampling model provided by the Distance program using its MCDS engine.
}
\details{
Uses the MCDS engine from program Distance. The function produces an input file and submits it to the MCDS engine
through the \code{\link{system}} function. The results are then extracted from the output files and returned as a
list object.
}
\section{Author}{
Francois Rousseu, Christian Roy, Francois Bolduc
}

\examples{
####################################################################
### Simple models without stratification based on line transect data
### Import and filter data
data(alcidae)
alcids <- mcds.filter(alcidae,
                     transect.id = "WatchID",
                     distance.field = "Distance",
                     distance.labels = c("A", "B", "C", "D"),
                     distance.midpoints = c(25, 75, 150, 250),
                     effort.field = "WatchLenKm", lat.field = "LatStart",
                     long.field = "LongStart",
                     sp.field = "Alpha",
                     date.field = "Date") 

### Run analysis with the MCDS engine. Here, the WatchID is used as the sample.
dist.out1 <- mcds.wrap(alcids,
                      SMP_EFFORT="WatchLenKm",
                      DISTANCE="Distance",
                      SIZE="Count",
                      Type="Line",
                      units=list(Distance="Perp",
                                 Length_units="Kilometers",
                                 Distance_units="Meters",
                                 Area_units="Square kilometers"),
                      breaks=c(0,50,100,200,300),
                      estimator=list(c("HN","CO")),
                      STR_LABEL="STR_LABEL",
                      STR_AREA="STR_AREA",
                      SMP_LABEL="WatchID",
                      path="c:/temp/distance",
                      pathMCDS="C:/Distance 7.2",
                      verbose=FALSE)

summary(dist.out1)

### Run separate analysis for years 2008-2009
alcids$Year <- substr(alcids$Date, start = 1, stop = 4)
alcids$Year <- as.numeric(alcids$Year)

dist.out2 <- mcds.wrap(alcids,
                      SMP_EFFORT="WatchLenKm",
                      DISTANCE="Distance",
                      SIZE="Count",
                      Type="Line",
                      units=list(Distance="Perp",
                                 Length_units="Kilometers",
                                 Distance_units="Meters",
                                 Area_units="Square kilometers"),
                      breaks=c(0,50,100,200,300),
                      estimator=list(c("HN","CO")),
                      lsub=list(Year=c(2007,2008)),
                      split=TRUE,
                      empty="Year",
                      STR_AREA="STR_AREA",
                      SMP_LABEL="WatchID",
                      path="c:/temp/distance",
                      pathMCDS="C:/Distance 7.2",
                      verbose=FALSE)

### Get the names of the different models produced
names(dist.out2)

#####summary for the Year 2008 model
summary(dist.out2[["2008"]])

#'####################################################################
### Simple models without stratification based on point transect data
library(AHMbook)
#########################
# Data simulation  #
########################
ll <- list()
j <- 1:100
al <- sample(300:1000, max(j))
for (i in j){
 simu.data <- sim.pdata(N = al[i],
                        sigma = 1,
                        B = 3,
                        keep.all = TRUE,
                        show.plot = TRUE)
 print(simu.data$N.real)
 tmp <- sim.pdata(N = al[i],
                  sigma = 1,
                  keep.all = FALSE,
                  show.plot = FALSE)
 ll[[i]] <- tmp
}
delta <- 0.5 # Width of distance bins
B <- 3 # Max count distance
dist.breaks <- seq(0, B, delta) # Make the interval cut points
dclass <- lapply(ll, function(i){
 i$d \%/\% delta + 1
})
nD <- length(dist.breaks) - 1 # How many intervals do you have
DF <- data.frame()
for(i in 1:length(ll)){
 transect.id <- rep(paste("sp1", i, sep = ""), length(dclass[[i]]))
 d.field <- dclass[[i]]
 effort.field <- rep(1, length(dclass[[i]])) 
 lat.field <- rep(47.0, length(dclass[[i]]))
 long.field <- rep((-45.24 + i), length(dclass[[i]]))
 sp.field <- rep("Piou", length(dclass[[i]]))
 date.field <- rep("2019-03-15", length(dclass[[i]])) 
 Count <- rep(1, length(dclass[[i]]))
 real.abun <- rep(ll[[i]]$N.real, length(dclass[[i]]))
 dt <- data.frame(transect.id ,
                  d.field,
                  effort.field,
                  lat.field,
                  long.field,
                  sp.field,
                  date.field,
                  Count,
                  real.abun)
 DF <- rbind(DF, dt)
}
# Convert numerical distance value to categorical with letters
DF$distance.field <- LETTERS[DF$d.field]
DF$distance.field <- as.factor(DF$distance.field)
summary(DF)
###################
###### Model ######
###################
library(R2MCDS)
DF.1 <- mcds.filter(DF,
                   transect.id = "transect.id",
                   distance.field = "distance.field",
                   distance.labels <- c("A", "B", "C", "D", "E", "F"),
                   distance.midpoints <- c(0.25, 0.75, 1.25, 1.75, 2.25, 2.75),
                   effort.field = "effort.field",
                   lat.field = "lat.field",
                   long.field = "long.field",
                   sp.field = "sp.field",
                   date.field = "date.field")
### Run analysis with the MCDS engine.
mod1 <- mcds.wrap(DF1,
                 SMP_EFFORT="WatchLenKm",
                 DISTANCE="Distance",
                 SIZE="Count",
                 Type="Point",
                 units=list(Distance="Radial",
                            Length_units="Meters",
                            Distance_units="Meters",
                            Area_units="Square meters"),
                  breaks=c(0, 0.5, 1, 1.50, 2, 2.50, 3),
                  SMP_LABEL="WatchID",
                  STR_LABEL="STR_LABEL",
                  STR_AREA="STR_AREA",
                  estimator=list(c("HN","CO")),
                  multiplier = c(1, 0, 0),
                  path="c:/temp/distance",
                  pathMCDS="C:/Distance 7.2",
                  verbose=FALSE)
mod1
summary(mod1)
plot.distanceFit(mod1)
#END
}
\references{
Thomas, L., S.T. Buckland, E.A. Rexstad, J. L. Laake, S. Strindberg, S. L. Hedley, J. R.B. Bishop,
T. A. Marques, and K. P. Burnham. 2010. \emph{Distance software: design and analysis of distance sampling
surveys for estimating population size.} Journal of Applied Ecology 47: 5-14.
DOI: 10.1111/j.1365-2664.2009.01737.x
}
