function [IDC,iM15m,iM1hr] = iMHEA_IDC(Date,P,varargin)
%iMHEA Calculation of Maximum Intensity-Duration Curve.
% [IDC,iM15m,iM1hr] = iMHEA_IDC(Date,P,flag).
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P    = Precipitation [mm].
% flag = leave empty NOT to graph plots.
%
% Output:
% IDC   = Maximum Intensity - Duration Curve [mm/h v time].
% iM15m = Maximum precipitation intensity (15 min scale) [mm/h].
% iM1hr = Maximum precipitation intensity (1 hour scale) [mm/h].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in July, 2015
% Last edited in November, 2017

%% PROCESS

% Maximum Intensity - Duration Curve.
h = waitbar(0,'Calculating IDC...');
% Consider periods only when data exists.
VP = P;
% Check if they are at 5 min interval.
if round(datenum(median(diff(Date))),4) ~= round(5/1440,4)
    % Consider periods only when data exists.
    VDate = Date(~isnan(VP));
    VP = VP(~isnan(VP));
    VDate(VP==0) = [];
    VP(VP==0) = [];
    % Agregate data at 5 minutes basis (because is IMHEA's time basis).
    fprintf('Aggregating precipitation data at 5min interval for IDC')
    fprintf('\n')
    [~,VP] = iMHEA_Aggregation(VDate,VP,5);
else
    % Consider periods only when data exists.
    VP(isnan(VP)) = 0;
end
k1 = length(VP);
% Durations: 5, 10, 15, 30, 60 min; 2, 4, 12, 24 hours; 2 days.
D = [1 2 3 6 12 24 48 144 288 576]; u =zeros(k1,1);
IDC = zeros(length(D),2);
IDC(:,1) = D'*5;
% Maximum intensities.
for i = 1:length(D)
    % Define initial IntP(1).
    u(1) = sum(VP(1:D(i))); % The sum of the first i elements.
    % Sums i elements using a moving window.
    for j = 2:k1-D(i)+1
        u(j) = u(j-1) + VP(j+D(i)-1)-VP(j-1);
    end
    IDC(i,2) = nanmax(u)*12/D(i);
    IDC(i,3) = nanmean(u(u>1E-12))*12/D(i);
    IDC(i,4) = median(u(u>1E-12),'omitnan')*12/D(i);
    waitbar(i/length(D))
end
close(h);

% Intensity indices.
iM15m = IDC(D==3,2);
iM1hr = IDC(D==12,2);

%% PLOT RESULTS
if nargin >= 3
    figure
    semilogx(IDC(:,1),IDC(:,2))
    xlabel('Duration (min)')
    ylabel('Maximum precipitation intensity (mm/h)')
    title('Maximum Intensity-Duration Curve')
    hold on
end