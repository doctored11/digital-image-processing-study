clc();
clear();
close(winsid());


myThisPath = get_absolute_file_path('k38.sce');
imPath = fullfile(myThisPath, 'res', 'Testbuilding.jpg');
im = imread(imPath);

img = rgb2gray(im)
