#CAlling the relevant libraries
from numpy import*
import matplotlib.pyplot as plt
from matplotlib.mlab import PCA

# reading the data from the file
table=loadtxt('Droughts.txt',skiprows=23,usecols=(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17))
# Replacing the missing values (-999) with -2.33 
table[table==-999]=-2.33

#This is where the PCA method is called and different variables are calculated
drought_PCA=PCA(table)
a=drought_PCA.a
weights=drought_PCA.Wt
projected=drought_PCA.Y
variance=drought_PCA.fracs
loadings=empty_like(drought_PCA.Wt)
U,s,V = linalg.svd(table) 
eigenvals = linalg.eigvals(cov(a.T))
for i in range(0,16):
	loadings[i]=weights[i]*projected.std(axis=0)[i]

# headings for matrix
header1=(" ","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16")
nameset=('Cld','Pet','Pre','Tmn','Tmp','Tmx','Vap','Wet','spei01','MEI','NINO34','QBO','SOI','AO','ONI','WP','var')
# Creating a new matrix with headings
loadings=loadings.round(5)
variance=variance.round(5)
new=column_stack((loadings,variance*100))
new=row_stack((nameset,new))
new=column_stack((header1,new))
# saving the loadings and explained variance to a file
savetxt('PCA.txt',new.T,delimiter="	 ",fmt='%s')
#Plotting the scree plot
pca_list=range(1,17)
plt.plot(pca_list,eigenvals)
plt.xlim(1,17)
plt.xlabel("principal components")
plt.ylabel("var")
plt.title("Scree Plot")
plt.savefig('scree.png')


