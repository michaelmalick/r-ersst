% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sst_subset_space.R
\name{sst_subset_space}
\alias{sst_subset_space}
\title{Spatially subset SST data}
\usage{
sst_subset_space(data, lat.min, lat.max, lon.min, lon.max)
}
\arguments{
\item{data}{list of SST data output from \code{\link{sst_load}}}

\item{lat.min}{minimum latitude (inclusive)}

\item{lat.max}{maximum latitude (inclusive)}

\item{lon.min}{minimum longitude (inclusive)}

\item{lon.max}{maximum longitude (inclusive)}
}
\value{
A list with elements:
    \itemize{
       \item{lon: vector of longitudes}
       \item{lat: vector of latitudes}
       \item{year: vector of years}
       \item{month: vector of months}
       \item{sst: 3D array of SST anomalies}
       \item{version: numeric, version of SST data}
     }
}
\description{
Takes input SST data output from \code{\link{sst_load}} and spatially
     subsets the array.
}
\examples{
\dontrun{
     sst_download(1950, 1:5, "./sst/", version = 5)
     x <- sst_load(1950, 1:5, "./sst/", version = 5)
     xs <- sst_subset_space(x,
                            lat.min = 20,
                            lat.max = 80,
                            lon.min = 130,
                            lon.max = 260)

}
}
\seealso{
\code{\link{sst_load}}
}
\author{
Michael Malick
}
