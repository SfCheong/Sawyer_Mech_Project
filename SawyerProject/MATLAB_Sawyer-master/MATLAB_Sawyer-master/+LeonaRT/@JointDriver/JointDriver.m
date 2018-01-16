classdef JointDriver < Joint
    %JOINTDRIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        angleTarget     = [];        	% Target angle for joint

        speedAccel      = 0;         	% Acceleration value
        speedMaximum    = 0;            % Maximum motion speed
        speedCurrent    = 0;            % Current motion speed
    end
    
    methods
        %% Constructor
        function obj = JointDriver( angle, constaraints, maxSpeed, accel )
            % Initialize supreclass
            obj@Joint( angle, constaraints );
            
            % How to read default accel and speed from sawyer?
            
            % Set current angle
            obj.angleTarget = obj.angle;
            
            obj.speedAccel  = accel;
            obj.maxSpeed    = maxSpeed;
        end
        
        function reset( obj )
            % reset current speed
            obj.speedCurrent = 0;
        end
        
        %% Set new speed
        function set.speedMaximum( obj, value )
            % Set new value
            obj.speedMaximum = value;
        end
        
        %% Set new target angle
        function set.angleTarget( obj, value )
            % Check constarints
            value = obj.angleCheckConatraints( value );
            % Set new value
            obj.angleTarget = value;            
        end
        
        %% Update positon
        % dTime: delta time - timde dilay from last update
        function update( obj, dTime )
            % Chwck current state
            if obj.speedCurrent < obj.speedMaximum
                % Calculate new speed
                obj.speedCurrent = obj.speedCurrent + obj.speedAccel * dTime;
            end
            
            % Check current angle
            if abs( obj.angleTarget ) < abs( obj.angle )
                % Calculate direction
                direction = abs( obj.angleTarget ) < abs( obj.angle );
                % Calculate angle differense
                tempAngle =  + obj.speedCurrent * dTime;
                % Calculate new angle
                obj.angle = obj.angle + tempAngle * direction;
            end
        end
    end
    
end

