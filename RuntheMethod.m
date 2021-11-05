function [ cc_final_coord, white_points_scal, patches_rgb ] = RuntheMethod
%% RuntheMethod processes the dataset images and returns the white points 
%%              measured with the colour checker charts
%
%   Output:
%       cc_final_coord : coordinates of the colour chart within the image  
%       white_points_scal : normalised RGBs of the lights  
%       patches_rgb : average RGB value of every patch in the colour chart 
%
%   Reference: 
%   Please cite : G. Hemrit et al. “Providing a single ground-truth
%   for illuminant estimation for the colorchecker dataset,” IEEE transactions 
%   on pattern analysis and machine intelligence, 2019, pp. 1286-1287.
%
%   [1] P. V. Gehler et al. “Bayesian color constancy revisited,” 
%   in IEEE Conference on Computer Vision and Pattern Recognition, 
%   2008, pp. 1–8.
%
%   [2] F. Fang, H. Gong, M. Mackiewicz, and G. Finlayson, “Colour Correction 
%   Toolbox,” in 13th AIC Congress, 2017, pp. 13–18.
%
%   [3] L. Shi and B. Funt, "Measuring the Scene Illumination," 
%   accessed from http://www.cs.sfu.ca/~colour/data/
%
%   Copyright (c) February 2018 Ghalia Hemrit <g.hemrit@uea.ac.uk>, 
%   University of East Anglia

warning('off', 'Images:initSize:adjustingMag');

% Images directory to be specified below
DATA_DIR = inputdlg('Please specify the images directory',...
                'Directory', 1, {'D:\colourchecker'});
DATA_DIR = DATA_DIR{1};

% Reading the files list
LIST_FILES = textread([DATA_DIR, '\filelist.txt'], '%s');
l = length(LIST_FILES);

% Initializing the output matrices
white_points = zeros(l,3);
white_points_scal = zeros(l,3);
patches_rgb = zeros(24,3,1);
cc_selection = zeros(1,4,1);
cc_coord_inselection = zeros(4,2,1);
cc_final_coord = zeros(4,2,1);


% t0 is the first processed image number in the dataset
t0 = 1;
test_set = t0:t0+l-1;

for c = 1:length(test_set)
    
    id = test_set(c);
    
    filename = char(LIST_FILES(c,:)); 
    im1 = imread(filename);
    
    %% Demosaicing
    [ im11, satur_val] = Demosaicing( im1, id );
 
    filename = strcat(num2str(id),'_', filename);
    imwrite(im11, filename);
    
    %% Extracting the Colour Checker
    [  checker_img, rect, inPts, coord ] = ProcessColourChecker( im11, id ); 

    %% Get Colour Chart RGBs
    [ white_point, white_point_scal, rgb ] = GetColourChartRGB( checker_img, satur_val, id );
    
    %% Saving chart coordinates
    cc_selection(id, :) = rect ;
    cc_coord_inselection(:,:,id) = inPts;
    cc_final_coord(:,:,id) = coord;
    filename = 'coordinates';
    save(filename, 'cc_selection','cc_coord_inselection','cc_final_coord');
 
    %% Saving RGBs
    patches_rgb(:,:, id) = rgb;
    white_points(id,:) = white_point;
    white_points_scal(id,:) = white_point_scal;
  
    filename = 'white_points';
    save(filename,'patches_rgb','white_points', 'white_points_scal');

end

warning('on', 'Images:initSize:adjustingMag');

end
 

