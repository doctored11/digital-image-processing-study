filterMatrix = double(1/571 * [2,7,12,7,2;
7,31,52,31,7;
12,52,127,52,12;
7,31,52,31,7;
2,7,12,7,2])

//Это удаление шумов можно оставить 

function reduceNoiseCallBack()
//    возможно вставить самописную из Lr3
setStatusWorkOn()
        global hotImg bImg framePlot a1 b1
        bImg = hotImg
     hotImg = imfilter(hotImg, filterMatrix);
      
     showNewPic()
     disp(' filtered showed')
setStatusWorkOf()
endfunction

