function EikvilCallBack()
     global hotImg framePlot a1
       setStatusWorkOn();
       
         big_window_size = getDoubleValueByTag("bW");
        small_window_size = getDoubleValueByTag("sW");
        
     hotImg = eqvila(hotImg,big_window_size,small_window_size );
     
      clf(framePlot)
      a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);
    imshow(hotImg);
   
    setStatusWorkOf();
    disp('Bernsen end');
endfunction

function result = eqvila(image, big_window_size, small_window_size)
    E = 0.4
    image = fillPadding(image,big_window_size)
    [rows, cols] = size(image);
    threshold_image = zeros(rows, cols);

    step = small_window_size;
    for i = 1:step:rows-big_window_size
        for j = 1:step:cols-big_window_size
            big_window = image(i:i+big_window_size-1, j:j+big_window_size-1);
            threshold = (double(max(big_window))+double(min(big_window)))*E //так просто лучше
//            threshold = otsu(image) как по факту
            disp(threshold)
            small_window = image(i:i+small_window_size-1, j:j+small_window_size-1);
            threshold_image(i:i+small_window_size-1, j:j+small_window_size-1) = small_window > threshold;
        end
    end

result=threshold_image(1+big_window_size:cols - big_window_size,1+big_window_size:rows-big_window_size);
endfunction
function optimalThreshold = otsu(img)
    image=img

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

endfunction

