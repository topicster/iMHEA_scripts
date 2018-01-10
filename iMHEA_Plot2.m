function iMHEA_Plot2(Date1,P1,Date2,P2,Date3,P3)
%iMHEA Plot of rainfall-runoff data.
% iMHEA_Plot2(Date1,P1,Date2,P2,Date3,P3)
%
% Input:
% Date = dd/mm/yyyy hh:mm:ss [date format].
% P = Variable: Precipitation [mm] or Discharge [l/s, m3/s, mm].
%
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in May, 2014
% Last edited in November, 2017

%% PLOT

figure
subplot(3,1,1)
plot(Date1,P1)
ylabel(inputname(2))
Xlim1 = get(gca,'XLim');

subplot(3,1,2)
plot(Date2,P2)
ylabel(inputname(4))
Xlim2 = get(gca,'XLim');

subplot(3,1,3)
plot(Date3,P3)
ylabel(inputname(6))
Xlim3 = get(gca,'XLim');

Xlim = [min([Xlim1(1),Xlim2(1),Xlim3(1)]),max([Xlim1(2),Xlim2(2),Xlim3(2)])];
for i = 1:3
    subplot(3,1,i)
    set(gca,'XLim',Xlim)
    grid on
    box on
end