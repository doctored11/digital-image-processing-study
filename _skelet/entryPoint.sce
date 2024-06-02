
close(winsid());
clc
clear
global myThisPath
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', '3.jpg'); //любую картинку или 1 - 20 из заготовленных

img = imread(imPath); 
im = rgb2gray(img);

global hotImg
hotImg = im

