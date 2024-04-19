xdel();
clc(); 
clear

myThisPath = get_absolute_file_path('lr2.sce');
imPath = fullfile(myThisPath, 'res', 'Falfel.jpg');

im = imread(imPath);
im1=rgb2gray(im)


function start()
//    1
    imshow(im1)
    getGrayHistsOfChannels()
//    2

    getBinaryIMG()
//3.1
scf()
customHist(im1)
customNegative()
//


//3.2
scf()
  subplot(2,2,1);xtitle("Оригинал");imshow(im1)
    subplot(2,2,2);customBW(im1,70)
    subplot(2,2,3);customBW(im1,128)
    subplot(2,2,4);customBW(im1,200)
//    3.3

   scf()
   resultImage = changeBrightness(im1,5,250)
   subplot(2,4,1);imshow(im1);xtitle("Оригинал")
    subplot(2,4,3);imshow(resultImage); ;xtitle("выделение яркости 5-250")
    subplot(2,4,2);customHist(im1);
    subplot(2,4,4);customHist(resultImage);
    
     resultImage = changeBrightness(im1,50,125)
     subplot(2,4,5);imshow(resultImage); ;xtitle("выделение яркости 50-125")
     subplot(2,4,6);customHist(resultImage);
     
     resultImage = changeBrightness(im1,190,225)
     subplot(2,4,7);imshow(resultImage); ;xtitle("выделение яркости 190-225")
     subplot(2,4,8);customHist(resultImage);
//     
       scf()
   resultImage = changeBrightness(im1,10,50)
   subplot(2,4,1);imshow(im1);xtitle("Оригинал")
    subplot(2,4,3);imshow(resultImage); ;xtitle("выделение яркости 10-50")
    subplot(2,4,2);customHist(im1);
    subplot(2,4,4);customHist(resultImage);
    
     resultImage = changeBrightness(im1,225,245)
     subplot(2,4,5);imshow(resultImage); ;xtitle("выделение яркости 225-245")
     subplot(2,4,6);customHist(resultImage);
     
     resultImage = changeBrightness(im1,128,129)
     subplot(2,4,7);imshow(resultImage); ;xtitle("выделение яркости 128-129")
     subplot(2,4,8);customHist(resultImage);
   
endfunction

function getGrayHistsOfChannels()
    [m, n, z] = size(im);
    R = im(1:m, 1:n, 1);
    G = im(1:m, 1:n, 2);
    B = im(1:m, 1:n, 3);

    IM_RGB1(1:m, 1:n, 1:3) = uint8(0);
    IM_RGB2(1:m, 1:n, 1:3) = uint8(0);
    IM_RGB3(1:m, 1:n, 1:3) = uint8(0);

    IM_RGB1(1:m, 1:n, 1) = R;   
    IM_RGB2(1:m, 1:n, 2) = G;
    IM_RGB3(1:m, 1:n, 3) = B;
    
    scf();
    clf();

    fullGist =imhist(rgb2gray(im))
    RGist=imhist(rgb2gray(IM_RGB1))
    GGist=imhist(rgb2gray(IM_RGB2))
    BGist=imhist(rgb2gray(IM_RGB3))
    
    subplot(2,4,1);xtitle("Оригинал "); imshow(rgb2gray(im));
    subplot(2,4,2);xtitle("R-канал "); imshow(rgb2gray(IM_RGB1));
    subplot(2,4,5);xtitle("G-канал ") ;imshow(rgb2gray(IM_RGB2));
    subplot(2,4,6);xtitle("B-канал ") ;imshow(rgb2gray(IM_RGB3));
  
     subplot(1,2,2);
     plot(fullGist,'-k');
     plot(RGist,'-r');
     plot(GGist,'-g');
    plot(BGist,'-b');
 endfunction
    
    
function getBinaryIMG()
    
    scf();
    imGray=rgb2gray(im);
    binaryImg1 = im2bw(imGray, 0.3);
    binaryImg2 = im2bw(imGray, 0.6);
    binaryImg3 = im2bw(imGray, 0.9);
    subplot(2,2,1);xtitle("Оригинал "); imshow(imGray);
    subplot(2,2,2);xtitle("0.3"); imshow(binaryImg1);
    subplot(2,2,3);xtitle("0.6") ;imshow(binaryImg2);
    subplot(2,2,4);xtitle("0.9"); imshow(binaryImg3);
    
endfunction

function customHist(imageGray)
    [rows, cols] = size(imageGray);
    maxIntensity = 255;
    histogram = zeros(1,maxIntensity + 1); 
    
    imageGray=uint16(imageGray)
    for i = 1:rows
        for j = 1:cols
            intensity = imageGray(i, j);

                histogram(( intensity + 1)) = histogram(intensity + 1) + 1; 
          
        end
    end

    plot2d(histogram);
    xtitle("Рукописная гистограмма");
endfunction










function customNegative()
    imGray = rgb2gray(im);
    
   dataType = typeof(imGray);
   //просто украл логику из lr1 не думая
    img1_int16 = int16(imGray);
    NegIm = convertToType(dataType, min(max(int16(floor(255- double(img1_int16))), 0), 255));
    scf()
    subplot(1,3,1);imshow(imGray)
    subplot(1,3,2);imshow(NegIm)
    subplot(1,3,3);customHist(NegIm)
endfunction

function result = convertToType(dataType, value)
    switch dataType
        case 'int8'
            result = int8(value);
        case 'int16'
            result = int16(value);
        case 'int32'
            result = int32(value);
        case 'int64'
            result = int64(value);
        case 'uint8'
            result = uint8(value);
        case 'uint16'
            result = uint16(value);
        otherwise
            error('Неподдерживаемый тип данных -_-');
    end
end

function customBW(imageGray,trash)

           binaryImage = zeros(size(imageGray, 1), size(imageGray, 2));

        binaryImage(imageGray > trash) = 255;
        disp([size(imageGray),size(binaryImage)])
        
           imshow(uint8(binaryImage));
           xtitle("Бинарная маска с trash = "+ string(trash))


endfunction
function resultImage = changeBrightness(imGray, xMin, xMax)
    dataType = typeof(imGray);


 resultImage = round((255 / double(xMax - xMin)) * double(imGray - xMin));



    resultImage(imGray < xMin) = 0;
    resultImage(imGray > xMax) = 255;


    resultImage = convertToType(dataType, resultImage);
endfunction






