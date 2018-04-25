%% Initial data generation
clc; clear;close all
Path = ('F:\data\software\program\20171122');  % folder location
filemane='ref.tif'; % file mane
frame_rate=20.4; % frame rate
% FileGeneration(Path,filemane,frame_rate);
%% Reference image generation
RefGeneration(Path)
%% ROI detection
ROIThreshold=0.03; % sensitive of ROI
ROIGeneration(Path,ROIThreshold)
%% Calcium signal Generation
FilterThreshold=0.4;
CaSigGeneration(Path,FilterThreshold);
PeakThreshold=0.06; % sensitive of delta_F/F
PeakDetection(Path,PeakThreshold)
Peak3D(Path)
%% Manual selection of signals
PeakManualSelection(Path)