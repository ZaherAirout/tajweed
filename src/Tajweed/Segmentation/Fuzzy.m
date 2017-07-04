classdef Fuzzy < handle
    methods (Static=true)
        
        function y = low(x)
            y = zeros(size(x));
            for i=1:size(x,1)
                for j=1:size(x,2)
                    y(i,j) = fuzzy.lowA(x(i,j));
                end
            end
        end 
        function y = medium(x)
            y = zeros(size(x));
            for i=1:size(x,1)
                for j=1:size(x,2)
                    y(i,j) = fuzzy.mediumA(x(i,j));
                end
            end
        end
        function y = high(x)
            y = zeros(size(x));
            for i=1:size(x,1)
                for j=1:size(x,2)
                    y(i,j) = fuzzy.highA(x(i,j));
                end
            end
        end
        
        function y = lowA(x)
            if x >= 5
                y = 0;
            elseif x <= 0
                y = 1;
            else
                y = -x/5+1;
            end
        end
        function y = mediumA(x)
            if x >= 10
                y = 0;
            elseif x <= 0
                y = 0;
            elseif 0 < x  && x <= 5
                y = x/5;
            else
                y = -x/5 + 2;
            end
        end
        function y = highA(x)
            if x >= 10
                y = 1;
            elseif x <= 5
                y = 0;
            else
                y = x/5 - 1;
            end
        end
    end
    
    
    properties
        setsCount = 3;
        center = 0;
        extent = 5;
    end
    
    methods
        function obj = Fuzzy(setsCount, center, extent)
            if(setsCount == 0)
                error('Sets count musts be non-zero value.');
            end
            if(setsCount < 0)
                    error('Sets count musts be positive value.');
            end
            if(mod(setsCount, 2) == 0)
                error('Sets count musts be Odd value.');
            end
            if(extent <= 0)
                error('Extent musts be positive value.');
            end
            
            obj.setsCount = setsCount;
            obj.center = center;
            obj.extent = extent;
        end
        
        function result = Apply(obj, x)
            
            result = zeros(obj.setsCount, size(x, 1), size(x, 2));

            % the center of the first set
            icenter = obj.center - ((obj.setsCount - 1)/2)*obj.extent;
            
            for k=1:obj.setsCount
                
                % first set // Low
                if(k==1)
                    y = zeros(size(x));
                    for i=1:size(x,1)
                        for j=1:size(x,2)
                            value = x(i,j);
                            
                            if value >= (icenter + obj.extent)
                                y(i,j) = 0;
                            elseif value <= icenter
                                y(i,j) = 1;
                            else
                                y(i,j) = -value/obj.extent + icenter/obj.extent +1;
                            end
                        end
                    end
                    % last set  // High
                elseif(k==obj.setsCount)
                    
                    y = zeros(size(x));
                    for i=1:size(x,1)
                        for j=1:size(x,2)
                            value = x(i,j);
                            if value >= icenter
                                y(i,j) = 1;
                            elseif value <= (icenter - obj.extent)
                                y(i,j) = 0;
                            else
                                y(i,j) = value/obj.extent - icenter/obj.extent +1;
                            end
                        end
                    end
                    
                    % between  // Medium
                else
                    y = zeros(size(x));
                    for i=1:size(x,1)
                        for j=1:size(x,2)
                            value = x(i,j);
                            if value >= (icenter + obj.extent)
                                y(i,j) = 0;
                            elseif value <= (icenter - obj.extent)
                                y(i,j) = 0;
                            elseif ((icenter - obj.extent) < value)  && (value <= icenter)
                                y(i,j) = value/obj.extent - icenter/obj.extent + 1;
                            else
                                y(i,j) = -value/obj.extent + icenter/obj.extent +1;
                            end
                        end
                    end
                end
                
                icenter = icenter + obj.extent;
                result(k,:,:) = y;
            end
        end
        
        function result = Duration(obj, phonemes)
            
            result = 0;
            for i=2:length(phonemes)
                result = [result phonemes(i) - phonemes(i-1)];
            end
            result = Processing.Normalize(result, 10);
            
            result = obj.Apply(result);
            
        end
        
    end
end