filterMatrix = double(1/571 * [2,7,12,7,2;
7,31,52,31,7;
12,52,127,52,12;
7,31,52,31,7;
2,7,12,7,2])

function reduceNoiseCallBack()
//    возможно вставить самописную из Lr3
     global hotImg;
     hotImg = imfilter(hotImg, filterMatrix);
     imshow(hotImg)
     disp(' filtered showed')

endfunction
