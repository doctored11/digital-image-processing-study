

function Ramesh()
  global hotImg bImg framePlot a1 b1   myThisPath
  setStatusWorkOn()
    bImg = hotImg;
//    myThisPath = get_absolute_file_path('entryPoint.sce');
    imPath = fullfile(myThisPath, 'res');
    
    numFrames = 6;
    fileNames = [];
    for i = 1:numFrames
        fileNames(i) = fullfile(imPath, sprintf('t%d.jpg', i));
    end
    
    scaleFactor = 0.3;
    
    frames = [];
    for i = 1:numFrames
        img = imread(fileNames(i));
        img = imresize(img, scaleFactor); 
        grayImg = rgb2gray(img); 
        frames(:,:,i) = grayImg;
    end
    
//    x1 = 15;
//    y1 = 55;
//    x2 = 37;
//    y2 = 80;
    
     x1 = 12;
    y1 = 62;
    x2 = 35;
    y2 = 86;
    
    [height, width] = size(frames(:,:,1));
    
    // пересчет координат для  относительно верхнего левого угла 
    y1_top = height - y2;
    y2_top = height - y1;
    
    figure();
    imshow(frames(:,:,1));
    plot([x1, x2, x2, x1, x1], [y1, y1, y2, y2, y1], "r-", "LineWidth", 2);
    

    y1_top = max(1, min(height, y1_top));
    y2_top = max(1, min(height, y2_top));
    x1 = max(1, min(width, x1));
    x2 = max(1, min(width, x2));
    
    selectedRegion = frames(y1_top:y2_top, x1:x2, 1); 
    
    histogram = histc(selectedRegion(:), 0:255); 
    histogram = double(histogram);
    histogram = histogram / max(histogram);

    savedImages = list(); 
    savedCoords = []; 
    savedBinaryImages = list(); 
    
    for i = 1:numFrames
        bestMatchScore = %inf;
        bestMatchScore2 = 0;
        bestMatchCoords = [0, 0];

        for y = 1:size(frames, 1) - (y2 - y1)
            for x = 1:size(frames, 2) - (x2 - x1)

                x_start = x;
                y_start = y;
                x_end = x + (x2 - x1);
                y_end = y + (y2 - y1);
                
                y_start_top = height - y_end;
                y_end_top = height - y_start;
    
                y_start_top = max(1, min(height, y_start_top));
                y_end_top = max(1, min(height, y_end_top));
                x_start = max(1, min(width, x_start));
                x_end = max(1, min(width, x_end));
    
                currentRegion = frames(y_start_top:y_end_top, x_start:x_end, i);
                
                currentHistogram = histc(currentRegion(:), 0:255);
                currentHistogram = double(currentHistogram);
                currentHistogram = currentHistogram / max(currentHistogram);
                
    //            Todo attencion -   bhattacharyya = sum(sqrt(histogram .* currentHistogram)) - чем больше тем лучше; bhattacharyya = sum(abs(histogram -currentHistogram) - чем меньше тем лучше
                 bhattacharyya2 = sum(sqrt(histogram .* currentHistogram));
                bhattacharyya = sum(abs(histogram - currentHistogram)); 
    
                if bhattacharyya < bestMatchScore then //(bhattacharyya < bestMatchScore && bhattacharyya2 > bestMatchScore2)
                    disp([i, bhattacharyya]);
                    disp([i, x, y]);
                    bestMatchScore = bhattacharyya;
                    bestMatchCoords = [x, y];
                    
                    hotImg = frames(:,:,i);
                    hotImg(y_start_top:y_end_top, x_start:x_end) = 255;
                    bImg = hotImg;
                    showNewPic();
                    sleep(100);
                end
            end
        end
        
        
         savedImages($+1) = frames(:,:,i);
        savedCoords($+1,:) = [bestMatchCoords(1), bestMatchCoords(2), bestMatchCoords(1)+(x2-x1), bestMatchCoords(2)+(y2-y1)];
        
//        обратная корректировка от верх лев угла
        frame = frames(:,:,i);
        x_start = bestMatchCoords(1);
        y_start = bestMatchCoords(2);
        x_end = x_start + (x2 - x1);
        y_end = y_start + (y2 - y1);

        y_start_top = height - y_end;
        y_end_top = height - y_start;

        y_start_top = max(1, min(height, y_start_top));
        y_end_top = max(1, min(height, y_end_top));
        x_start = max(1, min(width, x_start));
        x_end = max(1, min(width, x_end));

        // Бинаризация изображения
        binaryImg = zeros(height, width);
        selectedRegion = frame(y_start_top:y_end_top, x_start:x_end);
//        regionBinary = zeros(size(selectedRegion));
           selectedRegion =1
            binaryImg(y_start_top:y_end_top, x_start:x_end) = selectedRegion;
               savedBinaryImages($+1) = binaryImg;
           
       
        end

 scf();

    numRows = ceil(sqrt(numFrames));
    numCols = ceil(numFrames / numRows);
    
     for i = 1:numFrames
        subplot(numRows, numCols, i);
        imshow(savedImages(i));
        coords = savedCoords(i,:);
        
        title(sprintf('Кадр %d', i));
    end
    
    
    scf()
    
    for i = 1:numFrames
        subplot(numRows, numCols, i);
        imshow(savedImages(i));
        coords = savedCoords(i,:);
        plot([coords(1), coords(3), coords(3), coords(1), coords(1)], ...
             [coords(2), coords(2), coords(4), coords(4), coords(2)], "b-", "LineWidth", 2);
        title(sprintf('Кадр %d', i));
    end
    
    scf();
   
    for i = 1:numFrames
        subplot(numRows, numCols, i);
        imshow(savedBinaryImages(i));
        title(sprintf('Бинаризованный кадр %d', i));
    end

  setStatusWorkOf()
endfunction
