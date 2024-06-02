function SobelGradientCallBack()
    global hotImg framePlot a1
    setStatusWorkOn()
     hotImg = SobelGradien(hotImg);

      clf(framePlot);
        a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);
    imshow(hotImg)
    
   
    setStatusWorkOf()
endfunction

function gradImg = SobelGradien(image)
    image = im2double(image)

    sobelX = [1 0 -1; 2 0 -2; 1 0 -1];
    sobelY = [1 2 1; 0 0 0; -1 -2 -1];
    
    // Применяем операторы Собеля к изображению
    gradX = conv2(image, sobelX, 'same');
    gradY = conv2(image, sobelY, 'same');

    gradMagnitude = sqrt(gradX.^2 + gradY.^2);
    gradImg = gradMagnitude; //тут лежит изображение градиентов
    //       gradImg = gradMagnitude / max(gradMagnitude(:)); //нормировка
    
    suppressedGradImg =  NonMaximumSuppression(gradX, gradY, gradMagnitude)
    gradImg = suppressedGradImg
  endfunction



function suppressedImg = NonMaximumSuppression(gradX, gradY, gradMagnitude)
    [rows, cols] = size(gradMagnitude);
    padding = 1
     gradMagnitude = fillPadding(gradMagnitude,padding)
    suppressedImg = zeros(rows, cols);
    
    // Вычисляем направления градиентов
    gradientDirection = atan(gradY, gradX) * (180 / %pi);
    gradientDirection(gradientDirection < 0) = gradientDirection(gradientDirection < 0) + 180;

    angleStep = 45;  
    halfAngleStep = angleStep / 2;

    for i = 2:(rows - 1)
        for j = 2:(cols - 1)
            angle = gradientDirection(i, j);
            mag = gradMagnitude(i, j);
            
            // проверка  в каком направлении идет градиент и подавляем немаксимумы
            if ((angle >= 0 && angle < halfAngleStep) || (angle >= 180 - halfAngleStep && angle <= 180))  // градиент по горизонтали
                if (mag >= gradMagnitude(i, j-1) && mag >= gradMagnitude(i, j+1))
                    suppressedImg(i, j) = mag;
                end
            elseif (angle >= halfAngleStep && angle < (halfAngleStep + angleStep))  // по диагонали 
                if (mag >= gradMagnitude(i-1, j+1) && mag >= gradMagnitude(i+1, j-1))
                    suppressedImg(i, j) = mag;
                end
            elseif (angle >= (halfAngleStep + angleStep) && angle < (halfAngleStep + 2 * angleStep))  //  вертикали
                if (mag >= gradMagnitude(i-1, j) && mag >= gradMagnitude(i+1, j))
                    suppressedImg(i, j) = mag;
                end
            elseif (angle >= (halfAngleStep + 2 * angleStep) && angle < (halfAngleStep + 3 * angleStep))  //  диагонали2 
                if (mag >= gradMagnitude(i-1, j-1) && mag >= gradMagnitude(i+1, j+1))
                    suppressedImg(i, j) = mag;
                end
            end
        end
    end
endfunction
