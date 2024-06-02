
labels=[]
function segmentImg = segmentationColor(img)
   
    grayImage =img
    [h, w] = size(grayImage);
   
    k = 3;
   labels= kmeans(grayImage, k,4);

segmentImg = labels
endfunction


function clustered_image = kmeans(img, k, max_iterations)
    [h, w] = size(img);
   //временно
    // 1) Начальные случайные кластеры
    clusters = struct('center', [], 'brightness', []);
    clusters = repmat(clusters, 1, k);
    
    for i = 1:k
//        положение пикселя изменитть
// найдем самый яркий и не яркий пиксель и в этом диапозоне с одним шагом выберем K яркостей. И потом x y возьмем от случайных пикселей яркостей ( там у к=1 черный у к 2 белый при 2 кластерах)
        center_x = round(rand() * (w - 1) + 1);
        center_y = round(rand() * (h - 1) + 1);
//            disp(i)
//            center_x = w-1;center_y=h-1
//            if (i==1) then center_x = 1;center_y=1;end
            
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
//             disp([i,center_x,center_y])
             dR = sqrt((X - center_x).^2 + (Y - center_y).^2); // Вычисляем расстояние до центра кластера для каждого пикселя
              dI = abs(img - cluster_brightness); 
//              disp(size(dI));
                 distances(:, :, i) = dI; //dI+dR
            end
            
      

         
//        [minDistanceValue, cluster] = min(distances, 3);

            closest_cluster = zeros(h, w); // Создаем новый массив для хранения информации о ближайшем кластере для каждого пикселя
            
//минимумы моя версия v1
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

        pixels_in_cluster=[]
//         обновляем центроиды кластеров
         for i = 1:k
    
            pixels_in_cluster = find(closest_cluster == i);
            
//            disp(pixels_in_cluster)
//            disp("yllllll09")


            
        
             if ~isempty(pixels_in_cluster)
                             [y1, x1] = ind2sub([h, w], pixels_in_cluster);
                mean_x = mean(x1);
                mean_y = mean(y1);
                
                pixel_brightness_values = zeros(length(pixels_in_cluster), 1);
                for j = 1:length(pixels_in_cluster)
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
    
      clustered_image = zeros(h, w, 3, 'uint8'); 
//        disp(size(cluster))
      for i = 1:h
    for j = 1:w
        clusterIndex = closest_cluster(i, j); 
        clusterColor = clusters(clusterIndex).color; 
        clustered_image(i, j, :) = clusterColor; 
    end
end
        disp(size(find(cluster == 1)),size(find(cluster == 2)))


endfunction



function color = generate_random_color()
    color = uint8(rand(1, 3) * 255); // Генерируем случайное значение для каждого канала RGB
endfunction
//
//function clustered_image = kmeans(img, k, max_iterations)
//    [h, w] = size(img);
//
//    // Инициализация центров кластеров
//    random_x = round(rand(1, k) * (w - 1) + 1); 
//    random_y = round(rand(1, k) * (h - 1) + 1);
//    cluster_centers = img(sub2ind([h, w], random_y, random_x)); 
//
//    for iter = 1:max_iterations
//
//      distances = zeros(h, w, k);
//        for i = 1:k
//            distances(:, i) = sqrt((img - cluster_centers(i)).^2); 
//        end
//        [_n, cluster_indices] = min(distances, [], 2);
//
//        new_cluster_centers = zeros(k, 1);
//        for i = 1:k
//            cluster_pixels = img(cluster_indices == i);
//            new_cluster_centers(i) = mean(cluster_pixels); 
//        end
//
//        if isequal(cluster_centers, new_cluster_centers)
//            break;
//        end
//
//        cluster_centers = new_cluster_centers; 
//    end
//
//    clustered_image = zeros(h, w);
//     for i = 1:h
//        for j = 1:w
//            clustered_image(i, j) = cluster_centers(cluster_indices(i, j));
//        end
//    end
//
//    clustered_image = uint8(reshape(clustered_image, h, w)); 
//endfunction
