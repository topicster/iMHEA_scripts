function [Climate] = iMHEA_ClimateTotal(Date,P,varargin)
%iMHEA All climate indices for precipitation.
% [Climate] = iMHEA_ClimateTotal(Date,P,flag) calculates all coded climate
% indices using rainfall data.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Precipitation [mm].
% flag = leave empty NOT to graph plots.
%
% Output:
% Climate = Vector with Precipitation Indices from 2 sets:
%           IndicesP, ClimateP.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017

%% PROCESS
fprintf('\n')
fprintf('CALCULATION OF CLIMATE INDICES OF CATCHMENT %s.\n',inputname(2))
if nargin >= 3
    % Calculate indices for Discharge and Precipitation.
    [IndicesP] = iMHEA_ProcessP(Date,P,1);
    % Calculate Precipitation climatic indices.
    [ClimateP] = iMHEA_ClimateP(Date,P,1,1);
else
    % Calculate indices for Discharge and Precipitation.
    [IndicesP] = iMHEA_ProcessP(Date,P);
    % Calculate Precipitation climatic indices.
    [ClimateP] = iMHEA_ClimateP(Date,P);
end

%% COMPILE
[Climate] = [IndicesP(1:end-2);...
             ClimateP(end);...
             ClimateP(1:end-1);...
             IndicesP(end-1)];

%% PRINT RESULTS
fprintf('\n')
fprintf('CLIMATE INDICES:\n')
fprintf('Magnitude and variability:\n')
fprintf('Average annual precipitation: %8.4f [mm]\n',Climate(1))
fprintf('Number of days with zero precipitation: %8.4f [day/year]\n',Climate(2))
fprintf('Proportion of the year with zero precipitation: %8.4f [-]\n',Climate(3))
fprintf('Precipitation on the driest month: %8.4f [mm]\n',Climate(4))
fprintf('Seasonality Index: %8.4f [-]\n',Climate(5))
fprintf('Coefficient of variation in daily precipitation: %8.4f [mm/mm]\n',Climate(6))
fprintf('Rainfall intensity:\n')
fprintf('Median annual maximum 1-day precipitation: %8.4f [mm/day]\n',Climate(7))
fprintf('Median annual maximum 2-day precipitation: %8.4f [mm/2day]\n',Climate(8))
fprintf('Median annual maximum 1-hour precipitation: %8.4f [mm/hr]\n',Climate(9))
fprintf('Maximum 1-day precipitation intensity: %8.4f [mm/hr]\n',Climate(10))
fprintf('Maximum 2-day precipitation intensity: %8.4f [mm/hr]\n',Climate(11))
fprintf('Maximum 1-hour precipitation intensity: %8.4f [mm/hr]\n',Climate(12))
fprintf('Maximum 15-min precipitation intensity: %8.4f [mm/hr]\n',Climate(13))
fprintf('\n')
fprintf('Process finished.\n')
fprintf('\n')