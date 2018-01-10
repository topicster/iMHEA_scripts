% USE THIS SCRIPT TO PROCESS RAW iMHEA DATA INTO HRES, HOURLY, DAILY DATA
% AND TO CALCULATE HYDROLOGICAL AND CLIMATE INDICES
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in November, 2017
% Last edited in November, 2017

close all

%% INITIALISE COMMON VARIABLES
iMHEA_Indices_Hydro = nan(57,25);
iMHEA_Indices_Climate = nan(13,28);
% Indices from paired catchments (i.e., filling precipitation data)
iMHEA_Indices_Hydro_Pair = nan(57,25);
iMHEA_Indices_Climate_Pair = nan(13,28);

%% LLO LLOA
clc
%% LLO Analyse independent catchments
disp('Processing LLO_01')
% [iMHEA_LLO_01_HI_01_5mDate,iMHEA_LLO_01_HI_01_5mAvg] = iMHEA_Average(iMHEA_LLO_01_HI_01_raw{:,1},iMHEA_LLO_01_HI_01_raw{:,3},5);
% [~,iMHEA_LLO_01_HI_01_5mLvl] = iMHEA_Average(iMHEA_LLO_01_HI_01_raw{:,1},iMHEA_LLO_01_HI_01_raw{:,2},5);
% [iMHEA_LLO_01_DataHRes,iMHEA_LLO_01_Data1day,iMHEA_LLO_01_Data1hr,iMHEA_Indices(:,1),iMHEA_Climate(:,1)] = iMHEA_Workflow(iMHEA_Catchment_AREA{1,2},iMHEA_LLO_01_HI_01_5mDate,iMHEA_LLO_01_HI_01_5mAvg,0.2,iMHEA_LLO_01_PO_01_raw{:,1},iMHEA_LLO_01_PO_01_raw{:,2},iMHEA_LLO_01_PO_02_raw{:,1},iMHEA_LLO_01_PO_02_raw{:,2});
[iMHEA_LLO_01_DataHRes,iMHEA_LLO_01_Data1day,iMHEA_LLO_01_Data1hr,iMHEA_Indices_Hydro(:,1),iMHEA_Indices_Climate(:,1)] = iMHEA_Workflow(iMHEA_Catchment_AREA{1,2},iMHEA_LLO_01_HI_01_raw{:,1},iMHEA_LLO_01_HI_01_raw{:,3},0.2,iMHEA_LLO_01_PO_01_raw{:,1},iMHEA_LLO_01_PO_01_raw{:,2},iMHEA_LLO_01_PO_02_raw{:,1},iMHEA_LLO_01_PO_02_raw{:,2});
disp('Processing LLO_02')
% [iMHEA_LLO_02_HI_01_5mDate,iMHEA_LLO_02_HI_01_5mAvg] = iMHEA_Average(iMHEA_LLO_02_HI_01_raw{:,1},iMHEA_LLO_02_HI_01_raw{:,3},5);
% [~,iMHEA_LLO_02_HI_01_5mLvl] = iMHEA_Average(iMHEA_LLO_02_HI_01_raw{:,1},iMHEA_LLO_02_HI_01_raw{:,2},5);
% [iMHEA_LLO_02_DataHRes,iMHEA_LLO_02_Data1day,iMHEA_LLO_02_Data1hr,iMHEA_Indices(:,2),iMHEA_Climate(:,2)] = iMHEA_Workflow(iMHEA_Catchment_AREA{2,2},iMHEA_LLO_02_HI_01_5mDate,iMHEA_LLO_02_HI_01_5mAvg,0.2,iMHEA_LLO_02_PO_01_raw{:,1},iMHEA_LLO_02_PO_01_raw{:,2},iMHEA_LLO_02_PO_02_raw{:,1},iMHEA_LLO_02_PO_02_raw{:,2});
[iMHEA_LLO_02_DataHRes,iMHEA_LLO_02_Data1day,iMHEA_LLO_02_Data1hr,iMHEA_Indices_Hydro(:,2),iMHEA_Indices_Climate(:,2)] = iMHEA_Workflow(iMHEA_Catchment_AREA{2,2},iMHEA_LLO_02_HI_01_raw{:,1},iMHEA_LLO_02_HI_01_raw{:,3},0.2,iMHEA_LLO_02_PO_01_raw{:,1},iMHEA_LLO_02_PO_01_raw{:,2},iMHEA_LLO_02_PO_02_raw{:,1},iMHEA_LLO_02_PO_02_raw{:,2});
%% LLO Analyse Paired catchments
disp('Processing LLO pair catchments')
[iMHEA_LLO_Pair_DataHRes,iMHEA_LLO_Pair_Data1day,iMHEA_LLO_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[1,2]),iMHEA_Indices_Climate_Pair(:,[1,2])] = iMHEA_WorkflowPair(iMHEA_LLO_01_DataHRes,iMHEA_LLO_02_DataHRes);
%% LLO Write csv files
disp('Saving CSV Data of LLO catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_LLO_Pair_DataHRes,'LLO_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_LLO_Pair_Data1day,'LLO_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_LLO_Pair_Data1hr,'LLO_1hr')

%% JTU Jatunhuayco
clc
%% JTU Analyse independent catchments
disp('Processing JTU_01')
[iMHEA_JTU_01_DataHRes,iMHEA_JTU_01_Data1day,iMHEA_JTU_01_Data1hr,iMHEA_Indices_Hydro(:,3),iMHEA_Indices_Climate(:,3)] = iMHEA_Workflow(iMHEA_Catchment_AREA{3,2},iMHEA_JTU_01_HI_01_raw{:,1},iMHEA_JTU_01_HI_01_raw{:,3},0.1,iMHEA_JTU_01_PT_01_raw{:,1},iMHEA_JTU_01_PT_01_raw{:,2},iMHEA_JTU_01_PT_02_raw{:,1},iMHEA_JTU_01_PT_02_raw{:,2});
disp('Processing JTU_02')
[iMHEA_JTU_02_DataHRes,iMHEA_JTU_02_Data1day,iMHEA_JTU_02_Data1hr,iMHEA_Indices_Hydro(:,4),iMHEA_Indices_Climate(:,4)] = iMHEA_Workflow(iMHEA_Catchment_AREA{4,2},iMHEA_JTU_02_HI_01_raw{:,1},iMHEA_JTU_02_HI_01_raw{:,3},0.1,iMHEA_JTU_02_PT_01_raw{:,1},iMHEA_JTU_02_PT_01_raw{:,2},iMHEA_JTU_02_PT_02_raw{:,1},iMHEA_JTU_02_PT_02_raw{:,2});
disp('Processing JTU_03')
[iMHEA_JTU_03_DataHRes,iMHEA_JTU_03_Data1day,iMHEA_JTU_03_Data1hr,iMHEA_Indices_Hydro(:,5),iMHEA_Indices_Climate(:,5)] = iMHEA_Workflow(iMHEA_Catchment_AREA{5,2},iMHEA_JTU_03_HI_01_raw{:,1},iMHEA_JTU_03_HI_01_raw{:,3},0.1,iMHEA_JTU_03_PT_01_raw{:,1},iMHEA_JTU_03_PT_01_raw{:,2},iMHEA_JTU_03_PT_02_raw{:,1},iMHEA_JTU_03_PT_02_raw{:,2});
disp('Processing JTU_04')
[iMHEA_JTU_04_DataHRes,iMHEA_JTU_04_Data1day,iMHEA_JTU_04_Data1hr,iMHEA_Indices_Hydro(:,6),iMHEA_Indices_Climate(:,6)] = iMHEA_Workflow(iMHEA_Catchment_AREA{6,2},iMHEA_JTU_04_HI_01_raw{:,1},iMHEA_JTU_04_HI_01_raw{:,3},0.1,iMHEA_JTU_01_PT_01_raw{:,1},iMHEA_JTU_01_PT_01_raw{:,2},iMHEA_JTU_01_PT_02_raw{:,1},iMHEA_JTU_01_PT_02_raw{:,2},iMHEA_JTU_02_PT_01_raw{:,1},iMHEA_JTU_02_PT_01_raw{:,2},iMHEA_JTU_02_PT_02_raw{:,1},iMHEA_JTU_02_PT_02_raw{:,2},iMHEA_JTU_03_PT_01_raw{:,1},iMHEA_JTU_03_PT_01_raw{:,2},iMHEA_JTU_03_PT_02_raw{:,1},iMHEA_JTU_03_PT_02_raw{:,2},iMHEA_JTU_04_PT_01_raw{:,1},iMHEA_JTU_04_PT_01_raw{:,2},iMHEA_JTU_04_PT_02_raw{:,1},iMHEA_JTU_04_PT_02_raw{:,2});
%% JTU Analyse Paired catchments
disp('Processing JTU pair catchments 0102')
[iMHEA_JTU_Pair1_DataHRes] = iMHEA_WorkflowPair(iMHEA_JTU_01_DataHRes,iMHEA_JTU_02_DataHRes);
disp('Processing JTU pair catchments 0304')
[iMHEA_JTU_Pair2_DataHRes] = iMHEA_WorkflowPair(iMHEA_JTU_03_DataHRes,iMHEA_JTU_04_DataHRes);
disp('Processing JTU pair catchments 0203')
[iMHEA_JTU_Pair3_DataHRes] = iMHEA_WorkflowPair(iMHEA_JTU_Pair1_DataHRes(:,[1,4,5]),iMHEA_JTU_Pair2_DataHRes(:,[1,2,3]));
disp('Processing JTU pair catchments 0103')
[iMHEA_JTU_Pair4_DataHRes] = iMHEA_WorkflowPair(iMHEA_JTU_Pair1_DataHRes(:,[1,2,3]),iMHEA_JTU_Pair3_DataHRes(:,[1,4,5]));
disp('Re Processing JTU pair catchments 0102')
[iMHEA_JTU_Pair1_DataHRes,iMHEA_JTU_Pair1_Data1day,iMHEA_JTU_Pair1_Data1hr,iMHEA_Indices_Hydro_Pair(:,[3,4]),iMHEA_Indices_Climate_Pair(:,[3,4])] = iMHEA_WorkflowPair(iMHEA_JTU_Pair4_DataHRes(:,[1,2,3]),iMHEA_JTU_Pair3_DataHRes(:,[1,2,3]));
disp('Re Processing JTU pair catchments 0304')
[iMHEA_JTU_Pair2_DataHRes,iMHEA_JTU_Pair2_Data1day,iMHEA_JTU_Pair2_Data1hr,iMHEA_Indices_Hydro_Pair(:,[5,6]),iMHEA_Indices_Climate_Pair(:,[5,6])] = iMHEA_WorkflowPair(iMHEA_JTU_Pair4_DataHRes(:,[1,4,5]),iMHEA_JTU_Pair2_DataHRes(:,[1,4,5]));
clear iMHEA_JTU_Pair3_DataHRes iMHEA_JTU_Pair4_DataHRes
%% JTU Write csv files
disp('Saving CSV Data of JTU catchments 0102')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair1_DataHRes,'JTU_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair1_Data1day,'JTU_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair1_Data1hr,'JTU_1hr')

disp('Saving CSV Data of JTU catchments 0304')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair2_DataHRes,'JTU_HRes_0304')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair2_Data1day,'JTU_1day_0304')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_JTU_Pair2_Data1hr,'JTU_1hr_0304')

%% PAU
clc
%% PAU Analyse independent catchments
disp('Processing PAU_01')
[iMHEA_PAU_01_DataHRes,iMHEA_PAU_01_Data1day,iMHEA_PAU_01_Data1hr,iMHEA_Indices_Hydro(:,7),iMHEA_Indices_Climate(:,7)] = iMHEA_Workflow(iMHEA_Catchment_AREA{7,2},iMHEA_PAU_01_HW_01_raw{:,1},iMHEA_PAU_01_HW_01_raw{:,2},0.2,iMHEA_PAU_01_PD_01_raw{:,1},iMHEA_PAU_01_PD_01_raw{:,2},iMHEA_PAU_01_PD_02_raw{:,1},iMHEA_PAU_01_PD_02_raw{:,2},iMHEA_PAU_01_PD_03_raw{:,1},iMHEA_PAU_01_PD_03_raw{:,2});
disp('Processing PAU_02')
[iMHEA_PAU_02_DataHRes,iMHEA_PAU_02_Data1day,iMHEA_PAU_02_Data1hr,iMHEA_Indices_Hydro(:,8),iMHEA_Indices_Climate(:,8)] = iMHEA_Workflow(iMHEA_Catchment_AREA{8,2},iMHEA_PAU_02_HW_01_raw{:,1},iMHEA_PAU_02_HW_01_raw{:,2},0.254,iMHEA_PAU_02_PD_01_raw{:,1},iMHEA_PAU_02_PD_01_raw{:,2},iMHEA_PAU_02_PD_02_raw{:,1},iMHEA_PAU_02_PD_02_raw{:,2});
disp('Processing PAU_03')
[iMHEA_PAU_03_DataHRes,iMHEA_PAU_03_Data1day,iMHEA_PAU_03_Data1hr,iMHEA_Indices_Hydro(:,9),iMHEA_Indices_Climate(:,9)] = iMHEA_Workflow(iMHEA_Catchment_AREA{9,2},iMHEA_PAU_03_HW_01_raw{:,1},iMHEA_PAU_03_HW_01_raw{:,2},0.254,iMHEA_PAU_03_PD_01_raw{:,1},iMHEA_PAU_03_PD_01_raw{:,2},iMHEA_PAU_03_PD_02_raw{:,1},iMHEA_PAU_03_PD_02_raw{:,2});
disp('Processing PAU_04')
[iMHEA_PAU_04_DataHRes,iMHEA_PAU_04_Data1day,iMHEA_PAU_04_Data1hr,iMHEA_Indices_Hydro(:,10),iMHEA_Indices_Climate(:,10)] = iMHEA_Workflow(iMHEA_Catchment_AREA{10,2},iMHEA_PAU_04_HW_01_raw{:,1},iMHEA_PAU_04_HW_01_raw{:,2},0.2,iMHEA_PAU_04_PD_01_raw{:,1},iMHEA_PAU_04_PD_01_raw{:,2},iMHEA_PAU_04_PD_02_raw{:,1},iMHEA_PAU_04_PD_02_raw{:,2},iMHEA_PAU_04_PD_03_raw{:,1},iMHEA_PAU_04_PD_03_raw{:,2});
disp('Processing PAU_05')
[iMHEA_PAU_05_DataHRes,iMHEA_PAU_05_Data1day,iMHEA_PAU_05_Data1hr,iMHEA_Indices_Climate(:,11)] = iMHEA_WorkflowRain(0.2,iMHEA_PAU_05_PD_01_raw{:,1},iMHEA_PAU_05_PD_01_raw{:,2},iMHEA_PAU_05_PD_02_raw{:,1},iMHEA_PAU_05_PD_02_raw{:,2},iMHEA_PAU_05_PD_03_raw{:,1},iMHEA_PAU_05_PD_03_raw{:,2});
%% PAU Analyse Paired catchments
disp('Processing PAU pair catchments 0104')
[iMHEA_PAU_Pair1_DataHRes,iMHEA_PAU_Pair1_Data1day,iMHEA_PAU_Pair1_Data1hr,iMHEA_Indices_Hydro_Pair(:,[7,10]),iMHEA_Indices_Climate_Pair(:,[7,10])] = iMHEA_WorkflowPair(iMHEA_PAU_01_DataHRes,iMHEA_PAU_04_DataHRes);
disp('Processing PAU pair catchments 0203')
[iMHEA_PAU_Pair2_DataHRes,iMHEA_PAU_Pair2_Data1day,iMHEA_PAU_Pair2_Data1hr,iMHEA_Indices_Hydro_Pair(:,[8,9]),iMHEA_Indices_Climate_Pair(:,[8,9])] = iMHEA_WorkflowPair(iMHEA_PAU_02_DataHRes,iMHEA_PAU_03_DataHRes);
disp('Assigning PAU catchments 05')
iMHEA_Indices_Climate_Pair(:,11) = iMHEA_Indices_Climate(:,11);
%% PAU Write csv files
disp('Saving CSV Data of PAU catchments 0104')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair1_DataHRes,'PAU_HRes_0104')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair1_Data1day,'PAU_1day_0104')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair1_Data1hr,'PAU_1hr_0104')

disp('Saving CSV Data of PAU catchments 0203')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair2_DataHRes,'PAU_HRes_0203')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair2_Data1day,'PAU_1day_0203')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_PAU_Pair2_Data1hr,'PAU_1hr_0203')

disp('Saving CSV Data of PAU catchment 05')
% Max resolution
iMHEA_SaveSingleCSV(iMHEA_PAU_05_DataHRes,'PAU_05_HRes')
% Daily
iMHEA_SaveSingleCSV(iMHEA_PAU_05_Data1day,'PAU_05_1day')
% Hourly
iMHEA_SaveSingleCSV(iMHEA_PAU_05_Data1hr,'PAU_05_1hr')

%% PIU Piura
clc
%% PIU Analyse independent catchments
disp('Processing PIU_01')
[iMHEA_PIU_01_DataHRes,iMHEA_PIU_01_Data1day,iMHEA_PIU_01_Data1hr,iMHEA_Indices_Hydro(:,11),iMHEA_Indices_Climate(:,12)] = iMHEA_Workflow(iMHEA_Catchment_AREA{11,2},iMHEA_PIU_01_HI_01_raw{:,1},iMHEA_PIU_01_HI_01_raw{:,3},0.2,iMHEA_PIU_01_PO_01_raw{:,1},iMHEA_PIU_01_PO_01_raw{:,2},iMHEA_PIU_01_PO_02_raw{:,1},iMHEA_PIU_01_PO_02_raw{:,2},iMHEA_PIU_01_PO_03_raw{:,1},iMHEA_PIU_01_PO_03_raw{:,2});
disp('Processing PIU_02')
[iMHEA_PIU_02_DataHRes,iMHEA_PIU_02_Data1day,iMHEA_PIU_02_Data1hr,iMHEA_Indices_Hydro(:,12),iMHEA_Indices_Climate(:,13)] = iMHEA_Workflow(iMHEA_Catchment_AREA{12,2},iMHEA_PIU_02_HI_01_raw{:,1},iMHEA_PIU_02_HI_01_raw{:,3},0.2,iMHEA_PIU_02_PO_01_raw{:,1},iMHEA_PIU_02_PO_01_raw{:,2},iMHEA_PIU_02_PO_02_raw{:,1},iMHEA_PIU_02_PO_02_raw{:,2},iMHEA_PIU_02_PO_03_raw{:,1},iMHEA_PIU_02_PO_03_raw{:,2},iMHEA_PIU_02_PO_04_raw{:,1},iMHEA_PIU_02_PO_04_raw{:,2});
disp('Processing PIU_03')
[iMHEA_PIU_03_DataHRes,iMHEA_PIU_03_Data1day,iMHEA_PIU_03_Data1hr,iMHEA_Indices_Hydro(:,13),iMHEA_Indices_Climate(:,14)] = iMHEA_Workflow(iMHEA_Catchment_AREA{13,2},iMHEA_PIU_03_HI_01_raw{:,1},iMHEA_PIU_03_HI_01_raw{:,3},0.2,iMHEA_PIU_03_PO_01_raw{:,1},iMHEA_PIU_03_PO_01_raw{:,2},iMHEA_PIU_03_PO_02_raw{:,1},iMHEA_PIU_03_PO_02_raw{:,2},iMHEA_PIU_03_PO_03_raw{:,1},iMHEA_PIU_03_PO_03_raw{:,2},iMHEA_PIU_03_PO_04_raw{:,1},iMHEA_PIU_03_PO_04_raw{:,2});
disp('Processing PIU_04')
[iMHEA_PIU_04_DataHRes,iMHEA_PIU_04_Data1day,iMHEA_PIU_04_Data1hr,iMHEA_Indices_Hydro(:,14),iMHEA_Indices_Climate(:,15)] = iMHEA_Workflow(iMHEA_Catchment_AREA{14,2},iMHEA_PIU_04_HI_01_raw{:,1},iMHEA_PIU_04_HI_01_raw{:,3},0.2,iMHEA_PIU_04_PO_01_raw{:,1},iMHEA_PIU_04_PO_01_raw{:,2},iMHEA_PIU_04_PO_02_raw{:,1},iMHEA_PIU_04_PO_02_raw{:,2},iMHEA_PIU_04_PO_03_raw{:,1},iMHEA_PIU_04_PO_03_raw{:,2});
disp('Processing PIU_05')
[iMHEA_PIU_05_DataHRes,~,~,iMHEA_Indices_Climate(:,16)] = iMHEA_WorkflowRain(0.2,iMHEA_PIU_05_PO_01_raw{:,1},iMHEA_PIU_05_PO_01_raw{:,2});
disp('Processing PIU_06')
[iMHEA_PIU_06_DataHRes,~,~,iMHEA_Indices_Climate(:,17)] = iMHEA_WorkflowRain(0.2,iMHEA_PIU_06_PO_01_raw{:,1},iMHEA_PIU_06_PO_01_raw{:,2},iMHEA_PIU_06_PO_02_raw{:,1},iMHEA_PIU_06_PO_02_raw{:,2},iMHEA_PIU_06_PO_03_raw{:,1},iMHEA_PIU_06_PO_03_raw{:,2});
disp('Processing PIU_07')
[iMHEA_PIU_07_DataHRes,iMHEA_PIU_07_Data1day,iMHEA_PIU_07_Data1hr,iMHEA_Indices_Hydro(:,15),iMHEA_Indices_Climate(:,18)] = iMHEA_Workflow(iMHEA_Catchment_AREA{15,2},iMHEA_PIU_07_HI_01_raw{:,1},iMHEA_PIU_07_HI_01_raw{:,3},0.2,iMHEA_PIU_07_PO_02_raw{:,1},iMHEA_PIU_07_PO_02_raw{:,2},iMHEA_PIU_07_PO_03_raw{:,1},iMHEA_PIU_07_PO_03_raw{:,2});
%% PIU Analyse Paired catchments
disp('Processing PIU pair catchments 0102')
[iMHEA_PIU_Pair1_DataHRes,iMHEA_PIU_Pair1_Data1day,iMHEA_PIU_Pair1_Data1hr,iMHEA_Indices_Hydro_Pair(:,[11,12]),iMHEA_Indices_Climate_Pair(:,[12,13])] = iMHEA_WorkflowPair(iMHEA_PIU_01_DataHRes,iMHEA_PIU_02_DataHRes);
disp('Processing PIU pair catchments 0304')
[iMHEA_PIU_Pair2_DataHRes,iMHEA_PIU_Pair2_Data1day,iMHEA_PIU_Pair2_Data1hr,iMHEA_Indices_Hydro_Pair(:,[13,14]),iMHEA_Indices_Climate_Pair(:,[14,15])] = iMHEA_WorkflowPair(iMHEA_PIU_03_DataHRes,iMHEA_PIU_04_DataHRes);
disp('Processing PIU pair catchments 0407')
[iMHEA_PIU_Pair3_DataHRes,iMHEA_PIU_Pair3_Data1day,iMHEA_PIU_Pair3_Data1hr,iMHEA_Indices_PairAux,iMHEA_Climate_PairAux] = iMHEA_WorkflowPair(iMHEA_PIU_Pair2_DataHRes(:,[1,4,5]),iMHEA_PIU_07_DataHRes);
disp('Assigning PIU catchments 07')
iMHEA_Indices_Hydro_Pair(:,15) = iMHEA_Indices_PairAux(:,2);
iMHEA_Indices_Climate_Pair(:,18) = iMHEA_Climate_PairAux(:,2);
disp('Processing PIU pair catchments 0506')
[iMHEA_PIU_Pair4_DataHRes] = iMHEA_FillGaps(iMHEA_PIU_05_DataHRes(:,1),iMHEA_PIU_05_DataHRes(:,2),iMHEA_PIU_06_DataHRes(:,1),iMHEA_PIU_06_DataHRes(:,2),0,1);
disp('Processing PIU_05')
[iMHEA_PIU_05_DataHRes,iMHEA_PIU_05_Data1day,iMHEA_PIU_05_Data1hr,iMHEA_Indices_Climate_Pair(:,16)] = iMHEA_WorkflowRain(0.2,iMHEA_PIU_Pair4_DataHRes(:,1),iMHEA_PIU_Pair4_DataHRes(:,2));
disp('Processing PIU_06')
[iMHEA_PIU_06_DataHRes,iMHEA_PIU_06_Data1day,iMHEA_PIU_06_Data1hr,iMHEA_Indices_Climate_Pair(:,17)] = iMHEA_WorkflowRain(0.2,iMHEA_PIU_Pair4_DataHRes(:,1),iMHEA_PIU_Pair4_DataHRes(:,3));
clear iMHEA_Indices_PairAux iMHEA_Climate_PairAux
%% PIU Write csv files
disp('Saving CSV Data of PIU catchments 0102')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair1_DataHRes,'PIU_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair1_Data1day,'PIU_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair1_Data1hr,'PIU_1hr')

disp('Saving CSV Data of PIU catchments 0304')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair2_DataHRes,'PIU_HRes_0304')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair2_Data1day,'PIU_1day_0304')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair2_Data1hr,'PIU_1hr_0304')

disp('Saving CSV Data of PIU catchment 05')
% Max resolution
iMHEA_SaveSingleCSV(iMHEA_PIU_05_DataHRes,'PIU_05_HRes')
% Daily
iMHEA_SaveSingleCSV(iMHEA_PIU_05_Data1day,'PIU_05_1day')
% Hourly
iMHEA_SaveSingleCSV(iMHEA_PIU_05_Data1hr,'PIU_05_1hr')

disp('Saving CSV Data of PIU catchment 06')
% Max resolution
iMHEA_SaveSingleCSV(iMHEA_PIU_06_DataHRes,'PIU_06_HRes')
% Daily
iMHEA_SaveSingleCSV(iMHEA_PIU_06_Data1day,'PIU_06_1day')
% Hourly
iMHEA_SaveSingleCSV(iMHEA_PIU_06_Data1hr,'PIU_06_1hr')

disp('Saving CSV Data of PIU catchments 0407')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair3_DataHRes,'PIU_HRes_0407')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair3_Data1day,'PIU_1day_0407')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_PIU_Pair3_Data1hr,'PIU_1hr_0407')

%% CHA
clc
%% CHA Analyse independent catchments
disp('Processing CHA_01')
[iMHEA_CHA_01_DataHRes,iMHEA_CHA_01_Data1day,iMHEA_CHA_01_Data1hr,iMHEA_Indices_Hydro(:,16),iMHEA_Indices_Climate(:,19)] = iMHEA_Workflow(iMHEA_Catchment_AREA{16,2},iMHEA_CHA_01_HS_01_raw{:,1},iMHEA_CHA_01_HS_01_raw{:,3},0.1,iMHEA_CHA_01_PT_01_raw{:,1},iMHEA_CHA_01_PT_01_raw{:,2});
disp('Processing CHA_02')
[iMHEA_CHA_02_DataHRes,iMHEA_CHA_02_Data1day,iMHEA_CHA_02_Data1hr,iMHEA_Indices_Hydro(:,17),iMHEA_Indices_Climate(:,20)] = iMHEA_Workflow(iMHEA_Catchment_AREA{17,2},iMHEA_CHA_02_HS_01_raw{:,1},iMHEA_CHA_02_HS_01_raw{:,3},0.1,iMHEA_CHA_02_PT_01_raw{:,1},iMHEA_CHA_02_PT_01_raw{:,2});
%% CHA Analyse Paired catchments
disp('Processing CHA pair catchment')
[iMHEA_CHA_Pair_DataHRes,iMHEA_CHA_Pair_Data1day,iMHEA_CHA_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[16,17]),iMHEA_Indices_Climate_Pair(:,[19,20])] = iMHEA_WorkflowPair(iMHEA_CHA_01_DataHRes,iMHEA_CHA_02_DataHRes);
%% CHA Write csv files
disp('Saving CSV Data of CHA catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_CHA_Pair_DataHRes,'CHA_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_CHA_Pair_Data1day,'CHA_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_CHA_Pair_Data1hr,'CHA_1hr')

%% HUA Huaraz
clc
%% HUA Analyse independent catchments
disp('Processing HUA_01')
[iMHEA_HUA_01_DataHRes,iMHEA_HUA_01_Data1day,iMHEA_HUA_01_Data1hr,iMHEA_Indices_Hydro(:,18),iMHEA_Indices_Climate(:,21)] = iMHEA_Workflow(iMHEA_Catchment_AREA{18,2},[iMHEA_HUA_01_HD_01_raw{:,1};iMHEA_HUA_01_HD_02_raw{:,1}],[iMHEA_HUA_01_HD_01_raw{:,3};iMHEA_HUA_01_HD_02_raw{:,3}],0.2,iMHEA_HUA_01_PD_01_raw{:,1},iMHEA_HUA_01_PD_01_raw{:,2},iMHEA_HUA_01_PD_02_raw{:,1},iMHEA_HUA_01_PD_02_raw{:,2},iMHEA_HUA_01_PD_03_raw{:,1},iMHEA_HUA_01_PD_03_raw{:,2});
disp('Processing HUA_02')
[iMHEA_HUA_02_DataHRes,iMHEA_HUA_02_Data1day,iMHEA_HUA_02_Data1hr,iMHEA_Indices_Hydro(:,19),iMHEA_Indices_Climate(:,22)] = iMHEA_Workflow(iMHEA_Catchment_AREA{19,2},[iMHEA_HUA_02_HD_01_raw{:,1};iMHEA_HUA_02_HD_02_raw{:,1}],[iMHEA_HUA_02_HD_01_raw{:,3};iMHEA_HUA_02_HD_02_raw{:,3}],0.2,iMHEA_HUA_02_PD_01_raw{:,1},iMHEA_HUA_02_PD_01_raw{:,2},iMHEA_HUA_02_PD_02_raw{:,1},iMHEA_HUA_02_PD_02_raw{:,2},iMHEA_HUA_02_PD_03_raw{:,1},iMHEA_HUA_02_PD_03_raw{:,2});
%% HUA Analyse Paired catchments
disp('Processing HUA pair catchments')
[iMHEA_HUA_Pair_DataHRes,iMHEA_HUA_Pair_Data1day,iMHEA_HUA_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[18,19]),iMHEA_Indices_Climate_Pair(:,[21,22])] = iMHEA_WorkflowPair(iMHEA_HUA_01_DataHRes,iMHEA_HUA_02_DataHRes);
%% HUA Write csv files
disp('Saving CSV Data of HUA catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_HUA_Pair_DataHRes,'HUA_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_HUA_Pair_Data1day,'HUA_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_HUA_Pair_Data1hr,'HUA_1hr')

%% HMT Huamantanga
clc
%% HMT Analyse independent catchments
disp('Processing HMT_01')
[iMHEA_HMT_01_DataHRes,iMHEA_HMT_01_Data1day,iMHEA_HMT_01_Data1hr,iMHEA_Indices_Hydro(:,20),iMHEA_Indices_Climate(:,23)] = iMHEA_Workflow(iMHEA_Catchment_AREA{20,2},iMHEA_HMT_01_HI_01_raw{:,1},iMHEA_HMT_01_HI_01_raw{:,3},0.2,iMHEA_HMT_01_PO_01_raw{:,1},iMHEA_HMT_01_PO_01_raw{:,2},iMHEA_HMT_01_PO_02_raw{:,1},iMHEA_HMT_01_PO_02_raw{:,2});
disp('Processing HMT_02')
[iMHEA_HMT_02_DataHRes,iMHEA_HMT_02_Data1day,iMHEA_HMT_02_Data1hr,iMHEA_Indices_Hydro(:,21),iMHEA_Indices_Climate(:,24)] = iMHEA_Workflow(iMHEA_Catchment_AREA{21,2},iMHEA_HMT_02_HI_01_raw{:,1},iMHEA_HMT_02_HI_01_raw{:,3},0.2,iMHEA_HMT_02_PO_01_raw{:,1},iMHEA_HMT_02_PO_01_raw{:,2},iMHEA_HMT_02_PO_02_raw{:,1},iMHEA_HMT_02_PO_02_raw{:,2});
%% HMT Analyse Paired catchments
disp('Processing HMT pair catchments')
[iMHEA_HMT_Pair_DataHRes,iMHEA_HMT_Pair_Data1day,iMHEA_HMT_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[20,21]),iMHEA_Indices_Climate_Pair(:,[23,24])] = iMHEA_WorkflowPair(iMHEA_HMT_01_DataHRes,iMHEA_HMT_02_DataHRes);
%% HMT Write csv files
disp('Saving CSV Data of HMT catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_HMT_Pair_DataHRes,'HMT_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_HMT_Pair_Data1day,'HMT_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_HMT_Pair_Data1hr,'HMT_1hr')

%% TAM Tambobamba
clc
%% TAM Analyse independent catchments
disp('Processing TAM_01')
[iMHEA_TAM_01_DataHRes,iMHEA_TAM_01_Data1day,iMHEA_TAM_01_Data1hr,iMHEA_Indices_Hydro(:,22),iMHEA_Indices_Climate(:,25)] = iMHEA_Workflow(iMHEA_Catchment_AREA{22,2},iMHEA_TAM_01_HO_01_raw{:,1},iMHEA_TAM_01_HO_01_raw{:,3},0.2,iMHEA_TAM_01_PO_01_raw{:,1},iMHEA_TAM_01_PO_01_raw{:,2},iMHEA_TAM_01_PO_02_raw{:,1},iMHEA_TAM_01_PO_02_raw{:,2},iMHEA_TAM_01_PO_03_raw{:,1},iMHEA_TAM_01_PO_03_raw{:,2});
disp('Processing TAM_02')
[iMHEA_TAM_02_DataHRes,iMHEA_TAM_02_Data1day,iMHEA_TAM_02_Data1hr,iMHEA_Indices_Hydro(:,23),iMHEA_Indices_Climate(:,26)] = iMHEA_Workflow(iMHEA_Catchment_AREA{23,2},iMHEA_TAM_02_HO_01_raw{:,1},iMHEA_TAM_02_HO_01_raw{:,3},0.2,iMHEA_TAM_02_PO_01_raw{:,1},iMHEA_TAM_02_PO_01_raw{:,2},iMHEA_TAM_02_PO_02_raw{:,1},iMHEA_TAM_02_PO_02_raw{:,2},iMHEA_TAM_02_PO_03_raw{:,1},iMHEA_TAM_02_PO_03_raw{:,2});
%% TAM Analyse Paired catchments
disp('Processing TAM pair catchments')
[iMHEA_TAM_Pair_DataHRes,iMHEA_TAM_Pair_Data1day,iMHEA_TAM_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[22,23]),iMHEA_Indices_Climate_Pair(:,[25,26])] = iMHEA_WorkflowPair(iMHEA_TAM_01_DataHRes,iMHEA_TAM_02_DataHRes);
%% TAM Write csv files
disp('Saving CSV Data of TAM catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_TAM_Pair_DataHRes,'TAM_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_TAM_Pair_Data1day,'TAM_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_TAM_Pair_Data1hr,'TAM_1hr')

%% TIQ Tiquipaya
clc
%% TIQ Analyse independent catchments
disp('Processing TIQ_01')
[iMHEA_TIQ_01_DataHRes,iMHEA_TIQ_01_Data1day,iMHEA_TIQ_01_Data1hr,iMHEA_Indices_Hydro(:,24),iMHEA_Indices_Climate(:,27)] = iMHEA_Workflow(iMHEA_Catchment_AREA{24,2},iMHEA_TIQ_01_HD_01_raw{:,1},iMHEA_TIQ_01_HD_01_raw{:,3},0.2,iMHEA_TIQ_01_PO_01_raw{:,1},iMHEA_TIQ_01_PO_01_raw{:,2},iMHEA_TIQ_01_PO_02_raw{:,1},iMHEA_TIQ_01_PO_02_raw{:,2});
disp('Processing TIQ_02')
[iMHEA_TIQ_02_DataHRes,iMHEA_TIQ_02_Data1day,iMHEA_TIQ_02_Data1hr,iMHEA_Indices_Hydro(:,25),iMHEA_Indices_Climate(:,28)] = iMHEA_Workflow(iMHEA_Catchment_AREA{25,2},iMHEA_TIQ_02_HD_01_raw{:,1},iMHEA_TIQ_02_HD_01_raw{:,3},0.2,iMHEA_TIQ_02_PO_01_raw{:,1},iMHEA_TIQ_02_PO_01_raw{:,2},iMHEA_TIQ_02_PO_02_raw{:,1},iMHEA_TIQ_02_PO_02_raw{:,2});
%% TIQ Analyse Paired catchments
disp('Processing TIQ pair catchments')
[iMHEA_TIQ_Pair_DataHRes,iMHEA_TIQ_Pair_Data1day,iMHEA_TIQ_Pair_Data1hr,iMHEA_Indices_Hydro_Pair(:,[24,25]),iMHEA_Indices_Climate_Pair(:,[27,28])] = iMHEA_WorkflowPair(iMHEA_TIQ_01_DataHRes,iMHEA_TIQ_02_DataHRes);
%% TIQ Write csv files
disp('Saving CSV Data of TIQ catchments')
% Max resolution
iMHEA_SaveDoubleCSV(iMHEA_TIQ_Pair_DataHRes,'TIQ_HRes')
% Daily
iMHEA_SaveDoubleCSV(iMHEA_TIQ_Pair_Data1day,'TIQ_1day')
% Hourly
iMHEA_SaveDoubleCSV(iMHEA_TIQ_Pair_Data1hr,'TIQ_1hr')

%% EXPORT HYDROLOGICAL AND CLIMATE INDICES