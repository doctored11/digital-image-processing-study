function addGausNoiseCallBack()
    global hotImg bImg framePlot a1 b1
    bImg = hotImg
    setStatusWorkOn()
    
    if (typeof(hotImg)~= "uint8") then
        hotImg = im2uint8(hotImg)
    end
//    сбор значений
    nV1 = getDoubleValueByTag("noise1");
    nV2 = getDoubleValueByTag("noise2");
    

  
    hotImg = addNoise(hotImg, [nV1, nV2]);


    showNewPic()

    disp('imgNoise show')
    setStatusWorkOf()
endfunction



function noisyImage = addNoise(image, noiseRange)

//    todo реализовать шум ваш
//   todo в noisyImage положить зашумленное изображение
//
    noisyImage=image //вместо image результат

    noisyImage = uint8(max(0, min(255, noisyImage)));
endfunction

