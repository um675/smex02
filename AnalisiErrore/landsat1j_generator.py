import gdal
import os
from image_creator_landsat import *
#%reset -f
gdal.AllRegister()
# Prendo i driver del GeoTiff
driver = gdal.GetDriverByName("GTiff")
driver.Register()

pos00 = "U:/PaA/08_SMEX02/00_Input_data/LANDSAT_1july2002"
os.chdir(pos00)
rasterfile=gdal.Open("20020701_Landsat")

pos_out = "U:/PaA/08_SMEX02/03_Simulazioni/Landsat1j"
out_name="landsat1j"
image_creator_landsat(rasterfile,50,pos_out,out_name)
