library(sp)
library(raster)
library(Rgbp)
library(rgdal)
library(sn)
library(stats4)
library(mnormt)
library(GEOmap)
#library(PythonInR)
library(maptools)
library(mapproj)
library(geomapdata)
library(shapefiles)
library(tiff)
#library(Rquake)
#library(RSEIS)
rm(list=ls())
###### RECUPERO DATI #############
pos1="U:/PaA/08_SMEX02/cm6557"
setwd(pos1)

meta_5j="meta5j.csv"
info_5j=read.csv(meta_5j,header=F,sep=";")
info_5j=as.matrix(info_5j)
H=info_5j[57,2]
H=as.double(H)
R=info_5j[78,2]
R=as.double(R)
P=info_5j[10,2]
P=as.double(P)

pos2="U:/PaA/08_SMEX02/AiRSAR data decomp/20020705_sar"
setwd(pos2) 

fn_CL_5july02="C-L_5july02"
f_CL_5july02=brick(fn_CL_5july02)
nriga=nrow(f_CL_5july02)
ncolonne=ncol(f_CL_5july02)
nbande=nlayers(f_CL_5july02)
CL5j=values(f_CL_5july02)

teta=matrix(0,nriga,ncolonne)


for(j in 1:ncolonne){
  #teta[,j]=acos(H/(R+(j*P)))
  teta[,j]=(H/(R+(j*P))) #così ottengo il coseno di teta
} 

r_teta=raster(f_CL_5july02,1)
values(r_teta)=acos(teta)
sinteta=r_teta
values(sinteta)=sin(values(sinteta))

brk_5j_corr=f_CL_5july02
values(brk_5j_corr)=0

for(k in 1:nbande){
  
  sinlay=raster(f_CL_5july02,k)
  ground=sinlay
  values(ground)=values(ground)/values(sinteta)
  brk_5j_corr[[k]]=ground
  str_k=names(f_CL_5july02[[k]])
  #fileout01=paste("5july02_",str_k,sep="")
  #rnc <- writeRaster(ground, filename=fileout01, format="ENVI", overwrite=TRUE)
  rm(sinlay,ground)
  
}

# pos3="C:\\00_temp_wip"
# setwd(pos3)
# bbb=brk_5j_corr


#memory.size(max=9000000)
setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020705_sar/01_angle_correction_ground")
rnc <- writeRaster(brk_5j_corr, filename="5julybrkcorr", format="ENVI",bylayer=F, overwrite=TRUE)

setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020705_sar/00_angle_theta")
rnc <- writeRaster(r_teta, filename="theta_5j", format="ENVI",bylayer=F, overwrite=TRUE)


#dati generati per effettuare eventuali controlli
# q=1
# M1=(raster(f_CL_5july02,q))
# M2=(raster(brk_5j_corr,q))
# 
# tM1=values(M1)
# M2=values(M2)
# M3=values(r_teta)
# 
# M1=matrix(M1,nrow=nriga,ncol=ncolonne)
# M2=matrix(M2,nrow=nriga,ncol=ncolonne)
# M3=matrix(M3,nrow=nriga,ncol=ncolonne)
# 





