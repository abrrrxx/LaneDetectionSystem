
clear; clc; close all; 


imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Road_in_Norway.jpg/500px-Road_in_Norway.jpg';
outputFileName = 'road.png';
websave(outputFileName, imageUrl);


originalImage = imread(outputFileName);
figure; 
subplot(2,2,1);
imshow(originalImage);
title('Original Image');

grayImage = rgb2gray(originalImage);
edgeImage = edge(grayImage, 'Canny');
subplot(2,2,2);
imshow(edgeImage);
title('Edge Detection');


[height, width] = size(edgeImage);
roi_vertices = [width/2, height*0.5;  
                width*0.1, height*0.9;      
                width, height*0.9];     
roiMask = poly2mask(roi_vertices(:,1), roi_vertices(:,2), height, width);

maskedImage = edgeImage .* roiMask;
subplot(2,2,3);
imshow(maskedImage);
title('Masked Edges (Region of Interest)');


[H, T, R] = hough(maskedImage);
P = houghpeaks(H, 8, 'threshold', ceil(0.3*max(H(:))));
lines = houghlines(maskedImage, T, R, P, 'FillGap', 5, 'MinLength', 7);


subplot(2,2,4);
imshow(originalImage);
title('Detected Lane Lines');
hold on; 

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
hold off; 
disp('Lane detection complete!');