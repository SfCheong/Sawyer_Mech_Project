classdef SawyerModel < Viewer3D.Primitives.IDrawable 
    %SAWYERMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Joints          = [];           % List of the robot joints structures
        
        robotDrawPoints = [];           % Robots point
        robotLineObject = [];           % Object for drawing
        
        axesList        = [];        	% List for axes for drawing
        
        Color   = [ 0.0, 0.0, 0.0 ];    % Set default color
%         Visible = 'on'; 
        
        % Joint positions
        points = [];
        
        % Group object
        hGroup = [];
    end
    
    methods
        %% Class constructor
        function obj = SawyerModel()
            % Allocate matrix
            obj.points = repelem( single(0), 7, 3 );
            
            % Initialize robot struct
            obj.initializeJoints();

            % Make group object
            obj.hGroup = hggroup( 'Visible', 'off' );
                       
            % Allocate place
            obj.robotDrawPoints	= zeros( length( obj.Joints ), 3 );
            % Allocate axes list
            obj.axesList = repelem( Viewer3D.Primitives.Axes(), length( obj.Joints ) );
            % Intialize Axises
            for i = 1:length( obj.Joints )
                % Make new object
                hTempAxes = Viewer3D.Primitives.Axes();
                % Set scale
                hTempAxes.setScale( repelem( obj.Joints(i).axisScale, 3 ));
                hTempAxes.setParent( obj.hGroup );
                % Update
                obj.axesList(i) = hTempAxes;
            end
            
        	% Update joints state
            obj.updateJoints();      
            
            % Make line object
            obj.robotLineObject = line( obj.robotDrawPoints( :, 1  ),   ...
                                        obj.robotDrawPoints( :, 2  ),   ...
                                        obj.robotDrawPoints( :, 3  ),   ...
                                        'Parent',       obj.hGroup,     ...
                                        'Color',        obj.Color,      ...
                                        'LineWidth',    3               );
            
        end
        
        %% Set robot color
        function set.Color( obj, color )
            % Set new color
            obj.Color                   = color;
            obj.robotLineObject.Color   = obj.Color;
        end
        
        %% Set joint position
        function setJointAngle( obj, angles )
            % Temprary solution
            obj.Joints(2).rotationAngle =  angles(1);            
            obj.Joints(4).rotationAngle =  angles(2);            
            obj.Joints(5).rotationAngle =  angles(3);            
            obj.Joints(6).rotationAngle =  angles(4);            
            obj.Joints(7).rotationAngle =  angles(5);            
            obj.Joints(8).rotationAngle =  angles(6);            
            obj.Joints(9).rotationAngle =  angles(7);
            
            % Recalculate matrix 
            obj.updateJoints();
            
            % Update line
            if ~isempty( obj.robotLineObject )
                obj.robotLineObject.XData = obj.robotDrawPoints( :, 1  );
                obj.robotLineObject.YData = obj.robotDrawPoints( :, 2  );
                obj.robotLineObject.ZData = obj.robotDrawPoints( :, 3  );
            end
        end
        
        %% Get joint position
        function angles = getAngles( obj )
            angles = [  obj.Joints(2).rotationAngle 
                        obj.Joints(4).rotationAngle  
                        obj.Joints(5).rotationAngle  
                        obj.Joints(6).rotationAngle  
                        obj.Joints(7).rotationAngle  
                        obj.Joints(8).rotationAngle  
                        obj.Joints(9).rotationAngle   ]';
        end
        
        %% Get 3D Joint position
        function pos = getJointPositions( obj )
            % Allocate matrix
            pos = repelem( single(0), 7, 3 );
            
            % Calculate position
            pos( 1, : ) = obj.robotDrawPoints( 2, :  );
            pos( 2, : ) = obj.robotDrawPoints( 4, :  );
            pos( 3, : ) = obj.robotDrawPoints( 5, :  );
            pos( 4, : ) = obj.robotDrawPoints( 6, :  );
            pos( 5, : ) = obj.robotDrawPoints( 7, :  );
            pos( 6, : ) = obj.robotDrawPoints( 8, :  );
            pos( 7, : ) = obj.robotDrawPoints( 9, :  );
        end
        
        %% Set parnet object for drawing
        function setParent( obj, parent )
            % Set axes
            set( obj.robotLineObject, 'Parent', parent );            
            % Set unvisible
%         	set( obj.robotLineObject, 'Visible', 'on');
            set( obj.hGroup, 'Visible', 'on');
            
            for i = 1:length( obj.axesList )
                obj.axesList(i).setParent( parent );
            end
            
        end
        
%         %% Draw function
%         function draw( obj, axes )            
%             % If object  not visible
%             if obj.Visible == false
%                 return;                
%             end
%            
%             if isempty( obj.robotLineObject )
%                 % Make line object
%                 obj.robotLineObject = line( obj.robotDrawPoints( :, 1  ),   ...
%                                             obj.robotDrawPoints( :, 2  ),   ...
%                                             obj.robotDrawPoints( :, 3  ),   ...
%                                             'Parent',       axes,           ...
%                                             'Color',        obj.Color,      ...
%                                             'LineWidth',    3               );
%             else
%                 obj.robotLineObject.XData = obj.robotDrawPoints( :, 1  );
%                 obj.robotLineObject.YData = obj.robotDrawPoints( :, 2  );
%                 obj.robotLineObject.ZData = obj.robotDrawPoints( :, 3  );
%             end
%                                     
%             % Draw axes
%             for i = 1:length( obj.axesList )
%                 % Draw next axes
%                 obj.axesList(i).draw(axes);
%             end
%         end
    end
        
    methods ( Access = private )
        % Initialize robot struct
        initializeJoints( obj ); 
        
        % Recalculate joints transformation matrix   
        function updateJoints( obj )
            % For all joints
            for i = 1:length( obj.Joints )
                
                % Translate matrix
                tmtx = trvec2tform( obj.Joints(i).translationVec .* obj.Joints(i).length );
                % Rotate vector + angle 
                rmtx = axang2tform( [ obj.Joints(i).rotationVec obj.Joints(i).rotationAngle ] );

                obj.Joints(i).fmtx = rmtx * tmtx; 

                if i > 1
                   obj.Joints(i).fmtx = obj.Joints(i-1).fmtx * obj.Joints(i).fmtx;
                end
                
                % Referance for use
                mtx = obj.Joints(i).fmtx;
                
                % Calculate position
                point = [ 0 0 0 1 ]';
                point = mtx * point;
                
                % Append point
                obj.robotDrawPoints( i, 1:3 ) = point( 1:3 );
                                 
                % Set transformation
                obj.axesList(i).setTransformMat( mtx );
            end            
                % Update robot drawing
                obj.robotLineObject.XData = obj.robotDrawPoints( :, 1  );
                obj.robotLineObject.YData = obj.robotDrawPoints( :, 2  );
                obj.robotLineObject.ZData = obj.robotDrawPoints( :, 3  );
                
%                 obj.robotLineObject.Color       = obj.Color;                                
%                 obj.robotLineObject.LineWidth   = 3;         
        end
    end   
end

