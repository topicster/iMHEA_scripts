function [IndicesP,PM,IDC,IndicesQ,QM,FDC,QYEAR,RRa,RRm,RRl,CumP,CumQ,DP,DQ] = iMHEA_Indices(Date,P,Q,A,varargin)
%iMHEA Hydrological indices for rainfall-runoff monitoring.
% [Indices] = iMHEA_Indices(Date,P,Q,A,flag) calculates iMHEA hydrological
% indices using rainfall and runoff data.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Precipitation [mm].
% Q = Discharge [l/s].
% A = Catchment area [km2].
% flag = leave empty NOT to graph plots.
%
% Output:
% IndicesP = Vector with iMHEA's Hydrological Indices for Precipitation.
%           PYear = Annual precipitation [mm].
%           DayP0 = Number of Days with zero precipitation per year [-].
%           PMDry = Precipitation of driest month [mm].
%           Sindx = Seasonality index [-].
%           iM15m = Maximum precipitation intensity (15 min scale) [mm/h].
%           iM1hr = Maximum precipitation intensity (1 hour scale) [mm/h].
% PM   = Monthly precipitation (mm) per month number [Jan=1, Dec=12].
% IDC  = Maximum Intensity - Duration Curve [mm/h v time].
%
% IndicesQ = Vector with iMHEA's Hydrological Indices for Discharge.
%           Low flows:
%               QDMin = Minimum daily flow [l/s/km2].
%               Q95   = 95 Percentile flow from IDC [l/s/km2].
%               DayQ0 = Number of Days with zero flow per year [-].
%               QMDry = Mean daily flow of driest month [l/s/km2].
%           High flows:
%               QDMax = Maximum Daily flow [l/s/km2].
%               Q10   = 10 Percentile flow from IDC [l/s/km2].
%           Mean flows:
%               QDMY  = Annual Mean Daily flow [l/s/km2].
%               QDML  = Long-term Mean Daily flow [l/s/km2].
%               Q50   = 50 percentile flow from IDC [l/s/km2].
%           Regulation:
%               BFI   = Baseflow index [-].
%               k     = Recession constant [-].
%               Range = Discharge range [-] Qmax/Qmin.
%               R2FDC = Slope of the FDC between 33% and 66% / Mean flow.
% QM = Monthly Mean Daily flow (l/s) per month number [Jan=1, Dec=12].
% FDC  = Flow Duration Curve [l/s v %].
%
% RR   = Runoff Ratio [-) (Annual Discharge)/(Annual precipitation).
%        a: from interannual averages
%        m: from monthly averages
%        l: from long-term data averages
% QYEAR= Annual Discharge [mm].
% Diff = Annual Precipitation - Annual Discharge [mm].
% CumP = Cumulative Rainfall [mm].
% CumQ = Cumulative Discharge [mm].
% DP   = Daily Precipitation [mm].
% DQ   = Daily Discharge and baseflow separation [l/s/km2].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in June, 2014
% Last edited in November, 2017

%% PROCESS

% Calculate indices for Discharge and Precipitation.
if nargin >= 5
    [IndicesP,PM,IDC,CumP,DP] = iMHEA_ProcessP(Date,P,1);
    [IndicesQ,QM,FDC,CumQ,DQ] = iMHEA_ProcessQ(Date,Q,A,1,1);
else
    [IndicesP,PM,IDC,CumP,DP] = iMHEA_ProcessP(Date,P);
    [IndicesQ,QM,FDC,CumQ,DQ] = iMHEA_ProcessQ(Date,Q,A);
end

% Runoff Coefficient.
QYEAR = IndicesQ(8)*365/1000000*86400;
RRa = QYEAR / IndicesP(1);
CumQ(:,2) = CumQ(:,2)/1000000*86400;

if isnan(QYEAR); QYEAR = nanmean(DQ(:,2))/1000000*86400; end
RRl = nanmean(DQ(:,2))/1000000*86400 / (nanmean(DP(:,2)));

% Monthly discharge in mm.
MDays = [31 28 31 30 31 30 31 31 30 31 30 31]';
QM = QM.*MDays/1000000*86400;
RRm = nansum(QM)/nansum(PM);

if nargin >= 5
    % Transform dates to date format for plots
    CumPDate = datetime(CumP(:,1),'ConvertFrom','datenum');
    CumQDate = datetime(CumQ(:,1),'ConvertFrom','datenum');
    NewDateP = datetime(DP(:,1),'ConvertFrom','datenum');
    NewDateQ = datetime(DQ(:,1),'ConvertFrom','datenum');
    
    figure
    subplot(2,1,1)
    bar(Date,P)
    xlabel('Date')
    ylabel('Precipitation (mm)')
    set(gca,'YDir','reverse')
    Xlim = get(gca,'XLim');
    title('Input Precipitation')
    box on

    subplot(2,1,2)
    plot(Date,Q/A)
    xlabel('Date')
    ylabel('Discharge (l/s/km2)')
    title('Input Discharge')
    box on

    figure
    subplot(2,1,1)
    plot(CumPDate,CumP(:,2),CumQDate,CumQ(:,2))
    title('Cumulative comparison')
    legend('Cum. Rainfall (mm)','Cum. Discharge(mm)','Location','NorthWest')
    xlabel('Date')
    ylabel('Cumulative variables')
    box on

    subplot(2,1,2)
    plot(CumP(:,2),CumQ(:,2))
    title('Double Mass Plot')
    xlabel('Precipitation')
    ylabel('Discharge')
    box on

    figure
    semilogx(IDC(:,1),IDC(:,2))
    xlabel('Duration (min)')
    ylabel('Maximum precipitation intensity (mm/h)')
    title('Maximum Intensity-Duration Curve')
    box on

    figure
    semilogy(FDC(:,1),FDC(:,2))
    xlabel('Exceedance probability')
    ylabel('Discharge (l/s/km2)')
    title('Flow Duration Curve')
    box on

    figure
    plot((1:12)',PM,(1:12)',QM)
    xlabel('Month')
    ylabel('Variable (mm)')
    legend('Precipitation (mm)','Discharge (mm)')
    title('Monthly Data')
    xlim([0 13])
    box on

    figure
    subplot(2,1,1)
    bar(NewDateP,DP(:,2))
    xlabel('Date')
    ylabel('Precipitation (mm)')
    set(gca,'YDir','reverse','XLim',Xlim);
    title('Daily Precipitation')
    box on

    subplot(2,1,2)
    plot(NewDateQ,DQ(:,2),NewDateQ,DQ(:,3),NewDateQ,DQ(:,4))
    xlabel('Date')
    ylabel('Discharge (l/s/km2)')
    legend('Discharge','Baseflow','Stormflow')
    set(gca,'XLim',Xlim);
    title('Daily Discharge')
    box on
end