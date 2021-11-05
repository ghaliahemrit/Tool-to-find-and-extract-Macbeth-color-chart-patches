function [ pts, len ] = GetCoordFromImg( npts )
%%  GetCoordFromImg gets coordinates from an image.
%   Input:
%       npts : number of corners
%   Output:
%       pts : matrix of coordinates
%       len : length of the selected colour checker

if ~exist('npts', 'var')
    npts = 4;
end

hold on;
pts = zeros(npts, 2);
for i = 1:npts
    this_pt = ginput(1);
    plot(this_pt(1), this_pt(2), 'rx', 'MarkerSize', 15, 'LineWidth', 2);
    pts(i, :) = this_pt;
end
hold off;

len = sqrt(sum((pts(1,:) - pts(2,:)).^2));

end

 