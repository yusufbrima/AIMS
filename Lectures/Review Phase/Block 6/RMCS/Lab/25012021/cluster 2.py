#!/usr/bin/env python
#importing packages to use
from numpy import*
from scipy.cluster.hierarchy import linkage,dendrogram,distance
import matplotlib.pyplot as plt

#defining a function that standardizes the data
def scale(matrix):
    import numpy as np
    result=np.empty_like(matrix)
    for column in range(0,matrix.shape[0]):
        tmp=matrix[column,:]
        result[column,:]=(tmp-np.mean(tmp))/np.std(tmp)
    return result

# reading the data from the file
table=loadtxt('Droughts.txt',skiprows=23,usecols=(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)).T
# Replacing the missing values (-999) with -2.33 
table[table==-999]=-2.33
#calling the standardizing function
table1=scale(table[:,0:612:12])
#clustering
Y=linkage(table1,method='ward',metric='euclidean')
#nameset for labeling
nameset=('Year','Month','Cld','Pet','Pre','Tmn','Tmp','Tmx','Vap','Wet','spei01','MEI','NINO34','QBO','SOI','AO','ONI','WP')
cluster_nameset=nameset[2:18]
# defines the color of the dendrogram'
def f(x): 
       return 'black'
# plotting a dendrogram to visualise the clustering
dendrogram(Y,labels=cluster_nameset,leaf_rotation=90,color_threshold=10,leaf_font_size=10,link_color_func=f)
plt.ylabel('height')
plt.title('Cluster Analysis Droughts')
#creating a horizontal line
#plt.axhline(y=15)
#saving the plot 
plt.savefig('dendro.png')
plt.close()

