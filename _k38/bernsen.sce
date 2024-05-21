
function BernsenCallack()
    setStatusWorkOn()
    disp('Bernsen start')
     global hotImg
    windowSize = getDoubleValueByTag("BernWindiwSize")
    if modulo(windowSize, 2) == 0 then
        windowSize = windowSize + 1; 
    end
    
    trash = getDoubleValueByTag("BernTrashHold")
    
    
    hotImg = bernsen(hotImg, windowSize, trash);
    imshow(hotImg);
    setStatusWorkOf()
      disp('Bernsen end')
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

function restoredImg = bernsen(image, windowSize, threshold)
    [rows, cols] = size(image);
  padding = (windowSize - 1) / 2;
    image = fillPadding(image, padding);
      
    restoredImg = zeros(rows, cols);


    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            
            windowFilter = image((i - padding): (i + padding), (j - padding): (j + padding));
            minV = min(windowFilter)
            maxV = max(windowFilter)
            
            Avg = (minV+maxV)/2 ;
//          if image(i, j) > Avg && Avg > threshold
            if image(i, j) > Avg && image(i, j) < threshold
                restoredImg(i - padding, j - padding) = 255; 
            elseif Avg < threshold
                restoredImg(i - padding, j - padding) = 120; 
            else
                restoredImg(i - padding, j - padding) = 0;
            end
        end
    end
    
endfunction




