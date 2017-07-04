classdef Segmentation < handle
    % PhonemeSegmentation Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        td = 0.5;
        
        windowTime = 20;
        shiftTime = 10;
        preemphisizeAlpha = 0.97;
        cepstralCoefficients = 12;
        lifters = 22;
        filterbanks = 26;
        
        threshold = 0;
        
        lowFrequency = 300;
        highFrequency = 8000;
        
    end
    
    methods
        
        function obj = Segmentation(cepstralCoefficients, lifters, filterbanks, windowTime, shiftTime, alpha)
            
            if(nargin < 1)
                cepstralCoefficients = 13;
            end
            
            if(nargin < 2)
                lifters = 22;
            end
            
            if(nargin < 3)
                filterbanks = 24;
            end
            
            if(nargin < 4)
                windowTime = 20;
            end
            
            if(nargin < 5)
                shiftTime = 10;
            end
            
            if(nargin < 6)
                alpha = 0.97;
            end
            
            obj.cepstralCoefficients = cepstralCoefficients;
            obj.lifters = lifters;
            obj.filterbanks = filterbanks;
            obj.windowTime = windowTime;
            obj.shiftTime = shiftTime;
            obj.preemphisizeAlpha = alpha;
            
        end
        
        function AutoSegment(obj, signal, numberOfPhonemes, highFrequency, lowFrequency)
            
            if(nargin < 2)
                error('There is no signal');
            end
            
            if(nargin < 3)
                error('Number of phonemes is required');
            end
            
            if(nargin < 4)
                highFrequency = round(signal.fs/2);
            end
            
            if(nargin < 5)

                lowFrequency = 300;
            end
            
            obj.highFrequency = highFrequency;
            obj.lowFrequency = lowFrequency;
            
            distance = obj.Distance(signal);
            
            obj.FindThreshold(numberOfPhonemes, distance);
            Processing.Draw(distance, obj, 1);
            
            phonemes = obj.ExtractPhonemes(distance);

            signal.phonemes = phonemes;
            signal.phonemes(end+1) = length(distance);
            signal.threshold = obj.threshold;
            signal.distance = distance;
            
        end
        
        function ManualSegment(obj, signal, threshold, highFrequency, lowFrequency)
            
            if(nargin < 2)
                error('There is no signal');
            end
            
            if(nargin < 3)
                error('Threshold is required');
            end
            
            if(nargin < 4)
                highFrequency = round(signal.fs/2);
            end
            
            if(nargin < 5)
                lowFrequency = 300;
            end
            
            obj.threshold = threshold;
            obj.highFrequency = highFrequency;
            obj.lowFrequency = lowFrequency;
            
            distance = obj.Distance(signal);
            Processing.Draw(distance, obj, 1);
            
            phonemes = obj.ExtractPhonemes(distance);

            signal.phonemes = phonemes;
            signal.phonemes(end+1) = length(distance);
            signal.threshold = obj.threshold;
            signal.distance = distance;
        end
        
        function Merge(~, signal, count)
            
            while(count > 0)
                distance = Comparison.ApplyDTW(signal);
                
                minimum = +inf;
                iMinimum = -1;
                for i=1:length(signal.phonemes)-1
                    if(distance(i,i+1) ~= 0 && minimum > distance(i, i + 1))
                        minimum = distance(i, i+1); 
                        iMinimum = i+1;
                    end
                end
                
                if(minimum < +inf)
                    signal.phonemes = signal.phonemes([1:(iMinimum-1) , (iMinimum +1):end]);
                end
 
                count = count-1;
            end
        end
    end
    
    methods(Access= private)
        
        function phonemes = ExtractPhonemes(obj, distance)
            
            phonemes = 1;
            for i=2:length(distance)-2
                iprev = i - 1;
                inext = i + 1;
                inextNext = i + 2;
                if distance(iprev) < distance(i) && distance(inext) > distance(inextNext) && ...
                        distance(i) > obj.threshold && distance(inext) > obj.threshold ...
                        && abs(distance(i) - distance(iprev)) > obj.td && abs(distance(inext) - distance(inextNext)) > obj.td
                    
                    if(phonemes(end) ~= i-1)
                        phonemes = [phonemes i];
                    end
                    
                end
            end
            
        end % end function
        
        function FindThreshold(obj, numberOfPhonemes, distance)
            
            obj.threshold = mean(distance) / 3;
            
            phonemes = obj.ExtractPhonemes(distance);
           
            %%% threshold gives less phonemes.
            %%% decrease it, so it gives more phonemes
            while(length(phonemes) < numberOfPhonemes)
                oldPhonemes = length(phonemes);
                
                obj.threshold = 2*obj.threshold/3;
                phonemes = obj.ExtractPhonemes(distance);
                
                if(oldPhonemes == length(phonemes))
                    error(['Cant find ' num2str(numberOfPhonemes) ' phonemes in the speech signal.']);
                end
            end
            
            %%% threshold gives more phonemes
            %%% increase it to the lowest removeable frame
            while(length(phonemes) > numberOfPhonemes)
                
                oldThreshold = obj.threshold;
                
                obj.threshold = obj.GetLowestDistance(phonemes, distance) + 0.001;
                
                if(obj.threshold == oldThreshold)
                    error(['Cant find ' num2str(numberOfPhonemes) ' phonemes in the speech signal.']);
                end
                phonemes = obj.ExtractPhonemes(distance);
                
            end
        end
        
        function lowestDistance = GetLowestDistance(obj,phonemes, distance)
            temp = distance(phonemes);
            lowestDistance = min(temp(temp > obj.threshold));
        end
        
        function distance = Distance(obj, signal)
            
            MFCCs = FeaturesExtraction.Mfcc(signal, obj);
            signal.mfcc = MFCCs;
            
            MFCCs = Processing.Normalize(MFCCs,10);

            f = Fuzzy(3, 5,5);
            temp = f.Apply(MFCCs);
            
            low = squeeze(temp(1,:,:))';
            medium = squeeze(temp(2,:,:))';
            high = squeeze(temp(3,:,:))';
            
            range=1:size(MFCCs,2) - 3;
            distance=zeros(1,range(end));
            for i=range
                distance(i) = Distance.euclidian(i, low, medium, high);
            end
            
            distance = Processing.Normalize(distance, 12);
        end
        
    end % methods(Access = private)
end % class