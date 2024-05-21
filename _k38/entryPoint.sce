//⚠Видимо этот файл должен быть самым левым(из за очистки переменных) -_-

close(winsid());
clc
clear
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');

im = imread(imPath); 
im = rgb2gray(im);


global hotImg
hotImg = im
disp(typeof(hotImg))

