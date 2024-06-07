
close(winsid());
clc
clear
global myThisPath
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', '2.jpg');

img = imread(imPath); 
im = rgb2gray(img);

global hotImg
hotImg = im

