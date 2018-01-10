function [ClimateP] = iMHEA_ClimateP(Date,P,varargin)
%iMHEA Catchment climatic characteristics derived from precipitation.
% [ClimateP] = iMHEA_ClimateP(Date,P,flag).
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Precipitation [mm].
%
% Output:
% ClimateP = Climatic characteristics derived from precipitation.
%            RMED1D = Median annual maximum 1-day precipitation [mm].
%            RMED2D = Median annual maximum 2-day precipitation [mm].
%            RMED1H = Median annual maximum 1-hour precipitation [mm].
%           *iMAX1D = Maximum 1-day precipitation intensity [mm/h].
%           *iMAX2D = Maximum 2-day precipitation intensity [mm/h].
%           *iMAX1H = Maximum 1-hour precipitation intensity [mm/h].
%            PVAR   = Coefficient of variation in precipitation [-].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in June, 2014
% Last edited in November, 2017

%% PROCESS

% Agregate data at daily and hourly basis.
[DDate,DP] = iMHEA_Aggregation(Date,P,1440);
[HDate,HP] = iMHEA_Aggregation(Date,P,60);

% Consider periods only when data exists.
NewDate = DDate(~isnan(DP));
NewP = DP(~isnan(DP));
k = length(NewP);
NewHDate = HDate(~isnan(HP));
NewHP = HP(~isnan(HP));

% Mean and variation in daily precipitation.
PBAR = mean(NewP);
PSTD = std(NewP);
PVAR = PSTD/PBAR;

% Agregate 2-day precipitation from daily data.
Daycheck = 2;
Sum2D = zeros(k,1);
for i = 1:k
    Today = NewDate(i);
    Y = NewP(and(NewDate>=Today,NewDate<Today+Daycheck));
    Sum2D(i) = sum(Y);
end

% Calculate annual precipitation from 1-day, 2-day, 1-hour data.
[~,~,~,~,~,~,PYMax1D] = iMHEA_MonthlyRain(NewDate,NewP);
[~,~,~,~,~,~,PYMax2D] = iMHEA_MonthlyRain(NewDate,Sum2D);
[~,~,~,~,~,~,PYMax1H] = iMHEA_MonthlyRain(NewHDate,NewHP);
RMED1D = median(PYMax1D(:,2));
RMED2D = median(PYMax2D(:,2));
RMED1H = median(PYMax1H(:,2));

% Maximum Intensity - Duration Curve.
[IDC] = iMHEA_IDC(Date,P);
% Durations: 5, 10, 15, 30, 60 min; 2, 4, 12, 24 hours; 2 days.
D = [1 2 3 6 12 24 48 144 288 576];
% Intensity indices.
iMAX1D = IDC(D==288,2);
iMAX2D = IDC(D==576,2);
iMAX1H = IDC(D==12,2);

% Physical characteristics derived from precipitation.
ClimateP = [RMED1D;...
            RMED2D;...
            RMED1H;...
            iMAX1D;...
            iMAX2D;...
            iMAX1H;...
            PVAR];