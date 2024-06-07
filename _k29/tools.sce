
   function setStatusWorkOn()
    global statusObj
    statusObj.String = "Что-то считается ...";
    statusObj.foregroundcolor = [0.5, 0.55, 0.65];
    disp('работа идет')
endfunction

function setStatusWorkOf()
    global statusObj
    sleep(500)
    statusObj.String = "Ничего не происходит";
    statusObj.foregroundcolor = foregroundRGB;
endfunction
    
function valueFromUser = getDoubleValueByTag(tag)
     valueFromUser = strtod(findobj(mainWindow, "tag", tag).string);
endfunction


function [gaussianKernel, X, Y] = getGausMatrix(sigma) 
    kernelSize = ceil(10 * sigma);
    
    [X, Y] = meshgrid(-kernelSize:kernelSize, -kernelSize:kernelSize);
        gaussianKernel = exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (2 * %pi * sigma^2); //уже с нормаировкой 

//
//    gaussianKernel = gaussianKernel / sum(gaussianKernel(:)); // нормировка
endfunction

function laplacianGaussian = getLaplasGausMatrix(sigma,X,Y)
//    по математическим довадам берем 2ую производную о Гауса
    gaussianSecondDerivativeX = (-1 + X.^2 / sigma^2) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (sigma^4);
    gaussianSecondDerivativeY = (-1 + Y.^2 / sigma^2) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (sigma^4);
//    gaussianSecondDerivativeXY = (-1 + (Y.^2+X.^2 )/ (2*sigma^2)) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (sigma^4); 
//    gaussianSecondDerivativeXY = -1/(%pi*sigma^4).*(1-(X.^2+Y.^2)/(2*sigma^2)) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2))  
    laplacianGaussian = gaussianSecondDerivativeX+gaussianSecondDerivativeY;
    
endfunction


function plot3dKernels(X, Y, gaussianKernel,lapGausian)
    scf()
   
    subplot(1,2,1)
    title('3D   Гауссиан');
     plot3dMatrix(X, Y, gaussianKernel)
    
    subplot(1,2,2)
    plot3dMatrix(X, Y, -1.*lapGausian);
     
    colorbar; 
   
    title('3D  Лапласиан Гауссиана');
    
    
endfunction

function plot3dMatrix(X,Y,Kernel)
    gcf().color_map = coolcolormap(10)
     xlabel('X');
    ylabel('Y');
    zlabel('Z');
    surf(X, Y, Kernel,'FaceColor', 'interp');
    
endfunction



function plot2dKernels(X, Y, gaussianKernel, lapGausian)
    scf();

    [maxColumnIndexGauss, maxRowIndexGauss] = max(gaussianKernel);
    centralRowXGauss = X(maxRowIndexGauss(1), :);
    centralRowGauss = gaussianKernel(maxRowIndexGauss(1), :);
   
    subplot(1,2,1);
    plot(centralRowXGauss, centralRowGauss);

    xlabel('X');
    ylabel('Значение');
    title('Гауссиан');

    [maxColumnIndexLapGaus, maxRowIndexLapGaus] = max(-1 .* lapGausian);
    centralRowXLapGaussian = X(maxRowIndexLapGaus(1), :);
    centralRowLapGaussian = -1 .* lapGausian(maxRowIndexLapGaus(1), :);

    subplot(1,2,2);
    plot(centralRowXLapGaussian, centralRowLapGaussian);

    xlabel('X');
    ylabel('Значение');
    title('Лапласиан Гауссиана');
      
endfunction


function reloadIm()
    global hotImg framePlot a1
    
     clf(framePlot)
  a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
      
    hotImg= im
      sca(a1);
    imshow(hotImg)
endfunction

function inWindow()
    global hotImg framePlot a1
    b1 = scf();

    new_axes = newaxes(b1);
    new_axes.axes_bounds = [0 0 1 1];
    sca(new_axes);
    imshow(hotImg);
  
    sca(a1);

    
endfunction

function paddedImg = fillPadding(imageGray, padding)
    [rows, cols] = size(imageGray);
    paddedImg = zeros(rows + 2 * padding, cols + 2 * padding);

    for i = 1:padding
        paddedImg(i, (padding + 1):(cols + padding)) = imageGray(padding - i + 1, :);
        paddedImg(rows + padding + i, (padding + 1):(cols + padding)) = imageGray(rows - i + 1, :);
        
            paddedImg((padding + 1):(rows + padding), i) = imageGray(:, padding - i + 1);
        paddedImg((padding + 1):(rows + padding), cols + padding + i) = imageGray(:, cols - i + 1);
    end

    paddedImg((padding + 1):(rows + padding), (padding + 1):(cols + padding)) = imageGray;
endfunction

function coloredImg = ColorizeSegments(segmentedImg)
  [rows, cols] = size(segmentedImg);
  numSegments = max(segmentedImg);
  disp("_")
  disp(numSegments)
  colors = rand(numSegments, 3);

  coloredImg = zeros(rows, cols, 3);
  for i = 1:rows
    for j = 1:cols
      segment = segmentedImg(i, j);
      if segment == 0 then
          coloredImg(i, j, :) = [0,0,0];
          else
      coloredImg(i, j, :) = colors(segment, :);
      end
    end
  end
endfunction

