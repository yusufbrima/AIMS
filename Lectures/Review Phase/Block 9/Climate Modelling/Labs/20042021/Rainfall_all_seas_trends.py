import scipy.stats
import numpy as np ; import numpy.ma as ma
import scipy.stats
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from netCDF4 import Dataset
import netCDF4
import time
import pandas as pd
import numpy.ma as ma
import matplotlib.pyplot as plt, numpy as np
from matplotlib.colors import BoundaryNorm
import cartopy.crs as ccrs
import cartopy.feature as cfeat
from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER
import xarray as xr
import sys, glob, os, re

#----------function allowing to save high-quality figures in different formtats---------- 
def save(path, ext='png', close=True, verbose=True):
    """Save a figure from pyplot.
    Parameters
    ----------
    path : string
    The path (and filename, without the extension) to save the
    figure to.
    ext : string (default='png')
    The file extension. This must be supported by the active
    matplotlib backend (see matplotlib.backends module).  Most
    backends support 'png', 'pdf', 'ps', 'eps', and 'svg'.
    close : boolean (default=True)
    Whether to close the figure after saving.  If you want to save
    the figure multiple times (e.g., to multiple formats), you
    should NOT close it in between saves or you will have to
    re-plot it.
    verbose : boolean (default=True)
    whether to print information about when and where the image
    has been saved.
    """
    # Extract the directory and filename from the given path
    directory = os.path.split(path)[0]
    filename = "%s.%s" % (os.path.split(path)[1], ext)
    if directory == '':
       directory = '.'
    #If the directory does not exist, create it
    if not os.path.exists(directory):
        os.makedirs(directory)
    # The final path to save to
    savepath = os.path.join(directory, filename)
    if verbose:
        print("Saving figure to '%s'..." % savepath),
    # Actually save the figure
    plt.savefig(savepath)
    # Close it
    if close:
        plt.close()
    if verbose:
        print("Done")

#----------directory where the data are stored------------------------------------------- 
path = '/home/yusufbrima/Downloads/climate'

##########################################################################################

#--------Here let's read the different netDF files corresponding to four seasons--------- 

#--------DJF season--------- 
ncfile0 = Dataset(path + '/afr_cru_djf.nc', 'r', format='NETCDF4')
pr_djf = ncfile0.variables['pre'][:,:,:] # MULTIPLY BY 86400 TO CONVERT TO MM/DAY
lat = ncfile0.variables['lat'][:]
lon = ncfile0.variables['lon'][:]
time = ncfile0.variables['time']
ncfile0.close()

#--------MAM season--------- 
ncfile1 = Dataset(path + '/afr_cru_mam.nc', 'r', format='NETCDF4')
pr_mam = ncfile1.variables['pre'][:,:,:] # MULTIPLY BY 86400 TO CONVERT TO MM/DAY
lat = ncfile1.variables['lat'][:]
lon = ncfile1.variables['lon'][:]
#time = ncfile1.variables['time']
ncfile1.close()

#--------JJA season--------- 
ncfile2 = Dataset(path + '/afr_cru_jja.nc', 'r', format='NETCDF4')
pr_jja = ncfile2.variables['pre'][:,:,:] # MULTIPLY BY 86400 TO CONVERT TO MM/DAY
lat = ncfile2.variables['lat'][:]
lon = ncfile2.variables['lon'][:]
#time = ncfile2.variables['time']
ncfile2.close()

#--------SON season--------- 
ncfile3 = Dataset(path + '/afr_cru_son.nc', 'r', format='NETCDF4')
pr_son = ncfile3.variables['pre'][:,:,:] # MULTIPLY BY 86400 TO CONVERT TO MM/DAY
lat = ncfile3.variables['lat'][:]
lon = ncfile3.variables['lon'][:]
#time = ncfile3.variables['time']
ncfile3.close()


pr_djf = ma.masked_where(pr_djf <= 0.01, pr_djf)
pr_mam = ma.masked_where(pr_mam <= 0.01, pr_mam)
pr_jja = ma.masked_where(pr_jja <= 0.01, pr_jja)
pr_son = ma.masked_where(pr_son <= 0.01, pr_son)

##############################Linear trend calculation pr_djf####################################
#############DJF
nt, nlat, nlon = pr_djf.shape
ngrd = nlon*nlat
#import scipy.stats as stats
pr_djf_grd  = pr_djf.reshape((nt, ngrd), order='F') 
x        = np.linspace(1,nt,nt)#.reshape((nt,1))
pr_djf_rate = np.empty((ngrd,1))
pr_djf_rate[:,:] = np.nan

p_vals_djf       = np.empty((ngrd,1))
p_vals_djf[:,:] = np.nan

slope_djf       = np.empty((ngrd,1))
slope_djf[:,:]  = np.nan

for i in range(ngrd): 
    y = pr_djf_grd[:,i]   
    if(not np.ma.is_masked(y)):         
        z = np.polyfit(x, y, 1)
        pr_djf_rate[i,0] = z[0]*30.0
        slope_djf[i], tmp, tmp, p_vals_djf[i], tmp = scipy.stats.linregress(x, pr_djf_grd[:,i])
        #precip_rate[i,0] = slope*120.0     
    
pr_djf_rate = pr_djf_rate.reshape((nlat,nlon), order='F')
pr_djf_trend = pr_djf_rate.squeeze()

p_vals_djf = p_vals_djf.reshape((nlat,nlon), order='F')

#############MAM
nt, nlat, nlon = pr_mam.shape
ngrd = nlon*nlat
#import scipy.stats as stats
pr_mam_grd  = pr_mam.reshape((nt, ngrd), order='F') 
x        = np.linspace(1,nt,nt)#.reshape((nt,1))
pr_mam_rate = np.empty((ngrd,1))
pr_mam_rate[:,:] = np.nan

p_vals_mam       = np.empty((ngrd,1))
p_vals_mam[:,:] = np.nan

slope_mam       = np.empty((ngrd,1))
slope_mam[:,:]  = np.nan

for i in range(ngrd): 
    y = pr_mam_grd[:,i]   
    if(not np.ma.is_masked(y)):         
        z = np.polyfit(x, y, 1)
        pr_mam_rate[i,0] = z[0]*30.0
        slope_mam[i], tmp, tmp, p_vals_mam[i], tmp = scipy.stats.linregress(x, pr_mam_grd[:,i])
        #precip_rate[i,0] = slope*120.0     
    
pr_mam_rate = pr_mam_rate.reshape((nlat,nlon), order='F')
pr_mam_trend = pr_mam_rate.squeeze()

p_vals_mam = p_vals_mam.reshape((nlat,nlon), order='F')

#############JJA
nt, nlat, nlon = pr_jja.shape
ngrd = nlon*nlat
#import scipy.stats as stats
pr_jja_grd  = pr_jja.reshape((nt, ngrd), order='F') 
x        = np.linspace(1,nt,nt)#.reshape((nt,1))
pr_jja_rate = np.empty((ngrd,1))
pr_jja_rate[:,:] = np.nan

p_vals_jja       = np.empty((ngrd,1))
p_vals_jja[:,:] = np.nan

slope_jja       = np.empty((ngrd,1))
slope_jja[:,:]  = np.nan

for i in range(ngrd): 
    y = pr_jja_grd[:,i]   
    if(not np.ma.is_masked(y)):         
        z = np.polyfit(x, y, 1)
        pr_jja_rate[i,0] = z[0]*30.0
        slope_jja[i], tmp, tmp, p_vals_jja[i], tmp = scipy.stats.linregress(x, pr_jja_grd[:,i])
        #precip_rate[i,0] = slope*120.0     
    
pr_jja_rate = pr_jja_rate.reshape((nlat,nlon), order='F')
pr_jja_trend = pr_jja_rate.squeeze()

p_vals_jja = p_vals_jja.reshape((nlat,nlon), order='F')

#############SON
nt, nlat, nlon = pr_son.shape
ngrd = nlon*nlat
#import scipy.stats as stats
pr_son_grd  = pr_son.reshape((nt, ngrd), order='F') 
x        = np.linspace(1,nt,nt)#.reshape((nt,1))
pr_son_rate = np.empty((ngrd,1))
pr_son_rate[:,:] = np.nan

p_vals_son       = np.empty((ngrd,1))
p_vals_son[:,:] = np.nan

slope_son       = np.empty((ngrd,1))
slope_son[:,:]  = np.nan

for i in range(ngrd): 
    y = pr_son_grd[:,i]   
    if(not np.ma.is_masked(y)):         
        z = np.polyfit(x, y, 1)
        pr_son_rate[i,0] = z[0]*30.0
        slope_son[i], tmp, tmp, p_vals_son[i], tmp = scipy.stats.linregress(x, pr_son_grd[:,i])
        #precip_rate[i,0] = slope*120.0     
    
pr_son_rate = pr_son_rate.reshape((nlat,nlon), order='F')
pr_son_trend = pr_son_rate.squeeze()

p_vals_son = p_vals_son.reshape((nlat,nlon), order='F')

#=========================ressources pour la carte: cartopy à installer au préalable==============================
fig = plt.figure(figsize=(7.50,6.10))
#kwargs = {'format': '%.0f'}  # to fix decimals at X numbers after - put **kwargs in plt.cbar 

[lon2d, lat2d] = np.meshgrid(lon, lat)


prj = ccrs.PlateCarree(central_longitude=0.0)

axa = plt.subplot(221, projection=prj)
#axa.add_feature(cfeat.COASTLINE ,edgecolor = 'k')
axa.add_feature(cfeat.BORDERS.with_scale('10m'),linewidth=0.5)
axa.coastlines(resolution='10m',linewidth=0.5);
#axa.add_feature(cfeat.BORDERS, linestyle='-', alpha=.5)
#axa.add_feature(cfeat.OCEAN,edgecolor='k',facecolor='w') # to mask ocean

cs1 = plt.contourf(lon2d,lat2d,pr_djf_trend,cmap=plt.cm.RdBu)
stippling_plot = plt.contourf(lon2d,lat2d, p_vals_djf,levels=[0.0,0.05], hatches=['////',''],linewidth=2.0,colors='None')

axa.set_extent([-25 ,60, -40, 35])
#axa.set_xticks(range(-25,60,15), crs=prj)
axa.set_yticks(range(-40,40,15), crs=prj)
#axa.xaxis.set_major_formatter(LONGITUDE_FORMATTER)
axa.yaxis.set_major_formatter(LATITUDE_FORMATTER)
plt.title('a) DJF TREND in mm/day/decade',fontsize=8)
plt.ylabel('')
#cb0 = plt.colorbar ( cs1, ax = axa,orientation ='horizontal' )

axb = plt.subplot(222, projection=prj)
#axb.add_feature(cfeat.COASTLINE ,edgecolor = 'k')
axb.add_feature(cfeat.BORDERS.with_scale('10m'),linewidth=0.5)
axb.coastlines(resolution='10m',linewidth=0.5);
#axb.add_feature(cfeat.BORDERS, linestyle='-', alpha=.5)
#axb.add_feature(cfeat.OCEAN,edgecolor='k',facecolor='w') # to mask ocean

cs1 = plt.contourf(lon2d,lat2d,pr_mam_trend,cmap=plt.cm.RdBu)
stippling_plot = plt.contourf(lon2d,lat2d, p_vals_mam,levels=[0.0,0.05], hatches=['////',''],colors='None')

axb.set_extent([-25 ,60, -40, 35])
#axb.set_xticks(range(-25,60,15), crs=prj)
axb.set_yticks(range(-40,40,15), crs=prj)
axb.xaxis.set_major_formatter(LONGITUDE_FORMATTER)
axb.yaxis.set_major_formatter(LATITUDE_FORMATTER)
plt.title('b) MAM TREND in mm/day/decade',fontsize=8)
plt.ylabel('')
#cb0 = plt.colorbar ( cs1, ax = axb,orientation ='horizontal' )

axc = plt.subplot(223, projection=prj)
#axc.add_feature(cfeat.COASTLINE ,edgecolor = 'k')
axc.add_feature(cfeat.BORDERS.with_scale('10m'),linewidth=0.5)
axc.coastlines(resolution='10m',linewidth=0.5);
#axc.add_feature(cfeat.BORDERS, linestyle='-', alpha=.5)
#axc.add_feature(cfeat.OCEAN,edgecolor='k',facecolor='w') # to mask ocean

cs1 = plt.contourf(lon2d,lat2d,pr_jja_trend,cmap=plt.cm.RdBu)
stippling_plot = plt.contourf(lon2d,lat2d, p_vals_jja,levels=[0.0,0.05], hatches=['////',''],linewidth=20.0,colors='None')

axc.set_extent([-25 ,60, -40, 35])
axc.set_xticks(range(-25,60,15), crs=prj)
axc.set_yticks(range(-40,40,15), crs=prj)
axc.xaxis.set_major_formatter(LONGITUDE_FORMATTER)
axc.yaxis.set_major_formatter(LATITUDE_FORMATTER)
plt.title('c) JJA TREND in mm/day/decade',fontsize=8)
plt.ylabel('')
#cb0 = plt.colorbar ( cs1, ax = axc,orientation ='horizontal' )

axd = plt.subplot(224, projection=prj)
#axd.add_feature(cfeat.COASTLINE ,edgecolor = 'k')
axd.add_feature(cfeat.BORDERS.with_scale('10m'),linewidth=0.5)
axd.coastlines(resolution='10m',linewidth=0.5);
#axd.add_feature(cfeat.BORDERS, linestyle='-', alpha=.5)
#axd.add_feature(cfeat.OCEAN,edgecolor='k',facecolor='w') # to mask ocean

cs1 = plt.contourf(lon2d,lat2d,pr_son_trend,cmap=plt.cm.RdBu)
stippling_plot = plt.contourf(lon2d,lat2d, p_vals_son,levels=[0.0,0.05], hatches=['////',''],colors='None')

axd.set_extent([-25 ,60, -40, 35])
axd.set_xticks(range(-25,60,15), crs=prj)
axd.set_yticks(range(-40,40,15), crs=prj)
axd.xaxis.set_major_formatter(LONGITUDE_FORMATTER)
axd.yaxis.set_major_formatter(LATITUDE_FORMATTER)
plt.title('d) SON TREND in mm/day/decade',fontsize=8)
plt.ylabel('')
#cb0 = plt.colorbar ( cs1, ax = axd,orientation ='horizontal' )


axtop = axa.get_position()
axbot = axd.get_position()


cbar_ax = fig.add_axes([axbot.x1+0.045, axbot.y0, 0.020, axtop.y1-axbot.y0])
cbar = plt.colorbar(cs1, cax=cbar_ax, orientation='vertical')
#cbar.set_label('[mm/day]',rotation=270) 
plt.tight_layout()



save(f'{path}/figures/Rainfall_all_seasons_trends', ext='pdf', close=True, verbose=True)  # save high quality figures


