# NOAA ERSST Data

An R package for downloading and processing NOAA ERSST data.


## Installation
The `ersst` package is not on CRAN, but can be installed from R using:

    install.packages("devtools")
    library(devtools)
    install_github(repo = "michaelmalick/r-ersst")
    library(ersst)


## Data notes

The full metadata for the SST data are located in the headers of the downloaded
SST netCDF files. The metadata can be viewed using the `ncdump` utility with the
`-h` flag.

- Data website (v5): <https://www.ncei.noaa.gov/products/extended-reconstructed-sst>
- Data files (v5):   <https://www.ncei.noaa.gov/pub/data/cmb/ersst/v5/netcdf/>
- Longitude: degrees east, specifies center of grid cell
- Latitude: degrees north, specifies center of grid cell


## Code notes

The functions in this package are designed to work with gridded SST data
using three dimensional R arrays, which are considerably more efficient than
using data frames, but require some extra care to make sure the proper info is
kept with the data. In order to keep both the array data and other info, e.g.,
vectors of years, months, latitude, and longitude, together, most functions in
this package expect as input (and output data as) a list with the following
elements:

    $lon    vector of longitudes, corresponds to the rows in the $sst array
    $lat    vector of latitudes, corresponds to the columns in the $sst array
    $year   vector of years, corresponds to the 3rd dimension of the $sst array
                i.e. there is one year for each matrix in the $sst array
    $month  vector of months, corresponds to the 3rd dimension of the $sst array
                i.e. there is one month for each matrix in the $sst array
    $sst    array of gridded sst data with dimension lon x lat x time
    $version version of ERSST data

The `sst_dataframe()` can be used to convert the array data into a 'tidy' data
frame, which can be easier to work with in other projects.


## License
MIT
