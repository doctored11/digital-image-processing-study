clc();
clear;
close(winsid());
disp('start() to start)')


myThisPath = get_absolute_file_path('lr4.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');
im = imread(imPath);

 myMatrix = im2uint8([
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 255, 255, 0, 0,0, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0,255, 255, 200, 150, 140, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
 ]);
 muB1Matrix = im2uint8([0,0,0;1,1,0;0,1,0])
 
 
 
 function start ()
     1
    imshow(myMatrix)  
//     2
    allOperations()
//3
     scf()
     imshow(myMatrix)
     
     delatImg = useMorfOperation(myMatrix,muB1Matrix,"dilation")
     scf()
     imshow(delatImg)
     
     erImg = useMorfOperation(myMatrix,muB1Matrix,"erosion")
     scf()
     imshow(erImg)
 
     scf()
    //  выделения внешних точек 
     imshow(myMatrix-erImg)
     scf()
    // отбеливание
     openedImg = useMorfOperation(erImg,muB1Matrix,"dilation")
     imshow(myMatrix- openedImg)
    // зачернение 
    scf()
    disp([size(myMatrix), size(delatImg)])
    closedImg = useMorfOperation(delatImg,muB1Matrix,"erosion")
     imshow( closedImg - myMatrix)
 
// 4
    scf()
    [x,y]=imhist(rgb2gray(im))
    plot(y,x)
     binaryImage = im2bw(im,0.5);

    scf(); 
    subplot(1,2,1); imshow(im); xtitle('Оригинальное изображение');
    subplot(1,2,2); imshow(binaryImage); xtitle('Бинаризованное изображение');

    dilatedImg = useMorfOperation(binaryImage, muB1Matrix, "dilation");
    erodedImg = useMorfOperation(binaryImage, muB1Matrix, "erosion");
//    
//    // Размыкание
       openedImg = useMorfOperation(erodedImg, muB1Matrix, "dilation");
//    
//    // Замыкание
        closedImg = useMorfOperation(dilatedImg, muB1Matrix, "erosion");

//    // Выделение внешних точек
        outerPoints = binaryImage - im2bw(erodedImg,0.5);

//    
//    // Отбеливание
         whitenedImg = binaryImage-im2bw(openedImg,0.5)
    //    
//    // Зачернение
        darkenedImg = im2bw(closedImg,0.5) - binaryImage

    scf(); 
    subplot(3,3,1); imshow(dilatedImg); xtitle('Наращивание');
    subplot(3,3,2); imshow(erodedImg); xtitle('Эрозия');
    subplot(3,3,3); imshow(openedImg); xtitle('Размыкание');
    subplot(3,3,4); imshow(closedImg); xtitle('Замыкание');
    subplot(3,3,5); imshow(outerPoints); xtitle('Выделение внешних точек');
    subplot(3,3,6); imshow(whitenedImg); xtitle('Отбеливание');
    subplot(3,3,7); imshow(darkenedImg); xtitle('Зачернение');

//5
//(п4 раскомент)
scf()
S2 = imgradient(binaryImage,muB1Matrix);
xtitle('imgradient')
imshow(S2);
scf()//смотри такой же результат ( из описания функции в scilab)
imshow(dilatedImg-erodedImg)
////--
scf()
imout = imfill(binaryImage)
xtitle('imfill')
imshow(imout)

////--


scf()

se = imcreatese('ellipse',3,8);

S3  = imhitmiss(rgb2gray(im),se);
xtitle('imhitmiss')
imshow(S3)
 endfunction
 
 

function allOperations()
    morf_dilate_im=imdilate(myMatrix,muB1Matrix); 
    morf_erode_im=imerode(myMatrix,muB1Matrix);
    morf_open_im=imopen(myMatrix,muB1Matrix); 
     morf_close_im=imclose(myMatrix,muB1Matrix); 
    scf() ;
    subplot(1,5,1);
    imshow(myMatrix); xtitle('Изображение')
    subplot(1,5,2); imshow(morf_dilate_im);xtitle('Операция наращивания') 
    subplot(1,5,3); imshow(morf_erode_im);xtitle('Операция эрозия') 
    subplot(1,5,4); imshow(morf_open_im);xtitle('Операция размыкание')
    subplot(1,5,5); imshow(morf_close_im);xtitle('Операция замыкание')
endfunction



//
//
//


function restoreImg = useMorfOperation(binaryImg,pattern,stringMode)
 
    [rows, cols] = size(binaryImg);
    [filterRows, filterCols] = size(pattern);

    padding = (size(pattern,2) - 1) / 2;

     paddedImg = fillPadding(binaryImg, padding);
    restoredImg = zeros(rows, cols);


    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            
            window = paddedImg((i - padding): (i + padding), (j - padding): (j + padding));
            if stringMode == "erosion"
                filteredValue = erosion(window, pattern);
            elseif stringMode == "dilation"
                filteredValue = dilation(window, pattern);
               
            else
                error("Выбери режим erosion или dilation");
            end
          
            restoredImg(i - padding, j - padding) = im2uint8(filteredValue); 
//             disp(restoredImg)
        end
    end


    restoreImg = uint8(restoredImg);
   

endfunction
//
//
//
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

function result = dilation(window, pattern)
    resultMatrix = window .* pattern;
//    disp(sum(resultMatrix(:)))
    result = (sum(resultMatrix(:)) > 0);
endfunction

function result = erosion(window, pattern)
//    в моменте просто не знаю как не спамить переводом типов)
    pattern = customImg2bw(pattern, 0); 
   
    window = customImg2bw(window, 0);
    resultMatrix = customImg2bw(window .* pattern,0);
   
    result = isequal(resultMatrix, pattern);
endfunction



function bwImg = customImg2bw(img, thresh)
    thresh = thresh *255 //для совместимости с ориг im2bw (значение передавать от 0 до 1)
    [rows, cols] = size(img);
    bwImg = repmat(%F,[rows, cols]); //просто массив false
    for i = 1:rows
        for j = 1:cols
                bwImg(i, j) =(img(i, j) > thresh);

        end
    end
endfunction


