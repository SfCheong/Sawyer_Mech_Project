%% Save Point Cloud if it is necessory ************************************
% pcPart = outputPointCloud;
% 
% savePath = [slamData.projectPath 'matlab_output/pcForOctTree.mat'];
% save(savePath, 'pcPart' );
% 
% clear savePath

%% Read data***************************************************************
dataReading

loadPath = [slamData.projectPath 'matlab_output/pcForOctTree.mat'];
load(loadPath );

clear loadPath

%% Reduce points **********************************************************
% Make copy
% pcPart =  pcPart;
% Reserve variable
tempLogic = ones( length( pcPart ), 1 );

% x - min
tempLogic = tempLogic & pcPart(:,1) > -6;
% x - max
tempLogic = tempLogic & pcPart(:,1) < 7;

% y - min
tempLogic = tempLogic & pcPart(:,2) > -15;
% y - max
tempLogic = tempLogic & pcPart(:,2) < 4;

% z - min
% tempLogic = tempLogic & inputPointCloud(:,3)
% z - max
tempLogic = tempLogic & pcPart(:,3) > -0.1;

% [a,b] = hist(tempLogic,unique(tempLogic))

% Delete points
pcPart( ~tempLogic, : ) = [];  

%% Show interested scene **************************************************
pointCloudScene                 = pointCloud( pcPart(:, 1:3) );
% Append point colors
pointCloudScene.Color(:, 1:3)   = pcPart(:, 4:6);

% Try to reduce noise
% pointCloudScene = pcdenoise( pointCloudScene );

% Draw point cloud 
pcshow( pointCloudScene );

%% Make octotree **********************************************************
% pts     = (rand(200,3)-0.5).^2;
OT      = OcTree( pcPart(:, 1:3), 'maxSize', 1, 'minSize', 0.5  );    

% figure
hold on

boxH = OT.plot3;

grid on

ax = gca;
ax.XAxis.Color = 'r';
ax.YAxis.Color = 'g';
ax.ZAxis.Color = 'b';

% Finde cubes with a points
testUnique = unique( OT.PointBins );

% draw all cubes
for i = 1:length( testUnique )
    % check for children
    if ( ~ismember( testUnique(i), OT.BinParents ) )            
        % read next boundary
        boundary = OT.BinBoundaries( testUnique(i), : );
        % Draw this boundary
        drawCube( boundary, ax);
        
        disp( i );
	end
end

clear ax tform axang



% Find non em

% axis image, view(3)
% 
% cols = lines(OT.BinCount);
% 
% doplot3 = @(p,varargin)plot3( p(:,1), p(:,2), p(:,3), varargin{:} );
% 
% for i = 1:OT.BinCount
%     % Set new parameters ( color and line width )
%     set( boxH(i)    ,   ...
%         'Color'     ,   cols(i,:), ...
%         'LineWidth' ,   1 + OT.BinDepths(i) )
%     
%     % Draw points with colors
%     doplot3( pts( OT.PointBins == i, : ), '.', 'Color', cols(i,:))
% end
% 
% axis image, view(3)

%%*************************************************************************
% get conversion parameters
% se3	= slamData.allFramesBlenderData( 5703, : );
%          
% % ax = gca;
% ax.CameraPositionMode	= 'manual';
% ax.CameraPosition       = se3(1:3);
% 
% % Redraw figure
% drawnow
