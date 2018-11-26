% diode2power2.m
%
% 23/11/2018
%
% This function takes imported DAQ data for power (diode) and then converts
% it to laser power in watts
%
%INPUTS:
%
%OUTPUTS:
%

% Diode to power conversion
function [power,min_pow,max_pow] = diode2power2(diode)
        power = interp1(LaserData.REF_DIODE2POW(:,1),LaserData.REF_DIODE2POW(:,2),...
            diode,'linear','extrap');
        power(power < 0) = 0;
        min_pow = min(round(power - 0.01,2));
        max_pow = max(round(power + 0.01,2));
end