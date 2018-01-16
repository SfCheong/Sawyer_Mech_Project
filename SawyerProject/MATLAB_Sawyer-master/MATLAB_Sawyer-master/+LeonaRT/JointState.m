classdef JointState < handle
    %JOINTPOSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id = -1;
        
        position = [];
        velocity = [];
        effort   = [];
    end
    
    methods
        %% Constructor
        function obj = JointState( msg )
            % Check input parametrs
            if nargin < 1
                % Initialize by default                
            else            
                % Check is message correct
                if  ~strcmp( msg.MessageType, 'sensor_msgs/JointState')
                    error('Wrong message type..');
                end

                % Initialize proterties
                obj.id       = msg.Header.Seq;

                obj.position = msg.Position( 2:end-1 );
                obj.velocity = msg.Velocity( 2:end-1 );
                obj.effort   = msg.Effort  ( 2:end-1 );
            end
        end
        
        %% Set angles values
        function setAngles( obj, angles )
            % Set new angles
            obj.position = angles;
        end
        
        %% Open file
        function open( obj, fileName )
        end
        
        %% Save data to binary
        function append( obj,  msg )
        end
        
         %% Close file
        function close( obj, fileName )
            % append counter to the file header
            % append struct length
        end
        
        %% Load data from binary
        function load( obj, fileName )
        end
    end
    
end

