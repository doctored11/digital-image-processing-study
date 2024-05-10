
function IversonCallback()
      global hotImg; 
      setStatusWorkOn()
     trashHold = getDoubleValueByTag("IversonTrashHold");
      hotImg = Iverson(hotImg,trashHold);
      imshow(hotImg);
     setStatusWorkOf()
endfunction

function edgeImage =  Iverson(img,threshold)
    
    image = im2double(img)
   
//    градиенты
    dx = conv2(image, [-1, 0, 1; -1, 0, 1; -1, 0, 1], 'same');
    dy = conv2(image, [-1, -1, -1; 0, 0, 0; 1, 1, 1], 'same');

    gradientMagnitude = sqrt(dx.^2 + dy.^2);

//
//    disp([max(gradientMagnitude),min(gradientMagnitude)])
//    disp(typeof(gradientMagnitude))

//    пороговое отсечение
    edgeImage = im2uint8(gradientMagnitude) > threshold ;

    
endfunction
//

