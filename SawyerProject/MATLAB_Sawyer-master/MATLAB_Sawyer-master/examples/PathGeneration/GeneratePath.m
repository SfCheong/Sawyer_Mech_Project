%% This script is simulate angles ( sin - function )

%% Clear all
clc;
% close all;

import LeonaRT.*;

% (!!!) Read default values for speed (!!!)

%% Input data *************************************************************
% Time in second
minutesDuration = 0.3;
minutesDuration = single( minutesDuration );

% Set time for full rotation ( 2 * pi radians )
baseTimeForCircle   = 2;                            % [ seconds ]
baseTimeForCircle  	= single( baseTimeForCircle );

% Scale factors for joints
velocityScale   = repelem( single( 1.0 ), 7 );
velocityScale( 2 ) = 0.2;
velocityScale( 2 ) = 0.2;

% Phase displacement ( phi ) ( %  of period )
phase	=  repelem( single( 0.0 ), 7 );

% Amplitud factor
amplitude	= repelem( single( 1.0 ), 7 );

% Hight level    ( %  of amplitude )
higth	=  repelem( single( 0.5 ), 7 );
% Low level     ( %  of amplitude )
low     =  repelem( single( 0.5 ), 7 );

% Biases
bias	=  repelem( single( 0.0 ), 7 );

%% Velocity calculation ***************************************************
% Calculate velosity for main
baseVelocity = single( (2 * pi) / baseTimeForCircle );        % [ rad/sec ]

% !!! Normalize velosityScale !!!

% Calculate scaled velocity
velocity = baseVelocity * velocityScale;

%% Calculate angles *******************************************************
% Translate in seconds
seconds = minutesDuration * 60;
% Duratoin time ( Message duration interval )
step    = 0.01;
% Calculate time line
time    = 0:step:seconds;

% Calculate  
% angle = Amplitude * sin( Omega * time ) + Bias;

% Calculate base
% angle = amplitude * sin( velocity' * time ) + phase;
angle = sin( velocity' * time ) + phase';

%% Plot results ***********************************************************
% Set current figure
hFig	= figure( 1 );
% Clean figure
delete( hFig.Children );

% Save start time for profiling
startTime = tic;

% Create new line
hLine = line(   time, angle, ...
                'Visible', 'on' );

% Show all results
for i = 1:length( hLine )
    % Next axes 
    hAxis(i) = subplot(7, 1, i);
        
    hAxis(i).XGrid = 'on';
    hAxis(i).YGrid = 'on';
    hAxis(i).ZGrid = 'on';
    
    hLine(i).Color  = rand(1,3);
end
   
% Set for axes
hLine(i).Parent = hAxis(i);
  
% hLine.Color     = 'r';
% hLine.Parent    = repelem( hAxis, 7);
    
% Save ploting time 
plotTime  = toc( startTime );

% Plot profiling result
disp( ['Plot time:' num2str(plotTime) ] );

%% Simulation model
fkModel = SawyerModel();

%%
figure(2);

for i = 1:length( time )
    fkModel.setAngles( angle( i ) );
end

    




            
