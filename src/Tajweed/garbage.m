  
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

ps = PhonemeSegmentation(C, L, M, tw, ts, alpha);

% phonemes = ps.ManualSegment(signal, threshold);
phonemes = ps.AutoSegment(signal, 13);
Processing.ToTextGrid(phonemes./(1000/ts), 'Output', wav_file);
%%
% [headers, data] = Processing.Table(ps, signal, signal, phonemes, phonemes);
% Processing.ToExcelFile('hello.xlsx', data, headers);
% 

% GetLowestDistance
%lowestDistance = max(distance);
            
%             for i=2:length(phonemes)
%                 if(lowestDistance > distance(phonemes(i)))
%                     lowestDistance = distance(phonemes(i));
%                 end
%                 if(lowestDistance > distance(phonemes(i) + 1 ))
%                     lowestDistance = distance(phonemes(i) + 1);
%                 end
%             end
            