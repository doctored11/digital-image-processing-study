
function ZeroCrossCallback()
     global hotImg framePlot a1
     setStatusWorkOn()
    trashHold = getDoubleValueByTag("ZCTrash")
    
    hotImg= findZeroCross(hotImg,trashHold) 

        sca(a1);
    imshow(hotImg)
    setStatusWorkOf()
endfunction


function zeroCrossImgTrahHold = findZeroCross(image, threshold)
    
    
    [numRows, numCols] = size(image);
    zeroCrossImg = zeros(numRows, numCols);
    
    for i = 2:numRows-1
        for j = 2:numCols-1
             window = image(i-1:i+1, j-1:j+1);
              minVal = min(window(:));
            maxVal = max(window(:));
            disp([maxVal, minVal])
             if maxVal - minVal > threshold
                 
                 if (image(i, j-1) > 0 && image(i, j+1) < 0) || (image(i, j-1) < 0 && image(i, j+1) > 0)
                        zeroCrossImg(i, j) = 255;
    
                    elseif (image(i-1, j) > 0 && image(i+1, j) < 0) || (image(i-1, j) < 0 && image(i+1, j) > 0)
                        zeroCrossImg(i, j) = 255;
    
                    elseif (image(i-1, j-1) > 0 && image(i+1, j+1) < 0) || (image(i-1, j-1) < 0 && image(i+1, j+1) > 0)
                        zeroCrossImg(i, j) = 255;
    
                    elseif (image(i-1, j+1) > 0 && image(i+1, j-1) < 0) || (image(i-1, j+1) < 0 && image(i+1, j-1) > 0)
                        zeroCrossImg(i, j) = 255;
                    else
                        zeroCrossImg(i, j) = 0;
                    end
               else
                   zeroCrossImg(i, j) = 0;
            end
        end
    end


    zeroCrossImgTrahHold= zeroCrossImg
end
