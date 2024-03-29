% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sst_download.R
\name{sst_download}
\alias{sst_download}
\title{Download monthly ERSST SST data in netCDF format}
\usage{
sst_download(years, months, save.dir, version, method = "auto", mode = "wb")
}
\arguments{
\item{years}{vector of years to download, all years should be > 1983, should be a
numeric sequence, ascending by 1}

\item{months}{vector of months to download (integers 1:12), should be a
numeric sequence, ascending by 1}

\item{save.dir}{path to directory to save downloads, if directory doesn't exist it will
be created}

\item{version}{numeric, version of SST data to download}

\item{method}{method for file download, see \code{\link{download.file}}}

\item{mode}{mode for file download, see \code{\link{download.file}}}
}
\value{
function is only useful for the side effect of downloading data
}
\description{
Download NOAA ERSST data and saves it to disk in netCDF format. Function
     uses the utils::download.file function internally to download files.
}
\details{
Filename convention of downloaded data:
    \itemize{
       \item{ersst.VERSION.yyyymm.nc}
       \item{yyyy=four digit year}
       \item{mm=two digit month}
     }
}
\examples{
\dontrun{
     sst_download(1950, 1:5, "./sst/", version = 5)
}
}
\seealso{
\code{\link[utils]{download.file}}
}
\author{
Michael Malick
}
