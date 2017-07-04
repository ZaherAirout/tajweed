% Clean-up MATLAB's environment
% clear all; close all; clc;

%% fs = fs ?? ????????
% M =  filter banks = 40
% LPC = FS(in Khz) + 2
% C = 1.5 * LPC
% HF = Fs/2



wav_file = '112_mono.wav';  % input audio filename
% Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread(wav_file );

% Define variables
Ts = 10;                % analysis frame shift (ms)
Tw=20;                       % TW is the analysis frame duration (ms) 
alpha = 0.97;           % preemphasis coefficient
M  = 50;%M  = 8;%??                 % number of filterbank channels
C = 25;%C = 25;   %??              % number of cepstral coefficients
L = 28;%L = 28;      %??           % cepstral sine lifter parameter
LF = 300;          %??     % lower frequency limit (Hz)
HF = fs/2;      %??        % upper frequency limit (Hz)


%threshold = 1.65;
%threshold = 0.45;

%threshold = 1.35;
%threshold = 5.8;
threshold = 1.8;
%threshold = 0.9;
%threshold = 2;


% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );


%%
%MFCCs = MFCCs(2:end,:);

%MFCCs = [MFCCs; FBEs];
%%
%deltas = calculateDeltas(MFCCs, 2);
%deltasDeltas = calculateDeltas(deltas, 2);
%MFCCs = [ MFCCs; deltas; deltasDeltas];

%%

%MFCCs = normalize(MFCCs) * 10;

 MFCCs = normalize(FBEs)*10;
%%
A = fuzzy.lowA(MFCCs)';
M = fuzzy.mediumA(MFCCs)';
B = fuzzy.highA(MFCCs)';
% 
% A2 = fuzzy.lowB(MFCCs)';
% M2 = fuzzy.mediumB(MFCCs)';
% B2 = fuzzy.highB(MFCCs)';


%%
range=1:size(MFCCs,2) - 3;
d=[];
for i=range,
    d(i) = distance.euclidian(i, A, M, B);
end

d2=[];
for i=range,
    d2(i) = distance.chevyshev(i, A,M,B);
end
%%

d = normalize(d) * 12;
d2 = normalize(d2) * 12;

do(d,d2,threshold,1,2, MFCCs);
% 
% %%
% range=1:size(MFCCs,2) - 3;
% d=[];
% for i=range,
%     d(i) = distance.euclidian(i, A2, M2, B2);
% end
% 
% d2=[];
% for i=range,
%     d2(i) = distance.chevyshev(i, A2, M2, B2);
% end
% 
% %%
% 
% do(d,d2,threshold,3,4, MFCCs);