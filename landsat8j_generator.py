import gdal
import os
from image_creator import *
#%reset -f
gdal.AllRegister()
# Prendo i driver del GeoTiff
driver = gdal.GetDriverByName("ENVI")
driver.Register()

pos00 = "U:/PaA/08_SMEX02/00_Input_data/LANDSAT_8july2002"
os.chdir(pos00)
rasterfile=gdal.Open("20020708_Landsat")

# gdal.AllRegister()
# # Prendo i driver di ENVI
# driver = gdal.GetDriverByName("ENVI")
# driver.Register()
pos01 = "U:/PaA/08_SMEX02/00_Input_data/Classificata/landsat"
os.chdir(pos01)
classificata = gdal.Open("classificata_20020708")


pos_out = "U:/PaA/08_SMEX02/03_Simulazioni/Landsat8j"
out_name="landsat8j"
image_creator(rasterfile,classificata,50,pos_out,out_name)