function [IndicesQ,QM,FDC,CumQ,DQ] = iMHEA_ProcessQ(Date,Q,A,varargin)
%iMHEA Hydrological index calculation for Discharge.
% [Indices] = iMHEA_ProcessQ(Date,Q,A,flags) calculates streamflow indices.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% Q = Discharge [l/s].
% A = Catchment area [km2] (Optional).
% flag1 = leave empty NOT to graph discharge plots.
% flag2 = leave empty NOT to graph baseflow plots.
%
% Output: [l/s/km2 if Area was input, or l/s otherwise].
% IndicesQ = Vector with iMHEA's Hydrological Indices for Discharge.
%           Low flows:
%               QDMin = Minimum daily flow [l/s].
%               Q95   = 05th percentile [l/s].
%               DayQ0 = Days with zero flow per year [-].
%               PQ0   = Proportion of days with zero flow per year [-].
%               QMDry = Mean daily flow of driest month [l/s].
%           High flows:
%               QDMax = Maximum Daily flow [l/s].
%               Q10   = 90th percentile [l/s].
%           Mean flows:
%               QDMY  = Annual Mean Daily flow [l/s].
%               QDML  = Long-term Mean Daily flow [l/s].
%               Q50   = 50th percentile [l/s].
%           Regulation:
%               BFI1   = Baseflow index from UK handbook [-].
%               k1     = Recession constant from UK handbook [-].
%               BFI2   = Baseflow index 2-parameter algorithm [-].
%               k2     = Recession constant 2-parameter algorithm [-].
%               Range = Discharge range [-] Qmax/Qmin.
%               R2FDC = Slope of the FDC between 33%-66% / Mean flow [-].
%               IRH   = Hydrological Regulation Index [-].
%               RBI1  = Richards-Baker annual flashiness index [-].
%               RBI2  = Richards-Baker seasonal flashiness index [-].
%               DRYQMEAN = Min monthly flow / Mean monthly flow [-].
%               DRYQWET  = Min monthly flow / Max monthly flow [-].
%               SINDQ = Seasonality Index in flows [-].
% QM = Monthly Mean Daily flow (l/s) per month number [Jan=1, Dec=12].
% FDC  = Flow Duration Curve [l/s v %].
% CumQ = Date and Cumulative Discharge [l/s].
% DQ   = Daily Discharge only when data exist [date v l/s], including:
%        BQ: Baseflow [l/s].
%        SQ: Stormflow [l/s].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in May, 2014
% Last edited in February, 2018

%% PROCESS

% Normalize discharge.
if nargin >= 3
    Q = Q/A;
end

% Average data at daily basis.
[DDate,DQ,DCumQ,~,QDML,QDMax,QDMin] = iMHEA_Average(Date,Q,1440);
RANGE = QDMax/QDMin;
CumQ = [datenum(DDate),DCumQ];

% Consider periods only when data exists.
NewDate = DDate(~isnan(DQ));
NewQ = DQ(~isnan(DQ));
l = length(NewQ);

% Number of Days with zero flow.
ZeroQ = NewQ(NewQ==0);
DayQ0 = floor(365*length(ZeroQ)/l);
PQ0 = DayQ0/365;

% Annual and monthly average data.
if nargin >= 4
    [~,~,QM,QDMY] = iMHEA_MonthlyFlow(Date(~isnan(Q)),Q(~isnan(Q)),1);
else
    [~,~,QM,QDMY] = iMHEA_MonthlyFlow(Date(~isnan(Q)),Q(~isnan(Q)));
end
% Precipitation in the driest month
QMDry = nanmin(QM);
% Annual average flow as mean monthly flow
if isnan(QDMY)
    QDMY = mean(QM);
end
% Annual average flow as mean daily flow
if isnan(QDMY)
    QDMY = mean(NewQ);
end

% Monthly discharge indices
DRYQMEAN = QMDry/nanmean(QM);
DRYQWET = QMDry/nanmax(QM);

% Seasonality Index.
SINDQ = (1/(12*QDMY))*(sum(abs(QM-QDMY)))*6/11;

% Flow Duration Curve, FDC Slope, and IRH.
if nargin >= 4
    [FDC,R2FDC,IRH,Ptile] = iMHEA_FDC(NewQ,1);
else
    [FDC,R2FDC,IRH,Ptile] = iMHEA_FDC(NewQ);
end
% Percentiles from the FDC.
Q95 = Ptile(1);
Q50 = Ptile(4);
Q10 = Ptile(7);

% Baseflow index at daily scale.
if nargin >= 5
    [~,BQ1,SQ1,BFI1,k1] = iMHEA_BaseFlowUK(Date,Q,1,1); % Gustard et al., 1992
    [~,~,BFI2,k2] = iMHEA_BaseFlow(NewDate,NewQ,1); % Chapman, 1999
else
    [~,BQ1,SQ1,BFI1,k1] = iMHEA_BaseFlowUK(Date,Q,1); % Gustard et al., 1992
    [~,~,BFI2,k2] = iMHEA_BaseFlow(NewDate,NewQ); % Chapman, 1999
end

% Compile daily flows.
DQ = [datenum(DDate),DQ,BQ1,SQ1];

% Richards-Baker flashiness index (RBI).
Qi_1 = abs(diff(NewQ));
RBI1 = sum(Qi_1)/sum(NewQ(2:end));
Qi_2 = 0.5*(Qi_1(1:end-1)+Qi_1(2:end));
RBI2 = sum(Qi_2)/sum(NewQ(2:end-1));

% Hydrological indices for discharge.
IndicesQ = [QDMin;...
           Q95;...
           DayQ0;...
           PQ0;...
           QMDry;...
           QDMax;...
           Q10;...
           QDMY;...
           QDML;...
           Q50;...
           BFI1;...
           k1;...
           BFI2;...
           k2;...
           RANGE;...
           R2FDC;...
           IRH;...
           RBI1;...
           RBI2;...
           DRYQMEAN;...
           DRYQWET;...
           SINDQ];