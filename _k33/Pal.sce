function PalCallBack()
    global hotImg bImg framePlot a1 b1
    bImg = hotImg;  

    setStatusWorkOn();  

    hotImg = pal(hotImg); 
     hotImg = ColorizeSegments(hotImg);
    showNewPic();  

    setStatusWorkOf(); 
endfunction


function gradImg = pal(image)
    windowSize = 41; 
    threshold = 0.1;  

   
    [height, width] = size(image);
    halfWindow = floor(windowSize / 2);

    paddedImage = fillPadding(image, halfWindow);

    
    meanFilter = ones(windowSize, windowSize) / (windowSize * windowSize);

    
    localMean = correlate(paddedImage, meanFilter);
    localSqrMean = correlate(paddedImage .^ 2, meanFilter);
    localStd = sqrt(localSqrMean - localMean .^ 2);

    correlationMap = zeros(height, width);
    segmentedImage = zeros(height, width);


    for i = 1:height
        for j = 1:width
            localWindow = paddedImage(i:i + windowSize - 1, j:j + windowSize - 1);
            centralPixel = paddedImage(i + halfWindow, j + halfWindow);
            correlation = 0;
            for k = 1:windowSize
                for l = 1:windowSize
                    correlation = correlation + (localWindow(k, l) - localMean(i, j)) * (centralPixel - localMean(i, j));
                end
            end
            correlation = correlation / (windowSize * windowSize * localStd(i, j) ^ 2);
            correlationMap(i, j) = correlation;
        end
    end


    segmentLabel = 1;
    for i = 1:height
        for j = 1:width
            if segmentedImage(i, j) == 0 then
                if correlationMap(i, j) > threshold then

                    queue = [i, j];
                    while ~isempty(queue)
                        x = queue(1, 1);
                        y = queue(1, 2);
                        queue = queue(2:$, :);
                        if segmentedImage(x, y) == 0 then
                            segmentedImage(x, y) = segmentLabel;

                            dx = [-1; 1; 0; 0];
                            dy = [0; 0; -1; 1];
                            for k = 1:length(dx)
                                nx = x + dx(k);
                                ny = y + dy(k);
                                if nx > 0 && nx <= height && ny > 0 && ny <= width && segmentedImage(nx, ny) == 0 && correlationMap(nx, ny) > threshold then
                                    queue = [queue; nx, ny];
                                end
                            end
                        end
                    end
                    segmentLabel = segmentLabel + 1;
                end
            end
        end
    end

    gradImg = segmentedImage; 
    disp(gradImg)
endfunction


function result = correlate(image, filter)
    result = conv2(image, filter, 'same');  
endfunction
