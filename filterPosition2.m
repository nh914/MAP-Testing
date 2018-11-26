function [x_filtered_pos, y_filtered_pos] = filterPosition2(time, X_raw, Y_raw)
% filterPosition2.m
%
% 23/11/2018
%
% This function takes raw imported DAQ data and filters it for use in
% calibration
%
%INPUTS:
%
%OUTPUTS:
%

    %Calculate dt
    TimeDiff = time(2) - time(1);

    % Create a kaiser filter
    Fs = 1/TimeDiff; %sampling freq
    [filtorder, w, beta, ftype] = kaiserord([LaserData.F_PASS,LaserData.F_STOP],...
        [1,0],[LaserData.RIPPLE,LaserData.RIPPLE],Fs);
    windowfilt=fir1(filtorder,w,ftype,kaiser(filtorder+1,beta),'noscale');

    % Filter the position data
    x_filtered_pos = filtfilt(windowfilt,1,X_raw(1:end));
    y_filtered_pos = filtfilt(windowfilt,1,Y_raw(1:end));      

end