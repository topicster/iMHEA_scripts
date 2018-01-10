function [Indices,Climate,PM,QM,FDC1,FDC2,IDC1,IDC2] = iMHEA_Pair(Date1,P1,Q1,A1,Date2,P2,Q2,A2)
%iMHEA Pair-catchments comparisons.
% [Indices,Climate] = iMHEA_Pair(Date1,P1,Q1,A1,Date2,P2,Q2,A2) processes
% data from paired catchments and produce indices ands plots.
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Precipitation [mm].
% Q = Discharge [l/s].
% A = Catchment area [km2].
%
% Output:
% Indices  = Matrix of hydrological indices from streamflow.
% Climate  = Matrix of climate indices from precipitation.
% PM = Monthly precipitation (mm) per month number [Jan=1, Dec=12].
% QM = Monthly Mean Daily flow (l/s) per month number [Jan=1, Dec=12].
% IDCi  = Maximum Intensity - Duration Curve [mm/h v time] for catchment i.
% FDCi  = Flow Duration Curve [l/s v %] for catchment i.
% Comparative plots.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in June, 2014
% Last edited in November, 2017

%% PROCESS
% Initialise variables
Climate = zeros(13,2);
Indices = zeros(57,2);
PM = zeros(12,2);
QM = zeros(12,2);
% Calculate indices for Discharge and Precipitation.
[Climate(:,1),Indices(:,1)] = iMHEA_IndicesTotal(Date1,P1,Q1,A1);
[Climate(:,2),Indices(:,2)] = iMHEA_IndicesTotal(Date2,P2,Q2,A2);
[~,PM(:,1),IDC1,~,QM(:,1),FDC1,~,~,~,~,CumP1,CumQ1,DP1,DQ1] = iMHEA_Indices(Date1,P1,Q1,A1);
[~,PM(:,2),IDC2,~,QM(:,2),FDC2,~,~,~,~,CumP2,CumQ2,DP2,DQ2] = iMHEA_Indices(Date2,P2,Q2,A2);

%% PLOT PAIR COMPARISON

figure
subplot(3,1,3)
plot(Date1,Q1/A1,'k',Date2,Q2/A2,'r')
xlabel('Date')
ylabel('Discharge (l/s/km2)')
title('Input Discharge')
Xlim1 = get(gca,'XLim');
legend('Streamflow 1','Streamflow 2',...
'Location','NorthWest')
box on

subplot(3,1,1)
hold on
bar(Date1,P1,'k','EdgeColor','k')
xlabel('Date')
ylabel('Precipitation (mm)')
title('Input Precipitation')
Xlim2 = get(gca,'XLim');
legend('Rainfall 1',...
'Location','SouthWest')
box on

subplot(3,1,2)
hold on
bar(Date2,P2,'r','EdgeColor','r')
xlabel('Date')
ylabel('Precipitation (mm)')
title('Input Precipitation')
Xlim3 = get(gca,'XLim');
legend('Rainfall 2',...
'Location','SouthWest')
box on

Xlim = [min([Xlim1(1),Xlim2(1),Xlim3(1)]),max([Xlim1(2),Xlim2(2),Xlim3(2)])];

subplot(3,1,1)
set(gca,'YDir','reverse','XLim',Xlim)
subplot(3,1,2)
set(gca,'YDir','reverse','XLim',Xlim)
subplot(3,1,3)
set(gca,'XLim',Xlim)

figure
subplot(2,1,1)
hold on
plot(CumP1(:,1),CumP1(:,2),'-k',CumP2(:,1),CumP2(:,2),'-r')
plot(CumQ1(:,1),CumQ1(:,2),'--k',CumQ2(:,1),CumQ2(:,2),'--r','LineWidth',1.5)
title('Cumulative comparison')
legend('Rainfall 1','Rainfall 2','Streamflow 1','Streamflow 2',...
'Location','NorthWest')
xlabel('Date')
ylabel('Cumulative variables')
box on

subplot(2,1,2)
hold on
plot(CumP1(:,2),CumQ1(:,2),'-k')
plot(CumP2(:,2),CumQ2(:,2),'--r')
title('Double Mass Plot')
xlabel('Precipitation')
ylabel('Discharge')
legend('Catchment 1','Catchment 2',...
'Location','NorthWest')
box on

figure
semilogx(IDC1(:,1),IDC1(:,2),'-k')
hold on
semilogx(IDC2(:,1),IDC2(:,2),'--r')
xlabel('Duration (min)')
ylabel('Maximum precipitation intensity (mm/h)')
title('Maximum Intensity-Duration Curve')
legend('Catchment 1','Catchment 2')
box on

figure
semilogy(FDC1(:,1),FDC1(:,2),'-k')
hold on
semilogy(FDC2(:,1),FDC2(:,2),'--r')
xlabel('Exceedance probability')
ylabel('Discharge (l/s/km2)')
title('Flow Duration Curve')
legend('Catchment 1','Catchment 2')
box on

figure
subplot(2,1,1)
plot((0:12)',[PM(12,1);PM(:,1)],'-k',(0:12)',[QM(12,1);QM(:,1)],'--k')
xlabel('Date')
ylabel('Variable (mm)')
legend('Precipitation (mm)','Discharge (mm)')
title('Monthly Data')
title('Catchment 1')
box on

subplot(2,1,2)
plot((0:12)',[PM(12,2);PM(:,2)],'-r',(0:12)',[QM(12,2);QM(:,2)],'--r')
xlabel('Date')
ylabel('Variable (mm)')
legend('Precipitation (mm)','Discharge (mm)')
title('Monthly Data')
title('Catchment 2')
box on

dateP1 = datetime(DP1(:,1),'ConvertFrom','datenum');
dateP2 = datetime(DP2(:,1),'ConvertFrom','datenum');
dateQ1 = datetime(DQ1(:,1),'ConvertFrom','datenum');
dateQ2 = datetime(DQ2(:,1),'ConvertFrom','datenum');

figure
subplot(4,1,1)
bar(dateP1,DP1(:,2),'k','EdgeColor','k')
xlabel('Date')
ylabel('Precipitation (mm)')
set(gca,'YDir','reverse','XLim',Xlim);
title('Daily Precipitation in Catchment 1')
legend('Rainfall',...
'Location','South')
box on

subplot(4,1,2)
hold on
plot(dateQ1,DQ1(:,2),dateQ1,DQ1(:,3),dateQ1,DQ1(:,4))
xlabel('Date')
ylabel('Discharge (l/s/km2)')
set(gca,'XLim',Xlim)
legend('Total flow','Baseflow','Stormflow',...
'Location','North')
set(gca,'XLim',Xlim);
title('Daily Discharge in Catchment 1')
box on

subplot(4,1,3)
bar(dateP2,DP2(:,2),'r','EdgeColor','r')
xlabel('Date')
ylabel('Precipitation (mm)')
set(gca,'YDir','reverse','XLim',Xlim);
title('Daily Precipitation in Catchment 2')
legend('Rainfall',...
'Location','South')
box on

subplot(4,1,4)
hold on
plot(dateQ2,DQ2(:,2),dateQ2,DQ2(:,3),dateQ2,DQ2(:,4))
xlabel('Date')
ylabel('Discharge (l/s/km2)')
set(gca,'XLim',Xlim)
legend('Total flow','Baseflow','Stormflow',...
'Location','North')
set(gca,'XLim',Xlim);
title('Daily Discharge in Catchment 2')
box on