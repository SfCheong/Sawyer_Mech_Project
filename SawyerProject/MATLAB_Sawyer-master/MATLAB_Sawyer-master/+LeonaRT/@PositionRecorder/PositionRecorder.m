classdef PositionRecorder < handle
    %POSITONRECORDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileType = [];          % file type for data record
        
        % cotaner MAP by file type ????
        txtFileID   = [];
        binFileID   = [];
        
        jointStateList	= [];
        jsCounter       = 0;
    end
       
    properties ( Constant )
        % File types
        BINARY  = 1;
        TEXT    = 2;
        BOTH    = 3;
        JOME    = 4;        
        MAT     = 5;
        
        JOINT_STATE_BASE_SIZE = 1000;
    end
    
    methods
        %% Constructor:
        % projectPath   = Project folder for save motion data
        % fileBaseName  = base name for resalt file
        % fileType      =  
        function obj = PositionRecorder( projectPath, fileBaseName, fileType )
            % Set default values
            if nargin < 3 || isempty( fileType )
                fileType = obj.BOTH;
            end

            if nargin < 2 || isempty( fileBaseName )
                fileBaseName = 'test';
            end     

            if nargin < 1 || isempty( projectPath )
                projectPath = '';
            end
            
            % Save selected file type
%             obj.fileType = fileType;
            
            % Open text file
%             obj.txtFileID = fopen( [ projectPath '/' fileBaseName '.txt'] ,'w');
            
            % Open binary file
%             fid = fopen('nine.bin');
%             col9 = fread(fid);
%             fclose(fid);

            % Set default list
            obj.clean();
        end
        
        %% Destructor
        function delete( obj )
            % Close all files
            % if steel open
                % fclose()
        end
        
        %% Is empty
        function res = isemty( obj )
            res = true;
            if obj.jsCounter > 0
                res = false;
            end
        end
        
        %% Return length of available states
        function res = length( obj )
            % Return length of list
            res = obj.jsCounter;
        end
        
        %% Return state by number
        function jointSate = getJointState( obj, number )
            % Initialize as empty
            jointSate = [];
            % If list is empty
            if obj.jsCounter <= 0
                return;
            elseif number < 1
                % Return first element
                jointSate = obj.jointStateList( 1 );
            elseif number > obj.jsCounter
                % Return last element
                jointSate = obj.jointStateList( obj.jsCounter );
            else
                % Return spasify state
                jointSate = obj.jointStateList( number );
            end                
        end
        
        %% Clean current record list
        function clean( obj )
            % Clean old array
            obj.jointStateList	= repelem( LeonaRT.JointState(), obj.JOINT_STATE_BASE_SIZE );
            % Reset counter
            obj.jsCounter       = 0;
        end
        
        %% Save file
        function save( obj, fileName )
            % Debug message
            disp( 'PoistionRecoeder: Save list to file...' );
            % Create file 
            % Save list of joint states
        end
        
        %% Load file
        function load( obj, fileName )
            % Debug message
            disp( 'PoistionRecoeder: Load list from file...' );
            % Open file 
            % Read all data to list
        end
        
        %% Add record to joint state list
        function append( obj, msg )
            % Debug message
            disp(' PositionRecorder: Append joint state...');
            
            % Increment counter
            obj.jsCounter = obj.jsCounter + 1;
            obj.jointStateList( obj.jsCounter ) = LeonaRT.JointState( msg );

            if obj.jsCounter == obj.JOINT_STATE_BASE_SIZE
                % Show information 
%                 warning( 'jointPositionCallback: Extend array ... ' );                
                % Extend array
                obj.extendList();
            end            
        end
        
        %% Reduce list
        function reduce( obj )
            % Reduce array
            obj.jointStateList = obj.jointStateList( 1:obj.jsCounter );
            
            % Debug message
            disp( ['PositionRecorder: Reduced to '  num2str(obj.jsCounter) ' elements.' ] );
        end
        
    end
    
    methods(Access = private)
        %% Extend joint state list
        function extendList( obj )
            % allocate additonal space
            additionalPlace = repelem( LeonaRT.JointState(), obj.JOINT_STATE_BASE_SIZE );
            % Append additonal space
            obj.jointStateList = [ obj.jointStateList additionalPlace ];
            % Debug message            
            disp( 'PositionRecorder: New space allocated' );
        end
    end
    
end

