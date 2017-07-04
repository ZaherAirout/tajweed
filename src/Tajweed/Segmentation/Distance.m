classdef Distance < handle
    methods(Static=true)
        function result = cosineDistance(x1,x2)
            result = 1 - cosine(x1,x2);
        end
        
        function result = chevyshev(frame_number, A,M,B)
            result = 0;
            for i=frame_number:frame_number + 1
                for j = frame_number+2:frame_number+3
                    for k=1:size(A,2)
                        result =  result +  ...
                            max(power(A(i,k) - A(j,k),2), max(power(M(i,k) - M(j,k),2), power(B(i,k) - B(j,k),2)));
                    end
                end
            end
            
            result = sqrt(result);
        end
        
        function result = euclidian(frame_number, A,M,B)
            result = 0;
            for i=frame_number:frame_number + 1
                for j = frame_number+2:frame_number+3
                    for k=1:size(A,2)
                        result = result + power(A(i,k) - A(j,k),2) + power(M(i,k) - M(j,k),2) + power(B(i,k) - B(j,k),2);
                    end
                end
            end
            
            result = sqrt(result);
        end
        
        function result = euclidian1(frame_number, A,M,B)
            result = 0;
            i = frame_number - 1;
            j = frame_number + 1;
            
            for k=1:size(A,2)
                result = result + power(A(i,k) - A(j,k),2) + power(M(i,k) - M(j,k),2) + power(B(i,k) - B(j,k),2);
            end
            
            
            result = sqrt(result);
        end
        
        function result = cosine(x1, x2)
            result = dot(x1,x2)/(norm(x1)*norm(x2));
        end
    end
end
