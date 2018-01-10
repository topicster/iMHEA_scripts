function iMHEA_SaveSingleCSV(Data,FilePrefix)
%iMHEA export single catchment data to a csv files.
% iMHEA_SaveSingleCSV(Data,FilePrefix) exports data in Data to a file
% identified by iMHEA_<catchment>_<resolution>_processed> from FilePrefix.
%
% Input:
% Data        = [Date, Var] at certain temporal resolution.
% File Prefix = In the form of '<site name>_<temporal resolution>'
%
% Output:
% CSV File with the exported data.
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017

FileName = fullfile(pwd,['iMHEA_',FilePrefix,'_processed.csv']);
fid = fopen(FileName, 'w');
if fid == -1, error('Cannot open file for writing: %s', FileName); end
n = length(Data(:,1));
fprintf(fid,'%s,%s\n','Date','Rainfall mm');
% h = waitbar(0,'Saving CSV file...');
for i = 1:n
    fprintf(fid,'%s,%8.4f\n',datestr(Data(i,1),'dd/mm/yyyy HH:MM:SS'),Data(i,2));
    % waitbar(i/n)
end
% close(h);
fclose(fid);