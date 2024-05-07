function GausBlurCallBack()
    global hotImg
    sigma = getDoubleValueByTag("gausSigma")
   
    
    [gaussianMatrixFilt, X, Y] = getGausMatrix(sigma);
     hotImg = im2double(hotImg)
     hotImg = conv2(hotImg,gaussianMatrixFilt,'same');
     imshow(hotImg)
     
     scf()
     plot3dMatrix(X,Y,gaussianMatrixFilt)
endfunction
