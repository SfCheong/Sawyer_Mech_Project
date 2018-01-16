classdef Joint < handle
    %JOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( Access = protected )
        angle             = 0;              % Current joint angle        
        angleConstaraints = [-10 10];       % Joint angle constraint
        
        % Joint connection points coordinates
        % Rotation Axis 
        % Motion type ( LINAR, ROTATION )
        
        % Joint length
        
        % I (ones, eye) Convertion matrix
    end
    
    methods
        %% Constructor
        function obj = Joint( angle, constaraints )           
            % Set constarints
            obj.angleConstaraints   = constaraints;
            obj.angle               = angle;
        end
        
        %% Set current 
        function set.angle( obj, value )
            % Chack constraints
            value = obj.angleCheckConatraints( value );                
            % update angle
            obj.angle = value;
        end
        
        %% Check joint constaints
        function value = obj.angleCheckConatraints( obj, value )
            % If |value| >  2pi 
                % deived by 2pi for find numbers of cercles
                % |value| = |value| - 2*pi*cercles number
                % back sign
            
            % check for low boarder
            if value < obj.angleConstaraints(1)
                value = obj.angleConstaraints(1);
            end
            
            % check for hight boarder
            if value > obj.angleConstaraints(2)
                value = obj.angleConstaraints(2);
            end 
        end
        
        %% Set constaints
        function set.angleConstaraints( obj, value )         
            % Check constraint vector length
            % Check constraints values position ( max > min )
            
            % Update values
            obj.angleConstaraints(1) = value(1);            
            obj.angleConstaraints(2) = value(2);
        end
        
        %% EXPORT 2 points for Model Viewer
            % - connection point
            % - joint output point
    end
    
end

