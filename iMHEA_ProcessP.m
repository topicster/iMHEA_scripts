function [IndicesP,PM,IDC,CumP,DP] = iMHEA_ProcessP(Date,P,varargin)
%iMHEA Hydrological index calculation for Precipitation.
% [Indices] = iMHEA_ProcessP(Date,P,flag) calculates rainfall indices.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P    = Precipitation [mm].
% flag = leave empty NOT to graph plots.
%
% Output:
% IndicesP = Vector with iMHEA's Hydrological Indices for Precipitation.
%            PYear = Annual precipitation [mm].
%            DayP0 = Number of days with zero precipitation per year [day].
%            PP0 = Percentage of days with zero precipitation per year [-].
%            PMDry = Precipitation of driest month [mm].
%            Sindx = Seasonality Index [-].
%            iM15m = Maximum precipitation intensity (15 min scale) [mm/h].
%            iM1hr = Maximum precipitation intensity (1 hour scale) [mm/h].
% PM   = Monthly precipitation [mm] per month number [Jan=1, Dec=12].
% IDC  = Maximum Intensity - Duration Curve [mm/h v time].
% CumP = Cumulative Precipitation [date v mm].
% DP   = Daily precipitation only when data exist [date v mm].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in May, 2014
% Last edited in November, 2017

%% PROCESS

% Agregate data at daily basis.
[DDate,DP,DCumP] = iMHEA_Aggregation(Date,P,1440);
CumP = [datenum(DDate),DCumP];

% Consider periods only when data exists.
NewDate = DDate(~isnan(DP));
NewP = DP(~isnan(DP));
k = length(NewP);
DP = [datenum(NewDate),NewP];

% Number of Days with zero precipitation.
ZeroP = NewP(NewP==0);
DayP0 = floor(365*length(ZeroP)/k);
PP0 = DayP0/365;

% Annual and monthly agregated data.
if nargin >= 3
    [~,~,PM,~,~] = iMHEA_MonthlyRain(Date(~isnan(P)),P(~isnan(P)),1);
else
    [~,~,PM,~,~] = iMHEA_MonthlyRain(Date(~isnan(P)),P(~isnan(P)));
end
% Precipitation in the driest month.
PMDry = nanmin(PM);
% Annual precipitation.
PYear = sum(PM);
if isnan(PYear)
    PYear = 365*mean(NewP); % Equivalent to sum(newP)*365/Days
end

% Seasonality Index.
SINDX = (1/PYear)*(sum(abs(PM-PYear/12)))*6/11;

% Maximum Intensity - Duration Curve.
if nargin >= 3
    % Maximum Intensity - Duration Curve.
    [IDC,iM15m,iM1hr] = iMHEA_IDC(Date,P,1);
else
    [IDC,iM15m,iM1hr] = iMHEA_IDC(Date,P);
end

% Hydrological indices for precipitation.
IndicesP = [PYear;...
           DayP0;...
           PP0;...
           PMDry;...
           SINDX;...
           iM15m;...
           iM1hr];