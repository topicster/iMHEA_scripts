function [dates,c] = iMHEA_MonitoringGaps(Data,varargin)
%iMHEA show monitoring periods and percentage of gaps.
% [dates,c] = iMHEA_MonitoringGaps(Data,i,'Pair') shows the monitoring
% periods and percentage of data gaps in Data.
%
% Input:
% Data   = [Date, P1, Q1, P2, Q2] as table or matrix. Column 1 is Date.
% i      = Column index to estimate gaps.
% 'Pair' = When active, the function estimates flow overlap in the data.
%
% Output:
% Cdates = Monitoring period.
% c      = Percentage of data gaps or flow overlap.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017


%% PROCESS

% Check the column index
if nargin > 1
    i = varargin{1};
else
    i = 2;
end

% Process Tables or Matrices similarly
if istable(Data)
    a = min(datetime(Data{:,1},'ConvertFrom','datenum'));
    b = max(datetime(Data{:,1},'ConvertFrom','datenum'));
    [Voids,~] = iMHEA_Voids(Data{:,1},Data{:,i});
else
    a = min(datetime(Data(:,1),'ConvertFrom','datenum'));
    b = max(datetime(Data(:,1),'ConvertFrom','datenum'));
    [Voids,~] = iMHEA_Voids(Data(:,1),Data(:,i));
end
% Estimate data gaps
c = 100*sum(diff(Voids'))/(b-a);

% Process pair catchment data differently
if nargin > 2 && strcmp(varargin{2},'Pair')
    a1 = find(~isnan(Data(:,3)),1,'first');
    a2 = find(~isnan(Data(:,5)),1,'first');
    b1 = find(~isnan(Data(:,3)),1,'last');
    b2 = find(~isnan(Data(:,5)),1,'last');
    a = max(Data(a1,1),Data(a2,1));
    b = min(Data(b1,1),Data(b2,1));
    total = length(Data);
    Data(isnan(Data(:,3)),:) = [];
    Data(isnan(Data(:,5)),:) = [];
    c(1) = 100*length(Data)/total;
    Data(isnan(Data(:,2)),:) = [];
    Data(isnan(Data(:,4)),:) = [];
    c(2) = 100*length(Data)/total;
end
% Write monitoring period
dates = [datestr(a,'dd/mm/yyyy'),' - ',datestr(b,'dd/mm/yyyy')];