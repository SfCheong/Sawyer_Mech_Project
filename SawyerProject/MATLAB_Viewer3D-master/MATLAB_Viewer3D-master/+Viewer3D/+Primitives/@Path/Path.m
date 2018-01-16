classdef Path < handle 
    %PATH Summary of this class goes here
    %   Detailed explanation goes here
       
    properties %(Access = private)
       % Graphic objects
       hGroup           = []; 
       hAxes            = []; 
       hPathLine        = [];
       axesLines        = [];
       
       % Data
       pathPoints       = [];
       orientation      = [];
       
       pathAxesArray    = [];
       
       pointsType       = [];
       pointsColor      = [];
    end
    
    methods
        function obj = Path( points, orientation )
            obj.pathPoints  = points;
            obj.orientation = orientation;
            
            %% Path line
            % Create graphic group object
            obj.hGroup = hggroup();
            
            % Creat object arrays
%             obj.hPathLine = gobjects(1,3);
            
            % Create line object of for the path points
            obj.hPathLine = line(   obj.pathPoints( :, 1), ...
                                    obj.pathPoints( :, 2), ...
                                    obj.pathPoints( :, 3), ...
                                    'Parent',   obj.hGroup , ...
                                    'Marker',   '.', ... 
                                    'MarkerSize', 3);
            
            % Set unvisible
            set(obj.hPathLine, 'Visible', 'off');
            
            %% Axes array
            obj.fillAxesArr(1.0);
                         
        end
        
        % Set points to be drewn onto the axes in [x y z] format
        function setPathPoints(obj,points)
            obj.points = points;
        end
        
        % Parent Path Group to current axes
        function setParent(obj,axes)
            % Parent group to axes
            set(obj.hGroup, 'Parent', axes);
            
            obj.hAxes = axes;
            
            % Set visibility on
            set(obj.hPathLine, 'Visible', 'on');
        end
        
        % Function to draw 3D axes of each point, with factor deciding
        % density/number of axes to draw
        function drawPointsAxes(obj)
            % Show axes line objects
            set(obj.axesLines, 'Visible', 'on');
        end
        
        % Fill up axes array with Axes obj at each point, 
        % factor 0.0 - 1.0, 1.0 being the least dense axes array
        function fillAxesArr(obj,factor) 
            % Import package
            import Viewer3D.Primitives.*;   
                        
            % Get number of points, i.e. number of iterations
            num = length(obj.pathPoints(:,1));
            
            % Allocate axes array
            obj.pathAxesArray = repelem(Axes(),num);
            
            % Create axes line graphic objects group
            obj.axesLines = gobjects(num, 3);
            
            % Calculate step to create axes array
            step = uint16(1/factor);
            
            for i = 1:step:num
                % Create axes object 
                obj.pathAxesArray(i) = Axes();
                
                % Create transform matrix 
                transM  = makehgtform( 'translate'  , obj.pathPoints(i,:));
%                 rotM    = makehgtform( 'zrotate'    , obj.orientation(i));

                % Set transform to axes object
%                 obj.pathAxesArray(i).setTransformMat( transM * rotM );

%                 rotMat    = makehgtform( 'zrotate', obj.orientation(i, 1 ) );                    
%                 rotMat    = rotMat * makehgtform  ( 'yrotate', obj.orientation(i, 2 ) );
                rotMat  =  axang2tform( obj.orientation(i,:) );

                obj.pathAxesArray(i).setTransformMat( transM * rotMat );
                
                % Parent axes object to Axes object group
                obj.pathAxesArray(i).setParent( obj.hGroup );
                
                % Group axes line graphic objects 
                obj.axesLines(i,:) = obj.pathAxesArray.axesLines;
            end
        end
        
        % Set factor for array view and update array
        % TODO to manipulate each axes properties??
        function setAxesViewFactor(obj,factor)
            % Calculate step to create axes array
            step = uint16(1/factor);
            
            num = length(obj.pathPoints(:,1));
            
            % No axes visible
            set(obj.axesLines,'Visible','off');
            
            % Choose visible axes
            for i = 1:step:num
                elem = gobjects();
                set(obj.axesLines(i,:),'Visible','on')
            end
        end
        
        % To scale all axes on the points
        function setAxesScale(obj,scale)
            num = length(obj.pathAxesArray);
            
            % iterate and call function
            for i = 1:num
                obj.pathAxesArray(i).setScale(scale);
            end
        end
        
    end
    
end

