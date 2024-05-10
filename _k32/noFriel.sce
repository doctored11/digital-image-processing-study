function  friel()
    global hotImg
      setStatusWorkOn()
        radius= getDoubleValueByTag("FrielWindow")
        if modulo(radius, 2) == 0 then
        increasedRadius = radius + 1;end
    image = im2double(hotImg)
    
    [rows, cols] = size(image);
    

    segmentedImage = zeros(rows, cols);
  

    for i = 1:rows
        for j = 1:cols

         

//    окно
            startX = max(1, i - radius);
            endX = min(rows, i + radius);
            startY = max(1, j - radius);
            endY = min(cols, j + radius);
            
            neighborhood = image(startX:endX, startY:endY);

//     среднее значение  пикселей в окрестности
            meanValue = mean(neighborhood(:));

            image(i, j) = image(i, j)>= meanValue
//                segmentedImage(i, j) = 255; 
          
            
        end
        disp(i)
    end


//    segmentedImage = uint8(segmentedImage); 
   
//    clf();
     hotImg = image
    imshow(hotImg)
//      imshow(newIm);
      setStatusWorkOf();

end
