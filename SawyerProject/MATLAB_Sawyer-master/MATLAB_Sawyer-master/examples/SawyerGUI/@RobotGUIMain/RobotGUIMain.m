classdef RobotGUIMain < handle
    %ROBOTGUIMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties % (Access = private )
        % Robot FK/IK model ***********************************************

        
        % Robot 3D drawing ************************************************
        hScene             = [];        % Scene object
        
        hRobotCurrentState = [];       	% Robot model
        hRobotTargetState  = [];      	% Target state        
       
        needRedraw  = false;            % Need to redraw
        
        % Joint state properies
        hSawyerMotionController = [];	% Motion controller
        
        % Path generation *************************************************
        
        
        % Motion Player ***************************************************
        isRecording      = false;   % Recording position state
        
        isWaitPlayback   = false;   % Waiting for playback initialization 
        isPlayback       = false;   % Is playbacking
        
        listSize         = 0;       % Size of state list
        frameNumber      = 0;       % Number of playback frame
        frameStep        = 1;       % Step frame for feedback
        
        playbackMod      = [];      % Type of playback ( single or loop )
        
        positionRecorder = [];      % Positon recorder object         
        % *****************************************************************
    end
    
    methods
        %% Constructor
        %   robotAxis: axis for drawing robbot model
        function obj = RobotGUIMain( robotAxis )
            % Clean command line
            clc;
            % Initialize ROS
            rosshutdown;
            rosinit;
            
            % Get path to current projectdir
            scriptPath = mfilename('fullpath');
            obj.hScene = Viewer3D.GUI.Scene3D( robotAxis, scriptPath );
            
            % Sawyer current state representation *************************
            obj.hRobotCurrentState       = LeonaRT.SawyerModel();
            % Set color
            obj.hRobotCurrentState.Color = [ 0.0, 0.7, 0.0 ];
            % Change visible
            % obj.hRobotCurrentState.Visible = false;
            % Append to scene
            obj.hRobotCurrentState.setParent( obj.hScene.hAxes );

            % Sawyer target state representation **************************
            obj.hRobotTargetState        = LeonaRT.SawyerModel();
            % Set color
            obj.hRobotTargetState.Color  = [ 1.0, 0.0, 0.0 ];
            % Change visible
          	% obj.hRobotTargetState.Visible = false;
            % Append to scene
            obj.hRobotTargetState.setParent( obj.hScene.hAxes );
           
            % Initialize motion controller*********************************
            obj.hSawyerMotionController = LeonaRT.JointStateReceiver();
            % Add lisener
            addlistener(	obj.hSawyerMotionController, ...
                            'JointStateUpdated', @obj.jointStateListener );
                        
            addlistener(	obj.hSawyerMotionController, ...
                            'MotionDone', @obj.motionDoneListener );
                        
            % Initialize recorder class ***********************************
            obj.positionRecorder =  LeonaRT.PositionRecorder();            
            
        end
        
        %% Destructor
        function delete( obj )
            % Stop ROS comunications
            delete( obj.hSawyerMotionController );
            % Save axes
            delete( obj.hScene );
        end
        
        %% Change input forms state  
        updateInputAngleForms( obj, hObject, eventdata, handles );
        
        % Motion Player ***************************************************
        %% Record button
        function recordButton( obj, newState )
            disp( 'Record button pressed...' );
            % Check new state
            if newState
                % Clean old array
                obj.positionRecorder.clean();
                % Change record state
                obj.isRecording = true;
            else                
                % Change record state
                obj.isRecording = false;
                
                % Reduce array
                obj.positionRecorder.reduce();
                
                % Past process recorded data
                
            end
        end
        
        %% PlayBack button change state
        function playButton( obj, newState )
            disp( 'Play button pressed...' );
            
            if newState
                % If list is empty
                if obj.positionRecorder.isemty()
                    % Show information dialog
                    warndlg( 'Nothing for play', 'List is empty' );
                    
                    % Back button to unpressed state ???
                    return
                end
                
                % Set waiting for playback initialization done
                obj.isWaitPlayback   = true;
                obj.isPlayback       = false;
                
                % Read list lengh
                obj.listSize    = obj.positionRecorder.length();
                % Get first joint state 
                jointState      = obj.positionRecorder.getJointState( 1 );
                % Initialize increment direction
                obj.frameStep   = 1;
                % Initialize frame counter
                obj.frameNumber = 0;
                
                % Move to start position
                obj.hSawyerMotionController.setPosition( jointState );
                
            else
                % Stop playback
                % Set IDL state
                obj.isWaitPlayback   = false;
                obj.isPlayback       = false;                
            end 
        end
        
        %% Save current JointState List
        function saveStatesButton( obj )
            disp( 'Save button pressed...' );
            
            % If list is empty
            if obj.positionRecorder.isemty()
                % Show information dialog
                warndlg( 'Nothing for save', 'List is empty' );
                return
            end               
            
            % Save recorded data                
%             uisave( { obj.positionRecorder }, 'stateRecords' ); 
                
%             % Read project default path
%             baseProjectPath = getenv( 'MY_SLAM_PROJECT_PATH' );
%             % Add file mask 
%             fileMask = { '*.bjs;', 'Binary Joint State (*.bjs)' };
%             % Open folder dialog
%             [filename, pathname, filterindex] = uiputfile(  fileMask,       ...
%                                                             'Save motion as..',    ...
%                                                             baseProjectPath     );
% 
%             
%             disp( fullfile( pathname, filename) );
%             % Save list to file
%             obj.positionRecorder.save( fullfile( pathname, filename) );           
                
      
        end        
                
        %% Save current JointState List
        function loadStatesButton( obj )
            disp( 'Load button pressed...' );
            
            % Read project default path ***********************************
            baseProjectPath = getenv( 'MY_SLAM_PROJECT_PATH' );
            % Add file mask 
            fileMask = { '*.bjs;', 'Binary Joint State (*.bjs)' };
            % Open folder dialog
            filename = uigetfile(  fileMask, 'Load motion', baseProjectPath  );
            
            % Load list from file
            obj.positionRecorder.load( filename );
        end        
        % *****************************************************************
        
        %% Draw function
        function redraw( obj )
            % Redraw robot
            cla( obj.robotAxis );             
            obj.robotCurrentState.drawRobot( 'axis', obj.robotAxis );
        end
    end
    
    methods ( Access = private )
        %% Initialize axis parameters 
        initRobotAxis( obj );
                    
        %% Joint position callback liseners
        function jointStateListener( obj, src, evnt )
%             disp( 'jointStateListener: Notify reseived...' );
            % Save last message
            msg = obj.hSawyerMotionController.lastJointMessage();
            % Save in this class
%             obj.lastJointStateMessage = msg;

            angles = msg.Position( 2:8 );
            % Update current state
            obj.hRobotCurrentState.setJointAngle( angles );

            % Display cyrrent position for debug
%             disp( [ 'Current position: ' num2str( msg.Position') ] );
            
            % If recording now
            if  obj.isRecording
                disp( 'jointStateListener: Append state...' );
                % Append new record
                obj.positionRecorder.append( msg );
            end

            % Play back recorded motion
            if obj.isPlayback                
                % Increment counter 
                obj.frameNumber =  obj.frameNumber + obj.frameStep;
                % Get next joint state 
                jointState      = obj.positionRecorder.getJointState( obj.frameNumber );
                % Move to new position
                obj.hSawyerMotionController.setPosition( jointState );
                 
                obj.listSize    = obj.positionRecorder.length();
                
                % If counter == list length
                if	obj.frameNumber > obj.listSize || ...
                    obj.frameNumber < 1
                    % invert increment direction
                    obj.frameStep = obj.frameStep * -1;
                end
            end
            
        end
        
        %% Joint position callback liseners
        function motionDoneListener( obj, src, evnt )
            % Notify received
            disp( 'motionDoneListener: Motion done...' );
            
            % If check for start playback
            if obj.isWaitPlayback
                % Reset waiting
                obj.isWaitPlayback   = false;
                % Start playback
                obj.isPlayback       = true;
            end
        end
    end
    
end

