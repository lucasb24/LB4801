clear;
clc;
fp = 'C:\Users\Lucas\Documents\Thesis\SPRI_Knee_coregistered';
cd(fp);
tic
load('nii_structs.mat');
disp('Nifti Volumes loaded');
load('matlab_landmarks.mat');
disp('Manual landmarks loaded');
load('landmark_labels.mat');
disp('Landmark labels loaded');
toc