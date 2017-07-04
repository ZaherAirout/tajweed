classdef Processing
    %PROCEESSING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        
        function ToExcelFile(fileName, data)
            
            headers = {'phoneme1','len1','phoneme2','len2' , 'distance','result'};
            xlswrite(fileName, [headers;data]);

%             if fileExist==0
%                 xlswrite(fileName,headers);
%             end
%             
%             [~,~,input] = xlsread(fileName); % Read in your xls file to a cell array (input)             
%             output = input;
%             for i=1:size(data,1)
%                 
%                 new_data = {};
%                 
%                 for j=1:size(data,2)
%                     new_data{end+1} = data(i,j);% This is a cell array of the new line you want to add
%                 end
%                 output = cat(1,output,new_data); % Concatinate your new data to the bottom of input
%             end
%             xlswrite(fileName,output); % Write to the new excel file.
        end
        
        
        function ToTextGrid(phonemes, filePath, fileName)
            if(nargin < 1)
                error('Phonemes are required');
            end
            
            if(nargin < 2)
                filePath = '';
            end
            
            fid = fopen(strcat(filePath,'\', fileName, '.TextGrid'),'w');
            fprintf(fid,'File type = "ooTextFile"\nObject class = "TextGrid"\n\nxmin = %d\nxmax = %d\ntiers? <exists>\nsize = 1\nitem[]:\nitem [1]:class = "IntervalTier" name = "Automatic" xmin = %d \n xmax = %d\nintervals: size = %d ',phonemes(1),phonemes(end),phonemes(1),phonemes(end),size(phonemes,2)-1);
            for i=1:size(phonemes,2)-1
                fprintf(fid,'\tintervals [%d]: \n\t\t xmin = %d \n\t\t xmax = %d \n\t\t text = "" \n ',i,phonemes(i),phonemes(i+1));
            end
            fclose(fid);
        end
        
        function result = CalculateDeltas(MFCCs, N)
            result = zeros(size(MFCCs));
            
            rows = size(MFCCs,1);
            columns = size(MFCCs, 2);
            %     for t=N:rows-N
            
            upperBound = rows;
            lowerBound = 1;
            r = upperBound - lowerBound + 1;
            
            for k=1:columns
                for t=1:rows
                    range=1:N;
                    for n=1:N
                        
                        index1 = mod(mod(t+n - lowerBound, r) + r, r) + lowerBound;
                        index2 = mod(mod(t-n - lowerBound, r) + r, r) + lowerBound;
                        
                        result(t,k) = n * ( MFCCs( index1,k ) - MFCCs(index2,k));
                    end
                    
                    result(t,k) = result(t,k) / (2*sum(power(range,2 )));
                    
                end
            end
        end
        
        function delta_feat = Deltas(feat, N)
            if N < 1
                error('N must be an integer >= 1');
            end
            feat = feat';
            
            NUMFRAMES = size(feat, 1);
            
            denominator = 2 * sum(power([1,N+1], 2));
            delta_feat = zeros(size(feat,1), size(feat,2));
            padded = padarray(feat, [N,0], 'replicate', 'both');

            for t=1:NUMFRAMES
                delta_feat(t,:) = dot(repmat(-N:N, size(padded,2), 1)', padded(t:t+2*N, :))/ denominator;
            end
            
            delta_feat = delta_feat';
        end
        
        function Draw(distance, ps, fig)
            
            range=1:size(distance,2) - 3;
            
            figure(fig);
            hold on
            
            stem(range, distance(1:end-3));
            
            for i=2:size(distance,2)-2
                iprev = i - 1;
                inext = i + 1;
                inextNext = i + 2;
                if distance(iprev) < distance(i) && distance(inext) > distance(inextNext) && ...
                        distance(i) > ps.threshold && distance(inext) > ps.threshold && ...
                        abs(distance(i) - distance(iprev)) > ps.td && abs(distance(inext) - distance(inextNext)) > ps.td
                    
                    plot(i, distance(i), 'ko', 'MarkerFaceColor', [0,0.75,0.25]);
                end
            end

            title('Euclidian');
            xlabel('Frames (t)');
            ylabel('Distance');
            hold off
            
        end
        
        function result = Normalize(array, a, b, maximum, minimum)
            if(nargin < 3)
               result = Processing.Normalize1(array,a);
            else if(nargin < 5)
               result = Processing.Normalize1(array,a,b);
           else
               result = Processing.Normalize2(array,a,b,maximum,minimum);
           end
        end
        end
    end
    
    methods(Access=private,Static=true)
        
        function result = Normalize1( array, a, b)
            
            if(nargin == 1)
                a = 0;
                b= 1;
            elseif(nargin ==2)
                b= a;
                a= 0;
            end
            
            result = (b-a)*(array - min(array(:))) ./ ( max(array(:)) - min(array(:))) + a;
            
        end
        
        function result = Normalize2( array, a, b, mn, mx)
            
            if(nargin == 1)
                a = 0;
                b= 1;
            elseif(nargin ==2)
                b= a;
                a= 0;
            end
            
            result = (b-a)*(array - mn) ./ ( mx - mn) + a; 
        end
        
    end
end

