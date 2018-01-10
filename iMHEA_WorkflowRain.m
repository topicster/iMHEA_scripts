function [DataHRes,Data1day,Data1hr,Climate] = iMHEA_WorkflowRain(bucket,varargin)
%iMHEA workflow for a catchment.
% [DataHRes,Data1day,Data1hr,Climate] =
% iMHEA_Workflow(bucket,DateP1,P1,DateP2,P2,DateP3,P3,...)
% processes the raw precipitation and discharge data to get processed data.
%
% Input:
% bucket = Rain gauge bucket volume [mm].
% DatePi = dd/mm/yyyy hh:mm:ss [date format] for rain gauge i.
% Pi     = Precipitation [mm] from rain gauge i.
%
% Output:
% DataHres = [Date, Precipitation] at 5 min resolution.
% Data1day = [Date, Precipitation] at 1 day resolution.
% Data1hr  = [Date, Precipitation] at 1 hour resolution.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017

%% START PROCESS
fprintf('\n')
fprintf('iMHEA WORKFLOW FOR PRECIPITATION IN CATCHMENT %s',inputname(1))
fprintf('\n')

%% DETERMINE NUMBER OF RAIN GAUGES
nrg = floor((nargin-1)/2);
if nrg>=1 && rem(nrg,1)==0
    fprintf('The input data includes: %4i rain gauges.\n',nrg)
else
    fprintf('There are incomplete rain gauge data to process.\n')
    DataHRes = [];
    Data1day = [];
    Data1hr =[];
    Climate =[];
    fprintf('\n')
    return
end

%% DEPURATE PRECIPITATION EVENTS
NewEvent_mm = cell(nrg,1);
for i = 1:nrg
    [NewEvent_mm{i}] = iMHEA_Depure(varargin{2*i-1},varargin{2*i});
end

%% AGGREGATE PRECIPITATION DATA TO MATCH DISCHARGE INTERVAL
% Define aggregation interval
int_HRes = 5;
nd = 1440/int_HRes; % Number of intervals per day
% Interpolate each rain gauge data at max resolution using the CS algorithm
PrecHRes = cell(nrg,1);
for i = 1:nrg
    [PrecHRes{i}] = iMHEA_AggregationCS(varargin{2*i-1},NewEvent_mm{i},int_HRes,bucket);
end

%% FILL PRECIPITATION GAPS AND OBTAIN SINGLE MATRIX
if nrg > 1
    % Fill Precipitation gaps between all combinations of rain gauges
    combinations = combnk(1:nrg,2);
    combin_index = size(combinations,1);
    PrecHResFill = cell(combin_index,1);
    c = nan(combin_index,1);
    d = nan(combin_index,1);
    for i = 1:combin_index
        a = PrecHRes{combinations(i,1)};
        b = PrecHRes{combinations(i,2)};
        [PrecHResFill{i}] = iMHEA_FillGaps(a(:,1),a(:,2),b(:,1),b(:,2));
        c(i) = PrecHResFill{i}(1,1);
        d(i) = PrecHResFill{i}(end,1);
    end
    % Extend start and end of vectors to cover the same date period.
    date_start = round(min(c)*nd);
    date_end   = round(max(d)*nd);
    % Create high resolution matrix
    DateP_HRes = (date_start:date_end)';
    Precp_Fill_Compiled = nan(length(DateP_HRes),2*combin_index);
    for i = 1:combin_index
        % Compile precipitation data in a single matrix.
        DateAux = round(PrecHResFill{i}(:,1)*nd);
        Precp_Fill_Compiled(ismember(DateP_HRes,DateAux),2*i-1:2*i) = PrecHResFill{i}(:,2:3);
    end
    % Obtain average Precipitation and create high resolution matrix
    DataHRes(:,1) = DateP_HRes/nd;
    DataHRes(:,2) = nanmean(Precp_Fill_Compiled,2);
else
    % Obtain average Precipitation and create high resolution matrix
    DataHRes(:,1) = PrecHRes{1}(:,1);
    DataHRes(:,2) = PrecHRes{1}(:,2);
end

%% AGGREGATE DATA AT 1 HOUR AND 1 DAY TEMPORAL RESOLUTIONS
% Aggregate precipitation
[Data1day] = iMHEA_Aggregation(DataHRes(:,1),DataHRes(:,2),1440);
[Data1hr] = iMHEA_Aggregation(DataHRes(:,1),DataHRes(:,2),60);
Data1day(:,3:end) = [];
Data1hr(:,3:end) = [];
%% PLOT RESULTING TIME SERIES
iMHEA_Plot3(datetime(DataHRes(:,1),'ConvertFrom','datenum'),DataHRes(:,2))

%% CALCULATE HYDROLOGICAL AND CLIMATE INDICES
DateFormatHRes = datetime(DataHRes(:,1),'ConvertFrom','datenum');
[Climate] = iMHEA_ClimateTotal(DateFormatHRes,DataHRes(:,2),1);