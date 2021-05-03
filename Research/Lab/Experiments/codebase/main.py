#%matplotlib inline
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from celluloid import Camera  # getting the camera
from sklearn.model_selection import train_test_split
import tensorflow as tf
from tensorflow.keras import backend as K
from tensorflow.keras.models import Model, load_model
from tensorflow.keras.models import Sequential
from tensorflow.keras.optimizers import SGD
from tensorflow.keras.applications import VGG16, ResNet50, VGG19, DenseNet121, InceptionV3, Xception
from tensorflow.keras.layers import Dense, Dropout, Flatten, BatchNormalization, Activation
from keras.constraints import maxnorm
from tensorflow.keras.layers import Conv2D, MaxPooling2D
from keras.utils import np_utils, to_categorical
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from keras_preprocessing.image.dataframe_iterator import DataFrameIterator
from tensorflow.keras.callbacks import ModelCheckpoint, ReduceLROnPlateau, EarlyStopping, TensorBoard
from matplotlib.offsetbox import (OffsetImage,
                                  AnnotationBbox)
from IPython.display import HTML  # to show the animation in Jupyter
from sklearn.utils import class_weight
from sklearn.metrics import confusion_matrix
from mlxtend.plotting import plot_confusion_matrix
from sklearn.metrics import roc_curve
from sklearn.metrics import auc
import seaborn as sns
import itertools
import os
import shutil
import random
from google.colab import files
import cv2
import glob
from PIL import Image
#we are importing custom classes from project files
from eda import EDA
from preprocessing import Preprocessing
from modelling import Modelling
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
