classdef VAD
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    methods(Static =true)
         function RemoveSilence(signal)
            
            %step1
            mu = mean(signal.data(1:1600));
            segma = sqrt(mean((signal.data(1:1600)-mu).^2));
            
            %             step2
            bits = zeros(length(signal.data),1);
            for i=1:length(signal.data)
                if (abs(signal.data(i)-mu)/segma)>3
                    bits(i) = 1;
                end
            end
            
            %step3
            tw = signal.fs/100;
            frames = 1:tw:length(signal.data);
            result = zeros(length(frames),1);
            
            for i=1:length(frames)-1
                
                M = sum(bits(frames(i):frames(i+1)) == 0);
                N = frames(i+1) - frames(i) - M;
                
                %step4
                if(M < N)
                    result(i) = 1;
                end
            end
            
            %step5
            %return the new signal
            first = find(result, 1, 'first')*signal.fs/100;
            last = find(result, 1, 'last')*signal.fs/100;
            
            signal.data = signal.data(first:last);
        end
    end
end

