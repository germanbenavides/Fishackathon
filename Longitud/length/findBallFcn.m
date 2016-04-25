function centroid = findBallFcn(greenBall1, thresh, imageType, axH)
global I
% Copyright 2011 The MathWorks, Inc.

error(nargchk(3, 4, nargin, 'struct'));

if isempty(greenBall1)
    return;
end
if ischar(greenBall1)
    greenBall1 = imread(greenBall1);
end

%% Find Green Object
% This script reads in an image file and then attempts to find a green
% object in the image. It is designed to find one green ball and highlight
% that ball on the original image

%% Extract each color
% Next we using indexing to extract three 2D matrices from the 3D image
% data corresponding to the red, green, and blue components of the image.

r = greenBall1(:, :, 1);
g = greenBall1(:, :, 2);
b = greenBall1(:, :, 3);

%% Calculate Red
% Then we perform an arithmetic operation on the matrices as a whole to try
% to create one matrix that represents an intensity of green.
r = medfilt2(r, [3 3]);
Red = r - g/2 - b/2;

%% Threshold the image
% Now we can set a threshold to separate the parts of the image that we
% consider to be green from the rest.

if nargin == 4
    bw = Red > thresh;
else
    bw = Red > 80;
end

%% Remove small groups
% We can use special functions provided by the Image Processing toolbox to
% quickly perform common image processing tasks. Here we are using
% BWAREAOPEN to remove groups of pixels less than 30.

ball1 = bwareaopen(bw, 30);

%% Find center
% Now we are using REGIONPROPS to extract the centroid of the group of
% pixels representing the ball.
maxArea=1000;
s  = regionprops(ball1, {'centroid','area','BoundingBox'});
if isempty(s)
    bc = [];
else
    [maxArea, id] = max([s.Area]); 
    bc = s(id).Centroid;
bb = s(id).BoundingBox;
disp(bc(1));
disp(bc(2));

end
switch imageType
   case 'video'
      imshow(greenBall1, 'Parent', axH);
      
   case 'bw'
      imshow(ball1, 'Parent', axH);
      if ~isempty(bc)
         line(bc(1), bc(2), 'Parent', axH, 'Color', 'w', 'Marker', 'p', 'MarkerSize', 20, 'MarkerFaceColor', 'y')
%       a=text(bc(1)+15,bc(2), strcat('Longitud: ', num2str(round(bc(1))), ' Y: ', num2str(round(bc(2)))));
%       set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
         rectangle('Position',bb,'Parent', axH,'EdgeColor','r','LineWidth',2);
        

      end
%       if maxArea> 200
%     I=greenBall1;
%     I=imcrop(I,bb);
%     figure,imshow(I)
%     stop(handles.vid);
%     
% else
% end
end
