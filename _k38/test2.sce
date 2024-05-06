clc();
clear();
close(winsid());

myThisPath = get_absolute_file_path('test2.sce');
imPath = fullfile(myThisPath, 'res', 'Testbuilding.jpg');
im = imread(imPath);

im = rgb2gray(im)
im=im2double(im);

mainWindow = createWindow();
mainWindow.figure_name = "38 | Границы у полутонового изображения ";

framePlot = uicontrol(mainWindow, ...
    "style", "frame", ...
    "constraints", createConstraints("border", "center"), ...
    "backgroundcolor", [0 0 0], ...
    "layout", "border", ...
    "units", "normalized", ...
    "position", [0, 0.6, 0.4, 0.4]);


 clf(framePlot);
    a1 = newaxes(framePlot);
    a1.axes_bounds = [0 0 1 1];
    sca(a1);
    
    imshow(im)
    
    
    
 btnMod = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "+Шум", ...
    "fontSize", 18, ...
    "ForegroundColor", [0.8, 0.1, 0.1], ...
    "units", "normalized", ...
    "position", [0.5, 0.85, 0.4, 0.1], ...
    "callback", "createMatrixGUI");

    
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

defaults = [0, 0, 1, 1, 0, 0 1, 1];
j=0
for i =1:8
    if( modulo(i,2)) then
        j=j+1
        uicontrol(mainWindow, ...
        "style", "text", ...
        "String", "ТОчка "+ string(j),...
        "units", "normalized", ...
        "position", [0.78, 0.65-(j-1)*0.06, 0.11, 0.05]);
    end
    
    defaultValue = defaults(i);
    stroke = "txt" + string(i);
    
     uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(defaultValue),...
        "units", "normalized", ...
        "position", [0.5-(modulo(i,2)-1)*0.11, 0.65-(j-1)*0.06, 0.1, 0.05], ...
        "tag", stroke);
    
end
