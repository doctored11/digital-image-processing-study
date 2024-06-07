close(winsid());
clc;
clear;
global myThisPath;
myThisPath = get_absolute_file_path('entryPoint.sce');
imPath = fullfile(myThisPath, 'res', 'q.jpg');

img = imread(imPath);
grayImg = rgb2gray(img);

function start()
     imshow(grayImg)
    scf()
    t=1
    sigma=1
    [gaussianMatrixFilt, X, Y] = getGausMatrix(sigma);
     
  
    [imgCl, brightness] = kmeans(grayImg, 2, 15)
    disp(brightness)
    
    optimalTreshHold=mean(brightness)*t
    
    grayImg = im2double(grayImg)
    grayImg = conv2(grayImg,gaussianMatrixFilt,'same');
     
    imshow(imgCl)
    scf()
    disp([max(grayImg),optimalTreshHold])
    fImg =grayImg.*255>optimalTreshHold

    imshow(fImg)
    
endfunction


function [clustered_image,clusterBrightness] = kmeans(img, k, max_iterations)
    [h, w] = size(img);
    img = double(img)
   //временно
   
    clusters = struct('center', [], 'brightness', []);
    clusters = repmat(clusters, 1, k);
    
      min_brightness = min(img(:));
    max_brightness = max(img(:));
    step = (max_brightness - min_brightness) / k;
    
    for i = 1:k
        
        target_brightness = min_brightness + (i - 1) * step + step / 2;
        pixel_indices = find(abs(img - target_brightness) <= step / 2);

            center_x = round(rand() * (w - 1) + 1);
            center_y = round(rand() * (h - 1) + 1);
    
        brightness = img(center_y, center_x);
        
        clusters(i).center = [center_x, center_y];
        clusters(i).brightness = brightness;
        clusters(i).old_center = [0, 0];
        clusters(i).color = generate_random_color();
        
    end
    
    [X, Y] = meshgrid(1:w, 1:h);
    pixel_positions = [X(:), Y(:)];
    
    pixel_values = img(:);
    cluster=[]
    for iter = 1:max_iterations
        distances = zeros(h, w, k); 
        for i = 1:k
           center_x = clusters(i).center(1);
             center_y = clusters(i).center(2);
              cluster_brightness = clusters(i).brightness;

             dR = sqrt((X - center_x).^2 + (Y - center_y).^2); 
              dI = abs(img - cluster_brightness); 
//              disp(size(dI));
                 distances(:, :, i) = dI+dR; //dI+dR
            end
            

            closest_cluster = zeros(h, w); 

            for i = 1:h
                for j = 1:w
                    min_distance = distances(i, j, 1); 
                    closest_cluster(i, j) = 1; 
                    
                   
                    for k = 2:size(distances, 3)
                        if distances(i, j, k) < min_distance
                            min_distance = distances(i, j, k); 
                            closest_cluster(i, j) = k;
                        end
                    end
                end
            end
//    disp(size(closest_cluster))

        pxInCluster=[]
         for i = 1:k
            pxInCluster = find(closest_cluster == i);
        
             if ~isempty(pxInCluster)
                             [y1, x1] = ind2sub([h, w], pxInCluster);
                mean_x = mean(x1);
                mean_y = mean(y1);
                
                pixel_brightness_values = zeros(length(pxInCluster), 1);
                for j = 1:length(pxInCluster)
                    pixel_brightness_values(j) = img(y1(j), x1(j));
                end
                mean_brightness = mean(pixel_brightness_values);
                
                clusters(i).center = [mean_x, mean_y];
                clusters(i).brightness = mean_brightness;
            end
        end
        
           disp("итерация "+string(iter)+ " \"+string(max_iterations) );
          
            disp(" =" +string( clusters(1).center(1))+","+string( clusters(1).center(2))+" _ "+string(clusters(1).brightness) +"  |  "...
            +string( clusters(2).center(1))+","+string( clusters(2).center(2))+" _ "+string(clusters(2).brightness) );
    end
    clusterBrightness = []
      clustered_image = zeros(h, w, 3, 'uint8'); 
        //        disp(size(cluster))
                 for i = 1:h
                for j = 1:w
                    clusterIndex = closest_cluster(i, j); 
                    clusterColor = clusters(clusterIndex).color; 
                    clusterBrightness(clusterIndex)=  clusters(clusterIndex).brightness
                    clustered_image(i, j, :) = clusterColor; 
                end
            end
        disp(size(find(cluster == 1)),size(find(cluster == 2)))


endfunction


function color = generate_random_color()
    color = uint8(rand(1, 3) * 255); 
endfunction

function [gaussianKernel, X, Y] = getGausMatrix(sigma) 
    kernelSize = ceil(10 * sigma);
    
    [X, Y] = meshgrid(-kernelSize:kernelSize, -kernelSize:kernelSize);
        gaussianKernel = exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (2 * %pi * sigma^2); //уже с нормаировкой 

//
//    gaussianKernel = gaussianKernel / sum(gaussianKernel(:)); // нормировка
endfunction
