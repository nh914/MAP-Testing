function [time, power, x_true_pos, y_true_pos] = rationaliselaserdata(time, diode, x_raw, y_raw)
% rationaliselaserdata.m
%
% 23/11/2018
%
% This simple function takes imported DAQ data and then performs the relevant 
% filtering and calibration to output data in more readable units
%
%INPUTS:
%
%OUTPUTS:
%

    %Convert laser power
    [power,min_pow,max_pow] = diode2power2(diode);

    %Filter data
    [x_filtered_pos, y_filtered_pos] = filterPosition2(time, x_raw, y_raw);

    %Calibrate position data and get positions in mm
    [x_true_pos,y_true_pos,max_x,min_x,max_y,min_y] = calibratePosition2(x_filtered_pos, y_filtered_pos);

end
