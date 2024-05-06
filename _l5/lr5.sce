clc();
clear();
close(winsid());
disp('start() to start)');

myThisPath = get_absolute_file_path('lr5.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');
img = imread(imPath);
 im = rgb2gray(img);

function start()
//    1
    simpleAffine();
//    2



 scaleMatrix = [2, 0, 0; 0, 2, 0; 0, 0, 1];
    rotMatrix = [cos(0.1), sin(0.1), 0; -sin(0.1), cos(0.1), 0; 0, 0, 1];
    
    shiftMatrix = [1, 0.1, 0; 0.3,1, 0; 0, 0, 1];
    
    
//    
    scf()
    transformedImage =  applyAffineTransform(im,shiftMatrix,1);
    subplot(2,3,1); imshow(transformedImage)
    xtitle("shiftMatrix")
    
    filteredImg =  useCustomLowPassFilter(transformedImage);
   subplot(2,3,4); imshow(transformedImage)
    imshow(filteredImg);xtitle(" shiftMatrix + LowPass")
//    
    transformedImage =  applyAffineTransform(im,scaleMatrix,0);
    subplot(2,3,2); imshow(transformedImage)
    xtitle("scaleMatrix")
    
    filteredImg =  useCustomLowPassFilter(transformedImage);
   subplot(2,3,5); imshow(transformedImage)
    imshow(filteredImg);xtitle(" scaleMatrix + LowPass")
//    
    transformedImage =  applyAffineTransform(im,rotMatrix,1);
    subplot(2,3,3); imshow(transformedImage)
    xtitle("rotMatrix")
    
    filteredImg =  useCustomLowPassFilter(transformedImage);
   subplot(2,3,6); imshow(transformedImage)
    imshow(filteredImg);xtitle(" rotMatrix + LowPass")
 
  
   
      disp("size",size(transformedImage),size(im),size(filteredImg))
      

//        3(на 1 подряд)                   
        
    rotMatrix = [cosd(10), sind(10), 0; -sind(10), cosd(10), 0; 0, 0, 1];
     scaleMatrix = [1.5, 0, 0; 0, 1.5, 0; 0, 0, 1];
    shiftMatrix = [1, 0.1, 0; 0,1, 0; 0, 0, 1];
    
    scf()
    transformedImage =  applyAffineTransform(im,rotMatrix,1);
     transformedImage =  applyAffineTransform(transformedImage,scaleMatrix,0);
     transformedImage =  applyAffineTransform(transformedImage,shiftMatrix,1);
     imshow(transformedImage);xtitle("rotMatrix+scaleMatrix+shiftMatrix ")
 

endfunction

function simpleAffine()
    sx = 2;
    sy = 2;
    scaleMatrix = [sx, 0, 0; 0, sy, 0; 0, 0, 1];
    
    subplot(2, 4, 1);
    imshow(img);
    title('Исходное изображение');

    scaledIm = imresize(img, 0.1); 
    subplot(2, 4, 2);
    imshow(scaledIm);
    title('Изменение разрешения');
    
    scaledAffine = imtransform(img, scaleMatrix, 'affine');
    subplot(2, 4, 3);
    imshow(scaledAffine);
    title('Масштабирование x: ' + string(sx) + ', y: ' + string(sy));

    dx = 40;
    dy = 70;
    translationMatrix = [1, 0, 0; 0, 1, 0; dx, dy, 1];
    translatedAffine = imtransform(img, translationMatrix, 'affine');
    subplot(2, 4, 5);
    imshow(translatedAffine);
    title('Сдвиг x: ' + string(dx) + ', y: ' + string(dy));

    deg = 11;
    rotatedIm = imrotate(img, deg);
    subplot(2, 4, 6);
    imshow(rotatedIm);
    title('Поворот на ' + string(deg));

    dx1 = 0.1;
    dy1 = 0.3;
    shearedMatrix = [1, dx1, 0; dy1, 1, 0; 0, 0, 1]; 
    shearedIm = imtransform(img, shearedMatrix, 'affine');
    subplot(2, 4, 7);
    imshow(shearedIm);
    title('Скос по x: ' + string(dx1) + ', y: ' + string(dy1));

    mirroredIm = flipdim(img, 2);
    subplot(2, 4, 8);
    imshow(mirroredIm);
    title('Зеркальное отражение');
endfunction


function transformedImage = applyAffineTransform(img, transformationMatrix,strictForm)
   
    [rows, cols] = size(img);
    transformedImage = zeros(rows, cols, 'uint8');


    prevX = 1;
    prevY = 1;
    newY=1;newX =1
    for i = 1:rows
        for j = 1:cols
            newCoords = transformationMatrix * [i; j; 1];
            newX = round(newCoords(1));
            newY = round(newCoords(2));
            

             if newX >= 1 && newX <= rows && newY >= 1 && newY <= cols
                
                
                 x_range = [min(prevX, newX):max(prevX, newX)];
                y_range = [prevY:newY];


                transformedImage(x_range, y_range) = img(i, j);

                prevY = newY;
                if(strictForm) prevX = newX; end
                
               
            end 
            
        end
      
        if(~strictForm) prevX = newX; end
         
    end
endfunction


function restoreImg = useCustomLowPassFilter(imageGray)
    filterMatrix = double(1/55 * [1, 1, 1, 1, 1;
                                  1, 2, 3, 2, 1;
                                  1, 3, 25, 3, 1;
                                  1, 2, 3, 2, 1;
                                  1, 1, 1, 1, 1])




                     
//      filterMatrix = double(1/571 * [2,7,12,7,2;
//      7,31,52,31,7;
//      12,52,127,52,12;
//      7,31,52,31,7;
//      2,7,12,7,2])
      restoreImg = useCustomFilter(filterMatrix,imageGray)
   
   
       
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







