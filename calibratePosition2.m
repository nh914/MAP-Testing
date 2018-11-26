% calibratePosition2.m
%
% 23/11/2018
%
% This function takes filtered position data, and then carries out
% calibration to then calculate the true positions in mm
%
%INPUTS:
%
%OUTPUTS:
%

% Position data calibration and calculation
function [x_true_pos,y_true_pos,max_x,min_x,max_y,min_y] = calibratePosition2(x_filtered_pos, y_filtered_pos)

    %Get data path
    mdatapath = getdatapath2();

    %Set up correction file path
    CorrectionFilename = strcat(mdatapath{1,1}{1,1},'/active_Correction.ctb');

    % Refer to active correction file to calibrate the laser
    % position to true dimension
    fileID = fopen(CorrectionFilename,'r');

    % Read correction file data and put into specified 4225 * 2
    % matrix
    A = fread(fileID,[4225,2],'uint16');
    x = (A(:,1)-32768);
    y = (A(:,2)-32768);
    fclose(fileID);

    % Rearrange 4225 * 1 matrix of correction file data into 
    % 65 * 65 matrix
    X = (reshape(x,65,65))';
    Y = (reshape(y,65,65))';

    % Create a perfectly align square matrix with 65 * 65 size
    % to represent the desired corrected position
    x_res = (-32768:1024:32768);
    y_res = (-32768:1024:32768);
    [X_res,Y_res] = meshgrid(x_res,y_res);

    % Find the error between the correction data and the perfectly
    % aligned square
    X_e = X - X_res;
    Y_e = Y - Y_res;

    x_e = reshape(X_e,1,65 * 65);
    y_e = reshape(Y_e,1,65 * 65);

    % The determined x,y and error will be acting as a lookup table
    % for the real xy data

    % For the purpose of smoothing and denoising
    A = x_filtered_pos + y_filtered_pos;
    B = x_filtered_pos - y_filtered_pos;

    % Denoise function
    A= cmddenoise(A,'db1',4);
    B= cmddenoise(B,'db1',4);

    % Reassigned smoothed xy position (still uncorrected version)
    x_pos_sm = (A + B) / 2;
    y_pos_sm = (A - B) / 2;

    x_pos_sm = (x_pos_sm) * 28.855 * 227;
    y_pos_sm = (y_pos_sm) * 28.895 * 227;

    % Determine the positional error according to the lookup table
    error_x = griddata(x,y,x_e,x_pos_sm,y_pos_sm);
    error_y = griddata(x,y,y_e,x_pos_sm,y_pos_sm);

    % Determine the true position
    x_true_pos = ((x_pos_sm - error_x) / 227 - 2.0)';
    y_true_pos = ((y_pos_sm - error_y) / 227 - 3.7)';

    % Useful for setting xlim and ylim
    max_x = max(x_true_pos);
    min_x = min(x_true_pos);
    max_y = max(y_true_pos);
    min_y = min(y_true_pos); 

    max_x = round(max_x) + 1;
    min_x = round(min_x) - 1;
    max_y = round(max_y) + 1;
    min_y = round(min_y) - 1;
end