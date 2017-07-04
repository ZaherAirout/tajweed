classdef Comparison < handle
    %COMPARISON Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static=true)
        
        function Compare(signal1, signal2)
            
            [mfcc1,mfcc2] = Comparison.GetNormMFCCs(signal1, signal2);
            %% TODO: insert your comparison code here
            distance = zeros(length(phonemes1), length(phonemes2));
            for i=1:length(phonemes1) - 1
                for j=1:length(phonemes2) -1
                    dist = dtw(mfcc1(phonemes1(i)), mfcc2(phonemes2(j)));
                    len1=phonemes1(i+1)-phonemes1(i);
                    len2=phonemes2(j+1)-phonemes2(j);
                    distance(i,j) = dist/mean([len1, len2]) ;
                end
            end
        end
        
        % Get normalized MFCCs from 2 signals
        function [mfcc1,mfcc2] = GetNormMFCCs(signal1, signal2)
            maximum = max(max(signal1.mfcc(:)),max(signal2.mfcc(:)));
            minimum = min(min(signal1.mfcc(:)),min(signal2.mfcc(:)));
            
            mfcc1 = Processing.Normalize(signal1.mfcc, 0, 10, maximum, minimum);
            mfcc2 = Processing.Normalize(signal2.mfcc, 0, 10, maximum, minimum);
            
        end
        
        function [len1,len2,dist,diff] = One2One(signal1, signal2,iphoneme,jphoneme,PlaySound)
            % prepare the data
            [mfcc1,mfcc2] = Comparison.GetNormMFCCs(signal1, signal2);
            
            phonemes1 = signal1.phonemes;
            phonemes2 = signal2.phonemes;
            i = iphoneme;
            j = jphoneme;
            
            if(i==1)
                firstBoundary = 1;
            else
                firstBoundary=round(phonemes1(i));
            end
            
            secondBoundary=round(phonemes1(i+1));
            
            % TRIM THE 1st SPEECH
            mfcc1 = mfcc1(:,firstBoundary:secondBoundary);
            % play the phoneme
            if(nargin > 4 && PlaySound)
                sound(signal1.data(firstBoundary*signal1.fs/100:secondBoundary*signal1.fs/100),signal1.fs);
                pause(0.5);
            end
            % CALCULATE  2nd BOUNDARIES
            if(j==1)
                firstBoundary = 1;
            else
                firstBoundary=round(phonemes2(j));
            end
            
            secondBoundary=round(phonemes2(j+1));
            
            % TRIM THE 2nd SPEECH
            
            mfcc2= mfcc2(:,firstBoundary:secondBoundary);
            
            % play the phoneme
            if(nargin > 4 && PlaySound)
                sound(signal2.data(firstBoundary*signal2.fs/100:secondBoundary*signal2.fs/100),signal2.fs);
            end
            
            len1=phonemes1(i+1)-phonemes1(i);
            len2=phonemes2(j+1)-phonemes2(j);
            
            [dist,~,~]= dtw(mfcc1 ,mfcc2);
            diff=dist/mean([len1, len2]);
            
        end
        function table = All2All(signal1, signal2)
            
            table = cell( size(signal1.phonemes,1) * size(signal2.phonemes,1),6);
            row= 0;
            for i=1:size(signal1.phonemes,2)-1
                for j=1:size(signal2.phonemes,2)-1
                    
                   [len1,len2,dist,diff] = Comparison.One2One(signal1, signal2,i,j);
                   row=row+1;
                   table(row,:) = {i , len1,j , len2,dist, diff} ;

                end
            end
        end
        function distance =  ApplyDTW(signal1, signal2)
            % apply DTW on 2signals
            % returns distance matrix between each phoneme of
            % the first signal with each phoneme in the second signal
            
            if(nargin < 2)
                signal2 = signal1;
            end
            
            phonemes1 = signal1.phonemes;
            phonemes2 = signal2.phonemes;
            
            mfcc1 = signal1.mfcc;
            mfcc2 = signal2.mfcc;
            
            distance = zeros(length(phonemes1), length(phonemes2));
            for i=1:length(phonemes1) - 1
                for j=1:length(phonemes2) -1
                    dist = dtw(mfcc1(phonemes1(i)), mfcc2(phonemes2(j)));
                    len1=phonemes1(i+1)-phonemes1(i);
                    len2=phonemes2(j+1)-phonemes2(j);
                    distance(i,j) = dist/mean([len1, len2]) ;
                end
            end
        end
        
    end
    
end

