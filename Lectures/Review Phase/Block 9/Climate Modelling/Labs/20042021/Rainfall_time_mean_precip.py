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
import sys, glob, os

#----------function allowing to save high-quality figures in different formats---------- 
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
path = '/home/mousta-climate/Desktop/AIMS_Lectures/data'

##########################################################################################

#--------Here let's read the different netDF files corresponding to four seasons--------- 

#--------DJF season--------- 
ncfile0 = Dataset(path + '/afr_cru_ts4.04.1928.2017.pre.mm.day.nc', 'r', format='NETCDF4')
pr_djf = ncfile0.variables['pre'][:,:,:] # MULTIPLY BY 86400 TO CONVERT TO MM/DAY
lat = ncfile0.variables['lat'][:]
lon = ncfile0.variables['lon'][:]
time = ncfile0.variables['time']
ncfile0.close()

##############################compute mean for all seasons####################################
pr_djf = np.mean(pr_djf,axis=0)  

#-------mask precipitation below 1 mm/day
pr_djf = ma.masked_where(pr_djf <= 0.3, pr_djf)

#=========================Map resources==============================
fig = plt.figure(figsize=(7.40,6.10))
kwargs = {'format': '%.0f'}  # to fix decimals at X numbers after - put **kwargs in plt.cbar 
[lon2d, lat2d] = np.meshgrid(lon, lat)


prj = ccrs.PlateCarree(central_longitude=0.0)

axa = plt.subplot(111, projection=prj)
#axa.add_feature(cfeat.COASTLINE ,edgecolor = 'k')
axa.add_feature(cfeat.BORDERS.with_scale('10m'),linewidth=0.5)
axa.coastlines(resolution='10m',linewidth=0.5)
#axa.add_feature(cfeat.OCEAN,edgecolor='k',facecolor='w') # to mask ocean
#axa.add_feature(cfeat.LAKES.with_scale('10m'),linewidth=0.5,edgecolor='k')
#axa.add_feature(cfeat.RIVERS.with_scale('10m'),linewidth=0.5,edgecolor='k')
cs1 = plt.contourf(lon2d,lat2d,pr_djf,levels = np.linspace(1., 9.,11),cmap=plt.cm.rainbow)
axa.set_extent([-25 ,60, -41, 40])
axa.set_xticks(range(-25,60,15), crs=prj)
axa.set_yticks(range(-40,40,15), crs=prj)
axa.xaxis.set_major_formatter(LONGITUDE_FORMATTER)
axa.yaxis.set_major_formatter(LATITUDE_FORMATTER)
plt.title('a) CRU: RAINFALL CLIMATOLOGY', fontsize=12)
plt.ylabel('')
cb0 = plt.colorbar ( cs1, ax = axa,orientation ='vertical' )

cb0.set_label('[mm/day]',rotation=270) 



save('../figures/Rainfall_time_mean', ext='pdf', close=True, verbose=True)  # save high quality figures


