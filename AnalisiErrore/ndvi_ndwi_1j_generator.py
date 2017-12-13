import gdal
import os
from image_creator import *
#%reset -f
gdal.AllRegister()
# Prendo i driver del GeoTiff
driver = gdal.GetDriverByName("GTiff")
driver.Register()

pos00 = "U:/PaA/08_SMEX02/00_Input_data/NDVI_NDWI_originaliSMEX02_1july"
os.chdir(pos00)
rasterfile=gdal.Open("20020701_NDVI_NDWI_stk_NaN.tif")

gdal.AllRegister()
# Prendo i driver di ENVI
driver = gdal.GetDriverByName("ENVI")
driver.Register()
pos01 = "U:/PaA/08_SMEX02/00_Input_data/Classificata/ndvi_ndwi"
os.chdir(pos01)
classificata = gdal.Open("classificata_ndvi_ndwi_20020701")


pos_out = "U:/PaA/08_SMEX02/03_Simulazioni/ndvi_ndwi_1j"
out_name="ndvi_ndwi_1j"
image_creator(rasterfile,classificata,50,pos_out,out_name)
