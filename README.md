Download SRTM elevation maps locally and load them into R.


Install the SRTM package from Github:

```r
require(devtools)
install_github('jsga/SRTM_maps_in_R')
```

Load the library, download the elevation maps around mount Everest and plot them:

```r
library(SRTM)
everest =  get_srtm_raster(lon = 86.922623, lat = 27.986065 ,
    exdir_srtm_hgt = "SRTM") 
# Takes a while the first time
# See downloaded .hgt files in SRTM/
raster::plot(everest)
```
