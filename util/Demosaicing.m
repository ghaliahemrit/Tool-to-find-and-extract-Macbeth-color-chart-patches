function [ outIm, satur_val ] = Demosaicing( inIm, id )
%% Demosaicing does a simple linear interpolation of the images considering the RGGB 
%%             pattern of each camera ( Canon 1Ds and Canon 5D )
%   Input:
%       inIm : image tiff processed with dcraw
%       id  : image number
%
%   Output:
%       outIm : demosaiced image
%       satur_val : saturation value for no pixels counting > 3300
    

%% Canon 1Ds
    
    if id < 87  
        
        if size(inIm,1)>size(inIm, 2)        
          inIm = imrotate(inIm,-90);
        end 
        
        outIm = zeros(1359,2041,3);
        outIm = uint16(outIm); 
    
        for i = 1: 1359    
        for j = 1: 2041   
            outIm(i,j,1) = inIm(2*i-1, 2*j);
            outIm(i,j,3) = inIm(2*i,2*j-1);
            outIm(i,j,2) = ( inIm(2*i-1,2*j-1)+inIm(2*i,2*j) )./2 ;
        end
        end
        
        % Black level 0 and saturation
        outIm = double(outIm);
        satur_val = 3300/max(outIm(:));
        outIm = outIm./max(outIm(:));
        
    
%%  Canon 5D
    
    else
        set = [ 107 117 133 140 265 ];
        if size(inIm,1)>size(inIm, 2)  
            if ismember(id, set) 
                inIm = imrotate(inIm,90);    
            else
                inIm = imrotate(inIm,-90);
            end
        end
        
        outIm = zeros(1460,2193,3);
        outIm = uint16(outIm); 
    
        for i = 1: 1460
        for j = 1: 2193 
              outIm(i,j,1) = inIm(2*i-1,2*j-1);
              outIm(i,j,3) = inIm(2*i,2*j);
              outIm(i,j,2) = (inIm(2*i,2*j-1) + inIm(2*i-1, 2*j))./2 ;
        end
        end

        % Black level 129 and saturation
        outIm = double(outIm);
        satur_val = (3300-129)/(max(outIm(:))-129); 
        outIm = max((outIm-129)./(max(outIm(:))-129) ,0);  
    
    end
	
end
    
