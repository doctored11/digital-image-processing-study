
close(winsid());
clc
clear
global myThisPath
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', '1.jpg');

im = imread(imPath); 
//im = rgb2gray(img);

global hotImg
hotImg = im

