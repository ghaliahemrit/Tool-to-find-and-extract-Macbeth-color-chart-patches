function [ g, f ] = imshowGammaAdjust( inIm )
%% imshowGammaAdjust sets a desired gamma value for an image
%   Input:
%       inIm : input image
%
%   Output:
%       g : gamma value
%       f : displayed image

while(true)   
     str = inputdlg('Please input a gamma value:',...
                 'Gamma', 1, {'0.5'});
             
     if isempty(str)
        error('imshowGammaAdjust:cancelled', ...
            'Cancelled by user.');
     end
     
    g = str2double(str);
    f = figure;
    imshow(inIm.^g);
    set(gcf, 'Position', get(0, 'Screensize'));
     choice = questdlg('Are you happy with the current gamma value?', ...
     'Gamma Correction', 'Yes', 'No', 'Yes');
 
     if strcmp(choice, 'Yes')
       break;
     else
        close(f);
     end
    
end

end

