#' @title Temporally subset SST data
#'
#' @description
#'      Takes input SST data output from \code{\link{sst_load}} and temporally
#'      subsets the array.
#'
#' @param data
#'      list of SST data output from \code{\link{sst_load}}
#'
#' @param years
#'      vector of years to subset
#'
#' @param months
#'      vector of months to subset (integers 1:12)
#'
#' @return
#'     A list with elements:
#'     \itemize{
#'        \item{lon: vector of longitudes}
#'        \item{lat: vector of latitudes}
#'        \item{year: vector of years}
#'        \item{month: vector of months}
#'        \item{sst: 3D array of SST anomalies}
#'        \item{version: numeric, version of SST data}
#'      }
#'
#' @export
#'
#' @author Michael Malick
#'
#' @seealso \code{\link{sst_load}}
#'
#' @examples
#' \dontrun{
#'      sst_download(1950, 1:5, "./sst/", version = 5)
#'      x <- sst_load(1950, 1:5, "./sst/", version = 5)
#'      xs <- sst_subset_time(x, 1950, 3)
#'      filled.contour(x = xs$lon, y = xs$lat, z = xs$sst[ , , 1])
#' }
sst_subset_time <- function(data, years, months) {

    ind  <- which(data$month %in% months & data$year %in% years)

    out <- list(lon   = data$lon,
                lat   = data$lat,
                year  = data$year[ind],
                month = data$month[ind],
                sst   = data$sst[ , , ind],
                version = data$version)
    return(out)
}
