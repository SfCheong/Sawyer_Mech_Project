classdef Scene3D < handle
    %SLAM3DSCENE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %( Access = private )
        hAxes;                                      % handle to axes for control
        hCamera;                                    % camera for  current view
        
        dirPath  = 'figure';                        % Path to configuration file
        
        drawList = [];                              % list of object for redraw
        
        % !!! Move to external save/load class
        figureName = 'default figure';              % name of figure
    end
    
    methods
        %% Constructor
        % axes: handle to axes for control
        % path: path to configuration configuration file
        function obj = Scene3D( hAxes, path )
            % if path exist
            if nargin == 2
                % save path
                obj.dirPath = fullfile( path, obj.dirPath );
            end
            
            % If folder not exist
            if ~isdir( obj.dirPath )
                % Make dir 
                mkdir( obj.dirPath );
            end
            
            % Save handle
            obj.hAxes = hAxes;            
            % Try to load axes;
            obj.load();
        end
        
        %% Destructor
        function delete( obj )
            % Save scene to file
            obj.save();
        end
        
        %% Get axes handle
        function hAxes = get.hAxes( obj )
            % Save scene to file
            hAxes = obj.hAxes;
        end
         
%         %% Append new drawable object
%         function append( obj, drawable )
%             % If object incherted from IDrawable
%             
%             % Append to list
%             obj.drawList = [ obj.drawList drawable ];
%             
%             % Redraw all
%             obj.redraw();
%         end
%         
        %% Redraw all
%         function redraw( obj )
%             % Clean axes
% %             delete( obj.hAxes.Children );
%             % for objects in the list
%             for i = 1:length( obj.drawList  )
%                 % Get next object
%                	hNextObject = obj.drawList(i);
%               	% Redraw object
%                 hNextObject.draw( obj.hAxes );
%             end
%         end
        
        %% Save axes configureation        
        %% Load axes configuration
    end
    
    methods (Access = private )
        %% Set default values
        function initialize( obj )
            %************************** Appearance ************************
            % Axes box outline
            obj.hAxes.Box = 'on';
            
            % Style of axes box outline
            obj.hAxes.BoxStyle = 'full';
            
            %******************  Title, Axis Labels, and Legend ***********
            % Title
            obj.hAxes.Title.String      = obj.figureName;
%             obj.hAxes.Title.FontWeight	= 'normal';

            % Text object for axis label.
            obj.hAxes.XLabel.String     = 'Default x-Axis Label';
            obj.hAxes.XLabel.FontSize   = 12;
            
            obj.hAxes.YLabel.String     = 'Default y-Axis Label';
            obj.hAxes.YLabel.FontSize   = 12;
            
            obj.hAxes.ZLabel.String     = 'Default z-Axis Label';
            obj.hAxes.ZLabel.FontSize   = 12;
            
            % Legend associated with the axes
%             lgd = obj.hAxes.Legend;
%             if ~isempty(lgd)
%                 disp('Legend Exists')
%             end
            
            %***************** Individual Axis Appearance and Scale *******
            % Component that controls the appearance and behavior of the
            % axes
            % grid color 
            obj.hAxes.XAxis.Color = 'r';
            obj.hAxes.YAxis.Color = 'g';
            obj.hAxes.ZAxis.Color = 'b';
            
            % Minimum and maximum limits
            obj.hAxes.XLim = [-5, 5];            
            obj.hAxes.YLim = [-5, 5];            
            obj.hAxes.ZLim = [-5, 5];
        
            % ******************** Tick Values and Labels *****************
            % Tick mark locations
            obj.hAxes.XTick = -10:1:10;            
            obj.hAxes.YTick = -10:1:10;            
            obj.hAxes.ZTick = -10:1:10;
            
            % Display of minor tick marks
            obj.hAxes.XMinorTick = 'on';
            obj.hAxes.YMinorTick = 'on';
            obj.hAxes.ZMinorTick = 'on';
            
%             minTick  	= min(data(:,1));
%             maxTick  	= max(data(:,1));
%             tickSteps	= norm( [minTick maxTick], 1 )/tickNumbers;
%             range  	= round( minTick:tickSteps:maxTick, 2);
%             set( gca,	'XTick', range , 'XMinorTick',   'on'    );


            % ********************** Grid Lines ***************************
            % Display of grid lines
            obj.hAxes.XGrid = 'on';
            obj.hAxes.YGrid = 'on';
            obj.hAxes.ZGrid = 'on';

            % ********************** Aspect Ratio *************************
            % Type of projection onto 2-D screen
            obj.hAxes.Projection       = 'perspective';
            
            % Selection mode for the DataAspectRatio
            obj.hAxes.DataAspectRatioMode	= 'manual';            
            
            % ax.CameraViewAngle  = 63.44;

            % ax.XAxisLocation = 'origin';
            % ax.YAxisLocation = 'origin';
            
            view(3)
        end
        
        %% Make file path
        function fileName = getFileName( obj )
            if isempty( obj.hAxes.Tag )
                fileName = 'default.fig';
            else
                fileName = [  obj.hAxes.Tag '.fig' ];
            end
            
            % Full path
            fileName = fullfile( obj.dirPath, fileName );
        end
        
        %% Save axis configuration
        function save( obj )            
            % Make new fig
            hTempFig = figure( 'Visible', 'off' );
            % Clean object
            delete( obj.hAxes.Children );
            % Copy configurated axes
            copyobj( obj.hAxes, hTempFig );
            % Save temporary axes  
            savefig( hTempFig, obj.getFileName() );
            % Delete temporary figure
            delete( hTempFig );
            
            disp( 'Scene saved.. ' );
        end
        
        %% Load axis
        function load( obj )
%             disp( mfilename('fullpath') );
            
            % if default already axist 
            if exist( obj.getFileName(), 'file' ) ~= 2
                % Initilaize 
                obj.initialize();
            else
                % Save handle to figure
                hFigure = obj.hAxes.Parent;
                
                % Open figure
                hTempFig  = openfig( obj.getFileName() );
                % Find axes
                obj.hAxes = findobj( hTempFig.Children, 'Tag', obj.hAxes.Tag );
              	% Find axes on figure
                hTempAxis   = findobj(  hFigure.Children, 'Tag', obj.hAxes.Tag );                               
                % Set loaded axes
                obj.hAxes.Parent = hFigure;
                % Delete old axes
             	delete( hTempAxis );
                
                % Delete temporary figure
                delete( hTempFig );
            end
                                    
            disp( 'Scene loaded.. ' );
        end
    end        
    
end

