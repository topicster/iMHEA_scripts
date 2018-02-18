function [Climate,Indices] = iMHEA_IndicesTotal(Date,P,Q,A,varargin)
%iMHEA All Hydrological indices for rainfall-runoff monitoring.
% [Indices] = iMHEA_Indices(Date,P,Q,A, flag) calculates all coded
% hydrological indices using rainfall and runoff data.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Precipitation [mm].
% Q = Discharge [l/s].
% A = Catchment area [km2].
% flag = leave empty NOT to graph plots.
%
% Output:
% Climate = Vector with Precipitation Indices from 2 sets:
%           IndicesP, ClimateP.
% Indices = Vector with all Hydrological Indices from 3 sets:
%           IndicesQ, IndicesPQ, IndicesPlus.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in June, 2014
% Last edited in February, 2018

%% PROCESS
fprintf('\n')
fprintf('CALCULATION OF HYDROLOGICAL AND CLIMATE INDICES OF CATCHMENT %s.\n',inputname(4))
if nargin >= 5
    % Calculate indices for Discharge and Precipitation.
    [IndicesP,~,~,IndicesQ,~,~,QYEAR,RRa,RRm,RRl] = iMHEA_Indices(Date,P,Q,A,1);
    % Calculate indices from Olden & Poff (2003).
    [M,F,D,T,R] = iMHEA_IndicesPlus(Date,Q,A,1);
    % Calculate Precipitation climatic indices.
    [ClimateP] = iMHEA_ClimateP(Date,P,1);
else
    % Calculate indices for Discharge and Precipitation.
    [IndicesP,~,~,IndicesQ,~,~,QYEAR,RRa,RRm,RRl] = iMHEA_Indices(Date,P,Q,A);
    % Calculate indices from Olden & Poff (2003).
    [M,F,D,T,R] = iMHEA_IndicesPlus(Date,Q,A);
    % Calculate Precipitation climatic indices.
    [ClimateP] = iMHEA_ClimateP(Date,P);
end

%% COMPILE
[Climate] = [IndicesP(1:end-2);...
             ClimateP(end);...
             ClimateP(1:end-1);...
             IndicesP(end-1)];
[Indices] = [IndicesQ;...
             QYEAR;...
             RRa;...
             RRm;...
             RRl;...
             M;...
             F;...
             D;...
             T;...
             R];

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
fprintf('HYDROLOGICAL INDICES:\n')
fprintf('Low flows:\n')
fprintf('Minimum daily flow: %8.4f [l/s/km2]\n',Indices(1))
fprintf('05th flow percentile (Q95) flow: %8.4f [l/s/km2]\n',Indices(2))
fprintf('Number of days with zero flow: %8.4f [day/year]\n',Indices(3))
fprintf('Proportion of the year with zero flow: %8.4f [-]\n',Indices(4))
fprintf('Mean daily flow of driest month: %8.4f [l/s/km2]\n',Indices(5))
fprintf('High flows:\n')
fprintf('Maximum daily flow: %8.4f [l/s/km2]\n',Indices(6))
fprintf('90th flow percentile (Q10) flow: %8.4f [l/s/km2]\n',Indices(7))
fprintf('Mean flows:\n')
fprintf('Annual mean daily flow: %8.4f [l/s/km2]\n',Indices(8))
fprintf('Long-term mean daily flow: %8.4f [l/s/km2]\n',Indices(9))
fprintf('50th flow percentile (Q50) flow: %8.4f [l/s/km2]\n',Indices(10))
fprintf('Hydrological regulation:\n')
fprintf('Baseflow Index from UK handbook (BFI): %8.4f [-]\n',Indices(11))
fprintf('Average recession constant from UK handbook (k): %8.4f [-]\n',Indices(12))
fprintf('Baseflow Index from two-parameter algorithm (BFI2): %8.4f [-]\n',Indices(13))
fprintf('Average recession constant from two-parameter algorithm (k2): %8.4f [-]\n',Indices(14))
fprintf('Discharge range (Qmax/Qmin): %8.4f [-]\n',Indices(15))
fprintf('Slope of the FDC between 33%-66%: %8.4f [-]\n',Indices(16))
fprintf('Hydrological Regulation Index (IRH): %8.4f [-]\n',Indices(17))
fprintf('Richards-Baker annual flashiness index: %8.4f [-]\n',Indices(18))
fprintf('Richards-Baker seasonal flashiness index: %8.4f [-]\n',Indices(19))
fprintf('Water balance:\n')
fprintf('Min monthly flow / Mean monthly flow: %8.4f [-]\n',Indices(20))
fprintf('Min monthly flow / Max monthly flow: %8.4f [-]\n',Indices(21))
fprintf('Seasonality Index in flows: %8.4f [-]\n',Indices(22))
fprintf('Average annual discharge: %8.4f [mm]\n',Indices(23))
fprintf('Runoff Ratio with annual averages (RRa): %8.4f [-]\n',Indices(24))
fprintf('Runoff Ratio with monthly averages(RRm): %8.4f [-]\n',Indices(25))
fprintf('Runoff Ratio with long-term data (RRl): %8.4f [-]\n',Indices(26))
fprintf('\n')
fprintf('Indices of Average Flow Magnitude:\n')
fprintf('MA5 : Skewness in daily flows (Mean/Median): %8.4f [-]\n',Indices(27))
fprintf('MA41: Mean annual runoff: %8.4f [l/s/km2]\n',Indices(28))
fprintf('MA3 : Coefficient of variation in daily flows: %8.4f [-]\n',Indices(29))
fprintf('MA11: Range 75th-25th percentiles (Q25-Q75)/Median: %8.4f [-]\n',Indices(30))
fprintf('Indices of Low Flow Magnitude:\n')
fprintf('ML17: 7-day min flow / mean annual daily flows: %8.4f [-]\n',Indices(31))
fprintf('ML21: Coefficient of variation in 30-day minimum flows: %8.4f [-]\n',Indices(32))
fprintf('ML18: Coefficient of variation in ML17: %8.4f [-]\n',Indices(33))
fprintf('Indices of High Flow Magnitude:\n')
fprintf('MH16: High flow discharge: Mean 90th percentile (Q10)/Median: %8.4f [-]\n',Indices(34))
fprintf('MH14: Median maximum 30-day daily flow /Median: %8.4f [-]\n',Indices(35))
fprintf('MH22: Mean high flow volume over 3 times median /Median: %8.4f [-]\n',Indices(36))
fprintf('MH27: Mean high peak flow over 75th percentile (Q25)/Median: %8.4f [-]\n',Indices(37))
fprintf('Indices of Low Flow Frequency:\n')
fprintf('FL3 : Pulses below 5% mean daily flow/record length: %8.4f [year^-1]\n',Indices(38))
fprintf('FL2 : Coefficient of variation in FL1: %8.4f [-]\n',Indices(39))
fprintf('FL1 : Low flood pulse count below 25th percentile (Q75): %8.4f [year^-1]\n',Indices(40))
fprintf('Indices of High Flow Frequency:\n')
fprintf('FH3 : High flood pulse count over 3 median daily flow: %8.4f [year^-1]\n',Indices(41))
fprintf('FH6 : High flow events over 3 median monthly flow: %8.4f [year^-1]\n',Indices(42))
fprintf('FH7 : High flow events over 7 median monthly flow: %8.4f [year^-1]\n',Indices(43))
fprintf('FH2 : Coefficient of variation in FH1: %8.4f [-]\n',Indices(44))
fprintf('FH1 : High flood pulse count above 75th percentile (Q25): %8.4f [year^-1]\n',Indices(45))
fprintf('Indices of Low Flow Duration:\n')
fprintf('DL17: Coefficient of variation in DL16: %8.4f [-]\n',Indices(46))
fprintf('DL16: Low flow pulse duration below 25th percentile (Q75): %8.4f [day]\n',Indices(47))
fprintf('DL13: Mean of 30-day minima of daily discharge /Median: %8.4f [-]\n',Indices(48))
fprintf('Indices of High Flow Duration:\n')
fprintf('DH13: Mean of 30-day maxima of daily discharge /Median: %8.4f [-]\n',Indices(49))
fprintf('DH16: Coefficient of variation in DH15: %8.4f [-]\n',Indices(50))
fprintf('DH20: High flow pulse duration over median/0.75: %8.4f [day]\n',Indices(51))
fprintf('DH15: High flow pulse duration over 75th percentile (Q25): %8.4f [day]\n',Indices(52))
fprintf('Indices of Timing:\n')
fprintf('TH3 : Max proportion of the year with no flood occurrence (<Q10): %8.4f [-]\n',Indices(53))
fprintf('TL2 : Coefficient of variation if TL1: %8.4f [-]\n',Indices(54))
fprintf('TL1 : Median Julian day of 1-day annual minimum: %8.4f [-]\n',Indices(55))
fprintf('Indices of Flashiness:\n')
fprintf('RA8 : Number of flow reversals between days: %8.4f [year^-1]\n',Indices(56))
fprintf('RA5 : Ratio of days where flow is higher than the previous: %8.4f [-]\n',Indices(57))
fprintf('RA6 : Median of difference between log of increasing flows: %8.4f [l/s/km2]\n',Indices(58))
fprintf('RA7 : Median of difference between log of decreasing flows: %8.4f [l/s/km2]\n',Indices(59))
fprintf('\n')
fprintf('Process finished.\n')
fprintf('\n')