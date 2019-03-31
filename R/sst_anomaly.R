#' @title Compute monthly grid cell specific SST anomalies
#'
#' @description
#'      Anomalies are calculated as the difference between a grid cell specific
#'      SST value for a given year/month and the long-term monthly mean (defined
#'      by ref.years) for that grid cell. This follows the methods outlined in
#'      Mueter et al. 2002, Canadian Journal of Fisheries and Aquatic Sciences.
#'
#' @param data
#'      list of SST data output from \code{\link{sst_load}}
#'
#' @param ref.years
#'      years over which to calculate the long-term average,
#'      years must be contained in input data
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
#'      xa <- sst_anomaly(x, ref.years = 1950)
#' }
sst_anomaly <- function(data, ref.years) {

    if(sum(ref.years %in% data$year) != length(ref.years))
        stop("ref.years not contained in input data")

    u.months <- unique(data$month)
    n.months <- length(u.months)
    n.years  <- length(unique(data$year))

    if((n.years * n.months) != dim(data$sst)[3])
        stop("Not equal number of months in all year")

    ## 1. subset data for reference years
    sst.ref <- sst_subset_time(data,
                               years = ref.years,
                               months = u.months)

    ## 2. create empty array to hold monthly long-term averages
    ar.ref <- array(NA, dim = c(length(sst.ref$lon),
                                length(sst.ref$lat),
                                n.months))

    ## 3. calculate monthly long-term means for each grid cell
    for(i in u.months) {
        ind <- which(u.months == i)
        ar.ref[ , , ind] <- apply(sst.ref$sst[ , , which(sst.ref$month == i)],
                                  c(1, 2), mean, na.rm = TRUE)
    }

    ## 4. create empty array to hold monthly anomalies
    ar.out <- array(NA, dim = c(length(data$lon),
                                length(data$lat),
                                length(data$month)))

    ## 5. calculate monthly anomalies for each grid cell
    for(i in seq_along(data$month)) {
        i.ref <- which(unique(data$month) == data$month[i])
        ar.out[ , , i] <- data$sst[ , , i] - ar.ref[ , , i.ref]
    }

    ## 6. create list with anomalies, lat, lon, and time indices
    out <- list(lon   = data$lon,
                lat   = data$lat,
                year  = data$year,
                month = data$month,
                sst   = ar.out,
                version = data$version)
    return(out)
}
