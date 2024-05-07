function LaplasGausCallBack()
    global hotImg
    sigma2 = getDoubleValueByTag("gausLaplasSigma")
    
    [gaussianMatrix, X, Y] = getGausMatrix(sigma2);
     lapGausian = getLaplasGausMatrix(sigma2, X, Y);
     hotImg = im2double(hotImg)
     hotImg = conv2(hotImg,lapGausian,'same') //границы LoG
  
    imshow(hotImg)
    
    plot3dKernels(X, Y, gaussianMatrix,lapGausian)
    plot2dKernels(X, Y, gaussianMatrix,lapGausian)
endfunction
