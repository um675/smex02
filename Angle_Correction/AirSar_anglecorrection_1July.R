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
pos1="U:/PaA/08_SMEX02/cm6539"
setwd(pos1)

meta_1j="meta1j.csv"
info_1j=read.csv(meta_1j,header=F,sep=";")
info_1j=as.matrix(info_1j)
H=info_1j[55,2]
H=as.double(H)
R=info_1j[76,2]
R=as.double(R)
P=info_1j[10,2]
P=as.double(P)

pos2="U:/PaA/08_SMEX02/AiRSAR data decomp/20020701_sar"
setwd(pos2) 

fn_CL_1july02="C-L_1july02"
f_CL_1july02=brick(fn_CL_1july02)
nriga=nrow(f_CL_1july02)
ncolonne=ncol(f_CL_1july02)
nbande=nlayers(f_CL_1july02)
CL1j=values(f_CL_1july02)

teta=matrix(0,nriga,ncolonne)


for(j in 1:ncolonne){
  #teta[,j]=acos(H/(R+(j*P)))
  teta[,j]=(H/(R+(j*P))) #così ottengo il coseno di teta
} 

r_teta=raster(f_CL_1july02,1)
values(r_teta)=acos(teta)
sinteta=r_teta
values(sinteta)=sin(values(sinteta))

brk_1j_corr=f_CL_1july02
values(brk_1j_corr)=0

for(k in 1:nbande){
  
  sinlay=raster(f_CL_1july02,k)
  ground=sinlay
  values(ground)=values(ground)/values(sinteta)
  brk_1j_corr[[k]]=ground
  str_k=names(f_CL_1july02[[k]])
  #fileout01=paste("1july02_",str_k,sep="")
  #rnc <- writeRaster(ground, filename=fileout01, format="ENVI", overwrite=TRUE)
  rm(sinlay,ground)
  
}

# pos3="C:\\00_temp_wip"
# setwd(pos3)
# bbb=brk_1j_corr


#memory.size(max=9000000)
setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020701_sar/01_angle_correction_ground")
rnc <- writeRaster(brk_1j_corr, filename="1julybrkcorr", format="ENVI",bylayer=F, overwrite=TRUE)

setwd("U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020701_sar/00_angle_theta")
rnc <- writeRaster(r_teta, filename="theta_1j", format="ENVI",bylayer=F, overwrite=TRUE)


#dati generati per effettuare eventuali controlli
q=1
M1=(raster(f_CL_1july02,q))
M2=(raster(brk_1j_corr,q))

tM1=values(M1)
M2=values(M2)
M3=values(r_teta)

M1=matrix(M1,nrow=nriga,ncol=ncolonne)
M2=matrix(M2,nrow=nriga,ncol=ncolonne)
M3=matrix(M3,nrow=nriga,ncol=ncolonne)






