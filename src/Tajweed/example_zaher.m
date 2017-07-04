% Clean-up MATLAB's environment
clear;
clc;

C = 12;
L = 22;
M = 26;
tw = 20;
ts = 10;
alpha = 0.97;
phonemeNum = 16;

%%
wav_file1 =  'bsfr001001 (2).wav';% input audio filename

% Read speech samples, sampling rate and precision from file
signal = Signal(wav_file1);

% signal.RemoveSilence();
signal.Normalize(0,1);

signal.Play();

signal.Write(strcat('Output\new', wav_file1));


ps1 = Segmentation(C, L, M, tw, ts, alpha);

%  ps1.ManualSegment(signal, 5.1);
ps1.AutoSegment(signal, phonemeNum);

phonemes1 = signal.GetPhonemes();

%%
Processing.ToTextGrid(phonemes1./100, 'Output', wav_file1);
%%
wav_file2 =  'FormatFactorybsfr001001.wav';% input audio filename

% Read speech samples, sampling rate and precision from file
signal2 = Signal(wav_file2);

signal2.RemoveSilence();

signal2.Write(strcat('Output\new', wav_file2));

signal2.Normalize(0,1);

signal2.Play();

ps2 = Segmentation(C, L, M, tw, ts, alpha);

% ps.ManualSegment(speech, fs, threshold);
 ps2.AutoSegment(signal2, phonemeNum);
 phonemes2 = signal2.GetPhonemes();
%%
Processing.ToTextGrid(phonemes2./100, 'Output', wav_file2);

%%   Test Zone
CepstralCoefficient = 12; 
Lifters = 22; 
FilterBank = 26;

i = 1;
j = 1;

[~,~,dist,diff] = Comparison.One2One(signal,signal2,i,j,true);
fprintf(' \n distance is %f \n Different is %f \n',dist,diff);

%%
data = Comparison.All2All(signal,signal2);
Processing.ToExcelFile('Output\Features.xlsx',data);
disp('Finish');
