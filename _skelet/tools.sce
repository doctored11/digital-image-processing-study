// Просто сигнализация о процессе (если в онсоль упала ошибка то не отработает)
   function setStatusWorkOn()
    global statusObj
    statusObj.String = "Компутинг...";
    statusObj.foregroundcolor = [0.95, 0.80, 0.16];
    disp('работа идет')
endfunction

function setStatusWorkOf()
    global statusObj
    sleep(500)
    statusObj.String = "Ничего не происходит";
    statusObj.foregroundcolor = foregroundRGB;
endfunction
//     забрать значение из полей по тегу
function valueFromUser = getDoubleValueByTag(tag)
     valueFromUser = strtod(findobj(mainWindow, "tag", tag).string);
endfunction


// это оставить - откаты и вынос в окно 
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
    c1 = scf();

    new_axes = newaxes(c1);
    new_axes.axes_bounds = [0 0 1 1];
    sca(new_axes);
    imshow(hotImg);
  
    sca(a1);

    
endfunction


function showNewPic()
    global hotImg bImg framePlot a1 b1
   
    clf(framePlot2)
       b1 = newaxes(framePlot2);
     b1.axes_bounds = [0 0 1 1];
      sca(b1);
    imshow(bImg)
   
     clf(framePlot)
       a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];

      sca(a1);
    imshow(hotImg)

endfunction


function backImg()
    setStatusWorkOn()
     global hotImg bImg framePlot a1 b1
     hotImg= bImg
      showNewPic()
      setStatusWorkOf()
endfunction

// можно использовать для расширения картинки если надо 
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

