
//close(winsid());
//clc
//clear
//myThisPath = get_absolute_file_path('test2.sce');
//imPath = fullfile(myThisPath, 'res', 'Testbuilding.jpg');
//im = imread(imPath);
//im = rgb2gray(im);
//
//global hotImg
//hotImg = im


// filterMatrix = 1/16 * [1, 2, 1;
//                           2, 4, 2;
//                           1, 2, 1];
//
filterMatrix = double(1/571 * [2,7,12,7,2;
7,31,52,31,7;
12,52,127,52,12;
7,31,52,31,7;
2,7,12,7,2])
//function start()
//
//
//    MarrHild(im2double(hotImg))
//endfunction


//
////
////Интерфейс
//
//mainWindow = createWindow();
//mainWindow.figure_name = "38 | Границы у полутонового изображения ";
//
//framePlot = uicontrol(mainWindow, ...
//    "style", "frame", ...
//    "constraints", createConstraints("border", "center"), ...
//    "backgroundcolor", [0 0 0], ...
//    "layout", "border", ...
//    "units", "normalized", ...
//    "position", [0, 0.6, 0.4, 0.4]);
//
//
// clf(framePlot);
//    a1 = newaxes(framePlot);
//    a1.axes_bounds = [0 0 1 1];
//    sca(a1);
//
//    imshow(hotImg)

//
////    +ШУМ
//    btnMod = uicontrol(mainWindow, ...
//        "Style", "pushbutton", ...
//        "String", "+Шум", ...
//        "fontSize", 16, ...
//        "ForegroundColor", [0.8, 0.1, 0.1], ...
//        "units", "normalized", ...
//        "position", [0.7, 0.83, 0.2, 0.05], ...
//        "callback", "addGausNoiseCallBack");
//
//     uicontrol(mainWindow, ...
//        "style", "text", ...
//        "String", "  min и max шум",...
//        "units", "normalized", ...
//        "position", [0.55, 0.9, 0.35, 0.05],...
//        "HorizontalAlignment", "left", ...
//        "VerticalAlignment", "middle");
//
//     uicontrol(mainWindow, ...
//        "style", "edit", ...
//        "String", string(0.9),...
//        "units", "normalized", ...
//        "position", [0.55, 0.83, 0.06, 0.05], ...
//        "tag", "minGausNoise")
//
//     uicontrol(mainWindow, ...
//        "style", "edit", ...
//        "String", string(0.9),...
//        "units", "normalized", ...
//        "position", [0.63, 0.83, 0.06, 0.05], ...
//        "tag", "maxGausNoise")
//
////     -Шум
//        btnMod = uicontrol(mainWindow, ...
//        "Style", "pushbutton", ...
//        "String", "-Шум (НЧФ)", ...
//        "fontSize", 16, ...
//        "ForegroundColor", [0.1, 0.8, 0.1], ...
//        "units", "normalized", ...
//        "position", [0.55, 0.76, 0.35, 0.05], ...
//        "callback", "reduceNoiseCallBack");
//
//
//
//
//
//
    function addGausNoiseCallBack()
    global hotImg;
//    todo: сигнализировать о том что идет процесс
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
//    todo: показывать что все закончено
    disp('imgNoise show')
endfunction
//
//
//
//
//
//
//function noisyImage = addMultiplicativeNoise(image, noiseRange)
////    noise_range - кортеж где 1ое мин второе max
//    noisyImage = zeros(size(image));
//
//    for i = 1:size(image, 1)
//        for j = 1:size(image, 2)
//            if(rand()<0.6) noisyImage(i, j)=double(image(i, j));continue end
//
//            noiseFactor = rand()*(noiseRange(2)-noiseRange(1))+noiseRange(1);
//            noisyImage(i, j) =  min(max(double(image(i, j)) * noiseFactor, 0), 255);
//        end
//    end
//
//    noisyImage = uint8(noisyImage);
//endfunction
//
//function reduceNoiseCallBack()
////    возможно вставить самописную из Lr3
//     global hotImg;
//     hotImg = imfilter(hotImg, filterMatrix);
//     imshow(hotImg)
//     disp(' filtered showed')
//
//endfunction
//
//
//function valueFromUser = getDoubleValueByTag(tag)
//     valueFromUser = strtod(findobj(mainWindow, "tag", tag).string);
//endfunction
