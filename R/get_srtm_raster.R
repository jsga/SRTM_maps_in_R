#' \code{get_srtm_raster}
#' Given a pair of coordinates, find which SRTM file to download. Basically, find all the surrounding files and return them as a merged raster.
#'
#'
#' @param lat Latitude given in WGS84
#' @param lon Longitude given in WGS84
#' @param n Numbers of map tiles to gather around the specified coordinates. If n=1 (default), 9 tiles are merged, if n=2, 25 tiles are merged. In general, (2*n+1)^2 tiles are downloaded and merged so the computational time increases exponentially too. The length of the side of each tile is roughly 1 degree (approx 111km)
#' @param exdir_srtm_hgt Default: "SRTM/". Folder where the maps are downloaded and unzipped. The zip file is deleted and only the .hgt files are kept. The folder is created if it does not exist.
#'
#' @return Raster image containing merged SRTM files.
#'
#' @examples
#' # Download and plot maps around Mout Everest
#' library(SRTM)
#' everest =  get_srtm_raster(lon = 86.922623, lat = 27.986065 ,
#'     exdir_srtm_hgt = "SRTM") # Takes a while the first time
#' raster::plot(everest)
#'
#' @export
#' @seealso \code{\link{SRTM}}
#' @author Javier Saez Gallego
#' @importFrom  raster merge
#' @importFrom  raster raster
#' @import dplyr



get_srtm_raster = function(lon, lat, n=1, exdir_srtm_hgt = "SRTM"){


  ## ================
  # Check for the correct coordinates
  if( (lon < -180 | lon > 180) | (lat > 61 | lat < -57) ) {
    stop("Longitude must be in the range of [-180,180]. Latitude must be in the range of from [-56,60]")
  }

  # Check if the folder exists
  if( !dir.exists( file.path(exdir_srtm_hgt)) ){
    warning( paste0("Specified folder '", exdir_srtm_hgt,"' does not exists. Attempt to create it."))
    dir.create(file.path(exdir_srtm_hgt))
  }

  # Check the number of required tiles is positive integer
  if( ((n %% 1) != 0) | (n <=0)){
    stop("Parameter 'n' must be a positive integer")
  }
  # END check
  ## ================



  # Find the correspondin file
  if(lat>=0){
    ns = "N"
  }else{
    ns = "S"
    lat = -lat # Swap sign
  }

  if(lon >= 0){
    we = "E"
  }else{
    we = "W"
    lon = -lon # Swap sign
  }


  # Filter by NS-WE
  files_filtered = SRTM::SRTM_files_info %>% filter(NS == ns & WE == we)

  # Find closest files (use the latitude+lon difference to find them)
  file_center = files_filtered %>% slice(which.min(abs(files_filtered$coorNS - lat) + abs(files_filtered$coorWE - lon)))
  idx_select = which(files_filtered$coorNS %in% c(file_center$coorNS + seq(-n,n,length=2*n+1)) &
                       files_filtered$coorWE %in% c(file_center$coorWE + seq(-n,n,length=2*n+1)) )
  files_final = files_filtered %>% slice(idx_select)

  # Download the files from the web
  mapply(download_srtm,files_final$full_path, files_final$name_file, MoreArgs = list(exdir = exdir_srtm_hgt))

  # Load to raster files and merge
  r_aux = list()
  for(i in 1:length(files_final$name_file)){
    r_aux[[i]] = raster(paste0(exdir_srtm_hgt,'/',files_final$name_file[i],".hgt"))
  }
  srtm_map <- do.call(raster::merge, r_aux)

  # END. Return meged map.
  return(srtm_map)
}
