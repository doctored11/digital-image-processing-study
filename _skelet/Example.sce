function ExampleCallBack()
    global hotImg bImg framePlot a1 b1
        bImg = hotImg
         setStatusWorkOn()
//         если  надо тут забрать из интерфейса значения (см tools)
         
        disp("Вызвался ExampleCallBack")
     hotImg = Example(hotImg); //вызов основной функции

     

      

      showNewPic()
    setStatusWorkOf()
endfunction

function gradImg = Example(image)
//    реализовать сегментацию или выделение границ
       disp("Вызвался Example")
//    gradImg = результат
    gradImg=image .*1.2

   
endfunction

//просто бинаризация по нижнему порогу 
function strongBinarization()
        global hotImg bImg framePlot a1 b1
        bImg = hotImg
        trashHold = getDoubleValueByTag("trashHold");
        
        hotImg = hotImg > trashHold
        showNewPic()
endfunction

