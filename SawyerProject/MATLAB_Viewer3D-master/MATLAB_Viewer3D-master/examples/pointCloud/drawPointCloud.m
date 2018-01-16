%% This example show how to create and visualize Point Cloud.
clc
close all
% clear all

%% Import packages ********************************************************
import Viewer3D.*;
import Viewer3D.Tools.*

%% Testing axes ***********************************************************
% Make figure
hFigure  = figure( 1 );
% Appen call back function
hFigure.CloseRequestFcn  = @closeFigureCallback;

% Get path to current projectdir
scriptPath = mfilename('fullpath');
scriptPath = scriptPath( 1:end-length( mfilename ) );
% Get current axis
hAxis                   = axes( hFigure, 'Tag', 'basicAxes' );
% Create new scene
hBasicScene             = Viewer3D.GUI.Scene3D( hAxis, scriptPath );
%  Append handle to User data
hFigure.UserData.hScene = hBasicScene;

hAxis = gca;
%%  Add Graphic objects ***************************************************
    % Axes for debug drawing
    hTestAxes = Viewer3D.Primitives.Axes();
    % Add new drwable objects
    hTestAxes.setParent( hAxis );
    % Change visible
    %hTestAxes.Visible = false;
    
    % Make projector
    resolution  = [ 5, 5 ];           % Test resolution
    distance    = 5;                  % Test distance
    % Get vector fild
    vectors     = Viewer3D.Tools.Projector( resolution, distance );
    
    % Build depths
    depthMap = eye( resolution(1) );
    
    % Find indexes
    depthIdx = find( depthMap );
    depthMap = depthMap( depthIdx );
    
    tempPoints  = permute   ( vectors.VectorMap, [ 3 2 1] );
    points      = tempPoints( 1:3, depthIdx )';
      
    pointsCoods = bsxfun( @times, points, depthMap(:) );
    
    % Create Point Cloud
    hPointCloud         = pointCloud(  points(:, :) );
	pointscolor         = uint8( zeros( size( hPointCloud.Location ) ));
    hPointCloud.Color   = pointscolor;   
    
  	% Draw points
    hgPointCloud = pcshow(	hPointCloud,        ...
                            'MarkerSize',   50,  ...
                            'Parent',       hAxis   );
                     
    %///////////////////////////////////////////////
%     tempVector = vectors.VectorMap * 2;
% 	% Create Point Cloud
%     hPointCloud_1         = pointCloud(  tempVector( :, :, 1:3 ) );
% 	pointscolor           = uint8( ones( size(hPointCloud.Location )) * 51 );
%     hPointCloud_1.Color   = pointscolor;
%     
%   	% Draw points
%     hgPointCloud_1 = pcshow(	hPointCloud_1,       ...
%                                 'MarkerSize',   20,  ...
%                                 'Parent',       hAxis   );
    %///////////////////////////////////////////////
                        
% 	hgPointCloud.C(:) = 0;
%
% 	permute( vectors.VectorMap( :, :, 1:3 ), [3 2 1 ] );
    
%     pX = vectors.VectorMap( :, :, 1 );        
%     pY = vectors.VectorMap( :, :, 2 );        
%     pZ = vectors.VectorMap( :, :, 3 );
    % Draw points
    
%     pointArray = vectors.VectorMap( :, :, 1:3 );
    
%     hPointCloud         = pointCloud(  vectors.VectorMap( :, :, 1:3 ) );
%     hPointCloud.Color   = uint8( zeros( 8, 4, 3  ) );
    
%     pcshow(   	hPointCloud, ...
%               	'Parent',   hCurrentAxes );
% 
%     figure( 2 );
%     pcshow( hPointCloud, 'MarkerSize', 6  );
    
%     hg = hggroup;
    
%     % Draw points
%     hLine1 = line(      vectors.VectorMap( :, :, 1 ), ...
%                         vectors.VectorMap( :, :, 2 ), ...
%                         vectors.VectorMap( :, :, 3 ), ...
%                         'Parent',   hAxis , ...
%                         'LineStyle',  'none' , ...
%                         'Marker',   '.'             );
                
% 	% Create depth map
%     testDistance    = 2;
%     % Allocate matrix
%     depthMap        = ones( resolution ) * testDistance;
%     
%     % Build scaled point cloud
%     secondPC( :, :, 1 ) =  testDistance .* vectors.VectorMap( :, :, 1 );
%     secondPC( :, :, 2 ) =  testDistance .* vectors.VectorMap( :, :, 2 );
%     secondPC( :, :, 3 ) =  testDistance .* vectors.VectorMap( :, :, 3 );
% 
% %     hLine(2) = copyobj( hLine(1), hg );
% 	% Draw points
%     hLine2 = line(	secondPC( :, :, 1 ), ...
%                         secondPC( :, :, 2 ), ...
%                         secondPC( :, :, 3 ), ...
%                         'Parent', hCurrentAxes ,    	 ...
%                         'Marker',   '*'             );
%                     
%     drawnow
 
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
