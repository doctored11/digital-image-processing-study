function KirshCallBack()
    global hotImg bImg framePlot a1 b1
      
        bImg = hotImg

        setStatusWorkOn()
    
        hotImg = Kirsh(hotImg)

        showNewPic()
    
   
    setStatusWorkOf()
endfunction

function result = Kirsh(image)
    disp("1")
    kirsch_masks = zeros(3, 3, 8);
    kirsch_masks(:,:,1) = [-3, -3, -3;  5,  0, -3;  5,  5, -3];
    kirsch_masks(:,:,2) = [-3, -3,  5; -3,  0,  5; -3, -3,  5];
    kirsch_masks(:,:,3) = [-3,  5,  5; -3,  0,  5; -3, -3, -3];
    kirsch_masks(:,:,4) = [ 5,  5,  5; -3,  0, -3; -3, -3, -3];
    kirsch_masks(:,:,5) = [ 5,  5, -3;  5,  0, -3; -3, -3, -3];
    kirsch_masks(:,:,6) = [ 5, -3, -3;  5,  0, -3;  5, -3, -3];
    kirsch_masks(:,:,7) = [-3, -3, -3;  5,  0, -3; -3,  5,  5];
    kirsch_masks(:,:,8) = [-3, -3, -3; -3,  0, -3;  5,  5,  5];

    image = im2double(image);

    disp("2")

    [m, n] = size(image);
    result = zeros(m, n);

    for i = 1:8
        conv_result = conv2(image, kirsch_masks(:,:,i), 'same');
        result = max(result, conv_result);
    end
endfunction



