classdef SimpleFigure < Viewer3D.GUI.Scene3D
    %SIMPLEFIGURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        %% Constructor
        function obj = SimpleFigure( )
            % Make figure
            hFigure  = figure( 1 );
            % Appen call back function
            hFigure.CloseRequestFcn  = @closeFigureCallback;

%             % Get path to current projectdir
%             scriptPath = mfilename('fullpath');
%             scriptPath = scriptPath( 1:end-length( mfilename ) );

            % Get current axis
            hAxis                   = axes( hFigure, 'Tag', 'basicAxes' );
            % Create new scene
            hBasicScene             = Viewer3D.GUI.Scene3D( hAxis, scriptPath );
            %  Append handle to User data
            hFigure.UserData.hScene = hBasicScene;
        end
    end

    methods( Access = private )
        %% Save axis parameters befor figure will close
        function  closeFigureCallback( obj, src, data )
            % Show debug message
            disp( 'SimpleFigure::closeFigureCallback: Try to close..' );

            % Scene was append
            if ~isempty( src.UserData )
                % save scene
                delete( src.UserData.hScene );
            end

            % Close figure
            delete( gcf );
        end
    end
    
end

