#' @title Load downloaded ERSST data into R
#'
#' @description
#'      Load SST data in netCDF file format into R
#'
#' @param years
#'      vector of years to download, all years should be > 1983, should be a
#'      numeric sequence, ascending by 1
#'
#' @param months
#'      vector of months to download (integers 1:12), should be a
#'      numeric sequence, ascending by 1
#'
#' @param read.dir
#'      path to directory to read sst data
#'
#' @param version
#'      numeric, version of SST data to download
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
#'      The SST array has dimensions: lon (rows) x lat (columns) x month/year
#'      (slices)
#'
#'      Each matrix/slice in the array is gridded SST data for a given month and
#'      year, which can be indexed using the $year and $month vectors in the
#'      list.
#'
#' @details
#'   Requires the \code{ncdf4} package to read data
#'
#' @export
#'
#' @author Michael Malick
#'
#' @seealso \code{\link{sst_download}}
#'
#' @examples
#' \dontrun{
#'      sst_download(1950, 1:5, "./sst/", version = 5)
#'      x <- sst_load(1950, 1:5, "./sst/", version = 5)
#'      filled.contour(x = x$lon, y = x$lat, z = x$sst[ , , 1])
#' }
sst_load <- function(years, months, read.dir, version) {

    if(length(years) != length(min(years):max(years)))
        stop("years vector is not a sequence ascending by 1")

    if(length(months) != length(min(months):max(months)))
        stop("months vector is not a sequence ascending by 1")

    n         <- length(years) * length(months)
    vec.year  <- sort(rep(years, length(months)))
    vec.month <- rep(months, length(years))
    sst.list  <- vector("list", n)

    for(i in 1:n) {

        i.year  <- vec.year[i]
        i.month <- vec.month[i]

        if(i.month < 10) i.month <- paste("0", i.month, sep = "")

        sst.ncdf.name  <- paste(read.dir, "ersst.v", version, ".", i.year,
                                i.month, ".nc", sep = "")
        sst.name  <- "sst"
        lat.name  <- "lat"
        lon.name  <- "lon"

        ## read in netcdf SST data
        sst.ncdf <- ncdf4::nc_open(sst.ncdf.name)
        dat.lat  <- ncdf4::ncvar_get(sst.ncdf, varid = lat.name)
        dat.lon  <- ncdf4::ncvar_get(sst.ncdf, varid = lon.name)
        dat.sst  <- ncdf4::ncvar_get(sst.ncdf, varid = sst.name)
        ncdf4::nc_close(sst.ncdf)

        ## replace missing values
        dat.sst[dat.sst < -9.98] <- NA

        ## save sst matrix to list
        sst.list[[i]] <- dat.sst
    }

    ## array: lon x lat x month
    sst <- array(do.call("c", sst.list),
                 dim = c(length(dat.lon),
                         length(dat.lat),
                         n))

    out <- list(lon   = dat.lon,
                lat   = dat.lat,
                year  = vec.year,
                month = vec.month,
                sst   = sst,
                version = version)
    return(out)
}
