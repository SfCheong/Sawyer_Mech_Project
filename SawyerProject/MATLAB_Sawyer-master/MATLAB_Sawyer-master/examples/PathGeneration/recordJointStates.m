%% Save key frames in binary format
clc

%% Reserve global variables
global lastMessage;

%% *************************** Construct path *****************************
% Get base project folder path
baseProjectPath = getenv( 'SLAM_PROJECTS_PATH' );
% If  steel empty
if isempty( baseProjectPath )
    % Use current directory
    baseProjectPath = pwd;
end

% Set reletive path to to output folder
folderPath	= '/TestProject/Sawyer/JointPosition/';
% Set file 
fileName    = 'testJointState.bjs';

% Consrtuct full file name
fullFileName = fullfile( baseProjectPath, folderPath, fileName );

%% ***************************** Open file ********************************
% Open filse for record
stateRecorder = LeonaRT.JointStateRecorder( fullFileName );

%% **************************** Append data *******************************


%% ***************************** Close file *******************************
stateRecorder.close();

%% ************************** Make new subcrier ***************************
%% Close file
hJointStateSubsciber = rossubscriber(	'/robot/joint_states',  ...
                                        'BufferSize',           50  );
% Connect feedback function
hJointStateSubsciber.NewMessageFcn = { @keyFrameCallback, outputPath };

% Callback function
function keyFrameCallback( src, msg, outputPath )
    % Copy msg for warkspace visibal
    global lastMessage;
    lastMessage = msg; 
    
    % Create new file name ( Binary Joint State = 'bjs' )
    fileName = [ outputPath 'JointPosition_' num2str( lastMessage.Header.Seq ) '.bjs'];  
    
    % Start measuring
    timeStruct.Start = tic;
    % Initialize dry data
    tempMsg = LeonaRT.JointState( msg );
    % Save time
    timeStruct.BuildDryData = toc( timeStruct.Start );
    % Start measuring
    timeStruct.Start = tic;
    % Save in file 
    tempMsg.save( fileName );
    % Save time
    timeStruct.SaveFileTime = toc( timeStruct.Start );

    %% Show results ***********************************************
    disp( '*******************************************************' );
    disp( [ 'Build dry data time: '     num2str( timeStruct.BuildDryData )	] );
    disp('');
    disp( [ 'Build depth map time: '	num2str( timeStruct.SaveFileTime )	] );
    disp('');    
    disp( ['Save to file: ' fileName] );
end