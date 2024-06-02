function LaplasGausCallBack()
    global hotImg framePlot a1
    setStatusWorkOn()
    sigma2 = getDoubleValueByTag("gausLaplasSigma")
    
    [gaussianMatrix, X, Y] = getGausMatrix(sigma2);
     lapGausian = getLaplasGausMatrix(sigma2, X, Y);
     hotImg = im2double(hotImg)
     hotImg = conv2(hotImg,lapGausian,'same') //границы LoG
     
     
      clf(framePlot);
        a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);
    imshow(hotImg)
    
    plot3dKernels(X, Y, gaussianMatrix,lapGausian)
    plot2dKernels(X, Y, gaussianMatrix,lapGausian)
    setStatusWorkOf()
endfunction
