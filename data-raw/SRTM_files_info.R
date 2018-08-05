## ================
# Gather dataset SRTM_files_info

# Load libraries
library(xml2)
library(dplyr)
library(rvest)

# Get all the file names from the SRTM files
url = "https://dds.cr.usgs.gov/srtm/version2_1/SRTM3/";
page <- read_html(url)
sub_url = page %>% html_nodes('a') %>% html_attrs() %>% .[-1]

# Follow links 1-6, one per continent
for(i in 1:6){
  # Read subpage and get links
  url_sub = paste0(url, sub_url[[i]])
  page_sub <- read_html(url_sub)
  links = page_sub %>% html_nodes('a') %>% .[-1] %>% html_attrs() %>% unlist()

  # Return interesting stuff
  files_info_aux = data.frame(full_path = paste0(url_sub,links), # Return full path
                              name_file = as.character(substr(links,1,7)),
                              NS = as.character(substr(links,1,1)), # Coordinate
                              coorNS = as.numeric(substr(links,2,3)),
                              WE = as.character(substr(links,4,4)),
                              coorWE = as.numeric(substr(links,5,7)) ,
                              stringsAsFactors =F)
  # Save. Not very efficient but easy.
  if(i==1) files_info = files_info_aux
  if(i>1) files_info = rbind(files_info,files_info_aux)
}

# str(files_info)

# Save to a rda file
save(SRTM_files_info,file="data-raw/SRTM_files_info.rda")

