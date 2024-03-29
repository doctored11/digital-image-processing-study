clc();
clear;


myThisPath = get_absolute_file_path('lr3.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');


im = imread(imPath);
function start()
    //1
//    getNoiseImg(im)
//    
//    //2
//    testMedianFilter(im)
//    
//    //    3
//    testLowPassFilter(im)
//    
//     //    4
//    testHightPassFilter(im)
    //5
//    customNoiseImg = makeCustomNoise(im,15)
//    restoreImg =  useCustomLowPassFilter(customNoiseImg)
//     scf()
//     subplot(1, 2, 1); imshow(customNoiseImg); title('Исходное изображение');
//     subplot(1, 2, 2); imshow(restoreImg); title('Восстановленное изображение НЧФ');
//     
//      hightImg =  useCustomHightPassFilter(restoreImg)
//      scf()
//     subplot(1, 2, 1); imshow(restoreImg); title('Исходное изображение');
//     subplot(1, 2, 2); imshow(hightImg); title('Четкое изображение ВЧФ');
     
     
     //6
     customNoiseImg = makeCustomNoise(im,15)
     scf();xtitle("Исходник с шумом");imshow(customNoiseImg)
    restoreImg =  CustomFullFilter(customNoiseImg)
   
     
     
   
endfunction



function getNoiseImg(image)
    
imGray = rgb2gray(image);


scf();
subplot(1, 2, 1);
imshow(image);
title('Цветное изображение');


subplot(3, 4, 3);
imshow(imGray);
title('Полутоновое изображение');

subplot(3, 4, 4);
plot(imhist(imGray));
title('Гистограмма');


imWithSalt = imnoise(imGray, 'salt & pepper', 0.15);


subplot(3, 4, 7);
imshow(imWithSalt);
title('Соль-перец шум');


subplot(3, 4, 8);
plot(imhist(imWithSalt));
title('Гистограмма соль-перец шума');


imWithGaussian = imnoise(imGray, 'gaussian', 0, 0.02);


subplot(3, 4, 11);
imshow(imWithGaussian);
title('Гауссов шум');

subplot(3, 4, 12);
plot(imhist(imWithGaussian));
title('Гистограмма гауссова шума');
endfunction



function testMedianFilter(image)
    imageGray = rgb2gray(image);

    imSaltPepper = imnoise(imageGray, 'salt & pepper', 0.1);
    imSaltPepperMedian = immedian(imSaltPepper, 3);
    
    imGaussian = imnoise(imageGray, 'gaussian', 0.08, 0.005);
    imGaussianMedian = immedian(imGaussian, 3);

    scf();
  
    subplot(2, 2, 1);
    imshow(imSaltPepper);
    title('Соль-перец шум');
    
    subplot(2, 2, 2);
    imshow(imSaltPepperMedian);
    title('Медианный фильтр (Соль-перец шум)');
    
    subplot(2, 2, 3);
    imshow(imGaussian);
    title('Гауссов шум');
    
    subplot(2, 2, 4);
    imshow(imGaussianMedian);
    title('Медианный фильтр (Гауссов шум)');
endfunction




function testLowPassFilter(image)
    imageGray = rgb2gray(image);


    imSaltPepper = imnoise(imageGray, 'salt & pepper', 0.1)
    imGaussian = imnoise(imageGray, 'gaussian', 0.08, 0.005);

    filterMatrix = 1/16 * [1, 2, 1;
                           2, 4, 2;
                           1, 2, 1];
    

    imLowPassSaltPepper = imfilter(imSaltPepper, filterMatrix);
    imLowPassGaussian = imfilter(imGaussian, filterMatrix);


    scf();
    
    subplot(2, 2, 1);
    imshow(imSaltPepper);
    title('Соль-перец шум');
    
    
    
    subplot(2, 2, 2);
    imshow(imLowPassSaltPepper);
    title('НЧ фильтр (Соль-перец шум)');
    
    subplot(2, 2, 3);
    imshow(imGaussian);
    title('Гауссов шум');

    subplot(2, 2, 4);
    imshow(imLowPassGaussian);
    title('НЧ фильтр (Гауссов шум)');
endfunction



function testHightPassFilter(image)
    imageGray = rgb2gray(image);


    imSaltPepper = imnoise(imageGray, 'salt & pepper', 0.1)
    imGaussian = imnoise(imageGray, 'gaussian', 0.08, 0.005);

    filterMatrix =  [1, 1, 1;
                      1, -8, 1;
                      1, 1, 1];
//    filterMatrix =  [-1, -3, -4,-3,-1;
//                      -3, 0, 6,0,-3;
//                      -4, -6, 20,6,-4;
//                      -3, 0, 6,0,-3;
//                      -1, -3, -4,-3,-1; ];

    imHPassSaltPepper = imfilter(imSaltPepper, filterMatrix);
    imHPassGaussian = imfilter(imGaussian, filterMatrix);



    imSaltFilt= imSaltPepper - imHPassSaltPepper,
    imGausFilt= imGaussian - imHPassGaussian,

    scf();
    
    subplot(2, 2, 1);
    imshow(imSaltPepper);
    title('Соль-перец шум');
    
    
    
    subplot(2, 2, 2);
    imshow(imSaltFilt);
    title('ВЧ фильтр (Соль-перец шум)');
    
    subplot(2, 2, 3);
    imshow(imGaussian);
    title('Гауссов шум');

    subplot(2, 2, 4);
    imshow(imGausFilt);
    title('ВЧ фильтр (Гауссов шум)');
endfunction

function imgCustomNoise = makeCustomNoise(image, percent)
    imageGray = rgb2gray(image);

    [rows, cols] = size(imageGray);
    
    imgCustomNoise = imageGray;

    for i = 1:rows

        
        for j = 1:cols
            randPix = rand();
 if (randPix>percent/100) continue end
            randNum = rand();
            
            if randNum <= 0.5

                imgCustomNoise(i, j) = 255 - imgCustomNoise(i, j);
            else

                imgCustomNoise(i, j) = imgCustomNoise(i, j) + 0.3 * imgCustomNoise(i, j);
            end
        end
    end
    imgCustomNoise=uint8(imgCustomNoise)
  
    scf()
    imshow((imgCustomNoise));
endfunction

function restoreImg = useCustomLowPassFilter(imageGray)
//     filterMatrix = double( 1/14 * [1, 2, 1;
//                     2, 4, 2;
//                     2, 1, 2])
                     
      filterMatrix = double(1/571 * [2,7,12,7,2;
      7,31,52,31,7;
      12,52,127,52,12;
      7,31,52,31,7;
      2,7,12,7,2])
      restoreImg = useCustomFilter(filterMatrix,imageGray)
   
   
       
endfunction


function restoreImg = useCustomHightPassFilter(imageGray)
//     filterMatrix = double( [-1, -1, -1;
//                     -1, 8, -1;
//                     -1, -1, -1])

 filterMatrix = double( [-1, -3, -4,-3,-1;
                     -3, 0, 6,0,-3;
                     -4, 6, 20,6,-4;
                      -3, 0, 6,0,-3;
                      -1, -3, -4,-3,-1;])

//     filterMatrix = double(-1 .* [-1, -1, -1;
//                     -1, 8, -1;
//                     -1, -1, -1])
    centerPixelValue = filterMatrix(floor(size(filterMatrix, 1)/2) + 1, floor(size(filterMatrix, 2)/2) + 1);

    
    restoreImg = useCustomFilter(filterMatrix, imageGray);

    [rows, cols] = size(imageGray);
    
    if centerPixelValue > 0
        restoreImg = imageGray - restoreImg;
    else
        restoreImg = imageGray + restoreImg;
    end
   
         
endfunction



function restoreImg = useCustomFilter(filterMatrix,imageGray)
        
   
    
    [rows, cols] = size(imageGray);
    [filterRows, filterCols] = size(filterMatrix);

    padding = (size(filterMatrix,2) - 1) / 2;
    disp('паддинг',padding,size(filterMatrix,2))
    
   
    
    
//       disp(paddedImg(1,:))
//    заполнение падиногов этих
     paddedImg = fillPadding(imageGray, padding);
//    
//    disp(paddedImg(1,:))
    restoredImg = zeros(rows, cols);


    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            
            window = paddedImg((i - padding): (i + padding), (j - padding): (j + padding));
            filteredValue = min(max(sum(window .* filterMatrix), 0), 255);
            
            restoredImg(i - padding, j - padding) = uint8(filteredValue); 
        end
    end


    restoreImg = uint8(restoredImg);
   

endfunction



function restoreImg = useCustomMedianFilter(imageGray, filterSize)
    [rows, cols] = size(imageGray);
    padding = (filterSize - 1) / 2;

    paddedImg = fillPadding(imageGray, padding);

    
    paddedImg((padding + 1):(rows + padding), (padding + 1):(cols + padding)) = imageGray;

    restoreImg = zeros(rows, cols);
                
    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            window = paddedImg((i - padding):(i + padding), (j - padding):(j + padding));
            
            restoredValue = median(window(:));


            restoreImg(i - padding, j - padding) = uint8(max(0, min(255, restoredValue)));
        end
    end
    restoreImg = uint8(restoreImg);
    
endfunction

function paddedImg = fillPadding(imageGray, padding)
    [rows, cols] = size(imageGray);
    paddedImg = zeros(rows + 2 * padding, cols + 2 * padding);

    for i = 1:padding
        paddedImg(i, (padding + 1):(cols + padding)) = imageGray(padding - i + 1, :);
        paddedImg(rows + padding + i, (padding + 1):(cols + padding)) = imageGray(rows - i + 1, :);
        
            paddedImg((padding + 1):(rows + padding), i) = imageGray(:, padding - i + 1);
        paddedImg((padding + 1):(rows + padding), cols + padding + i) = imageGray(:, cols - i + 1);
    end

 

    paddedImg((padding + 1):(rows + padding), (padding + 1):(cols + padding)) = imageGray;
endfunction

function filteredIMG = CustomFullFilter(imageGray)
   restoreImgMedian =  useCustomMedianFilter(imageGray,5)
    restoreImgLowPass =  useCustomLowPassFilter(restoreImgMedian);
     filteredIMG =  useCustomHightPassFilter(restoreImgLowPass);
     scf(); 
     subplot(1,3,1)
     xtitle("медианный")
    imshow(restoreImgMedian);
     subplot(1,3,2) ;xtitle("медианный+НЧФ"); imshow(restoreImgLowPass);
      subplot(1,3,3) ;xtitle("медианный+НЧФ+ВЧФ");imshow(filteredIMG)
endfunction
