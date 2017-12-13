import gdal
import os
from image_creator_airsar import *
#%reset -f
gdal.AllRegister()
# Prendo i driver del GeoTiff
driver = gdal.GetDriverByName("ENVI")
driver.Register()

pos00 = "U:/PaA/08_SMEX02/00_Input_data/AirSAR/20020701_sar/04_clippato"
os.chdir(pos00)
rasterfile=gdal.Open("1_July_brk_geo_clip.envi")

pos_out = "U:/PaA/08_SMEX02/03_Simulazioni/Airsar1j"
out_name="airsar1j"

pos01 = "U:/PaA/08_SMEX02/00_Input_data/Classificata/airsar"
os.chdir(pos01)
classC=gdal.Open("C_classificata_1j")
classL=gdal.Open("L_classificata_1j")


image_creator_airsar(rasterfile,classC,classL,50,pos_out,out_name)