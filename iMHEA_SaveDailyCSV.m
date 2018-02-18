function iMHEA_SaveDailyCSV(Data,FilePrefix)
%iMHEA export pair catchment daily data to two csv files.
% iMHEA_SaveDoubleCSV(Data,FilePrefix) exports data in Data to files
% identified by iMHEA_<catchment>_<resolution>_processed> from FilePrefix.
% Daily streamflow data include a baseflow time series.
%
% Input:
% Data        = [Date, P1, Q1, BQ1, P2, Q2, BQ2] at certain temporal resolution.
% File Prefix = In the form of '<site name>_<temporal resolution>'
%
% Output:
% CSV Files with the exported data.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in February, 2018

FileName = fullfile(pwd,['iMHEA_',FilePrefix(1:3),'_01',FilePrefix(4:end),'_processed.csv']);
fid = fopen(FileName, 'w');
if fid == -1, error('Cannot open file for writing: %s', FileName); end
n = length(Data(:,1));
fprintf(fid,'%s,%s,%s,%s\n','Date','Rainfall mm','Flow l/s/km2','Baseflow l/s/km2');
% h = waitbar(0,'Saving CSV file...');
for i = 1:n
    fprintf(fid,'%s,%8.4f,%8.4f,%8.4f\n',datestr(Data(i,1),'dd/mm/yyyy HH:MM:SS'),Data(i,2:4));
    % waitbar(i/n)
end
% close(h);
fclose(fid);
FileName = fullfile(pwd,['iMHEA_',FilePrefix(1:3),'_02',FilePrefix(4:end),'_processed.csv']);
fid = fopen(FileName, 'w');
if fid == -1, error('Cannot open file for writing: %s', FileName); end
fprintf(fid,'%s,%s,%s,%s\n','Date','Rainfall mm','Flow l/s/km2','Baseflow l/s/km2');
% h = waitbar(0,'Saving CSV file...');
for i = 1:n
    fprintf(fid,'%s,%8.4f,%8.4f,%8.4f\n',datestr(Data(i,1),'dd/mm/yyyy HH:MM:SS'),Data(i,5:7));
    % waitbar(i/n)
end
% close(h);
fclose(fid);