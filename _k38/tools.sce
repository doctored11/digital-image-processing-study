function valueFromUser = getDoubleValueByTag(tag)
     valueFromUser = strtod(findobj(mainWindow, "tag", tag).string);
endfunction




function [gaussianKernel, X, Y] = getGausMatrix(sigma) 
    kernelSize = ceil(10 * sigma);
    
    [X, Y] = meshgrid(-kernelSize:kernelSize, -kernelSize:kernelSize);
    gaussianKernel = exp(-(X.^2 + Y.^2) / (2 * sigma^2));

    gaussianKernel = gaussianKernel / sum(gaussianKernel(:)); // нормировка
endfunction

function laplacianGaussian = getLaplasGausMatrix(sigma,X,Y)
//    по математическим довадам берем 2ую производную о Гауса
    gaussianSecondDerivativeX = (-1 + X.^2 / sigma^2) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / sigma^4;
    gaussianSecondDerivativeY = (-1 + Y.^2 / sigma^2) .* exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / sigma^4;

    laplacianGaussian = gaussianSecondDerivativeX + gaussianSecondDerivativeY;
    
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
