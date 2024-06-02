function  otsu()
    setStatusWorkOn()
   global hotImg

    image=hotImg

    histogram =imhist(image);
    numBins = size(histogram, 1);


//    вероятности  каждого уровня яркости
    probabilities = histogram / sum(histogram);

    maxVariance = 0;
    optimalThreshold = 0;

//     ищем оптимальн порог
    for threshold = 1:numBins
        
//  вычисление вероятностей для  каждого класса (объектов и фона)
        probClass1 = sum(probabilities(1:threshold));
        probClass2 = sum(probabilities(threshold+1:numBins));
        
        meanClass1 = sum((0:threshold-1)' .* probabilities(1:threshold)) / probClass1;
        meanClass2 = sum((threshold:numBins-1)' .* probabilities(threshold+1:numBins)) / probClass2;

// дисперсия
        variance = probClass1 * probClass2 * (meanClass1 - meanClass2)^2;

        if variance > maxVariance
            maxVariance = variance;
            optimalThreshold = threshold - 1;
        end
    end

//   бинаризация   
    disp(optimalThreshold)
    segmentedImage = image >= optimalThreshold;

    hotImg= segmentedImage;
//    disp(hotImg);
    imshow(hotImg)
    setStatusWorkOf()
end


