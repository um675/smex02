library(sp)
library(raster)
library(Rgbp)
library(rgdal)
library(sn)
library(stats4)
library(mnormt)
library(GEOmap)
library(maptools)
library(mapproj)
library(geomapdata)
library(shapefiles)
library(tiff)
rm(list=ls())
memory.size(max=T)

# Questo script serve per correggere i dati airsar che avevo proiettato in ground range in maniera errata
# Per proiettare in ground range avevo diviso per il cos del local incidence angle (lia)
# Quindi ora moltiplichero per il cos del lia per tornare in slant range
# E successivamente dividero per il sen di lia per proiettare correttamente in round range
# L'ho fatto solo per il 1 July ma e' facile estenderlo alle altre date se dovesse servire


#1 July

setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020701_sar/Teta")
teta1j=raster("1july_teta_geo_clip")

setwd("U:/PaA/08_SMEX02/AiRSAR data decomp/20020701_sar/errati_in_groundrange/05_clippato_standard")
airsar1j=brick("1_July_brk_geo_clip.tif")

nbande=nbands(airsar1j)

for(i in 1:nbande){
  values(airsar1j[[i]])=(values(airsar1j[[i]]))*cos(values(teta1j)) #avevo erroneamente diviso per il cos di teta (pensando che cosi lo proiettavo in ground range) quindi ora moltiplico per tornare in slant range
  values(airsar1j[[i]])=(values(airsar1j[[i]]))/sin(values(teta1j)) #ora che sono tornato in slant range divido per il sen di teta per proiettare in ground range

}

setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020701_sar")
rnc <- writeRaster(airsar1j, filename="20020701_AirSAR", format="ENVI",bylayer=F, overwrite=TRUE)



