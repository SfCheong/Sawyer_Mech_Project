function angle = angleBetweenVectors( vec1, vec2 )
%ANGLEBETWEENVECTORS Summary of this function goes here
%   Detailed explanation goes here

        %% Calculate angle between vectorRef and vectorProj
        % calculate cross product
        xyCrossProd     = cross( vec1, vec2 ) ; 
        % calculate dot Product
        dotProd      	= dot( vec1', vec2' );
        % Normalize cross product
        normCrossProd 	= sqrt( sum( xyCrossProd .^ 2, 2) );
        % Find angle
        angle           = deg2rad( atan2d( normCrossProd, dotProd' ) );
        
%         disp(angle);        
%         index = find( angle > pi ); 
%         angle( index ) = pi - angle (index);
        
     	% To ensure all points in the right direction                
%     	indXY = find( xyCrossProd(:, 3) > 0 );
%         xyAngle( indXY ) = 2*pi - xyAngle (indXY) ; 
end

