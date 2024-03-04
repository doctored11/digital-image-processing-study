clc();
clear;

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
     
//     1
imshow(myMatrix)
//     2
allOperations()
//3

 delatImg = useMorfOperation(myMatrix,muB1Matrix,"dilation")
 scf()
 imshow(delatImg)
 
  erImg = useMorfOperation(myMatrix,muB1Matrix,"erosion")
 scf()
 imshow(erImg)

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
    pattern = im2bw(pattern, 0); 
    window = im2bw(window, 0);
    resultMatrix = im2bw(window .* pattern,0);
   
    result = isequal(resultMatrix, pattern);
endfunction

