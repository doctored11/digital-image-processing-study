

 
   
   
   function setStatusWorkOn()
         global statusObj
    statusObj.String = "Что-то считается ...";
    statusObj.foregroundcolor = [0.95, 0.7, 0.15];
    disp('работа идет')
endfunction

function setStatusWorkOf()
    global statusObj
    sleep(500)
    statusObj.String = "Ничего не происходит";
    statusObj.foregroundcolor = foregroundRGB;
   
endfunction
    
function valueFromUser = getDoubleValueByTag(tag)
     valueFromUser = strtod(findobj(mainWindow, "tag", tag).string);
endfunction









function reloadIm()
    global hotImg framePlot a1
    hotImg= im
      sca(a1);
    imshow(hotImg)
endfunction

function inWindow()
    global hotImg framePlot a1
    
  
    b1 = scf();

    new_axes = newaxes(b1);
    new_axes.axes_bounds = [0 0 1 1];

    sca(new_axes);

     imshow(hotImg);
  
    sca(a1);

    
endfunction

