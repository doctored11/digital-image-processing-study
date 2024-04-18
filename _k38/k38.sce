clc();
clear();
close(winsid());


myThisPath = get_absolute_file_path('k38.sce');
imPath = fullfile(myThisPath, 'res', 'i.jpg');
im = imread(imPath);

img = rgb2gray(im)

function start()
     noisy_image = add_multiplicative_noise(img, [0.9, 1.1]);
     imshow(noisy_image)
    
endfunction



function noisy_image = add_multiplicative_noise(image, noise_range)
//    noise_range - кортеж где 1ое мин второе 
    noisy_image = zeros(size(image));

    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
          
            noise_factor = rand()*(noise_range(2)-noise_range(1))+noise_range(1);
            noisy_image(i, j) =  min(max(double(image(i, j)) * noise_factor, 0), 255);
        end
    end
 
    noisy_image = uint8(noisy_image);
endfunction



