rm(list=ls())
memory.size(max=T)
##Create MAP of SMC having a model
sim_num=5
for(i in 1:sim_num){
  ##LANDSAT=optional file
  LANDSAT="U:/PaA/08_SMEX02/03_Simulazioni/Landsat1j/"
  setwd(LANDSAT)
  lista=dir()
  lista=lista[which(substr(lista,nchar(lista)-3,nchar(lista))!=".hdr")]
  LANDSAT=paste(LANDSAT,lista[i],sep="")
  ##NDVI_NDWI= optional file
  NDVI_NDWI="U:/PaA/08_SMEX02/03_Simulazioni/ndvi_ndwi_1j/"
  setwd(NDVI_NDWI)
  lista=dir()
  lista=lista[which(substr(lista,nchar(lista)-3,nchar(lista))!=".hdr")]
  NDVI_NDWI=paste(NDVI_NDWI,lista[i],sep="")  
  ##DEM=optional file
  DEM="U:/PaA/08_SMEX02/00_Input_data/DEM/DEM_stk_has"
  ##SAR=optional fileü
  SAR="U:/PaA/08_SMEX02/03_Simulazioni/Airsar1j/"
  setwd(SAR)
  lista=dir()
  lista=lista[which(substr(lista,nchar(lista)-3,nchar(lista))!=".hdr")]
  SAR=paste(SAR,lista[i],sep="")
  ##TWI=optional file
  TWI="U:/PaA/08_SMEX02/00_Input_data/TWI/TWI"
  print(c(" riga 25",toString(i)))
  Band_1_layer=T
  Band_2_layer=T
  Band_3_layer=T
  Band_4_layer=T
  Band_5_layer=T
  Band_7_layer=T
  NDVI_layer=T
  NDWI_layer=T
  height_layer=F
  aspect_layer=F
  slope_layer=F
  C_HH_layer=F
  C_VV_layer=F
  C_HV_layer=F
  C_VH_layer=F
  L_HH_layer=T
  L_VV_layer=T
  L_HV_layer=T
  L_VH_layer=T
  TWI_layer=F
  
  Model_File="U:/PaA/08_SMEX02/01_SVR_SMC/Modelli/allBands_NDVI_NDWI_Lfull/QGIS_SVR_model.dat"
  
  Output_nome=paste("1july2002_smc",substr(SAR,nchar(SAR)-4,nchar(SAR)),sep="")
  Output_Directory="U:/PaA/08_SMEX02/03_Simulazioni/SMC/1july"
  
  
  # Check if all the required libraries are installed, otherwise download
  list.of.packages <- c("raster",
                        "gbm",
                        "caret",
                        "ggplot2",
                        "foreach",
                        "doSNOW",
                        "kernlab")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if (length(new.packages)) install.packages(new.packages)
  
  library(raster)
  library(gbm)
  library(kernlab)
  library(caret)
  library(ggplot2)
  library(foreach)
  library(doSNOW)
  #library(kernlab)
  print(c(" riga 72",toString(i)))
  #function definition for parallel SMC predictions
  parallel_predictions<-function(fit,testing)
  {
    cl<-makeCluster(4)
    registerDoSNOW(cl)
    num_splits<-4
    split_testing<-sort(rank(1:nrow(testing))%%4)
    predictions<-foreach(i=unique(split_testing),
                         .combine=c,.packages=c("caret", "kernlab")) %dopar% {
                           as.numeric(predict(fit,newdata=testing[split_testing==i,]))
                         }
    stopCluster(cl)
    return(predictions)
  }
  
  #script for the production of smc maps
  # -------------------------------------------------------
  
  # -------------------------------------------------------
  # Initiate required datasets
  # -------------------------------------------------------
  
  # initiate data stack
  data_stack <- stack()
  #BASE GEOGRAFICA
  if (SAR != '') {
    hh <- raster(SAR,1)
  }
  
  
  #  LANDSAT 7 BANDS
  if (LANDSAT != '') {
    BAND1 <- raster(LANDSAT,1)
    BAND1res <- resample(BAND1, hh, method="bilinear")
    remove(BAND1)
    
    if(Band_1_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND1res)
    }
    
    
    BAND2<- raster(LANDSAT,2)
    BAND2res <- resample(BAND2, hh, method="bilinear")
    remove(BAND2)
    
    if(Band_2_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND2res)
    }
    
    
    BAND3 <- raster(LANDSAT,3)
    BAND3res <- resample(BAND3, hh, method="bilinear")
    remove(BAND3)
    
    if(Band_3_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND3res)
    }
    
    
    
    BAND4 <- raster(LANDSAT,4)
    BAND4res <- resample(BAND4, hh, method="bilinear")
    remove(BAND4)
    
    if(Band_4_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND4res)
    }
    
    
    BAND5 <- raster(LANDSAT,5)
    BAND5res <- resample(BAND5, hh, method="bilinear")
    remove(BAND5)
    
    if(Band_5_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND5res)
    }
    
    
    BAND7 <- raster(LANDSAT,6)
    BAND7res <- resample(BAND7, hh, method="bilinear")
    remove(BAND7)
    
    if(Band_7_layer==TRUE){
      data_stack <- addLayer(data_stack, BAND7res)
    }
    
    
  }
  
  #NDVI NDWI
  if (NDVI_NDWI != '') {
    ndvi <- raster(NDVI_NDWI, band=1) # NDVI
    ndwi <- raster(NDVI_NDWI, band=2) # NDWI
    
    NDVIres <- resample(ndvi, hh)
    NDWIres <- resample(ndwi, hh)
    if(NDVI_layer==TRUE){
      data_stack <- addLayer(data_stack, NDVIres)
    }
    if(NDWI_layer==TRUE){
      data_stack <- addLayer(data_stack, NDWIres)
    }
    
    
    
  }
  # DEM
  if (DEM != '') {
    slp <- raster(DEM, band=3) # Slope
    asp <- raster(DEM, band=2) # Aspect
    hgt <- raster(DEM, band=1) # Height
    slpres <- resample(slp, hh)
    aspres <- resample(asp, hh)
    hgtres <- resample(hgt, hh)
    remove(slp, asp, hgt)
    
    if(height_layer==TRUE){
      data_stack <- addLayer(data_stack, hgtres)
    }
    if(slope_layer==TRUE){
      data_stack <- addLayer(data_stack, slpres)
    }
    if(aspect_layer==TRUE){
      data_stack <- addLayer(data_stack, aspres)
    }
    
    
  }
  
  # SAR dataset
  hhc <- raster(SAR,1)
  if(C_HH_layer==TRUE){
    data_stack <- addLayer(data_stack, hhc)
  }
  
  vvc <- raster(SAR,2)
  if(C_VV_layer==TRUE){
    data_stack <- addLayer(data_stack, vvc)
  }
  
  hvc <- raster(SAR,3)
  if(C_HV_layer==TRUE){
    data_stack <- addLayer(data_stack, hvc)
  }
  
  vhc <- raster(SAR,4)
  if(C_VH_layer==TRUE){
    data_stack <- addLayer(data_stack, vhc)
  }
  
  hhl <- raster(SAR,5)
  if(L_HH_layer==TRUE){
    data_stack <- addLayer(data_stack, hhl)
  }
  
  vvl <- raster(SAR,6)
  if(L_VV_layer==TRUE){
    data_stack <- addLayer(data_stack, vvl)
  }
  
  hvl <- raster(SAR,7)
  if(L_HV_layer==TRUE){
    data_stack <- addLayer(data_stack, hvl)
  }
  
  vhl <- raster(SAR,8)
  if(L_VH_layer==TRUE){
    data_stack <- addLayer(data_stack, vhl)
  }
  
  
  if (TWI != '') {
    twin <- raster(TWI)
    twires <- resample(twin, hh, method="bilinear")
    remove(twin)
    
    if(TWI_layer==TRUE){
      data_stack <- addLayer(data_stack, twires)
    }
    
    
  }
  
  
  print(c(" riga 257",toString(i)))
  # DEM
  #if (DEM != '') {
  #slp <- raster(DEM, band=1) # Slope
  #asp <- raster(DEM, band=2) # Aspect
  #hgt <- raster(DEM, band=3) # Height
  #slpres <- resample(slp, hh)
  #aspres <- resample(asp, hh)
  #hgtres <- resample(hgt, hh)
  #remove(slp, asp, hgt)
  #data_stack <- addLayer(data_stack, hgtres)
  #data_stack <- addLayer(data_stack, slpres)
  #data_stack <- addLayer(data_stack, aspres)
  #}
  
  
  
  
  #------------------------------------------------------------
  #Estimate soil moisture
  #------------------------------------------------------------
  
  # Initialise SMC map (sampe extent/resolution as SAR input data)
  smc_map <- raster(nrows=nrow(data_stack),
                    ncols=ncol(data_stack),
                    vals=-1,
                    ext=extent(data_stack),
                    crs=crs(data_stack))
  # load SVR model
  load(Model_File)
  
  # convert image stack to matrix
  data_stack_mat <- as.matrix(data_stack)
  smc_vector <- parallel_predictions(mod, data_stack_mat)
  remove(data_stack_mat)
  gc()
  
  smc_matrix <- matrix(data=smc_vector, nrow=nrow(data_stack), ncol=ncol(data_stack), byrow=TRUE)
  smc_map[,] <- smc_matrix
  
  # writeRaster(smc_map, Output_File, 'GTiff')
  print(c(" riga 298",toString(i)))
  #Output_File <- smc_map
  setwd(Output_Directory)
  rnc <- writeRaster(smc_map, filename=Output_nome, format="ENVI",bylayer=F, overwrite=TRUE)
  print(c(" riga 302",toString(i)))
  #rnc <- writeRaster(data_stack, filename="datastk_out", format="ENVI",bylayer=T, overwrite=TRUE)
  a=ls()
  a=a[which(a!="sim_num" & a!="i")]
  rm(list = a)
  print(c(" riga 303",toString(i)))
  gc()
}

