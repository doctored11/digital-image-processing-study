
close(winsid());
clc()
clear()
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', 'fish.jpg');

img = imread(imPath); 
im = rgb2gray(img);

global hotImg
hotImg = im

