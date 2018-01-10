function [MH,VH,FH,DH,TH,ML,VL,FL,DL,TL] = iMHEA_Pulse(Date,Q,Lim,varargin)
%iMHEA Pulse count.
% [MH,VH,FH,DH,TH,ML,VL,FL,DL,TL] = iMHEA_Pulse(Date,Q,Lim,flag) calculates
% magnitude, volume, frequency, duration, timing and coefficientes of
% variation for each property, of pulses in Q over the threshold Lim.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% Q    = Discharge [l/s or l/s/km2].
% Lim  = Threshold [l/s or l/s/km2].
% flag = leave empty NOT to graph plots or print results.
%
% Output:
% M = (Total Average Min Max CVar) magnitude of pulses [l/s].
% V = (Total Average Min Max CVar) volume of pulses [l].
% F = (Total Average Min Max CVar) frequency of pulses [/year].
% D = (Total Average Min Max CVar) duration of pulses [day].
% T = Max period with no pulse occurrence [day].
%
% These variables are defined for:
%      H = High pulses.
%      L = Low pulses.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in August, 2014
% Last edited in November, 2017

%% INITIALISE VARIABLES
% Obtain years for average number of pulses
Years = year(Date);
n = max(Years)-min(Years)+1; % Number of years
HFreq = [(min(Years):max(Years))' , zeros(n,1)];
LFreq = [(min(Years):max(Years))' , zeros(n,1)];
% Only when data exist
Date = datenum(Date(~isnan(Q)));
Q = Q(~isnan(Q));
k = length(Q);
% Counters
nH = 1; nL = 1;  % Pulse counters
HPeriod = zeros(1,1); LPeriod = zeros(1,1); % Initialize interval matrix
HPeak = zeros(1,1); LPeak = inf*ones(1,1); % Initialize peaks
HVol = zeros(1,1); LVol = zeros(1,1); % Initialize volumes
% Sustract threshold.
ModQ = Q - Lim;
Date(end+1) = Date (end);
ModQ(end+1) = ModQ (end);

%% PROCESS
for j = 1:k
    if ModQ(j) >= 0
        nH = nH + 1;
        HFreq(HFreq(:,1)==Years(j),2) = HFreq(HFreq(:,1)==Years(j),2) +1;
        HPeriod(nH,1) = Date(j); % Initial date of high pulse interval
        HPeriod(nH,2) = Date(j+1); % Final date of high pulse interval
        HPeak(nH,1) = Q(j); % Pulse peak
        HVol(nH) = (Date(j+1)-Date(j))*(max(ModQ(j+1),0)+max(ModQ(j),0))/2; % Volume
        if HPeriod(nH,1) == HPeriod(nH-1,2)
            % Aggregate continuous pulses
            nH = nH - 1;
            HFreq(HFreq(:,1)==Years(j),2) = HFreq(HFreq(:,1)==Years(j),2) -1;
            HPeriod(nH,2) = HPeriod(nH+1,2);
            HPeriod(nH+1,:) = [];
            HPeak(nH,1) = max(HPeak(nH,1),HPeak(nH+1));
            HPeak(nH+1) = [];
            HVol(nH) = HVol(nH+1)+HVol(nH);
            HVol(nH+1) = [];
        end
    else
        nL = nL + 1;
        LFreq(LFreq(:,1)==Years(j),2) = LFreq(HFreq(:,1)==Years(j),2) + 1;
        LPeriod(nL,1) = Date(j); % Initial date of low pulse interval
        LPeriod(nL,2) = Date(j+1); % Final date of low pulse interval
        LPeak(nL,1) = Q(j); % Pulse peak
        LVol(nL) = (Date(j+1)-Date(j))*(min(ModQ(j+1),0)+min(ModQ(j),0))/2; % Volume
        if LPeriod(nL,1) == LPeriod(nL-1,2)
            % Aggregate continuous pulses
            nL = nL - 1;
            LFreq(LFreq(:,1)==Years(j),2) = LFreq(HFreq(:,1)==Years(j),2) -1;
            LPeriod(nL,2) = LPeriod(nL+1,2);
            LPeriod(nL+1,:) = [];
            LPeak(nL,1) = min(LPeak(nL),LPeak(nL+1));
            LPeak(nL+1) = [];
            LVol(nL) = LVol(nL+1)+LVol(nL);
            LVol(nL+1) = [];
        end
    end
end
% Restore sizes
HFreq(:,1) = []; HPeriod(1,:) = []; nH = nH-1; HPeak(1) = [];
LFreq(:,1) = []; LPeriod(1,:) = []; nL = nL-1; LPeak(1) = [];

% Low pulse count.
if nL(1) == 0
    % No pulses
    FL = zeros(1,5);
    ML = zeros(1,5);
    VL = zeros(1,5);
    DL = zeros(1,5);
else
    % Obtain total, mean, min, max, Cv, for each property
    FL = [sum(LFreq) mean(LFreq) min(LFreq) max(LFreq) std(LFreq)/mean(LFreq)];
    ML = [sum(LPeak) mean(LPeak) min(LPeak) max(LPeak) std(LPeak)/mean(LPeak)];
    VL = [sum(LVol) mean(LVol) min(LVol) max(LVol) std(LVol)/mean(LVol)];
    DL = [sum(LPeriod(:,2) - LPeriod(:,1)),...
        mean(LPeriod(:,2) - LPeriod(:,1)),...
        min(LPeriod(:,2) - LPeriod(:,1)),...
        max(LPeriod(:,2) - LPeriod(:,1)),...
        std(LPeriod(:,2) - LPeriod(:,1))/mean(LPeriod(:,2) - LPeriod(:,1))];
end

% High pulse count.
if nH(1) == 0
    % No pulses
    FH = zeros(1,5);
    MH = zeros(1,5);
    VH = zeros(1,5);
    DH = zeros(1,5);
else
    % Obtain total, mean, min, max, Cv, for each property
    FH = [sum(HFreq) mean(HFreq) min(HFreq) max(HFreq) std(HFreq)/mean(HFreq)];
    MH = [sum(HPeak) mean(HPeak) min(HPeak) max(HPeak) std(HPeak)/mean(HPeak)];
    VH = [sum(HVol) mean(HVol) min(HVol) max(HVol) std(HVol)/mean(HVol)];
    DH = [sum(HPeriod(:,2) - HPeriod(:,1)),...
        mean(HPeriod(:,2) - HPeriod(:,1)),...
        min(HPeriod(:,2) - HPeriod(:,1)),...
        max(HPeriod(:,2) - HPeriod(:,1)),...
        std(HPeriod(:,2) - HPeriod(:,1))/mean(HPeriod(:,2) - HPeriod(:,1))];
end
% Max periods without pulses.
TL = DH(3);
TH = DL(3);
% Restore vector.
Date(end) = [];
Date = datetime(Date,'ConvertFrom','datenum');

%% PRINT RESULTS
if nargin >= 4
    
    fprintf('\n')
    fprintf('PULSE COUNT FOR DISCHARGE DATA.\n')
    fprintf('Treshold: %8.2f\n',Lim)
    fprintf('\n')
    fprintf('Low pulse count (below threshold).\n')
    fprintf('Total number of low pulses: %6i\n',nL)
    fprintf('Max period with no low pulse occurrence: %8.2f [day]\n',TL)
    fprintf('Statistics:\t\tTotal\t\tMean\t\tMinimum\t\tMaximum\t\tCoeff. var.\n')
    fprintf('Frequency:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',FL)
    fprintf('Magnitude:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',ML)
    fprintf('Volume:\t\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',VL)
    fprintf('Duration:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',DL)
    fprintf('\n')
    fprintf('High pulse count (above threshold).\n')
    fprintf('Total number of high pulses: %6i\n',nH)
    fprintf('Max period with no high pulse occurrence: %8.2f [day]\n',TH)
    fprintf('Statistics:\t\tTotal\t\tMean\t\tMinimum\t\tMaximum\t\tCoeff. var.\n')
    fprintf('Frequency:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',FH)
    fprintf('Magnitude:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',MH)
    fprintf('Volume:\t\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',VH)
    fprintf('Duration:\t\t%8.2f\t%8.2f\t%8.2f\t%8.2f\t%8.2f\n',DH)
    fprintf('\n')
    
    figure
    plot(Date,Q,Date,Lim*ones(size(Date)))
    xlabel('Date')
    ylabel('Discharge [l/s/km2]')
    legend('Discharge','Threshold')
    title('Flow Pulse Count')
    box on
end