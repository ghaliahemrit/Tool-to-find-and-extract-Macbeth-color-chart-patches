function [ white_point, white_point_scal, rgb ] = GetColourChartRGB( checker_img, satur_val, id )
%% GetColourChartRGB gets the RGB values off a colour chart.
%   Input:
%       checker_img : ColorChecker chart only image
%       satur_val : saturation value for no pixels counting > 3300
%       id : image number
%
%   Output:
%       white_point : white point measured from the colour chart
%       white_point_scal : normalised rgb values of the white point
%       rgb : matrix with the average rgb values of the colour checker


%% Sanity check
if ndims(checker_img) ~= 3
    error('The parameter checker_img is not an image.');
end


    %% Adjust the gamma correction of the Raw image
    [gamma_value, figure_handle] = imshowGammaAdjust(checker_img);
    close(figure_handle);

    %% the ColorChecker chart size is.
    x_count = 6; 
    y_count = 4; 

    %% Start of colour patch selection loop
    while true
        %% Collecting coordinates of the corners of the colour checker.
        figure_handle = figure;
        imshow(checker_img.^gamma_value);
        set(gcf, 'Position', get(0, 'Screensize'));

         uiwait(msgbox(['Please select the centres of the colour '...
             'patches at the four corners']));

        % Note that the coordinates are in x,y format, even though the
        % matrices are addressed in y,x format!!!
        cpc = GetCoordFromImg(4); % Corner Patches Centre

        % Calculate the size of the colour chart
        x_size = mean([cpc(2,1) - cpc(1,1), cpc(3,1) - cpc(4,1)]);
        y_size = mean([cpc(3,2) - cpc(2,2), cpc(4,2) - cpc(1,2)]);

        % Calculate the size of spacing
        x_spacing = x_size / (x_count-1);
        y_spacing = y_size / (y_count-1);

        % Define the starting and ending positions
        x_start = cpc(1,1);
        y_start = cpc(1,2);
        x_end = cpc(3,1);
        y_end = cpc(4,2);

        %% Gather information on how big each colour patch is.
        uiwait(msgbox(['Please draw a rectangle around a colour'...
            ' patch for this region will be replicated across all'...
            ' colour patches for sampling purposes']));
        p_rect = getrect();
        ps = mean([p_rect(3), p_rect(4)]);

        %% Looping through the colour checker to draw the rectangles
        hold on;

        % Make sure that we draw enough rectangles
        if size(x_start:x_spacing:x_end) < x_count
            x_end = x_end + x_spacing;
        end

        if size(y_start:y_spacing:y_end) < y_count
            y_end = y_end + y_spacing;
        end

        % The actual drawing loop
        for i = y_start:y_spacing:y_end
            for j = x_start:x_spacing:x_end
                rectangle('Position', [j-ps/2, i-ps/2, ps, ps], ...
                    'EdgeColor', 'r','LineWidth', 2);
            end
        end
        
        hold off;
        choice = questdlg('Are you happy with the selection?', ...
            'Selection confirmation', ...
            'Yes', 'No', 'Yes');
        if strcmp(choice, 'Yes')
            break;
        else
            close(figure_handle);
        end
    end 
    
    % Write the ccs_struct
    ccs_struct.x_start = x_start;
    ccs_struct.x_spacing = x_spacing;
    ccs_struct.x_end = x_end;

    ccs_struct.y_start = y_start;
    ccs_struct.y_spacing = y_spacing;
    ccs_struct.y_end = y_end;

    ccs_struct.gamma_value = gamma_value;
    ccs_struct.ps = ps;

    ccs_struct.x_count = x_count;
    ccs_struct.y_count = y_count;

    ccs_struct.cpc = cpc;

    %% End of Selection task
   
  
    %% Collecting colour patch samples and calculating the white point

    % Initializing the patches counting
    k = 0;
    rgb = zeros(x_count * y_count, 3);

    for i = y_start:y_spacing:y_end
        for j = x_start:x_spacing:x_end

            this_patch = checker_img(floor(i-ps/2):ceil(i+ps/2), ...,
                         floor(j-ps/2):ceil(j+ps/2), :);    
            patch_reshape = reshape(this_patch,[numel(this_patch),1,1]);

            % Exclusing patches with pixels level > 3300
            clipped = 1;
                  if isempty(patch_reshape(patch_reshape>satur_val))
                     clipped = 0; 
                  end
            
            this_patch = reshape(this_patch,[],1,3);
            k = k + 1;
            if clipped == 0
                for dim = 1:3
                    rgb(k,dim) = mean(this_patch(:,1,dim));
                end
            else
                  rgb(k,:) = NaN;
            end

            

        end
    end


    %% Brightest patch
    I_patches = mean(rgb(19:24,:),2); 
    patch_index = find(I_patches==max(I_patches));


    %% White Point 
     c = y_start + 3*y_spacing;
     d = x_start+x_spacing*(patch_index-1);

     bright_patch = checker_img(floor(c-ps/2):ceil(c+ps/2), ...,
                    floor(d-ps/2):ceil(d+ps/2), :);
     bright_patch = reshape(bright_patch,[],1,3);

     white_point = zeros(1,3);
        for dim = 1:3  
            white_point(1,dim) = median(bright_patch(:,1,dim));
        end 

    white_point_scal = white_point./sum(white_point(:));
    disp(white_point_scal)
    
    %% Saving chart selections parameters
    filename = strcat(num2str(id),'cc_struct');
    save(filename, '-struct', 'ccs_struct');
    
    close all;

    end





