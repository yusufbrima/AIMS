#!/bin/bash

iyear=1931
fyear=1960
dir='/home/yusufbrima/Downloads/climate/'
outdir='/home/yusufbrima/Downloads/climate/output/'

mkdir -p $outdir
# select the period from 1931 to 1960
cdo selyear,${iyear}/${fyear} ${dir}/afr_cru_ts4.04.1928.2017.pre.mm.day.nc ${outdir}/afr_cru_1931_1960.nc

# compute annual mean from multi year monthly data  
# you could also compute annual/seasonal cycle by cdo ymonmean  
cdo yearmonmean ${outdir}/afr_cru_1931_1960.nc ${outdir}/afr_cru_1931_1960_yearmean.nc
cd ${outdir}
#pwd; ls

# compute standardized anaomalies
cdo div -sub afr_cru_1931_1960_yearmean.nc -timmean afr_cru_1931_1960_yearmean.nc -timstd afr_cru_1931_1960_yearmean.nc afr_cru_1931_1960_ano_std.nc

rm -f afr_cru_1931_1960.nc afr_cru_1931_1960_yearmean.nc 

stations=( Aleg Ambidedi Bafoulabe Bakel Balle Bodie Boghe Boulivel Dabola Dagana )
lons=( -13.92 -11.78 -10.83 -12.47 -8.58 -12.04 -14.28 -12.18 -11.12 15.50 )
lats=( 17.05 14.58 13.80 14.90 15.33 11.02 16.57 10.61 10.75 16.52 )

for k in $(seq 0 9); do
    # extraction plus proche voisin
    cdo remapnn,lon=${lons[k]}/lat=${lats[k]} afr_cru_1931_1960_ano_std.nc afr_cru_1931_1960_remapnn_${stations[k]}.nc
    # extraction bilineaire ponderee
    cdo remapdis,lon=${lons[k]}/lat=${lats[k]} afr_cru_1931_1960_ano_std.nc afr_cru_1931_1960_remapbil_${stations[k]}.nc

    #ncview afr_cru_1931_1960_remapnn_${stations[k]}.nc afr_cru_1931_1960_remapbil_${stations[k]}.nc

done
