%  function newBoxPolygon1=objectdetection(sceneImage)
newBoxPolygon1 = 0;
% for i=1:1:10
% path1=num2str(i);
% path='C:\Data\Documents\NRL\1706\'
% path2='.jpg'
% fullpath=strcat(path,path1,path2);
% boxImage = imread(fullpath);
boxImage = imread('C:\Users\ruaha\Desktop\1706\Images\c1.jpg');

boxImage=rgb2gray(boxImage);
figure;
imshow(boxImage);
title('Image of a Box');

sceneImage =  imread('C:\Users\ruaha\Desktop\1706\Images\c3.jpg');

sceneImage=rgb2gray(sceneImage);
figure;
imshow(sceneImage);
title('Image of a Cluttered Scene');
boxPoints = detectSURFFeatures(boxImage)
scenePoints = detectSURFFeatures(sceneImage)

figure;
imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 10));

figure;
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 10));


[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :)
matchedScenePoints = scenePoints(boxPairs(:, 2), :)
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    newBoxPolygon = transformPointsForward(tform, boxPolygon);
    newBoxPolygon1 = 1;
    figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');
%  end