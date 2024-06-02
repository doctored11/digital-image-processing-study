function Karlot()
  global hotImg bImg framePlot a1 b1 myThisPath
  setStatusWorkOn()
  bImg = hotImg;
  hotImg = CarlotoSegmentation(hotImg);
  hotImg = ColorizeSegments(hotImg);
  showNewPic()
  setStatusWorkOf()
endfunction

function segmentedImg = CarlotoSegmentation(img)

  histogram = imhist(img);

  smoothedHistogram = histogram;
  scf()
  plot(histogram)
  
  numSmoothingPasses =30; 
  for k = 1:numSmoothingPasses
    newSmoothedHistogram = smoothedHistogram;
    for i = 2:255
      newSmoothedHistogram(i) = (smoothedHistogram(i-1) + smoothedHistogram(i) + smoothedHistogram(i+1)) / 3;
    end
    smoothedHistogram = newSmoothedHistogram;
  end
  scf()
  plot(smoothedHistogram)
  
  percent = 0.5;

  localMin = [];
  prevMinV = smoothedHistogram(1); 
  for i = 2:255
    if smoothedHistogram(i-1) > smoothedHistogram(i) && smoothedHistogram(i) < smoothedHistogram(i+1) then
      if abs(smoothedHistogram(i) - prevMinV) / prevMinV >= percent then
        localMin = [localMin, i];
        prevMinV = smoothedHistogram(i);
      end
    end
  end
    

  [rows, cols] = size(img);
  segmentedImg = zeros(rows, cols);
  numSegments = length(localMin);
  for i = 1:rows
    for j = 1:cols
      intensity = img(i, j);
      segment = 0;
      for k = 1:numSegments
        if intensity < localMin(k) then
          segment = k;
          break;
        end
      end
      if segment == 0 then
        segment = numSegments + 1;
      end
      // просто номера сегментов
      segmentedImg(i, j) = segment;
    end
  end
endfunction

function coloredImg = ColorizeSegments(segmentedImg)
  [rows, cols] = size(segmentedImg);
  numSegments = max(segmentedImg);
  disp("_")
  disp(numSegments)
  colors = rand(numSegments, 3);

  coloredImg = zeros(rows, cols, 3);
  for i = 1:rows
    for j = 1:cols
      segment = segmentedImg(i, j);
      if segment == 0 then
          coloredImg(i, j, :) = [0,0,0];
          else
      coloredImg(i, j, :) = colors(segment, :);
      end
    end
  end
endfunction
