#' @title Spatially subset SST data
#'
#' @description
#'      Takes input SST data output from \code{\link{sst_load}} and spatially
#'      subsets the array.
#'
#' @param data
#'      list of SST data output from \code{\link{sst_load}}
#'
#' @param lat.min
#'      minimum latitude (inclusive)
#' @param lat.max
#'      maximum latitude (inclusive)
#' @param lon.min
#'      minimum longitude (inclusive)
#' @param lon.max
#'      maximum longitude (inclusive)
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
#'      xs <- sst_subset_space(x,
#'                             lat.min = 20,
#'                             lat.max = 80,
#'                             lon.min = 130,
#'                             lon.max = 260)
#'
#' }
sst_subset_space <- function(data,
                             lat.min,
                             lat.max,
                             lon.min,
                             lon.max) {

    lat.sub.ind <- which(data$lat >= lat.min & data$lat <= lat.max)
    lon.sub.ind <- which(data$lon >= lon.min & data$lon <= lon.max)

    out <- list(lon   = data$lon[lon.sub.ind],
                lat   = data$lat[lat.sub.ind],
                year  = data$year,
                month = data$month,
                sst   = data$sst[lon.sub.ind, lat.sub.ind, ],
                version = data$version)
    return(out)
}
