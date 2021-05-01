#!/bin/bash 


dir='/home/origene/Desktop/project'
outdir='/home/origene/Desktop/project/output'
seasons='/home/origene/Desktop/project/output/seasons'
years='/home/origene/Desktop/project/output/years'
cdd='/home/origene/Desktop/project/output/years/cdd'
cwd='/home/origene/Desktop/project/output/years/cwd'
sea='/home/origene/Desktop/project/output/years/seasons'
## select the period from 1931 to 1960
##cdo selyear,${iyear}/${fyear} ${dir}/afr_cru_ts4.04.1928.2017.pre.mm.day.nc ${outdir}/afr_cru_1931_1960.nc

# compute annual mean from multi year monthly data  
# you could also compute annual/seasonal cycle by cdo ymonmean  


#cdo sellonlatbox,18.75,51.3,-25.5,20.5 chirts_Africa_masked.nc ${outdir}/temp_ea.nc

#cdo sellonlatbox,18.75,51.3,-25.5,20.5 chirps-v2.0.1985-2004.days_p25.nc ${outdir}/precip_ea.nc

#cd ${outdir}

#cdo selseas,DJF temp_ea.nc ${seasons}/DJFtemp.nc
#cdo selseas,MAM temp_ea.nc ${seasons}/MAMtemp.nc
#cdo selseas,JJA temp_ea.nc ${seasons}/JJAtemp.nc
#cdo selseas,SON temp_ea.nc ${seasons}/SONtemp.nc

#cdo selseas,DJF precip_ea.nc ${seasons}/DJFprecip.nc
#cdo selseas,MAM precip_ea.nc ${seasons}/MAMprecip.nc
#cdo selseas,JJA precip_ea.nc ${seasons}/JJAprecip.nc
#cdo selseas,SON precip_ea.nc ${seasons}/SONprecip.nc


#cd ${seasons}

#cdo splityear DJFprecip.nc ${years}/yearsDJF/

#cdo splityear MAMprecip.nc ${years}/yearsMAM/

#cdo splityear JJAprecip.nc ${years}/yearsJJA/

#cdo splityear SONprecip.nc ${years}/yearsSON/

#cd ${years}/yearsDJF/

#mkdir -p ${years}/yearsDJF/cdd
#for i in *.nc; do cdo eca_cdd $i ${years}/yearsDJF/cdd/cdd_${i}; done

#cdo mergetime cdd* merged_cdd_DJF.nc

#mkdir -p ${years}/yearsDJF/cwd
#for i in *.nc; do cdo eca_cwd $i ${years}/yearsDJF/cwd/cwd_${i}; done

#cdo mergetime cwd* merged_cwd_DJF.nc



cd ${years}/yearsMAM/

mkdir -p ${years}/yearsMAM/cdd
for i in *.nc; do cdo eca_cdd $i ${years}/yearsMAM/cdd/cdd_${i}; done

#cdo mergetime cdd* merged_cdd_DJF.nc

mkdir -p ${years}/yearsMAM/cwd
for i in *.nc; do cdo eca_cwd $i ${years}/yearsMAM/cwd/cwd_${i}; done



cd ${years}/yearsJJA/

mkdir -p ${years}/yearsJJA/cdd
for i in *.nc; do cdo eca_cdd $i ${years}/yearsJJA/cdd/cdd_${i}; done

#cdo mergetime cdd* merged_cdd_DJF.nc

mkdir -p ${years}/yearsJJA/cwd
for i in *.nc; do cdo eca_cwd $i ${years}/yearsJJA/cwd/cwd_${i}; done





cd ${years}/yearsSON/

mkdir -p ${years}/yearsSON/cdd
for i in *.nc; do cdo eca_cdd $i ${years}/yearsSON/cdd/cdd_${i}; done

#cdo mergetime cdd* merged_cdd_DJF.nc

mkdir -p ${years}/yearsSON/cwd
for i in *.nc; do cdo eca_cwd $i ${years}/yearsSON/cwd/cwd_${i}; done

#cd ${years}/yearsMAM/

#mkdir -p ${years}/yearsMAM/cdd
#for i in *.nc; do cdo eca_cdd $i ${years}/yearsDJF/cdd/cdd_${i}; done

#for i in *.nc; do cdo eca_cwd $i ${cwd}/cwd_${i}; done

#cd ${cdd}
#cdo mergetime cdd_djF* merged_cdd.nc

#cd ${cwd}
#cdo mergetime cwd* merged_cwd.nc

######

#cd ${sea}











#done
#cdo yearmean ${dir}/chirts_Africa_masked.nc ${dir}/yearmean.nc
#cd ${outdir}
#pwd; ls

# compute standardized anaomalies
#cdo timmean 
#cdo div -sub yearmean.nc -timmean yearmean.nc -timstd yearmean.nc yearmean_std.nc

#rm -f afr_cru_1931_1960.nc afr_cru_1931_1960_yearmean.nc 

#stations=( Kigali Huye Rusizi Musanze Kirehe )
#lons=( 30 29.75 29.18 29.55 30.64 )
#lats=( -1.94 -2.44 -2.53 -1.5 -2.26 )

#for k in $(seq 0 4); do
    # extraction plus proche voisin
    #cdo remapnn,lon=${lons[k]}/lat=${lats[k]} afr_cru_1931_1960_ano_std.nc afr_cru_1931_1960_remapnn_${stations[k]}.nc
    # extraction bilineaire ponderee
    #cdo remapdis,lon=${lons[k]}/lat=${lats[k]} yearmean_std.nc ${outdir}/yearmean_std_remapbil_${stations[k]}.nc

    #ncview afr_cru_1931_1960_remapnn_${stations[k]}.nc afr_cru_1931_1960_remapbil_${stations[k]}.nc

#done











