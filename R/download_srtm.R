#' \code{download_srtm}
#' Download the SRTM maps and unzip them into the specified folder. Helper function to get_elevation_srtm()
#'
#' @param url_file Url where the SRTM maps are stored
#' @param destfile Given name of the file of the downloaded map
#' @param exdir_srtm_hgt Default: "SRTM/". Folder where the maps are downloaded and unzipped. The zip file is deleted and only the .hgt files are kept
#'
#' @return Nothing to return.
#'
#' @examples
#' library(SRTM)
#' download_srtm(url_file = SRTM_files_info$full_path[1],
#'               destfile = SRTM_files_info$name_file[1] )
#' # See downloaded file in SRTM/N00E006.hgt
#'
#' @seealso \code{\link{SRTM}}
#' @export
#' @author Javier Saez Gallego
#' @importFrom utils unzip
#' @importFrom utils download.file

download_srtm = function(url_file,destfile,exdir_srtm_hgt ="SRTM"){

  # Check if file exists. If so, do not download
  if( file.exists( paste0(exdir_srtm_hgt,"/",destfile,".hgt")) ){
    # Already exists
    TRUE
  }else{
    # Download
    download.file( url = url_file,destfile=destfile,mode="wb")
    # Unzip
    unzip(destfile,exdir = exdir_srtm_hgt)
    # Delete zip, keep only .hgt
    file.remove(destfile)
  }
}
