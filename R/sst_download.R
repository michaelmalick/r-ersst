#' @title Download monthly ERSST SST data in netCDF format
#'
#' @description
#'      Download NOAA ERSST data and saves it to disk in netCDF format. Function
#'      uses the utils::download.file function internally to download files.
#'
#' @param years
#'      vector of years to download, all years should be > 1983, should be a
#'      numeric sequence, ascending by 1
#'
#' @param months
#'      vector of months to download (integers 1:12), should be a
#'      numeric sequence, ascending by 1
#'
#' @param save.dir
#'      path to directory to save downloads, if directory doesn't exist it will
#'      be created
#'
#' @param version
#'      numeric, version of SST data to download
#'
#' @param method
#'      method for file download, see \code{\link{download.file}}
#'
#' @param mode
#'      mode for file download, see \code{\link{download.file}}
#'
#' @return
#'      function is only useful for the side effect of downloading data
#'
#' @details
#'   Filename convention of downloaded data:
#'     \itemize{
#'        \item{ersst.VERSION.yyyymm.nc}
#'        \item{yyyy=four digit year}
#'        \item{mm=two digit month}
#'      }
#'
#' @export
#'
#' @author Michael Malick
#'
#' @seealso \code{\link[utils]{download.file}}
#'
#' @examples
#' \dontrun{
#'      sst_download(1950, 1:5, "./sst/", version = 5)
#' }
sst_download <- function(years, months, save.dir, version,
                         method = "auto", mode = "wb") {

    if(length(years) != length(min(years):max(years)))
        stop("years vector is not a sequence ascending by 1")

    if(length(months) != length(min(months):max(months)))
        stop("months vector is not a sequence ascending by 1")

    if(!dir.exists(save.dir)) {
        dir.create(save.dir, recursive = TRUE)
    }

    cnt <- 0
    for(i in years) {

        for(j in months) {

            if(j < 10) j <- paste("0", j, sep = "")

            web <- paste("https://www.ncei.noaa.gov/pub/data/cmb/ersst/v", version,
                         "/netcdf/ersst.v", version, ".", i, j, ".nc", sep = "")

            fname <- paste(save.dir, "ersst.v", version, ".", i, j, ".nc", sep = "")

            if(file.exists(fname) == FALSE) {
                utils::download.file(web, destfile = fname,
                                     method = method, mode = mode)
                cnt <- cnt + 1
            }
        }
    }

    ## check if all data files were downloaded
    n.possible <- length(years) * length(months)
    n.exist    <- length(list.files(save.dir))
    cat(cnt, "files downloaded of", n.possible, "requested", "\n")
    cat(n.exist, "files exist in", save.dir, "\n")
}
