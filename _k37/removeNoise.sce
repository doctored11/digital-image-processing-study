filterMatrix = double(1/571 * [2,7,12,7,2;
7,31,52,31,7;
12,52,127,52,12;
7,31,52,31,7;
2,7,12,7,2])

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



//альтернативщина рукаписная вырвана из lr3 - в финале не испаользуется
//function restoreImg=useCustomLowPassFilter(imageGray)
////     filterMatrix = double( 1/14 * [1, 2, 1;
////                     2, 4, 2;
////                     2, 1, 2])
////                     
//      filterMatrix = double(1/571 * [2,7,12,7,2;
//      7,31,52,31,7;
//      12,52,127,52,12;
//      7,31,52,31,7;
//      2,7,12,7,2]);
//      restoreImg = useCustomFilter(filterMatrix,imageGray)
//
//endfunction
//function restoreImg=useCustomFilter(filterMatrix, imageGray)
//        
//    [rows, cols] = size(imageGray);
//    [filterRows, filterCols] = size(filterMatrix);
//
//    padding = (size(filterMatrix,2) - 1) / 2;
//    disp('паддинг',padding,size(filterMatrix,2))
//    
////    заполнение падиногов 
//     paddedImg = fillPadding(imageGray, padding);
////    disp(paddedImg(1,:))
//    restoredImg = zeros(rows, cols);
//
//    for i = (1 + padding): (rows + padding)
//        for j = (1 + padding): (cols + padding)
//            
//            window = paddedImg((i - padding): (i + padding), (j - padding): (j + padding));
//            filteredValue = min(max(sum(window .* filterMatrix), 0), 255);
//            
//            restoredImg(i - padding, j - padding) = uint8(filteredValue); 
//        end
//    end
//
//    restoreImg = uint8(restoredImg);
//   
//endfunction
////
