 function Karlot()
  global hotImg bImg framePlot a1 b1 myThisPath
  setStatusWorkOn()
  bImg = hotImg;
  smoothCount = getDoubleValueByTag("smooth");
  hotImg = KarlotSegmentation(hotImg);
  hotImg = ColorizeSegments(hotImg);
  showNewPic()
  setStatusWorkOf()
endfunction

function segmentedImg = KarlotSegmentation(img,smoothCount)

  histogram = imhist(img);

  smoothedHistogram = histogram;
  scf()
  plot(histogram)
  
  numSmoothingPasses =smoothCount; 
  for k = 1:numSmoothingPasses
    newSmoothedHistogram = smoothedHistogram;
    for i = 2:255
      newSmoothedHistogram(i) = (smoothedHistogram(i-1) + smoothedHistogram(i) + smoothedHistogram(i+1)) / 3;
    end
    smoothedHistogram = newSmoothedHistogram;
  end
  scf()
  plot(smoothedHistogram)
  
  percent = 0;

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
    
    scf()
  plot(smoothedHistogram)
  for i = 1:length(localMin)
    xset("color", 1) 
    xpoly([localMin(i); localMin(i)], [0; smoothedHistogram(localMin(i))], "lines") 
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


