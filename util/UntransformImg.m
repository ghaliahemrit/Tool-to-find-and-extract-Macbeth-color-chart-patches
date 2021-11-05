function [ outImg, inPts ] = UntransformImg( inImg )
%% UntransformImg transforms an image so the camera is above the image.
%   Transform a ColorChecker image so that the camera is 90 degrees 
%   above the plane being imaged. 
%
%   Example:
%       outImg = UntransformImg(in_img);
%       The in_img will be displayed. The user then has to select 4 corners
%       specified by the example image.
%
%   Input:
%       inImg : image of the checker board.
%
%   Output:
%       outImg : image of the ColorChecker board after transformation.
%       inPts : coordinates of the corners of the ColorChecker.

%% Constants
REF_PTS = [ ...
       94.521        70.42; ...
       1021.3       71.334; ...
       1021.3       731.24; ...
       93.607       731.24; ...
       146.62       124.35; ...
       969.21       126.17; ...
       969.21       677.31; ...
       149.36        676.4; ...
        ];
REF_LEN = mean([sqrt(sum((REF_PTS(1,:) - REF_PTS(2,:)).^2)), ...
                sqrt(sum((REF_PTS(3,:) - REF_PTS(4,:)).^2))]);
REF_PTS = REF_PTS./REF_LEN;

ref_pts = REF_PTS;


%% Process the input image
    
while true  
  
    [ ~, f ] = imshowGammaAdjust(inImg);
     uiwait(msgbox(['Please select the designated corners in the colour'...
         ' checker in the natural order: Dark skin, Bluish green, Black,'...
         ' White']));
    hold on ;
    [inPts, in_len] = GetCoordFromImg(4);
    hold off;
        choice = questdlg('Are you happy with the selection?', ...
            'Selection confirmation', ...
            'Yes', 'No', 'Yes');
        if strcmp(choice, 'Yes')
            break;
        else
            close(f);
        end
end


%% Calculate the geometric transform between two sets of points
% Scale up the ref_pts
ref_pts = ref_pts * in_len;
tform_in_to_ref = estimateGeometricTransform(inPts, ref_pts(1:4,:), ...
    'projective');
outImg = imwarp(inImg, tform_in_to_ref);

end

