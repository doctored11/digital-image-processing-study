clc();
clear();
close(winsid());


myThisPath = get_absolute_file_path('test.sce');
imPath = fullfile(myThisPath, 'res', 'Testbuilding.jpg');
im = imread(imPath);

im = rgb2gray(im)
im=im2double(im);
