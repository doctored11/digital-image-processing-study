function PrewittCallBack()
    global hotImg bImg framePlot a1 b1
        bImg = hotImg

    setStatusWorkOn()
 
     hotImg = Prewitt(hotImg);

     

      clf(framePlot);
        a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);

showNewPic()
    
   
    setStatusWorkOf()
endfunction

function gradImg = Prewitt(image)
    image = im2double(image)

    prewittX  = [1 0 -1;
                  1 0 -1;
                  1 0 -1];
    prewittY  = [-1 -1 -1; 0 0 0; 1 1 1];
    
    gX = conv2(image, prewittX, 'same');
    gY = conv2(image, prewittY, 'same');
    
    gradImg = sqrt(gX.^2 + gY.^2);
    

   
  endfunction

function strongBinarization()
        global hotImg bImg framePlot a1 b1
        bImg = hotImg
        trashHold = getDoubleValueByTag("trashHold");
        
        hotImg = hotImg > trashHold
        showNewPic()
endfunction

