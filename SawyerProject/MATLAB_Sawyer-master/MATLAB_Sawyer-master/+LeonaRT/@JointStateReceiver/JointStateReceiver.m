classdef JointStateReceiver < handle
    %JOINTSTATERECEIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Private properties
    properties( Access = public )
        % Joint State subscriber ******************************************
        jointPoseSubsciber;         % state subscriber
        lastJointMessage;           % save last receved message   
        
      	% Motion publisher ************************************************
        targetPositionPublisher;    % Publish target position
        targetPositionMessage;      % Target position description
        
        % Motion control **************************************************
        hMotionTimer;       % Timer for callback clocking
        isMoving = false;           % Flag for moving in new position
        
        lastDiff        = [ 0 0 0 0 0 0 0 ]'; % Containe last save
        lastFiltered    = [ 0 0 0 0 0 0 0 ]';
    end
    
    %% Class events
    events 
      JointStateUpdated;     	% New joint state was received
      
      MotionStart;          	% Start robot motion 
      MotionDone;               % Last motion done
    end
    
    methods
        %% Constructor
        function obj = JointStateReceiver()
            % Make subcrier ***********************************************
            obj.jointPoseSubsciber = rossubscriber( '/robot/joint_states'   ,...
                                                    'sensor_msgs/JointState',...
                                                    'BufferSize',       1           );
            
            % Connect callback function
            obj.jointPoseSubsciber.NewMessageFcn = {@obj.jointPositionCallback};
            
%             obj.lastJointMessage = rosmessage('sensor_msgs/JointState');
            % Make publisher **********************************************
            obj.targetPositionPublisher	= rospublisher( '/robot/limb/right/joint_command', 'intera_core_msgs/JointCommand' );
            
            % Make message object
            obj.targetPositionMessage 	= rosmessage( 'intera_core_msgs/JointCommand' );
            % Initialize message
            obj.targetPositionMessage.Names           = { 'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'   };
            obj.targetPositionMessage.Mode            = obj.targetPositionMessage.POSITIONMODE;
%             obj.targetPositionMessage.Mode            = obj.targetPositionMessage.TRAJECTORYMODE;
            obj.targetPositionMessage.Header.Stamp    = rostime('now');
            
            jointsAngle = [ 0 0 0 0 0 0 0 ];
            obj.targetPositionMessage.Position        = deg2rad( jointsAngle );            
            
            % Run internal timer ******************************************
            obj.hMotionTimer                = timer();
            obj.hMotionTimer.ExecutionMode  = 'fixedRate';
            obj.hMotionTimer.Period         = 0.005;
            obj.hMotionTimer.TimerFcn       = @obj.motionTimerCallback;
            
            % Start clocking
            start( obj.hMotionTimer );
            
        end
        
        %% Destructor
        function delete( obj )       
            stop  ( obj.hMotionTimer );
            delete( obj.hMotionTimer );
            
            delete( obj.jointPoseSubsciber    );
            delete( obj.targetPositionPublisher );
        end 
    
        %% Return last message
        function msg = get.lastJointMessage( obj )
            % Initialize
            msg = [];
            % I f already not empty
            if ~isempty( obj.lastJointMessage )
                % return message
                msg = obj.lastJointMessage;
            end
        end
        
        %% Set new target position
        function setPosition( obj, jointState )
            % Create new control message
            obj.targetPositionMessage.Header.Stamp    = rostime('now');
            obj.targetPositionMessage.Position        = jointState.position;
            
            if ~isempty( jointState.velocity )
                obj.targetPositionMessage.Velocity = jointState.velocity;
            end
            
            % Change state
            obj.isMoving = true;
        end
        
    	%% Motion function for timer
        function motionTimerCallback( obj, src, event )
            % Debug message
%             disp( 'Timer callback...'  );
            
            if  obj.isMoving
                % Update header
            	obj.targetPositionMessage.Header.Stamp    = rostime('now');
                % Send motion message   
                obj.targetPositionPublisher.send( obj.targetPositionMessage );
            end
        end
    end
      
    methods( Access = private )
        %% Callback function
        function jointPositionCallback( obj, src, msg )
            
            % Initialize message
            if isempty( obj.lastJointMessage )
                obj.lastJointMessage = msg;
            end
            
            % Checking feedback seqense
            diffId = msg.Header.Seq - obj.lastJointMessage.Header.Seq;            
            if diffId ~= 1
                disp( ['Loosed ' num2str(diffId) ' frames!!' ] );
            end
            
            % Filter position
            filteredPos = obj.lastJointMessage.Position(2:8) - 0.1 * msg.Position(2:8);
            % Calculate diff
            diff = obj.lastFiltered - filteredPos;
            
            % Set it like target
            if  obj.isMoving
                % Update header
            	obj.targetPositionMessage.Header.Stamp    = rostime('now');
                % Send motion message   
                obj.targetPositionPublisher.send( obj.targetPositionMessage ); 
                
                disp( ['First diff:' num2str( diff') ] );                
                
                if isempty( find( diff, 1 ) )
                    % Stop motion
                    obj.isMoving = false;
                    % Send notifycation
                    notify( obj, 'MotionDone' );
                end                
            end 

            % Update last message
            obj.lastJointMessage = msg;
            % Update filtered;
            obj.lastFiltered = filteredPos;

            % Forward new state
            notify( obj, 'JointStateUpdated' ); 
            
            % debug message
%             disp( 'New position received...');
        end
    end
    
end

