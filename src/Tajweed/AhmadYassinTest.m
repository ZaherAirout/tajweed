% Clean-up MATLAB's environment
clear;
clc;
%%
wav_file =  'C:\\Users\\AHMAD ALYASSIN\\Desktop\\Project Code2\\Fatiha_Basfar\\aya3.wav';% input audio filename

% Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread( wav_file );
%%
% speech = normalize(speech, -1, 1);
% %%
speech = normalize(speech);

C = 12;
L = 22;
M = 26;
%threshold = 4.4;
threshold = 3.8;
tw = 20;
ts = 10;
alpha = 0.97;

ps = PhonemeSegmentation(C, L, M, threshold, tw, ts, alpha);
ps.Segment(speech, fs);