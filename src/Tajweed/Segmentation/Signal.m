classdef Signal < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data = [];
        fs = 16000;
        mfcc = [];
        phonemes = [];
        threshold = 0;
        distance = [];
    end
    
    methods
            
        function obj = Signal(fileName)
            obj.Read(fileName);
        end
        
        function Play(obj)
            sound(obj.data, obj.fs);
        end
        
        function Normalize(obj, a, b)
            
            switch( nargin )
                case 1
                    obj.data = Processing.Normalize(obj.data);
                case 2
                    obj.data = Processing.Normalize(obj.data, a);
                case 3
                    obj.data = Processing.Normalize(obj.data, a, b);
            end
            
        end
        
        function RemoveSilence(obj)
            VAD.RemoveSilence(obj);
        end
        
        function Read(obj, fileName)
            [obj.data, obj.fs] = audioread( fileName );
        end
        
        function Write(obj, fileName)
            audiowrite(fileName, obj.data, obj.fs);
        end
        
        function phonemes = GetPhonemes(obj)
            
            %% add +2.5 that has been removed before
            phonemes = [obj.phonemes length(obj.distance)];
            phonemes = phonemes + 2.5;
            phonemes(1) = 0;
            
        end
    end
    
end

