class Modelling:
    datapath = None
    testpath = None
    # augmentation parameters
    # you can use preprocessing_function instead of rescale in all generators
    # if you are using a pretrained network
    train_augmentation_parameters = dict(
        rescale=1.0 / 255.0,
        rotation_range=45,
        width_shift_range=0.15,
        height_shift_range=0.2,
        fill_mode='nearest',
        # crop_and_pad=0.25,
        shear_range=16.0,
        validation_split=0.2
    )
    # training parameters
    test_augmentation_parameters = dict(
        rescale=1.0 / 255.0
    )
    NUM_CLASSES = 4
    BATCH_SIZE = 32
    CLASS_MODE = 'categorical'
    # CLASS_MODE = 'binary'
    COLOR_MODE = 'grayscale'
    TARGET_SIZE = (128, 128)
    EPOCHS = 100
    SEED = 214
    train_datagen = None
    train_generator = None
    test_datagen  =  None
    test_generator  =  None
    valid_generator = None
    model = None
    optim_params = None
    reduce_lr = None
    check_point = None
    early_stop = None
    y_labels = None
    classweight_dict = None
    hist = None
    y_pred =  None
    y_pred_classes  =  None
    score  =  None
    classweight = None
    classes = ["COVID", "Lung_Opacity", "Normal", "Viral Pneumonia"]

    def __init__(self, datapath, testpath):
        self.datapath = datapath
        self.testpath = testpath
        pass

    def augment_data(self):
        # Using the training phase generators
        self.train_datagen = ImageDataGenerator(**self.train_augmentation_parameters)

        self.train_generator = self.train_datagen.flow_from_directory(
            self.datapath,  # +"/train",
            target_size=self.TARGET_SIZE,
            batch_size=self.BATCH_SIZE,
            class_mode=self.CLASS_MODE,
            subset="training"
        )

        self.valid_generator = self.train_datagen.flow_from_directory(
            self.datapath,
            target_size=self.TARGET_SIZE,
            batch_size=self.BATCH_SIZE,
            class_mode=self.CLASS_MODE,
            subset="validation"
        )

        # Test data generator
        self.test_datagen = ImageDataGenerator(**self.test_augmentation_parameters)
        self.test_generator = self.test_datagen.flow_from_directory(
            self.testpath,
            target_size=self.TARGET_SIZE,
            batch_size=self.BATCH_SIZE,
            class_mode=self.CLASS_MODE,
            shuffle=False,
        )

        print()
        print(np.bincount(self.train_generator.classes))
        print(np.bincount(self.valid_generator.classes))

    def build(self):
        K.clear_session()

        # base_model = VGG16(weights='imagenet', include_top=False, input_shape=TARGET_SIZE+(3,) ) base_model =
        # VGG16(weights='weights/vgg16_weights_tf_dim_ordering_tf_kernels_notop.h5', include_top=False,
        # input_shape=TARGET_SIZE+(3,))

        # base_model = VGG16(weights='imagenet', include_top=False, input_shape=TARGET_SIZE+(3,))

        # base_model = VGG19(weights='weights/vgg19_weights_tf_dim_ordering_tf_kernels_notop.h5', include_top=False,
        # input_shape=TARGET_SIZE+(3,))
        base_model = ResNet50(weights='imagenet', include_top=False, input_shape=self.TARGET_SIZE + (3,))
        # base_model = DenseNet121( weights='weights/densenet121_weights_tf_dim_ordering_tf_kernels_notop.h5',
        # include_top=False, input_shape=TARGET_SIZE+(3,)) base_model = InceptionV3(
        # weights='weights/inception_v3_weights_tf_dim_ordering_tf_kernels_notop.h5', include_top=False,
        # input_shape=TARGET_SIZE+(3,)) can also try other architectures

        x = base_model.output
        x = Flatten()(x)
        # x = Dense(512, activation='relu')(x)
        # x = Dropout(0.1)(x)
        # x = Dense(256, activation='relu')(x)
        # x = Dropout(0.1)(x)
        # x = Dense(128, activation='relu')(x)
        # x = Dropout(0.1)(x)
        # x = Dense(64, activation='relu')(x)
        # x = Dropout(0.1)(x)

        x = Dense(self.NUM_CLASSES, activation='softmax')(x)

        model = Model(inputs=base_model.input, outputs=x)

        # print(model.summary())

        # for layer in model.layers[0:-14]:
        #     layer.trainable = False

        # print_layers(model)
        self.model = model

    def printmodel(self):
        for idx, layer in enumerate(self.model.layers):
            print("layer {}: {}, trainable: {}".format(idx, layer.name, layer.trainable))

    def get_model(self):
        self.build()
        self.configuremodel()
        return self.model

    def configuremodel(self):
        self.optim_params = dict(
            learning_rate=0.0001,
            momentum=0.9394867962846013,
            decay=0.0001
        )

        self.model.compile(
            loss='categorical_crossentropy',
            optimizer=SGD(**self.optim_params),
            metrics=['accuracy'])
        self.check_point = ModelCheckpoint('weighted_model_v2.best.h5', monitor='val_loss', verbose=1,
                                           save_best_only=True, save_weights_only=False, save_freq=1)

        self.reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.2, patience=5, verbose=1, min_lr=0.00001);

        self.early_stop = EarlyStopping(monitor='val_loss', min_delta=0.001, patience=11, verbose=1,
                                        restore_best_weights=True);
        # y_labels = np.argmax(y_train, axis=1)
        self.y_labels = self.train_generator.classes
        self.classweight = class_weight.compute_class_weight('balanced', np.unique(self.y_labels), self.y_labels)

        self.classweight_dict = {}
        for i in range(len(self.classweight)):
            self.classweight_dict[i] = self.classweight[i]

        print(self.classweight_dict)
        print(np.bincount(self.train_generator.classes))

    def train(self):
        self.hist = self.model.fit(
            self.train_generator,
            validation_data=self.valid_generator,
            epochs=self.EPOCHS
        )
        train_hist = pd.DataFrame(self.hist.history)
        train_hist.to_csv(os.path.join(os.getcwd(), 'figures/train_history.csv'), index=False)
        self.plot_acc_loss()
        self.model.save(os.path.join(os.getcwd(), "models/ResNet50.model.h5"))
        self.model.save_weights(os.path.join(os.getcwd(), "models/ResNet50.weights.model..h5"))
    def plot_acc_loss(self):
        # We are checking if the figures directory exist, if not we are creating it
        if os.path.isdir(os.path.join(os.path.join(os.getcwd(),'figures')) is False:
            os.mkdir(os.path.join(os.getcwd(),'figures'))

        fig = plt.figure(figsize=(8, 6), dpi=150)
        plt.plot(self.hist.history['accuracy'])
        plt.plot(self.hist.history['val_accuracy'])
        plt.title('model accuracy')
        plt.ylabel('accuracy')
        plt.xlabel('epoch')
        plt.legend(['train', 'validation'], loc='lower right')
        plt.savefig(os.path.join(os.getcwd(), '/figures/train_val_accuracy.png'), dpi=300)

        fig = plt.figure(figsize=(8, 6))
        plt.plot(self.hist.history['loss'])
        plt.plot(self.hist.history['val_loss'])
        plt.title('model loss')
        plt.ylabel('loss')
        plt.xlabel('epoch')
        plt.legend(['train', 'test'], loc='upper right')
        plt.savefig(os.path.join(os.getcwd(), '/figures/train_val_loss.png'), dpi=300)
    def test(self):
        print(np.bincount(self.test_generator.classes), "\n")
        self.score = self.model.evaluate(self.test_generator, verbose=0)
        # Predic
        self.y_pred = self.model.predict_generator(generator=self.test_generator)
        # print(y_pred[:10])
        # to get the prediction, we pick the class with with the highest probability
        self.y_pred_classes = np.argmax(self.y_pred, axis=1)
        # y_true = np.argmax(y_val, axis = 1)
        y_true = self.test_generator.classes

        conf_mtx = confusion_matrix(y_true, self.y_pred_classes)
        plot_confusion_matrix(conf_mtx, figsize=(12, 8), hide_ticks=True, cmap=plt.cm.Blues, colorbar=True)
        plt.xticks(range(4), self.classes, fontsize=16)
        plt.yticks(range(4), self.classes, fontsize=16)
        plt.savefig(os.path.join(os.getcwd(), '/figures/test_confusion_matrix.png'), dpi=300)
        print('Model Loss: {}, Accuracy: {}'.format(self.score[0], self.score[1]))

        # we are analyzing model complexity using ROC
        self.plot_roc()
    def plot_roc(self):
        fpr = dict()
        tpr = dict()
        roc_auc = dict()

        y_test = to_categorical(self.test_generator.classes)

        for i in range(self.NUM_CLASSES):
            fpr[i], tpr[i], _ = roc_curve(y_test[:, i], self.y_pred[:, i])
            roc_auc[i] = auc(fpr[i], tpr[i])

        # for i in range(1):
        #     fpr[i], tpr[i], _ = roc_curve(y_true, y_pred)
        #     roc_auc[i] = auc(fpr[i], tpr[i])

        plt.figure(figsize=(10, 6))

        for i in range(self.NUM_CLASSES):
            plt.plot(fpr[i], tpr[i], lw=2,
                     label='ROC curve of {0} (area = {1:0.3f})'.format(self.classes[i], roc_auc[i]))

        # for i in range(1):
        #     plt.plot(fpr[i], tpr[i], lw=2,
        #              label='ROC curve (area = {:0.3f})'.format(roc_auc[i]))

        plt.plot(fpr[0], fpr[0], 'k-', label='random guessing')

        plt.xlabel('False Positive Rate')
        plt.ylabel('True Positive Rate')
        plt.title('ROC curve')
        plt.legend(loc="lower right")

        plt.tight_layout()
        plt.savefig(os.path.join(os.getcwd(), 'figures/roc_curve.png'), dpi=300)



