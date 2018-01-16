classdef ConicalPaths < handle
    %CONICALPATHS Summary of this class goes here
    %   Detailed explanation goes here
    properties
        baseDiameter    = [];
        coneHeight      = [];
        baseCenter      = [0 0 0];
        
        theta           = [];       % angular displacement per tick
        circlePoints    = [];       % coordinates of all circle poins
        
        circlePaths     = [];       % all Path objects
    end
    
    properties (Access = private)
        base2peakAngle  = [];       % angle of cone peak to base perimeter
        circlesCenters  = [];
        circlesDiameter = [];
        t               = (0:0.2:10)'; % time for path
    end
    
    methods
        % diamter of base circle, height of "cone", center coordinates
        function obj = ConicalPaths( diameter, height, center)
           obj.baseDiameter     = diameter;
           obj.coneHeight       = height;
           obj.baseCenter       = center;
           obj.theta            = obj.t * (2*pi / obj.t(end));
           
           obj.base2peakAngle   = atan( diameter/height );
        end
        
        % Set height of which circumference of the cone is to be drawn
        % ex. percentHeight = [1.0 0.8 0.3 0.1]
        function setHeightPercent(obj, percentHeight )
            % Copy baseCenter coordinates
            obj.circlesCenters       = repmat(obj.baseCenter, length(percentHeight),1); 
            
            % Find z coordinate of circles
            obj.circlesCenters(:, 3) = obj.circlesCenters(:, 3) + (percentHeight * obj.coneHeight)';
            
            % Find diameters of circles
            obj.circlesDiameter = (obj.coneHeight - obj.circlesCenters(:,3)) ...
                                    .* sin(obj.base2peakAngle); 
                                
            % Find new height of circles
%             for i = 1:length(percentHeights)
%                 obj.circlesCenters(i, 3) = obj.circlesCenters(i, 3) + ...
%                                            percentHeight(i) * obj.coneHeight;
%             end
        end
        
        % Create trajectory circles
        function createCircles(obj)
            count = length(obj.circlesDiameter);
            
            % Allocate matrix
            temp            = repmat([0 0 0], length(obj.theta), 1);
            obj.circlePoints = repmat(temp, 1, 1, count);
            
            for i = 1:count
                obj.circlePoints(:,:,i)    = obj.circlesDiameter(i) * [ cos(obj.theta) sin(obj.theta) zeros( size(obj.theta) ) ] ...
                                                + obj.circlesCenters(i,:);
            end
        end
        
        % Create objects of class Path
        function drawPaths(obj)
            %Import packages
            import Viewer3D.Primitives.*; 
            
            count = length(obj.theta);
            
            % dummy orientation
            orientation = repmat([0 0 0 0], count, 1);
            
            % Allocate matrix
            obj.circlePaths = repmat( Path(obj.circlePoints(:,:,1), orientation), length(obj.circlesDiameter), 1);
            
            for i = 1:count
                obj.circlePaths(i) = Path(obj.circlePoints(:,:,i), orientation); 
                obj.circlePaths(i).setParent(gca);
            end
        end
        
        % Update with new circles
        function update(obj)
            % To update al circles if properties are changed
        end
    end
    
end

