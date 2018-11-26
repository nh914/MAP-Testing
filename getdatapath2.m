% getdatapath2.m
%
% 23/11/2018
%
% This basic function just grabs the mDataPath.txt file and reads the data
% path.
%
%INPUTS:
%
%OUTPUTS:
%

function mdatapath = getdatapath2()
    if fopen('mDataPath.txt','r') > -1
        fileID = fopen('mDataPath.txt','r');
        mdatapath = textscan(fileID,'%s');
        fclose(fileID);
    else
        disp('Could not find mDataPath.txt file!');
    end
end