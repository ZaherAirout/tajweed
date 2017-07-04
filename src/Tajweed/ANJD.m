  
        % Clean-up MATLAB's environment
clear;
clc;

%%
wav_file =  '4-1.wav';% input audio filename

% Read speech samples, sampling rate and precision from file
signal = Signal(wav_file);
signal.Normalize(-1, 1);
signal.RemoveSilence();

signal.Write(strcat('Output\new', wav_file));

% C = 26; %12
% L = 30; %22
% M = 40; %26
C = 12;
L = 22;
M = 26;
threshold = 4.379849580937778;
tw = 20;
ts = 10;
alpha = 0.97;

ps = Segmentation(C, L, M, tw, ts, alpha);

pn1 = 14;
pn2 = pn1 + 1;

% phonemes = ps.ManualSegment(signal, threshold);
ps.AutoSegment(signal, pn1);
phonemes = signal.GetPhonemes();
Processing.ToTextGrid(phonemes./(1000/ts), 'Output', 'p1');

%%
ps.AutoSegment(signal, pn2);
phonemes = signal.GetPhonemes(); 
Processing.ToTextGrid(phonemes./(1000/ts), 'Output', 'p2');

%%
ps.Merge(signal, pn2-pn1);
phonemes = signal.GetPhonemes();
Processing.ToTextGrid(phonemes./(1000/ts), 'Output', 'p');

%%
% [headers, data] = Processing.Table(ps, signal, signal, phonemes, phonemes);
% Processing.ToExcelFile('hello.xlsx', data, headers);
% 