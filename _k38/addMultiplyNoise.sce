function addGausNoiseCallBack()
    global hotImg;
    
    setStatusWorkOn()
    
    if (typeof(hotImg)~= "uint8") then
        hotImg = im2uint8(hotImg)
    end
    

    minVal = getDoubleValueByTag("minGausNoise");
    maxVal = getDoubleValueByTag("maxGausNoise");
    disp([minVal,maxVal])

    if (maxVal < minVal)
        temp = minVal;
        minVal = maxVal;
        maxVal = temp;
    end
    hotImg = addMultiplicativeNoise(hotImg, [minVal, maxVal]);

    imshow(hotImg)

    disp('imgNoise show')
    setStatusWorkOf()
endfunction

function noisyImage = addMultiplicativeNoise(image, noiseRange)
//    noiseRange - кортеж где 1ое мин второе max
    noisyImage = zeros(size(image));

    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            if(rand()<0.6) noisyImage(i, j)=double(image(i, j));continue end

            noiseFactor = rand()*(noiseRange(2)-noiseRange(1))+noiseRange(1);
            noisyImage(i, j) =  min(max(double(image(i, j)) * noiseFactor, 0), 255);
        end
    end

    noisyImage = uint8(noisyImage);
endfunction
