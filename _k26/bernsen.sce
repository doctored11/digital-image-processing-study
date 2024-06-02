
function BernsenCallback()
    setStatusWorkOn()
  
    disp('Bernsen start')
     global hotImg framePlot a1
    windowSize = getDoubleValueByTag("BernWindiwSize")
    if modulo(windowSize, 2) == 0 then
        windowSize = windowSize + 1; 
    end
    disp([windowSize])
    trash = getDoubleValueByTag("BernTrashHold");
//    
    hotImg = bernsen(hotImg, windowSize, trash);


     clf(framePlot)
      a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);
    imshow(hotImg);
   
    setStatusWorkOf();
    disp('Bernsen end');
endfunction


function restoredImg = bernsen(image, windowSize, threshold)
    [rows, cols] = size(image);
  padding = (windowSize - 1) / 2;
    image = fillPadding(image, padding);
      lastColor=0
    restoredImg = zeros(rows, cols);

    bufferTrash =threshold
    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            
            windowFilter = image((i - padding): (i + padding), (j - padding): (j + padding));
            minV = min(windowFilter)
            maxV = max(windowFilter)
            contrast = maxV-minV
            Avg = (minV+maxV)/2 ;
            
            
            
            if contrast > bufferTrash then
                if image(i,j) >= Avg then
                    
                restoredImg(i - padding, j - padding) = 1; 
                lastColor =1
                else
                restoredImg(i - padding, j - padding) = 0; 
                lastColor =0
            end
             bufferTrash =threshold
            else
            restoredImg(i - padding : i, j - padding:j) = lastColor; 
            lastColor= Avg>bufferTrash
//            lastColor = 0
            continue
           end
        end
        lastColor = 0
    end

endfunction


