function [ checker_img, rect, inPts, coord ] = ProcessColourChecker( inIm, id )
%% ProcessColourChecker selects the ColorChecker in the image.
%   Input: 
%       inIm : entire demosaiced image 
%       id : image number
%
%   Output:
%       checker_img : colour checker image
%       rect : initial rectangular selection of the chart
%       inPts : coordinates within the selection 
%       coord: coordinates within the original image 

% Initial image crop
[~, rect] = imcrop(inIm.^0.5);
uiwait(msgbox('Please select the region of the chart '));
inIm = imcrop(inIm, rect);

% Untransform the image
[checker_img, inPts] = UntransformImg(inIm);

% Saving chart coordinates
coord = zeros(4,2);
for i = 1: 2
coord(:,i) = inPts(:,i)+rect(i) ;
end

% Second image crop
uiwait(msgbox('Please select the chart '));
[~, rect_cc] = imcrop(checker_img.^0.5);
checker_img = imcrop(checker_img, rect_cc);

filename=strcat(num2str(id), '_cc.tiff');
imwrite(checker_img, filename);

end

