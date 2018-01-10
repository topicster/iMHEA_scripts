function [M,F,D,T,R] = iMHEA_IndicesPlus(Date,Q,A,varargin)
%iMHEA Hydrological indices from Olden & Poff (2003).
% [M,F,D,T,R] = iMHEA_IndicesPlus(Date,P,Q,flag) calculates hydrological
% indices from Olden & Poff (2003) using discharge data.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% Q = Discharge [l/s or l/s/km2].
% A = Catchment area [km2] (Optional).
% flag = leave empty NOT to graph plots.
%
% Output:
% [M,F,D,T,R] = Hydrological Indices from Olden & Poff (2003).
% Code: \ not used; * modified from the paper.
% M = Magnitude.
%     Average flows:
%       MA5  = Skewness in daily flows: Mean / Median daily flows [-].
%       MA41 = Mean annual runoff [l/s or l/s/km2].
%       MA3  = Coefficient of variation in daily flows [-].
%       MA11 = Range 75th-25th (Q25-Q75) percentiles / Median [-].
%      \MA2  = Median daily flow [l/s or l/s/km2].
%     Low flows:
%       ML17 = 7-day min flow / mean annual daily flows [-].
%      \ML4  = Mean minimum monthly flow (4th: April) [l/s or l/s/km2].
%      *ML21 = Coefficient of variation in 30-day minimum flows [-].
%       ML18 = Coefficient of variation in ML17 [-].
%     High flows:
%       MH16 = High flow discharge: Mean 90th percentile (Q10) / Median [-].
%      \MH8  = Mean maximum monthly flow (8th: August) [l/s or l/s/km2].
%      \MH10 = Mean maximum monthly flow (10th: October) [l/s or l/s/km2].
%      *MH14 = Median maximum 30-day daily flow / Median [-].
%      *MH22 = Mean high flow volume over 3 times median / Median [day].
%      *MH27 = Mean high peak flow over 75th percentile (Q25) / Median [-].
%
% F = Frequency.
%     Low flows:
%       FL3  = Pulses below 5% mean daily flow / record length [year^-1].
%       FL2  = Coefficient of variation in FL1 [-].
%       FL1  = Low flood pulse count below 25th percentile (Q75) [year^-1].
%     High flows:
%       FH3  = High flood pulse count over 3 median daily flow [year^-1].
%      *FH6  = High flow events over 3 median monthly flow [year^-1].
%       FH7  = High flow events over 7 median monthly flow [year^-1].
%       FH2  = Coefficient of variation in FH1 [-].
%      *FH1  = High flood pulse count above 75th percentile (Q25) [year^-1].
%
% D = Duration.
%     Low flows:
%      \DL18 = Mean annual number of days having zero daily flow [year^-1].
%       DL17 = Coefficient of variation in DL16 [-].
%       DL16 = Low flow pulse duration below 25th percentile (Q75) [day].
%       DL13 = Mean of 30-day minima of daily discharge / Median [-].
%     High flows:
%       DH13 = Mean of 30-day maxima of daily discharge / Median [-].
%       DH16 = Coefficient of variation in DH15 [-].
%      *DH20 = High flow pulse duration over median/0.75 [day].
%       DH15 = High flow pulse duration over 75th percentile (Q25) [day].
%
% T = Timing.
%      \TA1  = Constancy (Colwell, 1974) [-].
%       TH3  = Max proportion of the year with no flood occurrence (<Q10) [-].
%       TL2  = Coefficient of variation if TL1 [-].
%      *TL1  = Median Julian day of 1-day annual minimum [-].
%
% R = Rate of change.
%      \RA9  = Coefficient of variation in RA8 [-].
%       RA8  = Number of flow reversals between days [year^-1].
%       RA5  = Ratio of days where flow is higher than the previous [-].
%       RA6  = Median of difference between log of increasing flows [l/s/km2].
%       RA7  = Median of difference between log of decreasing flows [l/s/km2].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in August, 2014
% Last edited in November, 2017

%% MAGNITUDE

% Normalize discharge.
if nargin >= 3
    Q = Q/A;
end

% Average data at daily basis.
[DDate,DQ,~,~,QDML] = iMHEA_Average(Date,Q,1440);

% Consider periods only when data exist.
NewDate = DDate(~isnan(DQ));
NewQ = DQ(~isnan(DQ));
k = length(NewQ);
% DL18 is replaced by DayQ0 in function iMHEA_ProcessQ
% ZeroQ = NewQ(NewQ==0);
% DL18 = floor(365*length(ZeroQ)/k);
% PQ0 = DL18/365;

% Median of flows
MA2 = median(NewQ);
if MA2==0
    MA2=QDML;
    disp('Warning: Median of flows is 0. Assigned mean.');
end
% Variability in daily flows.
MA3 = std(NewQ) / QDML;
% Skewness in daily flows.
MA5 = QDML / MA2;

% Percentiles from the Flow Duration Curve.
[~,~,~,Ptile] = iMHEA_FDC(NewQ);
% Percentiles from the FDC.
Q75 = Ptile(2);
Q25 = Ptile(6);
Q10 = Ptile(7);

% High flow discharge.
% MH15 = Q1 / MA2;
MH16 = Q10 / MA2;
% MH17 = Q25 / MA2;
% Spread in daily flows.
MA11 = (Q25 - Q75) / MA2;

% Annual and monthly average data.
[~,Q_Year,QDMM,~,~,Q_YMin,~] = iMHEA_MonthlyFlow(NewDate,NewQ);
% [~,Q_Year,QDMM,~,Q_Matrix,Q_Min_Year,~] = iMHEA_MonthlyFlow(NewDate,NewQ);
% Variability in monthly flows.
MonthMedian = median(QDMM);
% MonthIQR = iqr(QDMM);
% MA37 = MonthIQR / MonthMedian;

% Mean and minimum monthly flows.
YearFlow = Q_Year(:,2);
MA41 = mean(YearFlow);
% QDMMin = nanmin(Q_Matrix);
% MA12 = QDMM(1);
% MA19 = QDMM(7);
% MA18 = QDMM(6);
% ML4  = QDMMin(4);
% ML5  = QDMMin(5);
% ML9  = QDMMin(9);
% ML10 = QDMMin(10);

% 30-day maxima and minima of daily discharge.
Daycheck = 30;
Max30 = zeros(k,1);
Min30 = zeros(k,1);
for i = 1:k
    Today = NewDate(i);
    Y = NewQ(and(NewDate>=Today,NewDate<Today+Daycheck));
    Max30(i) = max(Y);
    Min30(i) = min(Y);
end
DH13 = mean(Max30) / MA2;
DL13 = mean(Min30) / MA2;
ML21 = std(Min30) / mean(Min30);
MH14 = median(Max30) / MA2;

% 7-day minima of daily discharge for Baseflow Index.
Daycheck = 7;
Min7 = zeros(k,1);
for i = 1:k
    Today = NewDate(i);
    Y = NewQ(and(NewDate>=Today,NewDate<Today+Daycheck));
    Min7(i) = min(Y);
end
ML17 = min(Min7) / MA41;
ML18 = std(Min7) / mean(Min7);

%% TIMING
% Julian Date (day number of current year) of annual minimum.
YearMinD = Q_YMin(:,3);
TL1  = median(YearMinD);
TL2  = std(YearMinD) / mean(YearMinD);

%% PULSES
% [MH,VH,FH,DH,TH,ML,VL,FL,DL,TL] = iMHEA_Pulse(Date,Q,Lim)

% Over Q25 (75th percentile).
[MH27,~,FH12,DH1516] = iMHEA_Pulse(NewDate,NewQ,Q25);
MH27 = MH27(2) / MA2;
FH1 = FH12(1)*365 / datenum(NewDate(end)-NewDate(1)+1);
FH2 = FH12(5);
DH15 = DH1516(2);
DH16 = DH1516(5);

% Over 3 times Median.
[~,MH22,FH3] = iMHEA_Pulse(NewDate,NewQ,3*MA2);
FH3 = FH3(1)*365 / datenum(NewDate(end)-NewDate(1));
MH22 = MH22(2) / MA2;

% Over 7 times Median.
% [MH26,MH23,FH4] = iMHEA_Pulse(NewDate,NewQ,7*MA2);
% FH4 = FH4(1)*365/datenum(NewDate(end)-NewDate(1));
% MH26 = MH26(2) / MA2;
% MH23 = MH23(2) / MA2;

% Over 3 times Monthly Median.
[~,~,FH6] = iMHEA_Pulse(NewDate,NewQ,3*MonthMedian);
FH6 = FH6(1)*365 / datenum(NewDate(end)-NewDate(1)+1);

% Over 7 times Monthly Median.
[~,~,FH7] = iMHEA_Pulse(NewDate,NewQ,7*MonthMedian);
FH7 = FH7(2)*365/datenum(NewDate(end)-NewDate(1)+1);

% Below Q75 (25th percentile).
[~,~,~,~,~,~,~,FL12,DL1617] = iMHEA_Pulse(NewDate,NewQ,Q75);
FL1 = FL12(1)*365 / datenum(NewDate(end)-NewDate(1));
FL2 = FL12(5);
DL16 = DL1617(2);
DL17 = DL1617(5);

% Below 5% of QDML.
[~,~,~,~,~,~,~,FL3] = iMHEA_Pulse(NewDate,NewQ,0.05*QDML);
FL3 = FL3(1)*365 / datenum(NewDate(end)-NewDate(1)+1);

% Over median/0.75.
[~,~,~,DH20] = iMHEA_Pulse(NewDate,NewQ,MA2/0.75);
DH20 = DH20(2);

% Below Q10 (90th percentile).
[~,~,~,~,TH3] = iMHEA_Pulse(NewDate,NewQ,Q10);
TH3 = TH3/365;

%% RATE OF CHANGE
% Rate of change of flows.
LogQ = log(NewQ);
DiffLogQ = diff(LogQ);
RA6 = median(DiffLogQ(DiffLogQ>0));
RA7 = median(DiffLogQ(DiffLogQ<0));

% Number of increasing and decreasing flows (reversals) between days.
reversal = 1; % 1 for increasing flows, -1 for decreasing flows
RA8 = 0; % Counter of flow reversals.
RA5 = 0; % Counter of flow increases.
for i = 1:k-1
    if and(NewQ(i+1) > NewQ(i),reversal==-1)
        RA8 = RA8+1;
        reversal = 1;
    elseif and(NewQ(i+1) < NewQ(i),reversal==1)
        RA8 = RA8+1;
        reversal = -1;
    end
    if NewQ(i+1) > NewQ(i)
        RA5 = RA5+1;
    end
end
RA8 = RA8/datenum(NewDate(end)-NewDate(1)+1);
RA5 = RA5/datenum(NewDate(end)-NewDate(1)+1);

% Hydrological indices for discharge.
M = [MA5;...
    MA41;...
    MA3;...
    MA11;...
    ML17;...
    ML21;...
    ML18;...
    MH16;...
    MH14;...
    MH22;...
    MH27];

F = [FL3;...
    FL2;...
    FL1;...
    FH3;...
    FH6;...
    FH7;...
    FH2;...
    FH1];

D = [DL17;...
    DL16;...
    DL13;...
    DH13;...
    DH16;...
    DH20;...
    DH15];

T = [TH3;...
    TL2;...
    TL1];

R = [RA8;...
    RA5;...
    RA6;...
    RA7];