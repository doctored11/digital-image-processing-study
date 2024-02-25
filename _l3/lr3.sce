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
   customNoiseImg = makeCustomNoise(im,15)
   useCustomFilter(im)
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

function restoreImg = useCustomFilter(image)
        imageGray = rgb2gray(image);
    filterMatrix =  [1, 1, 1;
                     1, -8, 1;
                     1, 1, 1];
    
    [rows, cols] = size(imageGray);
    [filterRows, filterCols] = size(filterMatrix);

    padding = (size(filterMatrix) - 1) / 2;
    
    paddedImg = zeros(rows + 2 * padding(1), cols + 2 * padding(2));

    paddedImg((padding(1) + 1):(rows + padding(1)), (padding(2) + 1):(cols + padding(2))) = imageGray;
    
    
//       disp(paddedImg(1,:))
//    заполнение падиногов этих
     for i = 1:padding(1)
        paddedImg(i, (padding(2) + 1):(cols + padding(2))) = imageGray(padding(1) - i + 1, :);
    end


    for i = 1:padding(1)
    paddedImg(rows + padding(1) + i, (padding(2) + 1):(cols + padding(2))) = imageGray(rows - i + 1, :);

    end


    for j = 1:padding(2)
        paddedImg((padding(1) + 1):(rows + padding(1)), j) = imageGray(:, padding(2) - j + 1);
    end


    for j = 1:padding(2)
    paddedImg((padding(1) + 1):(rows + padding(1)), cols + padding(2) + j) = imageGray(:, cols - j + 1);

    end
//    
//    disp(paddedImg(1,:))
    restoredImg = zeros(rows, cols);
    
    for i = (1 + padding(1)): (rows + padding(1))
        for j = (1 + padding(2)): (cols + padding(2))
            window = paddedImg((i - padding(1)): (i + padding(1)), (j - padding(2)): (j + padding(2)));
            restoredImg(i - padding(1), j - padding(2)) = sum(sum(window .* filterMatrix));
        end
    end

    restoreImg = uint8(restoredImg);

    scf()
    subplot(1, 2, 1); imshow(imageGray); title('Исходное изображение');
    subplot(1, 2, 2); imshow(restoreImg); title('Восстановленное изображение');
//    тут получать картинку и если это высокие частоты то складывать с исходником
endfunction

