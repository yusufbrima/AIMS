class Preprocessing:
    base = None
    test_path = None
    root = os.getcwd()
    basepath = None
    dataset = None
    paths =  None

    def __init__(self, basepath):
        self.dataset = 'dataset'
        if os.path.isdir(os.path.join(self.root, self.dataset)) is False:
            os.mkdir(os.path.join(self.root, self.dataset))
        if os.path.isdir(os.path.join(self.root, self.dataset + '/test')) is False:
            os.mkdir(os.path.join(self.root, self.dataset + '/test'))
        self.dataset = os.path.join(self.root, self.dataset)
        self.test_path = os.path.join(self.root, self.dataset + '/test')
        self.basepath = basepath
        self.paths =  os.listdir(self.basepath)
        self.path = os.path.join(self.root,'dataset')

    def make_testdir(self):
        # We are creating the test directories
        for k in range(len(self.paths)):
            if os.path.isdir(os.path.join(self.basepath, self.paths[k])):
                if os.path.isdir(os.path.join(self.test_path, self.paths[k])) is False:
                    os.mkdir(os.path.join(self.test_path, self.paths[k]))

    def testset(self,pr=0.1):
        # We are creating our test set
        if os.path.isdir(self.path) is True:
            paths = os.listdir(self.basepath)
            pr = pr
            for k in range(len(paths)):
                if os.path.isdir(os.path.join(self.basepath, self.paths[k])):
                    # We are moving 2% of the sample dataset to test

                    n = np.int(len(os.listdir(os.path.join(self.basepath, self.paths[k]))) * pr)
                    for c in random.sample(glob.glob(os.path.join(self.basepath, self.paths[k] + '/' + self.paths[k] + '*')), n):
                        shutil.move(c, os.path.join(self.test_path, self.paths[k]))

    def make_testset(self):
        self.make_testdir()
        self.testset(0.1)


basepath = os.getcwd()
pp =  preprocessing(basepath)
