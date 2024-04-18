clc();
clear();
close(winsid());
disp('start() to start)');

myThisPath = get_absolute_file_path('lr5.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');
im = imread(imPath);

function start()
//    1
    simpleAffine();
//    2
//   transformedImage =  customScale(2, 2)
//    disp(size(im));disp(size(transformedImage))
//    scf()
//    imshow(transformedImage)
//    //для теста сравнения
//    scf()
//    scaleMatrix = [2, 0, 0; 0, 2, 0; 0, 0, 1];
//     scaledAffine = imtransform(im, scaleMatrix, 'affine');
//
//    imshow(scaledAffine);
//    2rot
 transformedImage =  customRotate(0.1)
    disp(size(im));disp(size(transformedImage))
    scf()
    imshow(transformedImage)




endfunction

function simpleAffine()
    sx = 2;
    sy = 2;
    scaleMatrix = [sx, 0, 0; 0, sy, 0; 0, 0, 1];
    
    subplot(2, 4, 1);
    imshow(im);
    title('Исходное изображение');

    scaledIm = imresize(im, 0.1); 
    subplot(2, 4, 2);
    imshow(scaledIm);
    title('Изменение разрешения');
    
    scaledAffine = imtransform(im, scaleMatrix, 'affine');
    subplot(2, 4, 3);
    imshow(scaledAffine);
    title('Масштабирование x: ' + string(sx) + ', y: ' + string(sy));

    dx = 40;
    dy = 70;
    translationMatrix = [1, 0, 0; 0, 1, 0; dx, dy, 1];
    translatedAffine = imtransform(im, translationMatrix, 'affine');
    subplot(2, 4, 5);
    imshow(translatedAffine);
    title('Сдвиг x: ' + string(dx) + ', y: ' + string(dy));

    deg = 11;
    rotatedIm = imrotate(im, deg);
    subplot(2, 4, 6);
    imshow(rotatedIm);
    title('Поворот на ' + string(deg));

    dx1 = 0.1;
    dy1 = 0.3;
    shearedMatrix = [1, dx1, 0; dy1, 1, 0; 0, 0, 1]; 
    shearedIm = imtransform(im, shearedMatrix, 'affine');
    subplot(2, 4, 7);
    imshow(shearedIm);
    title('Скос по x: ' + string(dx1) + ', y: ' + string(dy1));

    mirroredIm = flipdim(im, 2);
    subplot(2, 4, 8);
    imshow(mirroredIm);
    title('Зеркальное отражение');
endfunction


function transformedImage =  customScale(sx, sy)
      sx = 1/sx;
    sy = 1/sy;
    scaleMatrix = [sx, 0, 0; 0, sy, 0; 0, 0, 1];
    transformedImage = applyAffineTransform(im, scaleMatrix);
endfunction

function transformedImage =  customRotate(myAngle)
      
    rotMatrix = [cos(myAngle), sin(myAngle), 0; -sin(myAngle), cos(myAngle), 0; 0, 0, 1];
    transformedImage = applyAffineTransform(im, rotMatrix);
endfunction


function transformedImage = applyAffineTransform(img, transformationMatrix)
    image = rgb2gray(img);
    [rows, cols] = size(image);
    transformedImage = zeros(rows, cols, 'uint8');

    for i = 1:rows
     for j = 1:cols
            newCoords = transformationMatrix * [i; j; 1];
            newX = round(newCoords(1));
            newY = round(newCoords(2));

//            if newX >= 1 && newX <= rows && newY >= 1 && newY <= cols
////                disp([i,j,newX,newY])
//                transformedImage(i, j) = image( newX, newY);
//
//            end

            if newX >= 1 && newX <= rows && newY >= 1 && newY <= cols
            transformedImage(newX, newY) = image( i, j);
            end
        end
    end
end






