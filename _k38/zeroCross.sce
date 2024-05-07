
function ZeroCrossCallback()
     global hotImg
    trashHold = getDoubleValueByTag("ZCTrash")
    
    hotImg= findZeroCross(hotImg,trashHold) // todo считывать trash
   
    imshow(hotImg)
endfunction


function zeroCrossImgTrahHold = findZeroCross(image, threshold)
    [numRows, numCols] = size(image);
    zeroCrossImg = zeros(numRows, numCols);

    for i = 2:numRows-1
        for j = 2:numCols-1
            if (image(i, j) > 0)
                if (image(i, j+1) >= 0 && image(i, j-1) < 0) || (image(i, j+1) < 0 && image(i, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i+1, j) >= 0 && image(i-1, j) < 0) || (image(i+1, j) < 0 && image(i-1, j) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i+1, j+1) >= 0 && image(i-1, j-1) < 0) || (image(i+1, j+1) < 0 && image(i-1, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i-1, j+1) >= 0 && image(i+1, j-1) < 0) || (image(i-1, j+1) < 0 && image(i+1, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                end
            end
        end
    end

    zeroCrossImg = im2uint8(zeroCrossImg);
    zeroCrossImgTrahHold= zeroCrossImg>threshold;
end
