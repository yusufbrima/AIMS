import matplotlib.pyplot as plt
import numpy as np

fig= plt.figure()

axes= fig.add_axes([0,0,1,1])

x= np.linspace(-10,10,100)

y = np.sin(x) + np.random.normal(0.5,1.4,100) + np.pi
y1 =  y -  np.std(y)
y2 =  y + np.std(y)
axes.plot(x,y, color='blue', alpha=0.5,linewidth=2.5,label="Sin(x) Wave+Noise")
axes.fill_between(x, y1, y2,color="green",alpha=0.1)


# yy = np.cos(x) + np.random.normal(0.7,3.4,100)
# y3 =  yy -  np.std(yy)
# y4 =  yy + np.std(yy)
# axes.plot(x,yy, color='red', alpha=0.5,linewidth=2.5,label="Cos(x)+Noise")
# axes.fill_between(x, y3, y4,color="magenta",alpha=0.1)

plt.legend()
plt.show()
