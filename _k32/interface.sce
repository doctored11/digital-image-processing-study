

backgroundRGB = [0.333, 0.333, 0.333]
foregroundRGB = [0.96, 0.96, 0.96]
buttonRGB = [0.1,0,0.1] 
secondColorRGB=[-1,-1,-1] 
textSize = 12

    global mainWindow hotImg framePlot a1
    mainWindow = createWindow();
mainWindow.figure_name = "38 | Границы у полутонового изображения ";
mainWindow.backgroundcolor = backgroundRGB;


framePlot = uicontrol(mainWindow, ...
    "style", "frame", ...
    "constraints", createConstraints("border", "right"), ...
    "backgroundcolor", [0 0 0], ...
    "layout", "border", ...
    "units", "normalized", ...
    "position", [-0.05, 0.35, 0.65, 0.65]); 


 global statusObj
    statusObj = uicontrol(mainWindow, ...
        "style", "text", ...
        "String", "Ничего не происходит",...
         "fontSize", textSize, ...
        "units", "normalized", ...
        "position", [0.05, 0.3, 0.4, 0.05],...
        "HorizontalAlignment", "left", ...
        "VerticalAlignment", "bottom",...
        "backgroundcolor", backgroundRGB,...
        "foregroundcolor",foregroundRGB,...
        "tag","statusTXT");
        
        
      

     clf(framePlot);
        a1 = newaxes(framePlot);
     a1.axes_bounds = [0 0 1 1];
        sca(a1);

        imshow(hotImg)


//    +ШУМ
    btnMod = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "+Шум", ...
    "fontSize", 16, ...
    "BackgroundColor", secondColorRGB,...
    "ForegroundColor", buttonRGB, ...
    "units", "normalized", ...
    "position", [0.75, 0.83, 0.2, 0.05], ...
    "callback", "addGausNoiseCallBack",...
    "TooltipString", "Клик");
     
     
     

 
    
    
     uicontrol(mainWindow, ...
        "style", "text", ...
        "String", "min и max шум",...
         "fontSize", textSize, ...
        "units", "normalized", ...
        "position", [0.6, 0.9, 0.35, 0.05],...
        "HorizontalAlignment", "left", ...
        "VerticalAlignment", "bottom",...
        "backgroundcolor", backgroundRGB,...
        "foregroundcolor",foregroundRGB);

     uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(0.8),...
        "units", "normalized", ...
        "position", [0.6, 0.83, 0.06, 0.05], ...
        "tag", "minGausNoise")

     uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(1.5),...
        "units", "normalized", ...
        "position", [0.67, 0.83, 0.06, 0.05], ...
        "tag", "maxGausNoise")

//     -Шум
        btnMod = uicontrol(mainWindow, ...
        "Style", "pushbutton", ...
        "String", "-Шум (НЧФ)", ...
        "fontSize", 16, ...
        "ForegroundColor",buttonRGB, ...
        "units", "normalized", ...
        "position", [0.6, 0.76, 0.35, 0.05], ...
        "callback", "reduceNoiseCallBack");



// выделение границ

    
     uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(160),...
        "units", "normalized", ...
        "position", [0.6, 0.62, 0.06, 0.05], ...
        "tag", "IversonTrashHold",...
        "TooltipString", "Trash")

  btnMod = uicontrol(mainWindow, ...
        "Style", "pushbutton", ...
        "String", "Iverson", ...
        "fontSize", 16, ...
        "ForegroundColor",buttonRGB, ...
        "units", "normalized", ...
        "position", [0.68, 0.62, 0.27, 0.05], ...
        "callback", "IversonCallback",...
        "TooltipString", "Требуется порог");
        
        
        
//  сегментации

  btnMod = uicontrol(mainWindow, ...
        "Style", "pushbutton", ...
        "String", "otsu", ...
        "fontSize", 16, ...
        "ForegroundColor", buttonRGB, ...
        "units", "normalized", ...
        "position", [0.6, 0.56, 0.35, 0.05], ...
        "callback", "otsu",...
        "TooltipString", "Отсо.");
        
// 
        
           uicontrol(mainWindow, ...
        "style", "edit", ...
        "String", string(7),...
        "units", "normalized", ...
        "position", [0.6, 0.50, 0.06, 0.05], ...
        "tag", "FrielWindow",...
        "TooltipString", "Порог")

  btnMod = uicontrol(mainWindow, ...
        "Style", "pushbutton", ...
        "String", "friel", ...
        "fontSize", 16, ...
        "ForegroundColor", buttonRGB, ...
        "units", "normalized", ...
        "position", [0.68, 0.50, 0.27, 0.05], ...
        "callback", "friel",...
        "TooltipString", "требуется размер окна");


// Бернсен

    
//    
btnMod = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "откат", ...
    "fontSize", 10, ...
    "BackgroundColor", secondColorRGB,...
    "ForegroundColor", buttonRGB, ...
    "units", "normalized", ...
    "position", [0.04, 0.23, 0.1, 0.05], ...
    "callback", "reloadIm",...
    "TooltipString", "Клик");
    
    
btnMod = uicontrol(mainWindow, ...
    "Style", "pushbutton", ...
    "String", "в окно", ...
    "fontSize", 10, ...
    "BackgroundColor", secondColorRGB,...
    "ForegroundColor", buttonRGB, ...
    "units", "normalized", ...
    "position", [0.15, 0.23, 0.15, 0.05], ...
    "callback", "inWindow",...
    "TooltipString", "Клик");
