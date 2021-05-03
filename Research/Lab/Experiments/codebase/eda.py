class EDA:
    data = None
    plots = {}
    root = None

    def __init__(self, root):
        self.root = root
        pass

    def load_data(self):
        # We are creating our test set
        paths = os.listdir(self.root)
        base = self.root
        ls = {'path': [], 'class': [], 'mean': [], 'std': [], 'min': [], 'max': [], 'image': []}
        if os.path.isdir(self.root) is True:
            paths = os.listdir(self.root)
            pr = 10.
            for k in range(len(paths)):
                if os.path.isdir(os.path.join(base, paths[k])):
                    for f in os.listdir(os.path.join(base, paths[k])):
                        file = os.path.join(os.path.join(base, paths[k]), f)
                        arr_img = cv2.imread(file)
                        mean = arr_img.mean()
                        std = arr_img.std()
                        minimum = arr_img.min()
                        maximum = arr_img.max()
                        clas = f.split('/')[-1].split('.')
                        classes = clas[0].split('-')[0]
                        ls['path'].append(file)
                        ls['class'].append(classes)
                        ls['mean'].append(mean)
                        ls['std'].append(std)
                        ls['min'].append(minimum)
                        ls['max'].append(maximum)
                        ls['image'].append(arr_img)
        df = pd.DataFrame(ls)
        df['image_r'] = df['path'].map(lambda x: np.asarray(Image.open(x).resize((75, 75))))
        return df

    def visualize(self):
        self.data = self.load_data()
        samples, features = self.data.shape

        # We are checking if the figures directory exist, if not we are creating it
        if os.path.isdir(os.path.join(os.path.join(os.getcwd(),'figures')) is False:
            os.mkdir(os.path.join(os.getcwd(),'figures'))
        # Samples per class
        plt.figure(figsize=(10, 6))
        sns.set(style="ticks", font_scale=1)
        ax = sns.countplot(data=self.data, x='class', order=self.data['class'].value_counts().index, palette="flare")
        sns.despine(top=True, right=True, left=True, bottom=False)
        plt.xticks(rotation=0, fontsize=12)
        ax.set_xlabel('Class Type - Diagnosis', fontsize=14, weight='bold')
        ax.set(yticklabels=[])
        ax.axes.get_yaxis().set_visible(False)
        plt.title('Number of Sample X-Ray Images per Class', fontsize=12, weight='bold');

        for p in ax.patches:
            ax.annotate("%.1f%%" % (100 * float(p.get_height() / samples)),
                        (p.get_x() + p.get_width() / 2., abs(p.get_height())),
                        ha='center', va='bottom', color='black', xytext=(0, 10), rotation='horizontal',
                        textcoords='offset points')
        plt.savefig(f'{self.root}/figures/image_class_distribution.png', dpi=300)

        self.plot_sample_images(3, "sample_images_all_channels", True)
        self.plot_sample_images(3, "sample_images_single_channels", False)

    #     We are plotting color distribution of images
        ax = sns.displot(data=self.data, x='mean', kind="kde", hue='class', fill=False);
        plt.title('Images Colour Mean Value Distribution by Class', fontsize=12, weight='bold');
        plt.savefig(f'{self.root}/figures/image_mean_color.png', dpi=300)

        #
        ax = sns.displot(data=self.data, x='max', kind="kde", hue='class');
        plt.title('Images Colour Max Value Distribution by Class', fontsize=12, weight='bold');
        plt.savefig(f'{self.root}/figures/image_max_color.png', dpi=300)

        ax = sns.displot(data=self.data, x='min', kind="kde", hue='class');
        plt.title('Images Colour Min Value Distribution by Class', fontsize=12, weight='bold');
        plt.savefig(f'{self.root}/figures/image_min_color.png', dpi=300)

        # we are plotting the mean and standard deviation of the dataset
        plt.figure(figsize=(10, 6))
        sns.set(style="ticks", font_scale=1)
        ax = sns.scatterplot(data=self.data, x="mean", y=self.data['std'], hue='class', alpha=0.8);
        sns.despine(top=True, right=True, left=False, bottom=False)
        plt.xticks(rotation=0, fontsize=12)
        ax.set_xlabel('Image Channel Colour Mean', fontsize=12, weight='bold')
        ax.set_ylabel('Image Channel Colour Standard Deviation', fontsize=12, weight='bold')
        plt.title('Mean and Standard Deviation of Image Samples', fontsize=12, weight='bold');
        plt.savefig(f'{self.root}/figures/image_distribution_scatter.png', dpi=300)

        plt.figure(figsize=(14, 8))
        g = sns.FacetGrid(self.data, col="class", height=5);
        g.map_dataframe(sns.scatterplot, x='mean', y='std', hue='class');
        g.set_titles(col_template="{col_name}", row_template="{row_name}", size=16)
        g.fig.subplots_adjust(top=.7)
        # g.fig.suptitle('Mean and Standard Deviation of Image Samples',fontsize=16, weight = 'bold')
        axes = g.axes.flatten()
        axes[0].set_ylabel('Standard Deviation');
        for ax in axes:
            ax.set_xlabel('Mean')
        g.fig.tight_layout()
        plt.savefig(f'{self.root}/figures/image_distribution_4_plots.png', dpi=300)

        #we are plotting samples of the images in an annotation  box

        DF_sample = self.data.sample(frac=0.1, replace=False, random_state=1)
        paths = DF_sample['path']

        fig, ax = plt.subplots(figsize=(10, 6))
        ab = sns.scatterplot(data=DF_sample, x="mean", y='std')
        sns.despine(top=True, right=True, left=False, bottom=False)
        ax.set_xlabel('Image Channel Colour Mean', fontsize=12, weight='bold')
        ax.set_ylabel('Image Channel Colour Standard Deviation', fontsize=14, weight='bold')
        plt.title('Mean and Standard Deviation of Image Samples - 10% of Data', fontsize=12, weight='bold');

        for x0, y0, path in zip(DF_sample['mean'], DF_sample['std'], paths):
            ab = AnnotationBbox(self.getImage(path), (x0, y0), frameon=False)
            ax.add_artist(ab)
        plt.savefig(f'{self.root}/figures/image_bounding_box.png', dpi=300)



    def getImage(self,path):
        imdata = plt.imread(path)
        return OffsetImage(imdata, zoom=0.1)

    def plot_sample_images(self, n_samples=3, pltname="sample_images_all_channels", channels=True):
        fig, m_axs = plt.subplots(4, n_samples, figsize=(4 * n_samples, 3 * 4))
        for n_axs, (type_name, type_rows) in zip(m_axs, self.data.sort_values(['class']).groupby('class')):
            n_axs[1].set_title(type_name, fontsize=12, weight='bold')
            for c_ax, (_, c_row) in zip(n_axs, type_rows.sample(n_samples, random_state=1234).iterrows()):
                picture = c_row['path']
                if channels:
                    image = cv2.imread(picture)
                else:
                    image = plt.imread(picture)
                c_ax.imshow(image)
                c_ax.axis('off')

        plt.savefig(f'{self.root}/figures/{pltname}.png', dpi=300)