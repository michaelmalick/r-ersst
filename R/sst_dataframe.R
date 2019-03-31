#' @title Convert SST data array to a data.frame
#'
#' @description
#'      Takes input SST data output from \code{\link{sst_load}} and spatially
#'      subsets the array.
#'
#' @param data
#'      list of SST data output from \code{\link{sst_load}}
#' @param na.rm
#'      logical, should cells with NA sst values be removed
#'
#' @return
#'     A data.frame with columns:
#'     \itemize{
#'        \item{year: vector of years}
#'        \item{month: vector of months}
#'        \item{lon: vector of longitudes}
#'        \item{lat: vector of latitudes}
#'        \item{id: unique grid cell id}
#'        \item{sst: sst data}
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
#'      xdf <- sst_dataframe(x)
#'    e xdf <- sst_dataframe(x, na.rm = TRUE)
#'
#' }
sst_dataframe <- function(data, na.rm = FALSE) {

    lat      <- data$lat
    lon      <- data$lon
    n        <- length(data$year)
    sst.list <- vector("list", n)

    for(i in 1:n) {

        i.year  <- data$year[i]
        i.month <- data$month[i]
        i.sst   <- data$sst[ , , i]

        sst.df        <- as.data.frame(i.sst)
        names(sst.df) <- lat
        sst.df$lon    <- lon

        sst.long <- stats::reshape(sst.df,
                            direction = "long",
                            varying   = names(sst.df)[names(sst.df) != "lon"],
                            v.names   = "sst",
                            times     = lat,
                            timevar   = "lat")
        row.names(sst.long) <- NULL
        sst.long$year  <- i.year
        sst.long$month <- i.month
        sst.long$id    <- 1:length(sst.long$year)

        sst.list[[i]] <- sst.long
    }

    out    <- do.call("rbind", sst.list)
    out.df <- data.frame(year  = out$year,
                         month = out$month,
                         lon   = out$lon,
                         lat   = out$lat,
                         id    = out$id,
                         sst   = out$sst)
    if(na.rm) {
        out.df <- out.df[stats::complete.cases(out.df), ]
        row.names(out.df) <- NULL
    }
    return(out.df)
}
