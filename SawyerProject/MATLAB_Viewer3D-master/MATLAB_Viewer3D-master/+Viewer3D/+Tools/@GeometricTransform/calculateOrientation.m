function  rotMat  = calculateOrientation(  vectors )
%CALCULATEORIENTATION Summary of this function goes here
%   Detailed explanation goes here

        import Viewer3D.Tools.*;
        
%         zyProjVec   = vectors;        
%         yVect       = repmat( [0 1 0], length( vectors ), 1 );
%         zyProjVec( :, 1 ) = 0;
%         zyAngle = GeometricTransform.angleBetweenVectors( yVect, zyProjVec );
% %         indZY = find( zyCrossProd(:, 1) > 0 );       
% %         zyAngle( indZY ) = 2*pi - zyAngle (indZY) ;
% 
%        
%         % xVector same size and point2CenterVectors
        xVect 	= repmat( [1 0 0], length( vectors ), 1 );        
%         xyProjVec = vectors;
%         xyProjVec( :, 3 ) = 0; 
%         xyAngle = GeometricTransform.angleBetweenVectors( xVect, xyProjVec );        
% %         indXY = find( xyCrossProd(:, 3) > 0 );
% %             xyAngle( indXY ) = 2*pi - xyAngle (indXY) ; 
%         
%         xzProjVec = vectors;        
%         zVect 	= repmat( [0 0 1], length( vectors ), 1 );
%         xzProjVec( :, 2 ) = 0;
%         xzAngle = GeometricTransform.angleBetweenVectors( zVect, xzProjVec );
% %         indXZ = find( xzCrossProd(:, 2) > 0 );       
% %         xzAngle( indXZ ) = 2*pi - xzAngle (indXZ) ;
%         
%         rotMat =[ xyAngle, xzAngle, zyAngle];

    rotMat = vrrotvec( xVect , vectors);
end

