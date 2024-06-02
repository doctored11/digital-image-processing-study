
function CannyBinarisationCallback()
     global hotImg framePlot a1
     setStatusWorkOn()
    highThreshold = getDoubleValueByTag("HightTrash")
       lowThreshold = getDoubleValueByTag("LowTrash")
       
       if lowThreshold<=0 then
           lowThreshold=0.01
       end
    dtI= DoubleThresholding(hotImg, lowThreshold, highThreshold)
    hotImg = HysteresisThresholding( dtI)
        sca(a1);
    imshow(hotImg)
    scf()
    imshow(dtI)
    setStatusWorkOf()
endfunction


function edgeImg = DoubleThresholding(suppressedImg, lowThreshold, highThreshold)
    [rows, cols] = size(suppressedImg);
    edgeImg = zeros(rows, cols);  
    
   
 strong = 1;
    weak = 0.5;

   
    for i = 1:rows
        for j = 1:cols
            if suppressedImg(i, j) >= highThreshold
                edgeImg(i, j) = strong;
            elseif suppressedImg(i, j) >= lowThreshold
                edgeImg(i, j) = weak;
            else
                edgeImg(i, j) = 0;
            end
        end
    end
endfunction




function finalEdges = HysteresisThresholding(edgeImg)
    [rows, cols] = size(edgeImg);
    padding = 1;
    edgeImg = fillPadding(edgeImg, padding);
    finalEdges = zeros(rows, cols);

    strong = 1;
    weak = 0.5;

    neighborOffsets = [-1, -1; -1, 0; -1, 1;0, -1;0, 1;1, -1;  1, 0;  1, 1];

//     извлекаем все сильные пиксели и добавляем их в очередь
    queue = [];
    for i = 1+padding:rows+padding
        for j = 1+padding:cols+padding
            if edgeImg(i, j) == strong
                finalEdges(i-padding, j-padding) = strong;  
                queue = [queue; i, j]; 
            end
        end
    end

//    обрабатываем очередь
    while ~isempty(queue)
//         извлекаем пиксель из очереди
        currentPixel = queue(1, :);
        queue(1, :) = [];

        for k = 1:size(neighborOffsets, 1)
            neighbor = currentPixel + neighborOffsets(k, :);
            ni = neighbor(1);
            nj = neighbor(2);
            
            if ni >= 1 && ni <= rows && nj >= 1 && nj <= cols
//                 есл соседний  пиксель слабый и не  обработан ранее то помечаем его как сильный и добавляем в очередь
                if edgeImg(ni, nj) == weak && finalEdges(ni-padding, nj-padding) == 0 //проверка на слабость и на пройденность
                    finalEdges(ni-padding, nj-padding) = strong;
                    queue = [queue; ni, nj];  // добавляем в очередь
                end
            end
        end
    end
endfunction





