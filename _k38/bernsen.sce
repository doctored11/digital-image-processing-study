
clc();
clear();
close(winsid());

myThisPath = get_absolute_file_path('bernsen.sce');
imPath = fullfile(myThisPath, 'res', 'j.jpg');
im = imread(imPath);

im = rgb2gray(im)

imshow(im)
scf()
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

function restoredImg = bernsen(image, window_size, threshold)
    [rows, cols] = size(image);
  padding = (window_size - 1) / 2;
    image = fillPadding(image, padding);
      
    restoredImg = zeros(rows, cols);


    for i = (1 + padding): (rows + padding)
        for j = (1 + padding): (cols + padding)
            
            windowFilter = image((i - padding): (i + padding), (j - padding): (j + padding));
            minV = min(windowFilter)
            maxV = max(windowFilter)
            
            Avg = (minV+maxV)/2 ;
            if (Avg<threshold)  restoredImg(i - padding, j - padding) = image(i,j)>Avg; end
        end
    end
    
endfunction



window_size = 9; 
contrast_threshold = 150;
segmented_img = bernsen(im, window_size, contrast_threshold);
imshow(segmented_img);
