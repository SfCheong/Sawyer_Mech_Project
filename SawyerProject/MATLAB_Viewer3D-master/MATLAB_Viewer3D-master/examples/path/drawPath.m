%% Show simple 3D scene. Save and load Axes parameters
clc
close all
% clear all

%% Import packages ********************************************************
import Viewer3D.*;      

%% Testing axes ***********************************************************
% Make figure
hFigure  = figure( 1 );
% Appen call back function
hFigure.CloseRequestFcn  = @closeFigureCallback;

% Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis                   = axes( hFigure, 'Tag', 'pathAxis' );
% Create new scene
hBasicScene             = GUI.Scene3D( hAxis, scriptPath );
%  Append handle to User data
hFigure.UserData.hScene = hBasicScene;

hAxes = gca;

%% Trajectory Circle
% A circle to be traced over the course of 10 seconds
t               = (0:0.2:10)';
count           = length(t);
center          = [0 0 2];
radius          = 3;

% Deviation of angle every 0.1s
theta           = t * ( 2*pi / t(end) );

% Coordinates of points on trajectory
trajecPoints    = radius * [ cos(theta) sin(theta) zeros( size(theta) ) ] + center;

%% Calculate orientation vect[ors
% Vector of point to goal. Goal is center of circle in this example
goal                = [0 0 0];
point2CenterVectors = goal - trajecPoints ;


% Calculate angle between point2CenterVectors and x-axis
% omega = Tools.GeometricTransform.calculateOrientation( point2CenterVectors);

xVector = [ 0 0 0 1; 
            1 0 0 1 ]';
       
xVect       = repmat( [1 0 0], length( point2CenterVectors ), 1 );

orientation = repmat( [0 0 0 0], length( point2CenterVectors ), 1 );
        
for i = 1:length( point2CenterVectors )

    
        % Create transform matrix 
%     transM  = makehgtform( 'translate'  , trajecPoints(i,:) );
% 
%     rotMat  = makehgtform( 'zrotate', omega(i, 1 ), ...
%                            'yrotate', omega(i, 2 ), ...
%                            'xrotate', omega(i, 3 ) );
                       
%     rotMat  = makehgtform( omega(i) );
    orientation(i,:) = vrrotvec( xVect(i, :) , point2CenterVectors(i, :));
    
%     rotMat  = vrrotvec( xVect(i, :) , point2CenterVectors(i, :));
%     rotMat  = axang2tform( rotMat );
% 
%    res  = (transM * rotMat) * xVector(:, :); 
%     
%     line(   [ trajecPoints(i, 1) goal(1) ], ...
%             [ trajecPoints(i, 2) goal(2) ], ...
%             [ trajecPoints(i, 3) goal(3) ],...
%             'Color', 'r'        );
%         
%     line(   res( 1, : ), ...
%             res( 2, : ), ...
%             res( 3, : )       );
end

% %% Calculate angle between point2CenterVectors and x-axis
% % calculate cross product
% crossProd           = cross(xVector,point2CenterVectors) ;
% 
% % calculate dot Product
% dotProd             = dot(xVector',point2CenterVectors');
% % Normalize cross product
% normCrossProd       = sqrt(sum(crossProd .^ 2, 2));
% % Find angle
% omega               = deg2rad(atan2d(normCrossProd, dotProd'));
% 
% for i = 1:length(omega)
%    if crossProd(i,3) < 0
%     omega(i)     = 2*pi - omega(i) ;
%    end
% end

% % Method with cosine
% normProd            = sqrt(sum(xVector .^ 2,2)) + sqrt(sum(point2CenterVectors .^ 2, 2));
% cosOmega            = dotProd' / normProd;
% omega               = deg2rad(acosd(cosOmega));
 
%%  Add Graphic objects ***************************************************
% Create path object
hTestPath = Viewer3D.Primitives.Path(trajecPoints,orientation);

hTestPath.setParent(hAxes);

% Axes for debug drawing
hTestAxes = Viewer3D.Primitives.Axes();

% Add new drwable objects
% hBasicScene.append( hTestAxes );
% Change visible
%hTestAxes.Visible = false;

%% Save axis parameters befor figure will close ***************************
function  closeFigureCallback( src, data )
    % Show debug message
    disp( 'closeFigureCallback: Try to close..' );
    
    % Scene was append
    if ~isempty( src.UserData )
        % save scene
        delete( src.UserData.hScene );
    end
    
    % Close figure
    delete( gcf );
end
