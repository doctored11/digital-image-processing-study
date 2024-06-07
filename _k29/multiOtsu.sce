function multyOtsuCallBack()
    global hotImg bImg framePlot a1 b1
        bImg = hotImg;

    setStatusWorkOn();
 
    hotImg = SSegmentation(hotImg,20);
   
    hotImg = ColorizeSegments(hotImg);


    clf(framePlot);
    a1 = newaxes(framePlot);
    a1.axes_bounds = [0 0 1 1];
    sca(a1);
   
    
    
    imshow(hotImg);
   
    setStatusWorkOf();
endfunction

function segmentedImg = SSegmentation(img, numSegments)
    histogram = imhist(img);
numSegments =numSegments-1
    
  
    
    
    percent = 0;

    numSmoothingPasses =30; 
    smoothedHistogram = histogram
      for k = 1:numSmoothingPasses
        newSmoothedHistogram = smoothedHistogram;
        for i = 2:255
          newSmoothedHistogram(i) = (smoothedHistogram(i-1) + smoothedHistogram(i) + smoothedHistogram(i+1)) / 3;
        end
        smoothedHistogram = newSmoothedHistogram;
      end
    histogram = smoothedHistogram
    localMin = [];
    prevMinV = histogram(1); 
    windowWidth = 20; 
    for i = 2:(255 - windowWidth)
        if min(histogram((i-1):(i+windowWidth-1))) == histogram(i)
            if abs(histogram(i) - prevMinV) / prevMinV >= percent
                localMin = [localMin, i];
                prevMinV = histogram(i);
            end
        end
    end
    
   
    
   

    [rows, cols] = size(img);
    segmentedImg = zeros(rows, cols);
    disp(length(localMin))
    disp(localMin)
    
//       
            if numSegments < length(localMin)

    segmentIntegrals = [];
    for i = 1:(length(localMin)-1)
        segmentIntegral = sum(histogram(localMin(i):localMin(i+1)-1));
        segmentIntegrals = [segmentIntegrals, segmentIntegral];
    end
    segmentIntegral = sum(histogram(localMin($):255)); 
    segmentIntegrals = [segmentIntegrals, segmentIntegral];

   
    [sortedIntegrals, sortedIndices] = gsort(segmentIntegrals, "g");

    selectedSegments = localMin(sortedIndices(1:numSegments));

   
    for i = (numSegments+1):length(localMin)
        closestSegmentIndex = 1;
        minDistance = abs(localMin(i) - selectedSegments(1));
        for j = 2:numSegments
            distance = abs(localMin(i) - selectedSegments(j));
            if distance < minDistance
                closestSegmentIndex = j;
                minDistance = distance;
            end
        end
     
        selectedSegments(closestSegmentIndex) = localMin(i);
    end

    localMin = selectedSegments;
end


 
//    
    
    disp(localMin)
    for i = 1:rows
        for j = 1:cols
            intensity = img(i, j);
            segment = 0;
            for k = 1:length(localMin)
                if intensity < localMin(k)
                    segment = k;
                    break;
                end
            end
            if segment == 0
                segment = length(localMin) + 1;
            end

            segmentedImg(i, j) = segment;
        end
    end
endfunction
