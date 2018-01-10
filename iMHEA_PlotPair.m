function iMHEA_PlotPair(iMHEA_DataPair)
%iMHEA Plot of paired catchment data.
% iMHEA_Plot2(iMHEA_DataPair)
%
% Input:
% iMHEA_DataPair = [Date, P1, Q1, P2, Q2].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017

%% PLOT

Date1 = datetime(iMHEA_DataPair(:,1),'ConvertFrom','datenum');

subplot(4,4,1:3)
plot(Date1,iMHEA_DataPair(:,2),'LineWidth',1)
hold on
title('Precipitation in catchment 1')
ylabel('[mm]')
grid on
box on
text(0.0125,0.900,'A','Units','normalized','FontWeight','bold','FontSize',14)

subplot(4,4,5:7)
plot(Date1,iMHEA_DataPair(:,4),'r','LineWidth',1)
hold on
title('Precipitation in catchment 2')
ylabel('[mm]')
grid on
box on
text(0.0125,0.900,'B','Units','normalized','FontWeight','bold','FontSize',14)

subplot(4,4,[9:11,13:15])
plot(Date1,iMHEA_DataPair(:,3),'LineWidth',1)
hold on
plot(Date1,iMHEA_DataPair(:,5),'r','LineWidth',1)
title('Streamflow in paired catchments')
ylabel('[l s^{-1} km^{-2}]')
xlabel ('Date')
legend('Catchment 1','Catchment 2')
legend('boxoff')
grid on
box on
text(0.0125,0.950,'C','Units','normalized','FontWeight','bold','FontSize',14)

% Zoom
subplot(4,4,4)
plot(Date1,iMHEA_DataPair(:,2),'LineWidth',1)
hold on
title('Precipitation in catchment 1')
ylabel('[mm]')
grid on
box on
text(0.025,0.900,'D','Units','normalized','FontWeight','bold','FontSize',14)

subplot(4,4,8)
plot(Date1,iMHEA_DataPair(:,4),'r','LineWidth',1)
hold on
title('Precipitation in catchment 2')
ylabel('[mm]')
grid on
box on
text(0.025,0.900,'E','Units','normalized','FontWeight','bold','FontSize',14)

subplot(4,4,[12,16])
plot(Date1,iMHEA_DataPair(:,3),'LineWidth',1)
hold on
plot(Date1,iMHEA_DataPair(:,5),'r','LineWidth',1)
title('Streamflow in paired catchments')
ylabel('[l s^{-1} km^{-2}]')
xlabel ('Date')
legend('Catchment 1','Catchment 2')
legend('boxoff')
grid on
box on
text(0.025,0.950,'F','Units','normalized','FontWeight','bold','FontSize',14)