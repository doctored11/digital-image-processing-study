function PalCallBack()
    global hotImg  framePlot a1 
    setStatusWorkOn();
    scaleFactor = 0.35;
    hotImg = imresize(hotImg, scaleFactor);
    

// написать что это pal метод с присоединением малых класстеров
    trashH = getDoubleValueByTag("trashHold")
    numClusters = getDoubleValueByTag("sizeV")
    
    

    hotImg = pal(hotImg, trashH);
    hotImg = MergeSmallClusters(hotImg,numClusters);
    hotImg = ColorizeSegments(hotImg);
    hotImg = imresize(hotImg, 1/scaleFactor);
       
        imshow(hotImg)

    setStatusWorkOf();
endfunction
           

function segmentedImg = pal(image, trashH)
   
    [rows, cols] = size(image);
    segmentedImg = zeros(rows, cols);
    segmentLabel = 1;
    threshold = trashH; 
    visited = zeros(rows, cols);

    for i = 1:rows
        disp(string(i) + " / " + string(rows))
        for j = 1:cols
            if visited(i, j) == 0 then
                [segmentedImg, visited] = RegionGrowing(image, segmentedImg, visited, i, j, segmentLabel, threshold);
                segmentLabel = segmentLabel + 1;
            end
        end
    end
 
endfunction

function [segmentedImg, visited] = RegionGrowing(image, segmentedImg, visited, x, y, segmentLabel, threshold)
    [rows, cols] = size(image);
    seedValue = image(x, y);
    stack = [x, y];  

    while ~isempty(stack)
        i = stack($, 1);  
        j = stack($, 2);
        stack = stack(1:$-1, :); 

        if i > 0 && i <= rows && j > 0 && j <= cols then
            if visited(i, j) == 0 && abs(image(i, j) - seedValue) <= threshold then
                visited(i, j) = 1;
                segmentedImg(i, j) = segmentLabel;

//               
                if i+1 <= rows && visited(i+1, j) == 0 then
                    stack = [stack; i+1, j];
                end
                if i-1 > 0 && visited(i-1, j) == 0 then
                    stack = [stack; i-1, j];
                end
                if j+1 <= cols && visited(i, j+1) == 0 then
                    stack = [stack; i, j+1];
                end
                if j-1 > 0 && visited(i, j-1) == 0 then
                    stack = [stack; i, j-1];
                end
            end
        end
    end
endfunction



function segmentedImg = MergeSmallClusters(segmentedImg,numClusters)
    [rows, cols] = size(segmentedImg);
    numSegments = max(segmentedImg);
    clusterSizes = zeros(1, numSegments);

    disp("1 = Подсчет размеров кластеров")
    for i = 1:rows
         disp("1 = "+string(i) + " / " + string(rows))
        for j = 1:cols
            if segmentedImg(i, j) > 0 then
                clusterSizes(segmentedImg(i, j)) = clusterSizes(segmentedImg(i, j)) + 1;
            end
        end
    end

    
    [sortedSizes, sortedIndices] = gsort(clusterSizes, "g", "d");
    largestSegments = sortedIndices(1:numClusters); // Получаем индексы 10 крупнейших кластеров

    disp("3 = Присваивание черных областей крупным кластерам")
    for label = 1:numSegments
         disp("3 = "+string(label) + " / " + string(numSegments))
        if ~ismember(label, largestSegments) then
            segmentedImg(segmentedImg == label) = 0; // Присваиваем черные области
        end
    end

    disp("4 = Присвоение ближайших крупных кластеров черным областям")
    for i = 1:rows
         disp("4 = "+string(i) + " / " + string(rows))
        for j = 1:cols
            if segmentedImg(i, j) == 0 then
                nearestLabel = findNearestLabel(segmentedImg, i, j, largestSegments);
                if nearestLabel > 0 then
                    segmentedImg(i, j) = nearestLabel;
                    clusterSizes(nearestLabel) = clusterSizes(nearestLabel) + 1;
                end
            end
        end
    end

    disp("5 = Завершение")
    disp(size(segmentedImg))
    disp(max(segmentedImg))
endfunction

function nearestLabel = findNearestLabel(segmentedImg, x, y, largestSegments)
    [rows, cols] = size(segmentedImg);
    nearestLabel = 0;
    minDistance = %inf;

    for label = largestSegments
        [r, c] = find(segmentedImg == label);
        for k = 1:length(r)
            distance = sqrt((x - r(k))^2 + (y - c(k))^2);
            if distance < minDistance then
                minDistance = distance;
                nearestLabel = label;
            end
        end
    end
endfunction



function res = ismember(value, array)
    res = %F;
    for i = 1:length(array)
        if array(i) == value then
            res = %T;
            break;
        end
    end
endfunction


