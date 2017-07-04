classdef TajweedController < handle
   
    properties
       
        orignialSignal@Signal;
        recordedSignal@Signal;
        
        segmentation@Segmentation;
        comparison@Comparison;
        
    end
    
    methods
        
        function obj = TajweedController()
        end
        
        function SetOriginal(obj, fileName)
            obj.orignialSignal = Signal(fileName);
            obj.orignialSignal.RemoveSilence();
            obj.segmentation.AutoSegment(fileName, 12);
        end
        
        function SetRecorded(obj, fileName)
            obj.recordedSignal = Signal(fileName);
            obj.recordedSignal.RemoveSilence();
            obj.segmentation.AutoSegment(fileName, length(obj.recordedSignal.phonemes));
        end
        
        function FindMistakes(obj)
            obj.comparison.Compare(obj.orignialSignal, obj.recordedSignal);
            
            % complete the work
        end
        
    end
    
end