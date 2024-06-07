function PalCallBack()
    global hotImg bImg framePlot a1 b1
    bImg = hotImg;
    trashH = getDoubleValueByTag("trashHold")
    setStatusWorkOn();

    hotImg = pal(hotImg, trashH);
    hotImg = MergeSmallClusters(hotImg);
    hotImg = ColorizeSegments(hotImg);
    showNewPic();

    setStatusWorkOf();
endfunction

function segmentedImg = pal(image, trashH)
    scaleFactor = 0.55;
    image = imresize(image, scaleFactor);
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
    segmentedImg = imresize(segmentedImg, 1/scaleFactor);
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


function segmentedImg = MergeSmallClusters(segmentedImg)
    [rows, cols] = size(segmentedImg);
    numSegments = max(segmentedImg);
    clusterSizes = zeros(1, numSegments);

    
    for i = 1:rows
        for j = 1:cols
            if segmentedImg(i, j) > 0 then
                clusterSizes(segmentedImg(i, j)) = clusterSizes(segmentedImg(i, j)) + 1;
            end
        end
    end

    // сорт по величине
    sortedClusterSizes = gsort(clusterSizes, "g", "i");
    if length(sortedClusterSizes) >= 3 then
        thresholdSize = sortedClusterSizes($-1); //от класстера процент минимальный размер 
    else
        thresholdSize = sortedClusterSizes($);  
    end

    
    for i = 1:rows
        for j = 1:cols
            if segmentedImg(i, j) > 0 then
                if clusterSizes(segmentedImg(i, j)) < 0.15 * thresholdSize then
                    segmentedImg(i, j) = 0;
                end
            end
        end
    end
endfunction

