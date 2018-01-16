classdef Camera < Viewer3D.Primitives.IDrawable
    %CAMERA Represant camera position and parameters
    %   Detailed explanation goes here
    
    properties
        % Camera parameters ( Use class from 3DViewer )
        Fx = -1;                       	% Fx       
        Fy = -1;                      	% Fy         
        Cx = -1;                      	% Cx        
        Cy = -1;                       	% Cy
        
        % transformMatrix = [];         
        position 	= [];               % Camera position 
        orientation = [];               % Camera orientation
        
        % Near, Far distance
    end
    
    methods
        %% Constructor
        function obj = Camera()
        end
        
        %% Draw camera function
        handle = drawCamera( obj, axisScale )

    end
    
end

