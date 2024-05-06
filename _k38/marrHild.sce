
clc();
clear();
close(winsid());

myThisPath = get_absolute_file_path('marrHild.sce');
imPath = fullfile(myThisPath, 'res', 'j.jpg');
im = imread(imPath);

im = rgb2gray(im)
im=im2double(im);


function start()
     sigma = 1.3; //для гауса todo считывать
     sigma2=1.1; // для ЛапласаГауссиана todo считывать
     
     //тут матрицу гауса можно для размытия conv2 с im (опционально)
     [gaussianMatrixFilt, _n, _n] = getGausMatrix(sigma);
     
     im = conv2(im,gaussianMatrixFilt,'same');
     imshow(im)
    //     
     
     [gaussianMatrix, X, Y] = getGausMatrix(sigma2);
     lapGausian = getLaplasGausMatrix(sigma2, X, Y);
     
     edgeImg = conv2(im,lapGausian,'same') //границы LoG
    scf()
    imshow(edgeImg)
//     plot3dKernels(X, Y, gaussianMatrix,lapGausian);
//    plot2dKernels(X, Y, gaussianMatrix,lapGausian);
    
    trueEdgeImg= findZeroCross(edgeImg,25) // todo считывать trash
    scf()
    imshow(trueEdgeImg)
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
//todo разделить каждый из них
function plot3dKernels(X, Y, gaussianKernel,lapGausian)
    scf()
    gcf().color_map = coolcolormap(10);
    subplot(1,2,1)
    title('3D   Гауссиан');
    surf(X, Y, gaussianKernel,'FaceColor', 'interp');
    
    subplot(1,2,2)
    
    surf(X, Y, -1.*lapGausian,'FaceColor', 'interp');
     
    colorbar; 
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D  Лапласиан Гауссиана');
    disp(min(lapGausian),max(lapGausian));
    
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


function zeroCrossImgTrahHold = findZeroCross(image, threshold)
    [numRows, numCols] = size(image);
    zeroCrossImg = zeros(numRows, numCols);

    for i = 2:numRows-1
        for j = 2:numCols-1
            if (image(i, j) > 0)
                if (image(i, j+1) >= 0 && image(i, j-1) < 0) || (image(i, j+1) < 0 && image(i, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i+1, j) >= 0 && image(i-1, j) < 0) || (image(i+1, j) < 0 && image(i-1, j) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i+1, j+1) >= 0 && image(i-1, j-1) < 0) || (image(i+1, j+1) < 0 && image(i-1, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                elseif (image(i-1, j+1) >= 0 && image(i+1, j-1) < 0) || (image(i-1, j+1) < 0 && image(i+1, j-1) >= 0)
                    zeroCrossImg(i, j) = image(i, j+1);
                end
            end
        end
    end

    zeroCrossImg = im2uint8(zeroCrossImg);
    zeroCrossImgTrahHold= zeroCrossImg>threshold;
end

