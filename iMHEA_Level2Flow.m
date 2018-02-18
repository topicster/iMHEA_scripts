function [HQ] = iMHEA_Level2Flow(WL,WEIR,COEFF,varargin)
%iMHEA Transformation of water levels to discharge.
% [HQ] = iMHEA_Level2Flow(Date,WL,WEIR,CURVE) calculates the corresponding
% streamflows (HQ) for each input water level (WL) using the WEIR
% dimensions and the coefficients specified in COEFF.
%
% Input:
% WL    = Stage [cm].
% WEIR  = Weir dimensions, vector (a, b, c, d) [m].
%         a: V-notch section height. Default: 0.30 m
%         b: Rectangular section width (total width - V-notch width).
% COEFF = Rating curve coefficients, vector (C1, e1, C2, e2) [-].
%         C1: Coefficient of the V-notch section. Default: 1.37
%         e1: Exponential of the V-notch section. Default: 2.5
%         C2: Coefficient of the rectangular section. Default: 1.77
%         e2: Exponential of the rectangular section. Default: 1.5
%         If left empty, default values are used (90-degree V-notch).
% flag  = leave empty NOT to run the data voids assessment and plots.
%
% RATING CURVE EQUATION:
%  V-notch section: HQ = C1*WL^e1
% Compound section: HQ = C1*(WL^e1-(WL-a)^e1) + C2*b*(WL-a)^e2
%
% Output:
% Q     = Discharge [l/s].
%
% Boris Ochoa Tocachi
% Imperial College London
% Created in February, 2018
% Last edited in February, 2018

%% CHECK INPUT DATA
fprintf('Transformation of water levels to streamflows.\n')
fprintf('\n')
% Rating curve coefficients.
if nargin < 3  || isempty(COEFF)
    C1 = 1.37;
    e1 = 2.5;
    C2 = 1.77;
    e2 = 1.5;
else
    C1 = COEFF(1);
    e1 = COEFF(2);
    C2 = COEFF(3);
    e2 = COEFF(4);
end
fprintf('Equation coefficients used: C1=%8.4f, e1=%8.4f, C2=%8.4f, e2=%8.4f.\n',[C1,e1,C2,e2]);
fprintf('RATING CURVE EQUATION\n')
fprintf('V-notch section: HQ = C1*WL^e1\n')
fprintf('Compound section: HQ = C1*(WL^e1-(WL-a)^e1) + C2*b*(WL-a)^e2\n')
fprintf('\n')

% Weir dimensions.
if nargin < 2 || isempty(WEIR)
    a = 0.30; % iMHEA standard.
    b = 1.00; % This is variable, no standard.
    fprintf('Please check the dimensions of the weir that are being used.\n')
else
    a = WEIR(1);
    b = WEIR(2);
end
fprintf('Weir dimensions: V-notch height=%8.4f, Rectangular width=%8.4f.\n',[a,b]);
fprintf('\n')

% It is assumed that at least a water level vector is input.

%% STREAMFLOW CALCULATION
% Apply the equation depending on the water levels.
WL = WL/100; % Transform cm to m
HQ(WL<=a) = C1*WL(WL<=a).^e1;
HQ(WL>a) = C1*(WL(WL>a).^e1-(WL(WL>a)-a).^e1) + C2*b*(WL(WL>a)-a).^e2;
HQ = 1000*HQ; % Transform units to l/s
WL = WL*100; % Re-transform m to cm

%% PLOT THE RESULTS
if nargin > 3
    figure
    subplot(2,1,1)
    plot(WL)
    ylabel('Water level [cm]')
    hold on
    
    subplot(2,1,2)
    plot(HQ)
    ylabel('Streamflow [l/s]')
    hold on
end