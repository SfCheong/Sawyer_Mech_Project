classdef Projector
    %PROJECTOR This class calculate vectors for depth map projection. 
    %   Detailed explanation goes here
    
    properties
        VectorMap = [];             % Vector matrix
    end
    
    methods
        %% Constructor
        function obj = Projector( resolution, focusDistance, center )
            % Set default value
            if nargin < 3
                center =  resolution ./ 2;
            end
            
            % Set varibales
            width  = resolution(1);
            height = resolution(2);

            % Focus diatance ( Can we reduse Fy ??? ) 
            Cx = center(1);
            Cy = center(2);

            % Allocate new plase for uniform vectros
            obj.VectorMap = ones( height, width, 4 );
            
            sizeX = double( 1:width ) - Cx;
            sizeY = double( 1:height) - Cy;

            % Calculate point coods in pixels 
            [ indexX, indexY ] = meshgrid(  sizeX, sizeY );
            % Set focus distance
            obj.VectorMap( :, :, 1) = indexX;
            obj.VectorMap( :, :, 2) = indexY;
            obj.VectorMap( :, :, 3) = focusDistance;

            % Calculate norms for all vectors
            norms = sqrt( sum( abs( obj.VectorMap( :, :, 1:3 ) ).^ 2 , 3 ) );

            % Normalize vectors
            obj.VectorMap( :, :, 1:3 )  = bsxfun(   @rdivide, ...
                                                    obj.VectorMap( :, :, 1:3 ), ...
                                                    norms );
                                        
        end
    end
    
end

