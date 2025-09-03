clc; 
clear; close all;

%Reading data of the bode plot exported from PLECS
data = readmatrix('Buck_Boost_Voltage_Loop_New.csv');

%Saving data of the bode plot exported from PLECS into mat-file
save('Buck_Boost_Voltage_Loop_New.mat', 'data');

% Extract frequency, magnitude, and phase
freq = data(:,1);           % Hz or rad/s
mag = data(:,2);            % Linear magnitude (or convert from dB)
phase = data(:,3);          % Degrees

mag = 10.^(mag/20);

freq_rad = 2*pi*freq;

% Construct the Transfer function
resp = mag .* exp(1j * deg2rad(phase));
plant_frd = frd(resp, freq_rad);   % Use freq_rad here

n_poles = 2;   % Adjust based on system
n_zeros = 1;
plant_tf = tfest(plant_frd, n_poles, n_zeros);

disp('Plant Transfer Function G(s):');
plant_tf

% Plot Bode Diagram
figure;
bode(plant_tf);
grid on;
title('Bode Plot of Plant G(s) = 1 / [22μH·s·(1 + 0.001s)]');

% Launch SISO Design Tool
sisotool(plant_tf);