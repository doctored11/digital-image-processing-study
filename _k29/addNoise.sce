function addGausNoiseCallBack()
    global hotImg bImg framePlot a1 b1
    bImg = hotImg
    setStatusWorkOn()
    
    if (typeof(hotImg)~= "uint8") then
        hotImg = im2uint8(hotImg)
    end
    
    mVal = getDoubleValueByTag("mGausNoise");
    vVal = getDoubleValueByTag("vGausNoise");
    

  
    hotImg = addNoise(hotImg, [mVal, vVal]);

    imshow(hotImg)
   

    disp('imgNoise show')
    setStatusWorkOf()
endfunction



function noisyImage = addNoise(image, noiseRange)

    // noiseRange - кортеж, где 1ое значение это среднее, а второе - стандартное отклонение шума
//    
    meanNoise = noiseRange(1);
    stdDevNoise = noiseRange(2);
//    disp([noiseRange])

    [height, width] = size(image);
    

    noise = meanNoise + stdDevNoise * rand(height, width, "normal"); 
//    
//    noisyImage = imnoise(im, 'gaussian',meanNoise,stdDevNoise)  //проветрка - все так же работает (тут только значения нормаиррванные)
    image = double(image);
    noisyImage = image + noise;
//
    noisyImage = uint8(max(0, min(255, noisyImage)));
endfunction

