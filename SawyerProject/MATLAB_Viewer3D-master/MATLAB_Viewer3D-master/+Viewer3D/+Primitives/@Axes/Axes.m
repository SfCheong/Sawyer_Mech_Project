classdef Axes < Viewer3D.Primitives.IDrawable
    %AXES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( Constant )
        % Origin point for drawing
        originPoints = [	0, 0, 0, 1;
                            1, 0, 0, 1;
                            0, 1, 0, 1;
                            0, 0, 1, 1  ]';             
    end
    
	properties %( Access = private )                   
        % Transformation matrix ( should be innitialized by I )
%         rmtx;           % Rotation matrix
%         tmtx;           % Translation matrix
        smtx;           % Scale matrix        
        fmtx;           % Full transformation matrix
        
        axesLines   = [];      % Line array for drawing
        
        % Points for draw
        points      = [];
                    
        % Axis colors
        
        lineWidth = 1;  % Axis wigths
        
        hGroup   = [];
    end
    
    methods
        %% Constructor 
        function obj = Axes()
%             % Rotation matrix
%             obj.rmtx = eye(4);       
%             % Translation matrix
%             obj.tmtx = eye(4);     

            obj.hGroup = hggroup();
            
            % Creat object arrays
            obj.axesLines = gobjects(1,3);
            
            % Update line arrays
            obj.axesLines(1,1) = line(	obj.originPoints( 1, [1,2] ),	... 
                                        obj.originPoints( 2, [1,2] ),	...
                                        obj.originPoints( 3, [1,2] ),	...
                                        'Color',        'r',  	...
                                        'LineWidth',    obj.lineWidth, ...
                                        'Parent',       obj.hGroup );

            obj.axesLines(1,2) = line(	obj.originPoints( 1, [1,3] ),	... 
                                        obj.originPoints( 2, [1,3] ),	...
                                        obj.originPoints( 3, [1,3] ),	...
                                        'Color',        'g',  	...
                                        'LineWidth',    obj.lineWidth, ...
                                        'Parent',       obj.hGroup );


            obj.axesLines(1,3) = line(	obj.originPoints( 1, [1,4] ),	... 
                                        obj.originPoints( 2, [1,4] ),	...
                                        obj.originPoints( 3, [1,4] ),	...
                                        'Color',        'b',  	...
                                        'LineWidth',    obj.lineWidth, ...
                                        'Parent',       obj.hGroup );
                                    
            % Set unvisible
            set( obj.axesLines, 'Visible', 'off');  

            % Scale matrix
            obj.smtx = eye(4);             
            % Transformation matrix
            obj.fmtx = eye(4);             
            
            % Update
%             update( obj );
        end
        
        %% Set orientation
        function setTransformMat( obj, mat )
            
            % Check for input vector langth
            obj.fmtx = mat;

            % Calculate full matrix
%             obj.fmtx = obj.rmtx * obj.tmtx;
            
            % Update point coordinates
%             tempPoints = obj.fmtx * obj.originPoints( : , 1:end );

            % Update
            update( obj );
        end
        
%         %% Set orientation
%         function setOrientation( obj, vec, angle )
%             % Check for input vector langth
%             obj.rmtx = makehgtform( 'rotation',	vec, angle ); 
%             
%             % update drawing
%             obj.update();
%         end
%         
%         %% Set translation
%         function setTranslation( obj, vec )
%             % Check for input vector langth
%             obj.rmtx = makehgtform( 'translate', vec ); 
%             
%             % update drawing
%             obj.update();
%         end
       
        %% Set scale
        function setScale( obj, vec )
            % Check for input vector langth
            obj.smtx = makehgtform( 'scale', vec );             
            % Update
            update( obj );    
        end
        
        %% Draw camera
        function setParent( obj, parent )
            % Set axes
            set( obj.hGroup, 'Parent', parent );            
            % Set unvisible
            set( obj.axesLines, 'Visible', 'on');
        end
    end
    
    methods (Access = private)
        % Update axes
        function update( obj )
            % Set scale
            obj.points = obj.smtx * obj.originPoints;            
            % Update point coordinates
            obj.points = obj.fmtx * obj.points;
            
            obj.axesLines(1,1).XData = obj.points( 1, [1,2] );
            obj.axesLines(1,1).YData = obj.points( 2, [1,2] );
            obj.axesLines(1,1).ZData = obj.points( 3, [1,2] );

            obj.axesLines(1,2).XData = obj.points( 1, [1,3] );
            obj.axesLines(1,2).YData = obj.points( 2, [1,3] );
            obj.axesLines(1,2).ZData = obj.points( 3, [1,3] );

            obj.axesLines(1,3).XData = obj.points( 1, [1,4] );
            obj.axesLines(1,3).YData = obj.points( 2, [1,4] );
            obj.axesLines(1,3).ZData = obj.points( 3, [1,4] );          
 
        end
    end    
end

