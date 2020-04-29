function W = Classify(~)
% Step 1: Read image
RGB = imread("input.bmp");
figure,
imshow(RGB),
title('Original Image');

% Step 2: Convert image from RGB to gray 
GRAY = rgb2gray(RGB);
figure,
imshow(GRAY),
title('Gray Image');

% Step 3: Threshold the image Convert the image to black and white in order
% to prepare for boundary tracing using bwboundaries. 
threshold = graythresh(GRAY);
BW = imbinarize(GRAY, threshold);
figure,
imshow(BW),
title('Binary Image');

% Step 4: Invert the Binary Image
BW = ~ BW;
figure,
imshow(BW),
title('Inverted Binary Image');

% Step 5: Find the boundaries Concentrate only on the exterior boundaries.
% Option 'noholes' will accelerate the processing by preventing
% bwboundaries from searching for inner contours. 
[B,L] = bwboundaries(BW, 'noholes');

% Step 6: Determine objects properties
STATS = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'

% Step 7: Classify Shapes according to properties
% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
% UNKNOWN = 0

fprintf("Shape features extraction: \n\n")
figure,
imshow(RGB),
title('Results');
xlabel('C - Circle, R - Rectangle, S - Square, U - Unknown.  Numbers denote the shape numbers');
hold on
for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  centroid = STATS(i).Centroid;
  fprintf('-------------------------------------\n');  
  fprintf("Shape no %d - ",i);
  
  switch W(i)
      case 1
          msg = sprintf('%d C',i);
          text(centroid(1),centroid(2),msg,'Color','w');
          fprintf("It's a Circle\n");
          fprintf('EquivDiameter = ');display(STATS(i).EquivDiameter);
      case 2
          msg = sprintf('%d R',i);
          text(centroid(1),centroid(2),msg,'Color','w');
          fprintf("It's a Rectangle\n");
      case 3
          msg = sprintf('%d S',i);
          text(centroid(1),centroid(2),msg,'Color','w');
          fprintf("It's a Square\n");
      otherwise
          msg = sprintf('%d U',i);
          text(centroid(1),centroid(2),msg,'Color','w');
          fprintf("Unknown Shape\n");
  end
  
  %shape features extraction
  fprintf('Area =');display(STATS(i).Area);
  fprintf('Perimeter = ');display(STATS(i).Perimeter);
  fprintf('Orientation = ');display(STATS(i).Orientation);
  fprintf('Centroid = ');display(STATS(i).Centroid);
  fprintf('BoundingBox =');display(STATS(i).BoundingBox);
  fprintf('Circularity = ');display(STATS(i).Circularity);
  fprintf('Extent = ');display(STATS(i).Extent);
  fprintf('MajorAxisLength = ');display(STATS(i).MajorAxisLength);
  fprintf('MinorAxisLength = ');display(STATS(i).MinorAxisLength);
end
return