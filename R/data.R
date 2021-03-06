#' Coolection of links and metadata about the individuals SRTM3 maps.
#'   See 'data-raw/' for details on its generation
#'
#' @format A data frame with 14546 rows and 6 variables:
#' \describe{
#'   \item{full_path}{ URl where the file is stored}
#'   \item{name_file}{Name of the .hgt file}
#'   \item{NS}{Either N (North) or S (South) empishere}
#'   \item{coorNS}{Coordinate number, integer}
#'   \item{WE}{Either W (West) or E (East) side of the Earth}
#'   \item{coorWE}{Coordinate number, integer}
#' }
#' @source \url{https://dds.cr.usgs.gov/srtm/version2_1/SRTM3/}
#' @seealso \code{\link{SRTM}}
#' @author Javier Saez Gallego
"SRTM_files_info"
