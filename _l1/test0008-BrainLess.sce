xdel();
clc(); 
clear

myThisPath = get_absolute_file_path('test0008-BrainLess.sce');
//
//
imPath = fullfile(myThisPath, 'res', 'testPic.png');
imgPath = fullfile(myThisPath, 'res', 'test2.png');
maskPath = fullfile(myThisPath, 'res', 'mask1.jpg');


 myMatrix = ([
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
        0, -100, 255, 0, 0,0, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0,255, 255, 200, 150, 140, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0, 255, 255, 0, 0, 0, 120, 120, 0, 0;
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
 ]);
    
//    
//
//

im = imread(imPath);
[m, n, z] = size(im);
img = imread(imgPath);
[m2, n2, z2] = size(img);
mask = imread(maskPath);

mainWindow = createWindow();
mainWindow.figure_name = "Приколы | Введение ";
//
btnMod = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "1 Моделирование изображения", ...
    "fontSize", 18, ...
    "ForegroundColor", [0.8, 0.1, 0.1], ...
    "units", "normalized", ...
    "position", [0.5, 0.85, 0.4, 0.1], ...
    "callback", "createMatrixGUI");

btnRGBConvert = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "RGB", ...
    "fontSize", 18, ...
    "ForegroundColor", [0.1, 0.8, 0.1], ...
    "units", "normalized", ...
    "position", [0.5, 0.75, 0.4, 0.1], ...
    "callback", "convertToRGB");

framePlot = uicontrol(mainWindow, ...
    "style", "frame", ...
    "constraints", createConstraints("border", "center"), ...
    "backgroundcolor", [0 0 0], ...
    "layout", "border", ...
    "units", "normalized", ...
    "position", [0, 0.6, 0.4, 0.4]);
framePlot2 = uicontrol(mainWindow, ...
    "style", "frame", ...
    "constraints", createConstraints("border", "center"), ...
    "backgroundcolor", [0 0 0], ...
    "layout", "border", ...
    "units", "normalized", ...
    "position", [0, 0.2, 0.4, 0.4]);
    
  
disp("_1")


j=0
defaults = [0, 0, n, m, 0, 0 n2, m2];
buffCalback = "editCallBack(1)"
for i =1:8
    if( modulo(i,2)) then
        j=j+1
        uicontrol(mainWindow, ...
        "style", "text", ...
        "String", "ТОчка "+ string(j),...
        "units", "normalized", ...
        "position", [0.78, 0.65-(j-1)*0.06, 0.11, 0.05]);
    end
    if (i>4) then 
        buffCalback = "editCallBack(2)"
        end
    defaultValue = defaults(i);
    stroke = "txt" + string(i);
    
     uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(defaultValue),...
        "units", "normalized", ...
        "position", [0.5-(modulo(i,2)-1)*0.11, 0.65-(j-1)*0.06, 0.1, 0.05], ...
        "tag", stroke,...
        "Callback",buffCalback);
    
end




uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "Обрезать", ...
    "fontSize", 18, ...
    "ForegroundColor", [0.7, 0.2, 0.1], ...
    "units", "normalized", ...
    "position", [0.5, 0.35, 0.4, 0.1], ...
    "callback", "Cut()");
    
    //не понял как тултипы работают - если работают(
uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", "*const",...
        "TooltipString","Множитель для серых img",...
        "units", "normalized", ...
        "position", [0.5, 0.18, 0.1, 0.05], ...
        "tag", "grayMulti");

 uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", "+const",...
        "units", "normalized", ...
        "TooltipString","+Const для серых",...
        "position", [0.8, 0.18, 0.1, 0.05], ...
        "tag", "grayPlus");
        
uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "Серый мир", ...
    "fontSize", 18, ...
    "ForegroundColor", [0.7, 0.2, 0.1], ...
    "units", "normalized", ...
    "position", [0.5, 0.05, 0.4, 0.1], ...
    "callback", "toGray()");
    
    clf(framePlot);
    a1 = newaxes(framePlot);
    a1.axes_bounds = [0 0 1 1];
    sca(a1);
    imshow(im,0);
    global _h ;
    _h=plot(a1, [1,1], [50,50], "r-", "Tag", "cropRectangle", "LineWidth", 2);
    
    
    clf(framePlot2);
    b1 = newaxes(framePlot2);
    b1.axes_bounds = [0 0 1 1];
    sca(b1);
    imshow(img,0);
    global _h2 ;
    _h2 = plot(b1, [1,1], [50,50], "r-", "Tag", "cropRectangle", "LineWidth", 2);

function multiConstant(img1,img2)
    numInStr = findobj(mainWindow, "tag", "grayMulti").string;
     constant = strtod(numInStr)
        
      if isnan(constant) 
        constant=1
       end

    disp(constant)

// [rows, cols] = size(img2);
// dataType = typeof(img2);
// disp(dataType)
//    for i = 1:rows
//        for j = 1:cols
////            disp([img2(i, j),constant,floor(constant * double(img2(i, j)))])
//
//           buffPixel = int16(floor(constant * double(img2(i, j))));
//            buffPixel = min(max(buffPixel, 0), 255);
//        
//            img2_multiplied(i, j)=convertToType(dataType,buffPixel);
//        end
//    end


dataType = typeof(img1);
img1_int16 = int16(img1);
img1_multiplied = convertToType(dataType, min(max(int16(floor(constant * double(img1_int16))), 0), 255));

dataType = typeof(img2);
img2_int16 = int16(img2);
img2_multiplied = convertToType(dataType, min(max(int16(floor(constant * double(img2_int16))), 0), 255));

    scf();
    
    subplot(2, 2, 1);
    imshow(img1);
    title('Оригинал');

    subplot(2, 2, 2);
    imshow(img1_multiplied);
    title(['Умножено на ', string(constant)]);
    
     subplot(2, 2, 3);
    imshow(img2);
    title('Оригинал');

    subplot(2, 2, 4);
    imshow(img2_multiplied);
    title(['Умножено на ', string(constant)]);
    
endfunction


function plusConstant(img1,img2)
    numInStr = findobj(mainWindow, "tag", "grayPlus").string;
     constant = strtod(numInStr)
        
      if isnan(constant) 
        constant=1
       end

    disp(constant)


   dataType = typeof(img1);
    img1_int16 = int16(img1);
    img1_multiplied = convertToType(dataType, min(max(int16(floor(constant + double(img1_int16))), 0), 255));
    
    
    dataType = typeof(img2);
    img2_int16 = int16(img2);
    img2_multiplied = convertToType(dataType, min(max(int16(floor(constant + double(img2_int16))), 0), 255));

    
    scf();
    
    subplot(2, 2, 1);
    imshow(img1);
    title('Оригинал');

    subplot(2, 2, 2);
    imshow(img1_multiplied);
    title(['+ ', string(constant)]);
    
     subplot(2, 2, 3);
    imshow(img2);
    title('Оригинал');

    subplot(2, 2, 4);
    imshow(img2_multiplied);
    title([' ', string(constant)]);
    
endfunction



function toGray()
    disp("допустимая глубина цвета 3 или 4, сейчас: ",[z,z2])
   
      im = im(:, :, 1:3)
     img = img(:, :, 1:3)
    
    im_gray=rgb2gray(im)
    im_gray2=rgb2gray(img)
    scf()
     subplot(2, 2, 1);
    imshow(im);
    title('Это оргинал');
  
    subplot(2, 2, 2);
    imshow(im_gray);
    title('Серый Оригинал');

    subplot(2, 2, 3);
    imshow(img);
    
    title('Оргинал 2');


    subplot(2, 2, 4);
    imshow(im_gray2);
    title('Серый 2');
    
    
    multiConstant(im_gray,im_gray2);
    plusConstant(im_gray,im_gray2);
    sumImg(im_gray,im_gray2,0.6);
    maskImg(im_gray,mask);
endfunction

function editCallBack(key)
    global _h _h2 n m z n2 m2 z2
     nb =0
    mb=0
    zb=4
    if(key==1) 
    v1 = findobj(mainWindow, "tag", "txt1").string;
    v2 = findobj(mainWindow, "tag", "txt2").string;
    v3 = findobj(mainWindow, "tag", "txt3").string;
    v4 = findobj(mainWindow, "tag", "txt4").string;
     nb =n
    mb=m
    zb=z
   
    else
    v1 = findobj(mainWindow, "tag", "txt5").string;
    v2 = findobj(mainWindow, "tag", "txt6").string;
    v3 = findobj(mainWindow, "tag", "txt7").string;
    v4 = findobj(mainWindow, "tag", "txt8").string;
     nb =n2;
    mb=m2;
    zb=z2;
    end
   
  [xMin, xMax, yMin, yMax] = cropValues(v1, v2, v3, v4,nb,mb,zb);
 
     x = [xMin, xMax, xMax, xMin, xMin];
    y = [yMin, yMin, yMax, yMax, yMin];
    
    if(key==1)  then delete(_h);
         _h = plot(a1, x, y, "r-", "Tag", "cropRectangle", "LineWidth", 2);
     else
          delete (_h2)
          _h2 = plot(b1, x, y, "b-", "Tag", "cropRectangle", "LineWidth", 2);
    
    end

    
endfunction


function result = convertToType(dataType, value)
    switch dataType
        case 'int8'
            result = int8(value);
        case 'int16'
            result = int16(value);
        case 'int32'
            result = int32(value);
        case 'int64'
            result = int64(value);
        case 'uint8'
            result = uint8(value);
        case 'uint16'
            result = uint16(value);
        otherwise
            error('Неподдерживаемый тип данных -_-');
    end
end
function Cut()
   global n m z n2 m2 z2 ;
   
    v1 = findobj(mainWindow, "tag", "txt1").string;
    v2 = findobj(mainWindow, "tag", "txt2").string;
    v3 = findobj(mainWindow, "tag", "txt3").string;
    v4 = findobj(mainWindow, "tag", "txt4").string;
    
     v5 = findobj(mainWindow, "tag", "txt5").string;
    v6 = findobj(mainWindow, "tag", "txt6").string;
    v7 = findobj(mainWindow, "tag", "txt7").string;
    v8 = findobj(mainWindow, "tag", "txt8").string;

    [xMin, xMax, yMin, yMax] = cropValues(v1, v2, v3, v4,n,m,z);
    [xMin2, xMax2, yMin2, yMax2] = cropValues(v5, v6, v7, v8,n2,m2,z2);
    disp([xMin,xMax,yMin,yMax])
    //    imCrop=im(yMin:yMax,xMin:xMax,1:z); 
    //почему то по y была инверсия - вот и фикс)
    imCrop = im(size(im, 1)-yMax+1:size(im, 1)-yMin+1, xMin:xMax, 1:z);
     imCrop2 = img(size(img, 1)-yMax2+1:size(img, 1)-yMin2+1, xMin2:xMax2, 1:z2);
    scf()
    imshow(imCrop)
    scf()
    imshow(imCrop2)
    
     scf()
    subplot(2, 2, 1);
    imshow(im);
   
    
    
     plot( [xMin, xMax, xMax, xMin, xMin],[yMin, yMin, yMax, yMax, yMin], "r-", "LineWidth", 3);
        title('Это оргинал');
   

    subplot(2, 2, 2);
  
    imshow(imCrop);
    title('а это нет');

    subplot(2, 2, 3);
    imshow(img);
    
   plot( [xMin2, xMax2, xMax2, xMin2, xMin2],[yMin2, yMin2, yMax2, yMax2, yMin2], "b-", "LineWidth", 3);
    title('и это Оргинал');


    subplot(2, 2, 4);
    imshow(imCrop2);
    title('а это обрезок');
    
    

    
endfunction

function [xMin, xMax, yMin, yMax] = cropValues(v1, v2, v3, v4,nb,mb,zb)
//    global n m;
//    disp([v1, v2, v3, v4,nb,mb,zb])
    v1 = max(floor(strtod(v1)), 1);
    v2 = max(floor(strtod(v2)), 1);
    v3 = max(floor(strtod(v3)), 1);
    v4 = max(floor(strtod(v4)), 1);

    x1 = min(v1, nb);
    y1 = min(v2, mb);
    x2 = min(v3, nb);
    y2 = min(v4, mb);

    xMin = min(x1, x2);
    xMax = max(x1, x2);
    yMin = min(y1, y2);
    yMax = max(y1, y2);
    
    disp("получил:");
    disp(["xMin: " + string(xMin), "xMax: " + string(xMax), "yMin: " + string(yMin), "yMax: " + string(yMax)]);
endfunction


function convertToRGB()
    R = im(1:m, 1:n, 1);
    G = im(1:m, 1:n, 2);
    B = im(1:m, 1:n, 3);

    IM_RGB1(1:m, 1:n, 1:3) = uint8(0);
    IM_RGB2(1:m, 1:n, 1:3) = uint8(0);
    IM_RGB3(1:m, 1:n, 1:3) = uint8(0);

    IM_RGB1(1:m, 1:n, 1) = R;   
    IM_RGB2(1:m, 1:n, 2) = G;
    IM_RGB3(1:m, 1:n, 3) = B;

    disp("Конвертим в РГБ");
    scf();
    clf();
    subplot(2,2,1);xtitle("Оригинал RGB"); imshow(im);
    subplot(2,2,2);xtitle("R-канал в цвете"); imshow(IM_RGB1);
    subplot(2,2,3);xtitle("G-канал в цвете") ;imshow(IM_RGB2);
    subplot(2,2,4);xtitle("B-канал в цвете") ;imshow(IM_RGB3);

  
endfunction

function sumImg(img1,img2,a)
    
    
    //чтоб не запутаться)
     [rows1, cols1, _z1] = size(img1);
    [rows2, cols2, _z2] = size(img2);

    commonRows = max(rows1, rows2);
    commonCols = max(cols1, cols2);

    im1_resized = imresize(img1, [commonRows, commonCols], 'nearest');
    im2_resized = imresize(img2, [commonRows, commonCols], 'nearest');
    dataType = typeof(im2_resized);
 
    imgRes = convertToType(dataType,( min(max(int16(floor(a * double(im1_resized) + (1 - a) * double(im2_resized))), 0), 255)));
    
    scf()
     subplot(1, 3, 1);
    imshow(im1_resized);
    title('1');
  
    subplot(1, 3, 2);
    imshow(im2_resized);
    title('2');

    subplot(1, 3, 3);
    imshow(imgRes);
    
    title('1+2 при a = '+ string(a));
    
endfunction

function maskImg(img,imgMask)
     [rows1, cols1, _z1] = size(img);
    [rows2, cols2, _z2] = size(imgMask);


    maskResized = imresize(imgMask, [rows1, cols1], 'nearest');
   
    maskResized =(maskResized(:, :, 1:1)~= 0) ; //в bool так переводим
 
    scf()
  imshow(img);
   
    imgRes = img .* maskResized;
   scf()
    imshow(imgRes);
     title('Маскирование');
endfunction

numRows=0;
numCols=0;
inputHandles=[]

function createMatrixGUI()
    
    clc(); 
  
     global numRows numCols inputHandles;

    mainWindow = createWindow();
    mainWindow.figure_name = "Матрица чисел в рисуночек";
    
    
     numRows = size(myMatrix, 1);
    numCols = size(myMatrix, 2);
  
     for i = 1:1:numRows
        for j = 1:1:numCols
            value = string(myMatrix(i, j))    
            inputHandles(i, j) =  uicontrol(mainWindow, ...
                "style", "edit", ...
                "units", "normalized", ...
                "position", [(j-1)*0.05, 1-i*0.05, 0.05, 0.05], ...
                "fontsize", 12, ...
                "string", value);
          
        end
    end
    
     
       
       uicontrol(mainWindow, ...
         "Style","text",...  
          "String","Без учета переполнения и прочих проверок",...
          "units", "normalized", ...
          "position", [0, 0, 1, 0.1]);  

       btnDrawImages = uicontrol(mainWindow, ...
                "style", "pushbutton", ...
                "String", "Начертить изображения", ...
                "fontSize", 12, ...
                "units", "normalized", ...
                "position", [0, (1-numRows*0.05)-0.1, 0.3, 0.1], ...
                "callback", "drawImagesCallback");
       
endfunction

 function drawImagesCallback()
      global numRows numCols inputHandles;
                updatedMatrix = zeros(numRows, numCols);
                for i = 1:numRows
                    for j = 1:numCols
                        updatedMatrix(i, j) =strtod(inputHandles(i, j).string);
                    end
                end
                
                disp(updatedMatrix)
               
                im1 = im2double(updatedMatrix)  
                im2 = uint8(updatedMatrix)
                im3 = int8(updatedMatrix)
                im4 = uint16(updatedMatrix)
                im5 = int16(updatedMatrix)
                im6 = mat2gray(updatedMatrix)
                disp(im6)
                disp(int32(updatedMatrix))
                  
                
                scf(2);
                clf(2);
                 subplot(3,2,1);xtitle("double"); imshow(im1);
                 subplot(3,2,2);xtitle("mat2gray"); imshow(im6);
                 subplot(3,2,3);xtitle("uint8"); imshow(im2);
                 subplot(3,2,4);xtitle("int8"); imshow(im3);
                 subplot(3,2,5);xtitle("uint16"); imshow(im4);
                 
                 subplot(3,2,6);xtitle("int16"); imshow(im5);
        
                
 endfunction

